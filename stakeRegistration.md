# Building transactions for stakeRegistration operations in rosetta  to register stake address

## Step 1:  to construct a request for any metadata

Using /construction/preprocess end-point to construct a request for any metadata that is needed for transaction construction
```
curl --location 'localhost:8082/construction/preprocess' \
--header 'Content-Type: application/json' \
--data '{
  "metadata": {
    "deposit_parameters": {
      "poolDeposit": "500000000",
      "keyDeposit": "2000000"
    }
  },
  "network_identifier": {
    "blockchain": "cardano",
    "network": "preview"
  },

    "operations": [
        {
        
            "operation_identifier": {
                "index": 0,
                "network_index": 0
            },
            "type": "input",
            "status": "success",
            "account": {
                "address": "addr_test1qzz4ute6rgrth5xfdxthmy0ym8xyfe7zt62kx7stmal4gtzcxc3706rx4s4nhxkejvnp5aplpp7ktlz783f5rraqk4tqp6uath"
            },
            "amount": {
                "value": "-9988974302",
                "currency": {
                    "symbol": "ADA",
                    "decimals": 6
                }
            },
            "coin_change": {
                "coin_identifier": {
                    "identifier": "0a65fb232ed406ec55253643886911011dfb229964a1c5a5489c98981aa047df:0"
                },
                "coin_action": "coin_spent"
            }
        },
        
        {
            "operation_identifier": {
                "index": 1
            },
            "related_operations": [
                {
                    "index": 0
                }
            ],
            "type": "output",
            "status": "",
            "account": {
                "address": "addr_test1qzz4ute6rgrth5xfdxthmy0ym8xyfe7zt62kx7stmal4gtzcxc3706rx4s4nhxkejvnp5aplpp7ktlz783f5rraqk4tqp6uath"
            },
            "amount": {
                "value": "9188974302",
                "currency": {
                    "symbol": "ADA",
                    "decimals": 6
                }
            }
        },
        
        {
            "operation_identifier": {
                "index": 2
            },
            "type": "stakeKeyRegistration",
            "status": "",
            "account": {
        
                "address": "stake_test1upvrvgl8apn2c2emntvexfs6wslsslt9l30rc56p37st24srqglm6"
            },
            "metadata": {
                "staking_credential": {
        
                    "hex_bytes": "4cf7c1ccee5015a8dd8e563224eb4f7a07b899775633d4b72336c1aae852797b",   
                    "curve_type": "edwards25519"
                }
            }
        }
    ]
}'
```
The above query will return

```
{
    "options": {
        "relative_ttl": 1000,
        "transaction_size": 261
    }
}
```
We will bring these info to the next step

## Step 2:  to get metadata for transaction construction

using construction/metadata to get metadata for transaction construction

```
curl --location 'localhost:8082/construction/metadata' \
--header 'Content-Type: application/json' \
--data '{
    "network_identifier": {
        "blockchain": "cardano",
        "network": "preview"
    },
    "options": {
        "relative_ttl": 1000,
        "transaction_size": 261
    }
    }
}'
```
this end point will return us the output as below:

```
{
    "metadata": {
        "ttl": 73804214,
        "protocol_parameters": {
            "coinsPerUtxoSize": "4310",
            "maxTxSize": 16384,
            "maxValSize": 5000,
            "keyDeposit": "2000000",
            "maxCollateralInputs": 3,
            "minFeeCoefficient": 44,
            "minFeeConstant": 155381,
            "minPoolCost": "170000000",
            "poolDeposit": "500000000",
            "protocol": 10
        }
    },
    "suggested_fee": [
        {
            "value": "167041",
            "currency": {
                "symbol": "ADA",
                "decimals": 6
            }
        }
    ]
}
```

## Step 3:  Generate an Unsigned Transaction
In this step we use /construction/payloads to generate an unsigned transaction

