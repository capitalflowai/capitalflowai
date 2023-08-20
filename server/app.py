from flask import Flask, request, jsonify
import midas
import requests
import datetime
import json
app = Flask(__name__)


def process_message(message):
    return {"message": message.upper()}
#For 5 days monthly expense
def calculate_expenses_by_frequency(transactions, frequency_days):
    expenses_by_frequency = {}
    
    for transaction in transactions:
        transaction_date = datetime.datetime.strptime(transaction['transactionTimestamp'][:10], '%Y-%m-%d')
        key = (transaction_date.day // frequency_days) + 1
        
        if key not in expenses_by_frequency:
            expenses_by_frequency[key] = 0
        
        if transaction['type'] == 'DEBIT':
            expenses_by_frequency[key] += float(transaction['amount'])
    
    return sorted(expenses_by_frequency.items())

def format_date(day, month):
    return f"{day}/{month}"

#The decorater for it 
@app.route("/ExpensesByFrequency", methods=["GET"])
def expenses_by_frequency():
    try:
       
       
        request_data = request.json

        #Retrieve transactions from the json file
        transactions = request_data['Payload'][0]['data'][0]['decryptedFI']['account']['transactions']['transaction']
        # Get the current month and year
        
        current_month = datetime.datetime.now().month
        current_year = datetime.datetime.now().year
        
        # Filter transactions for the current month and year
        current_month_transactions = [transaction for transaction in transactions if
                                      int(transaction['transactionTimestamp'][:4]) == current_year and
                                      int(transaction['transactionTimestamp'][5:7]) == current_month]
        
        frequency_days = 5
        expenses = calculate_expenses_by_frequency(current_month_transactions, frequency_days)
        
        response_data = [{'period': format_date(1 + (period - 1) * frequency_days, current_month), 'total_expenses': total_expenses} for period, total_expenses in expenses]
        
        return jsonify(response_data), 200
        
    except ValueError:
        return "Invalid input or JSON data. Please make sure the data is correct.", 400


#For Budget Slider purple thingy
def calculate_percentage_spent(transactions, budget):
    print(transactions)
    total_spent = sum(float(transaction['amount']) for transaction in transactions if transaction['type'] == 'DEBIT')
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
       
        request_data = request.json

        #Retrieve transactions from the json file
        transactions = request_data['Payload'][0]['data'][0]['decryptedFI']['account']['transactions']['transaction']

            
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

        #Retrieve budget from the json file
        budget = float(request_data['budget'])

        # Get the current month using the datetime module
        current_month = datetime.datetime.now().month
        transactions = request_data['Payload'][0]['data'][0]['decryptedFI']['account']['transactions']['transaction']

        # Filter transactions for the current month
        current_month_transactions = [transaction for transaction in transactions if float(transaction['transactionTimestamp'][:10].split('-')[1]) == current_month]

        # Calculate the percentage spent
        percentage_spent = calculate_percentage_spent(current_month_transactions, budget)

        # Post the calculated percentage back to the client as JSON response
        response_data = {'percentage': percentage_spent}
        return jsonify(response_data), 200

    except:
        return "Check request data.", 400


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
    app.run()
