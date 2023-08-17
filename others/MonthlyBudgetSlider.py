import requests
import datetime

def calculate_percentage_spent(transactions, budget):
    total_spent = sum(transaction['amount'] for transaction in transactions if transaction['type'] == 'DEBIT')
    percentage_spent = (total_spent / budget) * 100
    return percentage_spent

def main():
    try:
        # Make a GET request to the Flask server to fetch the monthly budget
        budget_response = requests.get("http://localhost:5000/budget")#PRANAV YOU HAVE TO CHANGE THIS PART
        
        if budget_response.status_code != 200:
            print("Failed to fetch monthly budget.")
            return
        
        budget = float(budget_response.text)
        
        # Get the current month using the datetime module
        current_month = datetime.datetime.now().month
        
        # Make a GET request to the Flask server to fetch transaction data
        dataFetch_response = requests.get("http://localhost:5000/dataFetch")#AND THIS ONE> IDK WHAT IS THE URL OF THE SERVER
        
        if dataFetch_response.status_code != 200:
            print("Failed to fetch transaction data.")
            return
        
        dataFetch = dataFetch_response.json()
        transactions = dataFetch['Payload'][0]['data'][0]['decryptedFI']['account']['transactions']['transaction']
        # Filter transactions for the current month
        current_month_transactions = [transaction for transaction in transactions if int(transaction['transactionTimestamp'][:10].split('-')[1]) == current_month]#Retrive all transactions of current month
        
        percentage_spent = calculate_percentage_spent(current_month_transactions, budget)
        
        print(f"You have spent {percentage_spent:.2f}% of your budget in the current month.")
        
        # Post the calculated percentage back to the Flask server
        percentage_data = {'percentage': percentage_spent}
        post_response = requests.post("http://localhost:5000/percentage", json=percentage_data)#SAME HERE. THIS WILL POST THE PERCENTAGE> USE THAT TO MANUPULATE THE SLIDER
        
        
        
    except ValueError:
        print("Invalid input. Please enter valid numerical values.")

if __name__ == "__main__":
    main()