```
{
  "metadata": {
    "deposit_parameters": {
      "poolDeposit": "500000000",
      "keyDeposit": "2000000"
    }
  },
  "network_identifier": {
    "blockchain": "cardano",
    "network": "{{networkId}}"
  },

    "operations": [
        {
        // 1.=================INPUT: You need to indicate the address and UTXO you will spend here ==================== 
            "operation_identifier": {
                "index": 0,
                "network_index": 0
            },
            "type": "input",
            "status": "success",
            "account": {
                "address": "addr_test1qzz4ute6rgrth5xfdxthmy0ym8xyfe7zt62kx7stmal4gtzcxc3706rx4s4nhxkejvnp5aplpp7ktlz783f5rraqk4tqp6uath"
            },
            "amount": {
                "value": "-9988974302",
                "currency": {
                    "symbol": "ADA",
                    "decimals": 6
                }
            },
            "coin_change": {
                "coin_identifier": {
                    "identifier": "0a65fb232ed406ec55253643886911011dfb229964a1c5a5489c98981aa047df:0"
                },
                "coin_action": "coin_spent"
            }
        },
        // 2.=================OUTPUT: You declare new outputs here.====================================================== 
        {
            "operation_identifier": {
                "index": 1
            },
            "related_operations": [
                {
                    "index": 0
                }
            ],
            "type": "output",
            "status": "",
            "account": {
                "address": "addr_test1qzz4ute6rgrth5xfdxthmy0ym8xyfe7zt62kx7stmal4gtzcxc3706rx4s4nhxkejvnp5aplpp7ktlz783f5rraqk4tqp6uath"
            },
            "amount": {
                "value": "9188974302",
                "currency": {
                    "symbol": "ADA",
                    "decimals": 6
                }
            }
        },
        // 3.=================STAKE KEY REGISTRATION  ==================== 
        {
            "operation_identifier": {
                "index": 2
            },
            "type": "stakeKeyRegistration",
            "status": "",
            "account": {
        // 3.1.============The stake address you want to register
                "address": "stake_test1upvrvgl8apn2c2emntvexfs6wslsslt9l30rc56p37st24srqglm6"
            },
            "metadata": {
                "staking_credential": {
        // 3.2.=============Stake address vkey in Hex: which could be retrived by running `cardano-address key inspect <stake.xvk`===
                    "hex_bytes": "4cf7c1ccee5015a8dd8e563224eb4f7a07b899775633d4b72336c1aae852797b",   
                    "curve_type": "edwards25519"
                }
            }
        }
    ],
        // 4.==============The metadata is copied from output of construction/metadata end point ============
       "metadata": {
        "ttl": 73804214,
        "protocol_parameters": {
            "coinsPerUtxoSize": "4310",
            "maxTxSize": 16384,
            "maxValSize": 5000,
            "keyDeposit": "2000000",
            "maxCollateralInputs": 3,
            "minFeeCoefficient": 44,
            "minFeeConstant": 155381,
            "minPoolCost": "170000000",
            "poolDeposit": "500000000",
            "protocol": 10
        }
    },
    "suggested_fee": [
        {
            "value": "167041",
            "currency": {
                "symbol": "ADA",
                "decimals": 6
            }
        }
    ]

}
```
## Step 4:  Signing Payloads
Construction/combine endpoint will creates a network-specific transaction from an unsigned transaction and an array of provided signatures

### Step 4.1:  

