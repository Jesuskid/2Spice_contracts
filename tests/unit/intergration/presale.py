from brownie import accounts, config, network, Spice, interface, Presale
from scripts.helpful_scripts import get_account
from web3 import Web3
from scripts.deploy_test.deploy import latest_contract, latest_presale
import time


def test_presaleOpens():
    ACCOUNT = get_account()
    ONE_ETHER = Web3.toWei(1, "ether")
    BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
    BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
    # arrange
    spiceContract = latest_presale()
    # spiceContract.openPresale({"from": ACCOUNT, "gas_limit": 2100000})

    # act
    open = spiceContract.presaleOpen()
    timer = spiceContract.presaleTimer()

    # assert
    assert open == True
    assert timer > 0


def test_presale():
    ACCOUNT = get_account()
    ONE_ETHER = Web3.toWei(1, "ether")
    BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
    BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
    # arrange

    spiceContract = latest_presale()
    initial_balance = BUSD_CONTRACT.balanceOf(spiceContract.address)
    # act
    BUSD_CONTRACT.approve(
        spiceContract.address, ONE_ETHER, {"from": ACCOUNT, "gas_limit": 2100000}
    )
    spiceContract.presale(ONE_ETHER, {"from": ACCOUNT, "gas_limit": 2100000})
    # assert
    assert BUSD_CONTRACT.balanceOf(spiceContract.address) > initial_balance
    print("presale successful")


def test_withdraw():
    # arrange
    ACCOUNT = get_account()
    ONE_ETHER = Web3.toWei(1, "ether")
    BUSD_ADDRESS = "0x035a87F017d90e4adD84CE589545D4a8C5B7Ec80"
    BUSD_CONTRACT = interface.IERC20(BUSD_ADDRESS)
    spiceContract = latest_presale()
    initial_balance = BUSD_CONTRACT.balanceOf(spiceContract.address)
    # act
    spiceContract.openContractAndWithdrawPresale(
        {"from": ACCOUNT, "gas_limit": 2100000}
    )
    # assert
    assert BUSD_CONTRACT.balanceOf(spiceContract.address) == 0
