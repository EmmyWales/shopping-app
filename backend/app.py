import os
import uuid

import requests

from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv


# ========================================
# LOAD ENVIRONMENT VARIABLES
# ========================================

load_dotenv()


# ========================================
# CREATE FLASK APP
# ========================================

app = Flask(__name__)

CORS(app)


# ========================================
# PAYSTACK CONFIGURATION
# ========================================

PAYSTACK_SECRET_KEY = os.getenv("PAYSTACK_SECRET_KEY")

PAYSTACK_BASE_URL = "https://api.paystack.co"


# Make sure secret key exists
if not PAYSTACK_SECRET_KEY:
    raise RuntimeError(
        "PAYSTACK_SECRET_KEY was not found in .env"
    )


# ========================================
# HOME
# ========================================

@app.route("/", methods=["GET"])
def home():

    return jsonify({
        "message": "Shoply Paystack backend is running!"
    })


# ========================================
# INITIALIZE PAYMENT
# ========================================

@app.route("/initialize-payment", methods=["POST"])
def initialize_payment():

    try:

        # Get JSON sent from Flutter
        data = request.get_json()

        if not data:

            return jsonify({
                "success": False,
                "message": "No data received"
            }), 400


        # Get customer email
        email = data.get("email")

        # Get payment amount
        amount = data.get("amount")


        # ========================================
        # CHECK EMAIL
        # ========================================

        if not email:

            return jsonify({
                "success": False,
                "message": "Email is required"
            }), 400


        # ========================================
        # CHECK AMOUNT
        # ========================================

        if amount is None:

            return jsonify({
                "success": False,
                "message": "Amount is required"
            }), 400


        # ========================================
        # CONVERT AMOUNT
        # ========================================

        try:

            amount = float(amount)

        except (ValueError, TypeError):

            return jsonify({
                "success": False,
                "message": "Amount must be a number"
            }), 400


        # ========================================
        # CHECK AMOUNT IS POSITIVE
        # ========================================

        if amount <= 0:

            return jsonify({
                "success": False,
                "message": "Amount must be greater than zero"
            }), 400


        # ========================================
        # CONVERT NAIRA TO KOBO
        #
        # ₦10 = 1000 kobo
        # ₦1,000 = 100000 kobo
        # ========================================

        amount_in_kobo = int(round(amount * 100))


        # ========================================
        # CREATE UNIQUE PAYMENT REFERENCE
        # ========================================

        reference = (
            f"SHOPLY-{uuid.uuid4().hex[:12].upper()}"
        )


        # ========================================
        # PAYSTACK HEADERS
        # ========================================

        headers = {

            "Authorization":
                f"Bearer {PAYSTACK_SECRET_KEY}",

            "Content-Type":
                "application/json"
        }


        # ========================================
        # PAYMENT DATA
        # ========================================

        payment_data = {

            "email":
                email,

            "amount":
                str(amount_in_kobo),

            "currency":
                "NGN",

            "reference":
                reference
        }


        # ========================================
        # SEND REQUEST TO PAYSTACK
        # ========================================

        response = requests.post(

            f"{PAYSTACK_BASE_URL}/transaction/initialize",

            headers=headers,

            json=payment_data,

            timeout=30
        )


        # ========================================
        # GET PAYSTACK RESPONSE
        # ========================================

        paystack_response = response.json()


        # ========================================
        # CHECK HTTP RESPONSE
        # ========================================

        if response.status_code != 200:

            return jsonify({

                "success": False,

                "message":
                    "Paystack rejected the transaction",

                "paystack_response":
                    paystack_response

            }), response.status_code


        # ========================================
        # CHECK PAYSTACK STATUS
        # ========================================

        if not paystack_response.get("status"):

            return jsonify({

                "success": False,

                "message":
                    paystack_response.get(
                        "message",
                        "Payment initialization failed"
                    )

            }), 400


        # ========================================
        # GET TRANSACTION DATA
        # ========================================

        transaction = paystack_response.get(
            "data",
            {}
        )


        # ========================================
        # RETURN DATA TO FLUTTER
        # ========================================

        return jsonify({

            "success": True,

            "access_code":
                transaction.get(
                    "access_code"
                ),

            "reference":
                transaction.get(
                    "reference"
                ),

            "authorization_url":
                transaction.get(
                    "authorization_url"
                )

        })


    # ========================================
    # PAYSTACK CONNECTION ERROR
    # ========================================

    except requests.exceptions.RequestException as e:

        return jsonify({

            "success": False,

            "message":
                "Could not connect to Paystack",

            "error":
                str(e)

        }), 500


    # ========================================
    # GENERAL ERROR
    # ========================================

    except Exception as e:

        return jsonify({

            "success": False,

            "message":
                "Something went wrong",

            "error":
                str(e)

        }), 500


# ========================================
# VERIFY PAYMENT
# ========================================

@app.route(
    "/verify-payment/<reference>",
    methods=["GET"]
)
def verify_payment(reference):

    try:

        # ========================================
        # PAYSTACK HEADERS
        # ========================================

        headers = {

            "Authorization":
                f"Bearer {PAYSTACK_SECRET_KEY}",

            "Content-Type":
                "application/json"
        }


        # ========================================
        # VERIFY TRANSACTION
        # ========================================

        response = requests.get(

            f"{PAYSTACK_BASE_URL}/transaction/verify/{reference}",

            headers=headers,

            timeout=30
        )


        # ========================================
        # PAYSTACK RESPONSE
        # ========================================

        paystack_response = response.json()


        # ========================================
        # CHECK HTTP RESPONSE
        # ========================================

        if response.status_code != 200:

            return jsonify({

                "success": False,

                "message":
                    "Payment verification failed",

                "paystack_response":
                    paystack_response

            }), response.status_code


        # ========================================
        # CHECK PAYSTACK STATUS
        # ========================================

        if not paystack_response.get("status"):

            return jsonify({

                "success": False,

                "message":
                    paystack_response.get(
                        "message",
                        "Unable to verify payment"
                    )

            }), 400


        # ========================================
        # GET TRANSACTION
        # ========================================

        transaction = paystack_response.get(
            "data",
            {}
        )


        # ========================================
        # RETURN PAYMENT RESULT
        # ========================================

        return jsonify({

            "success": True,

            "reference":
                transaction.get(
                    "reference"
                ),

            "status":
                transaction.get(
                    "status"
                ),

            "amount":
                transaction.get(
                    "amount"
                ),

            "currency":
                transaction.get(
                    "currency"
                ),

            "channel":
                transaction.get(
                    "channel"
                ),

            "paid_at":
                transaction.get(
                    "paid_at"
                ),

            "gateway_response":
                transaction.get(
                    "gateway_response"
                )

        })


    # ========================================
    # PAYSTACK CONNECTION ERROR
    # ========================================

    except requests.exceptions.RequestException as e:

        return jsonify({

            "success": False,

            "message":
                "Could not connect to Paystack",

            "error":
                str(e)

        }), 500


    # ========================================
    # GENERAL ERROR
    # ========================================

    except Exception as e:

        return jsonify({

            "success": False,

            "message":
                "Something went wrong",

            "error":
                str(e)

        }), 500


# ========================================
# RUN SERVER
# ========================================

if __name__ == "__main__":

    app.run(

        host="0.0.0.0",

        port=5000,

        debug=True
    )