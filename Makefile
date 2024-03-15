-include .env

build:; forge build

deploy:
	ifeq ($(strip $(contract)),)
		forge create $(contract) --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-scan $(ETHERSCAN_API_KEY) -vvvv
	else
		echo "contract not defined"
	endif