Access https://cbor.me/, paste the contents of unsigned_transaction to the right box
```
8279013c61353030383138323538323030613635666232333265643430366563353532353336343338383639313130313164666232323939363461316335613534383963393839383161613034376466303030313831383235383339303038353565326633613161303662626430633936393937376439316534643963633434653763323565393536333761306264663766353432633538333632336537653836366163326233623961643939333236316137343366303837643635666335653363353334313866613062353536316230303030303030323233623439656465303231613266393038333830303331613034363762303536303438313832303038323030353831633538333632336537653836366163326233623961643939333236316137343366303837643635666335653363353334313866613062353536a16a6f7065726174696f6e7382a6746f7065726174696f6e5f6964656e746966696572a265696e646578006d6e6574776f726b5f696e64657800676163636f756e74a16761646472657373786c616464725f7465737431717a7a34757465367267727468357866647874686d7930796d3878796665377a7436326b783773746d616c3467747a6378633337303672783473346e68786b656a766e703561706c7070376b746c7a3738336635727261716b34747170367561746866616d6f756e74a26863757272656e6379a26673796d626f6c6341444168646563696d616c73066576616c75656b2d393938383937343330326b636f696e5f6368616e6765a26f636f696e5f6964656e746966696572a16a6964656e7469666965727842306136356662323332656434303665633535323533363433383836393131303131646662323239393634613163356135343839633938393831616130343764663a306b636f696e5f616374696f6e6a636f696e5f7370656e74667374617475736773756363657373647479706565696e707574a5746f7065726174696f6e5f6964656e746966696572a165696e64657802676163636f756e74a1676164647265737378407374616b655f74657374317570767276676c3861706e326332656d6e7476657866733677736c73736c74396c33307263353670333773743234737271676c6d36686d65746164617461a1727374616b696e675f63726564656e7469616ca2696865785f62797465737840346366376331636365653530313561386464386535363332323465623466376130376238393937373536333364346237323333366331616165383532373937626a63757276655f747970656c65647761726473323535313966737461747573606474797065747374616b654b6579526567697374726174696f6e
```

### Step 4.2:  

```
a500818258200a65fb232ed406ec55253643886911011dfb229964a1c5a5489c98981aa047df00018182583900855e2f3a1a06bbd0c969977d91e4d9cc44e7c25e95637a0bdf7f542c583623e7e866ac2b3b9ad993261a743f087d65fc5e3c53418fa0b5561b0000000223b49ede021a2f908380031a0467b056048182008200581c583623e7e866ac2b3b9ad993261a743f087d65fc5e3c53418fa0b556
```
add 84 to 
add A0F5F6 to the end

```
84a500818258200a65fb232ed406ec55253643886911011dfb229964a1c5a5489c98981aa047df00018182583900855e2f3a1a06bbd0c969977d91e4d9cc44e7c25e95637a0bdf7f542c583623e7e866ac2b3b9ad993261a743f087d65fc5e3c53418fa0b5561b0000000223b49ede021a2f908380031a0467b056048182008200581c583623e7e866ac2b3b9ad993261a743f087d65fc5e3c53418fa0b556A0F5F6
```



```
82790144383461353030383138323538323030613635666232333265643430366563353532353336343338383639313130313164666232323939363461316335613534383963393839383161613034376466303030313831383235383339303038353565326633613161303662626430633936393937376439316534643963633434653763323565393536333761306264663766353432633538333632336537653836366163326233623961643939333236316137343366303837643635666335653363353334313866613062353536316230303030303030323233623439656465303231613266393038333830303331613034363762303536303438313832303038323030353831633538333632336537653836366163326233623961643939333236316137343366303837643635666335653363353334313866613062353536413046354636A16A6F7065726174696F6E7382A6746F7065726174696F6E5F6964656E746966696572A265696E646578006D6E6574776F726B5F696E64657800676163636F756E74A16761646472657373786C616464725F7465737431717A7A34757465367267727468357866647874686D7930796D3878796665377A7436326B783773746D616C3467747A6378633337303672783473346E68786B656A766E703561706C7070376B746C7A3738336635727261716B34747170367561746866616D6F756E74A26863757272656E6379A26673796D626F6C6341444168646563696D616C73066576616C75656B2D393938383937343330326B636F696E5F6368616E6765A26F636F696E5F6964656E746966696572A16A6964656E7469666965727842306136356662323332656434303665633535323533363433383836393131303131646662323239393634613163356135343839633938393831616130343764663A306B636F696E5F616374696F6E6A636F696E5F7370656E74667374617475736773756363657373647479706565696E707574A5746F7065726174696F6E5F6964656E746966696572A165696E64657802676163636F756E74A1676164647265737378407374616B655F74657374317570767276676C3861706E326332656D6E7476657866733677736C73736C74396C33307263353670333773743234737271676C6D36686D65746164617461A1727374616B696E675F63726564656E7469616CA2696865785F62797465737840346366376331636365653530313561386464386535363332323465623466376130376238393937373536333364346237323333366331616165383532373937626A63757276655F747970656C65647761726473323535313966737461747573606474797065747374616B654B6579526567697374726174696F6E
```
