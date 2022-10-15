from brownie import FundMe
from scripts.helpful_scripts import get_account


def fund():
    print("**one**")
    fund_me = FundMe[-1]
    print("**two**")
    account = get_account()
    print("**three**")
    entrance_fee = fund_me.getEntranceFee()
    print("**four**")
    print(entrance_fee)
    print(f"The current entry fee is {entrance_fee}")
    print("Funding")
    fund_me.fund({"from": account, "value": entrance_fee})
    print("**1**")

def withdraw():
    print("**2**")
    fund_me = FundMe[-1]
    print("**3**")
    account = get_account()
    print("**4**")
    fund_me.withdraw({"from": account})
    print("**5**")

def main():
    print("**6**")
    fund()
    print("**7**")
    withdraw()
    print("**8**")