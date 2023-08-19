import time
import openai
import yfinance as yf

openai.api_key = "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"
import finnhub
import pandas as pd
from dateutil import parser
from datetime import datetime


CLIENT = finnhub.Client(api_key="cj7ogr1r01qnc6365m50cj7ogr1r01qnc6365m5g")

messages = [{}]


def record(role, message):
    """
    Record messages into a global variable

    Args:
        role (string): user or assistant
        message (string): message content
    """
    global messages
    messages.append({"role": role, "content": message})


def davinci_003(query, temperature=0):
    print(query)
    print("Starting text-davinci-003...\n")

    start_time = time.time()

    response = openai.Completion.create(
        model="text-davinci-003",
        prompt=query,
        temperature=temperature,
        max_tokens=100,
        top_p=0,
        frequency_penalty=0.0,
        presence_penalty=0.0,
        stop=["|"],
    )

    end_time = time.time()
    elapsed_time = end_time - start_time

    print("\nTime elapsed: " + str(elapsed_time) + " seconds\n")

    response = response.choices[0].text.strip("'").strip(" ")
    return response


def gpt_3(message_list, temperature=0.2):
    """Uses OpenAI's GPT-3.5-turbo API to generate a response to a query

    Args:
    query (str): The query to be sent to the API
    temperature (float): The temperature of the response, which controls randomness. Higher values make the response more random and vice versa.
        (default is 0.2)

    Returns:
        response: The response from the API
    """

    print("Starting GPT-3.5-turbo...\n")

    start_time = time.time()

    completion = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=message_list,
        temperature=temperature,
    )

    end_time = time.time()
    elapsed_time = end_time - start_time
    print("\nTime elapsed: " + str(elapsed_time) + " seconds\n")

    response = completion.choices[0].message.content
    return response


def analyst(input_symbol):
    recommendations = CLIENT.recommendation_trends(symbol=input_symbol)

    recommendations_df = pd.DataFrame(recommendations)

    # Get the latest analyst recommendation
    latest_recommendation = recommendations_df.iloc[0]

    # Get the date of the latest recommendation
    latest_date = latest_recommendation["period"]

    # Get the values of each element inside the recommendation
    buy = latest_recommendation["buy"]
    hold = latest_recommendation["hold"]
    sell = latest_recommendation["sell"]
    strong_buy = latest_recommendation["strongBuy"]
    strong_sell = latest_recommendation["strongSell"]

    # Print the results
    response = (
        "Latest analyst recommendation for "
        + input_symbol
        + ": Date: {}, Buy: {}, Hold: {}, Sell: {}, Strong Buy: {}, Strong Sell: {}".format(
            latest_date, buy, hold, sell, strong_buy, strong_sell
        )
    )
    return str(response)


def parse_input(prompt):
    quantity, ticker, start_date_str, end_date_str = prompt

    # Parse start and end dates using dateutil parser
    start_date = parser.parse(start_date_str, fuzzy=True)

    # Check if end date is "today" and replace with current date
    if end_date_str.lower() == "today":
        end_date = datetime.now()
    else:
        end_date = parser.parse(end_date_str, fuzzy=True)

    # Check if start date is before end date
    if start_date >= end_date:
        raise ValueError("Invalid date range: start date must be before end date")

    # Check if end date is after today's date
    if end_date.date() > datetime.now().date():
        raise ValueError("Invalid date range: end date cannot be after today's date")

    # Convert ticker to uppercase for consistency
    ticker = ticker.upper()

    return quantity, ticker, start_date, end_date, None


