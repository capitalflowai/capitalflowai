from flask import Flask, request, jsonify
import midas
import requests
import datetime
import json
app = Flask(__name__)


def process_message(message):
    return {"message": message.upper()}

#For Budget Slider purple thingy
def calculate_percentage_spent(transactions, budget):
    total_spent = sum(transaction['amount'] for transaction in transactions if transaction['type'] == 'DEBIT')
    percentage_spent = (total_spent / budget) * 100
    return percentage_spent

#For Pie Chart
def calculate_percentage_by_mode(transactions, mode):
    mode_transactions = [transaction for transaction in transactions if transaction['mode'] == mode and transaction['type'] == 'DEBIT']
    total_spent = sum(transaction['amount'] for transaction in mode_transactions)
    return total_spent

@app.route("/ModePieChart", methods=["POST"])
def mode_pie_chart():
    try:
        # Get the current month using the datetime module
        current_month = datetime.datetime.now().month
        
        # Fetch transaction data from your local JSON file
        with open('others/dataFetch-long.json', 'r') as data_file:
            data = json.load(data_file)
            transactions = data['Payload'][0]['data'][0]['decryptedFI']['account']['transactions']['transaction']
            
        # Filter transactions for the current month
        current_month_transactions = [transaction for transaction in transactions if int(transaction['transactionTimestamp'][:10].split('-')[1]) == current_month]
        
        # Calculate the total money spent in the current month
        total_money_spent = sum(transaction['amount'] for transaction in current_month_transactions if transaction['type'] == 'DEBIT')
        
        # Calculate the percentage spent for each mode of transaction
        mode_percentages = {}
        modes = ("ATM", "FT", "CASH", "OTHER")
        values = []
        for mode in range(len(modes)):
            mode_money_spent = calculate_percentage_by_mode(current_month_transactions, mode)
            mode_percentage = (mode_money_spent / total_money_spent) * 100
            values[mode] = mode_percentage
        values = tuple(values)
        
        # Create the response data containing mode-wise percentages
        response_data = {
            'mode_percentages': zip(modes,values)
        }
        
        return jsonify(response_data), 200
        
    except ValueError:
        return "Invalid input. Please enter valid numerical values.", 400

if __name__ == "__main__":
    app.run(debug=True)



@app.route("/MonthlyBudgetslider", methods=["POST"])
def monthly_budget_slider():
    try:
        # Get the monthly budget from the POST request data
        request_data = request.json
        budget = float(request_data.get('budget', 0))  # Replace 0 with a default value
        
        # Get the current month using the datetime module
        current_month = datetime.datetime.now().month
        
        # Fetch transaction data from your local JSON file
        with open('others/dataFetch.json', 'r') as data_file:
            data = json.load(data_file)
            transactions = data['Payload'][0]['data'][0]['decryptedFI']['account']['transactions']['transaction']
            
        # Filter transactions for the current month
        current_month_transactions = [transaction for transaction in transactions if float(transaction['transactionTimestamp'][:10].split('-')[1]) == current_month]
        
        # Calculate the percentage spent
        percentage_spent = calculate_percentage_spent(current_month_transactions, budget)
        
        # Post the calculated percentage back to the client as JSON response
        response_data = {'percentage': percentage_spent}
        return jsonify(response_data), 200
        
    except ValueError:
        return "Invalid input. Please enter valid numerical values.", 400


@app.route("/midasai", methods=["POST"])
def process():
    try:
        data = request.get_json()
        input_message = data["message"]
        result = midas.generate(input_message)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 400


if __name__ == "__main__":
    app.run(host="localhost", port=8000)