def get_stock_data(num_shares, ticker, start_date, end_date):
    try:
        # Retrieve stock info and extract company name
        company_name = yf.Ticker(ticker).info["longName"]

        # Retrieve historical data for specified dates
        stock_data = yf.download(ticker, start=start_date, end=end_date)

        # Retrieve start and end prices
        start_price = stock_data["Close"][0]
        start_price = float("{:.2f}".format(start_price))
        end_price = stock_data["Close"][-1]
        end_price = float("{:.2f}".format(end_price))

        # Calculate return amount
        return_amount = (end_price - start_price) * int(num_shares)
        return_amount = float("{:.2f}".format(return_amount))
        profit_loss = "profit" if return_amount > 0 else "loss"

        # Calculate total return percentage
        return_percent = (end_price - start_price) / start_price * 100
        return_percent = float("{:.2f}".format(return_percent))

        # Calculate total value of shares
        total = end_price * int(num_shares)
        total = float("{:.2f}".format(total))

        # Construct response message
        response = f"{num_shares} shares of {company_name} ({ticker}) from {start_date.strftime('%d-%m-%Y')} to {end_date.strftime('%d-%m-%Y')}: start price = ${start_price:.2f}, end price = ${end_price:.2f}, {profit_loss} = ${return_amount:.2f}"
    except:
        # Return error message for invalid ticker symbol
        response = f"Invalid ticker symbol: {ticker}"

    return response, (
        start_date,
        ticker,
        num_shares,
        start_price,
        end_price,
        return_percent,
        return_amount,
        total,
    )


def prompt_profit(input_list):
    if len(input_list) == 4:
        num_shares, ticker, start_date, end_date, error_msg = parse_input(input_list)

        if error_msg:
            return error_msg
        stock_data = get_stock_data(num_shares, ticker, start_date, end_date)
        response = (
            "Assume that I bought or sold the stock, using this information to give me a response on my stock details including start price, end price and profit if I sell it on the end date: "
            + stock_data[0]
        )

        return response, stock_data[1]
    return None, None


def prompt_recomendation(ticker):
    analystical = analyst(ticker)
    result = (
        "Using this information to give the me an appropriate stocks recommendation: "
        + analystical
    )

    return result


import requests


def stock_price_target(symbol):
    api_key = "S0XJUDB61X78JAGV"

    # Make a request to the Alpha Vantage API
    url = f"https://www.alphavantage.co/query?function=OVERVIEW&symbol={symbol}&apikey={api_key}"
    response = requests.get(url)
    data = response.json()

    # Check if the request was successful
    if "Error Message" not in data:
        target_price = data.get("AnalystTargetPrice", "N/A")

    if target_price != "N/A":
        return target_price
    else:
        return "No price target found for this stock"


def generate(prompt):
    start = time.time()
    user_message = prompt
    with open("prompt.txt", "r") as f:
        promptinput = f.read()
        result = davinci_003(promptinput + prompt, 0)
        output_list = result.split("\n")

        output_list = output_list[-1]

        output_list = output_list.lower()
        output_list = str(output_list)

        output_list = output_list.split(" ")

        # find index of "Answer"
        index = 0

        for i in range(len(output_list)):
            if output_list[i] == "Answer: " or output_list[i] == "Output: ":
                index = i
                break
        if index == 0:
            case = output_list[0]
            output_data = output_list[1:]
        else:
            case = output_list[index + 1]
            output_data = output_list[index + 2 :]

        if case == "buy" or case == "sell":
            print("User bought stock\n")

            prompt_result = prompt_profit(output_data)

            (
                start_date,
                ticker,
                quantity,
                start_price,
                end_price,
                return_percent,
                return_amount,
                total,
            ) = prompt_result[1]

            record("user", prompt_result[0])

        elif case == "recommendation":
            print("\nGive user stock recommendations\n")
            ticker = output_data[0].strip()
            a = analyst(ticker)
            record("user", a)

        # user want to know stock target price
        elif case == "target":
            print("\nGive user stock price target\n")
            ticker = output_data[0].strip()
            price_target = stock_price_target(ticker)
            query = f"This is the up-to-date price target: {price_target} for {ticker}.Just explain this"

            record("user", query)

        else:
            print("\nGive user a normal response\n")
            query = user_message
            record("user", query)

        # return thr last messafe

    message_list = []
    message_list.append(
        {
            "role": "system",
            "content": "You are a friendly financial chatbot named Midas Ai. The user will ask you questions, and you will provide polite responses. If user bought or sold a stock,  answer detail about their profit. If asked about the stock target price just explain the content i give you",
        }
    )
    message_list.append(messages[-1])
    finalMessage = gpt_3(message_list)
    totalTime = time.time() - start
    return {"message": finalMessage, "latency": totalTime}


# print(generate("Hi how are you?"))
# print(generate("what is stock prediction for aapl on 27 th august 2023"))

# print("output" + generate("i bought 100 shares of aapl on 7 th august 2023"))
