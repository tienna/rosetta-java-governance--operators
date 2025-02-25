#!/bin/bash

cat .phrase.prv | cardano-address key from-recovery-phrase Shelley > root.xsk

cardano-address key child 1852H/1815H/0H/0/0 < root.xsk > payment.xsk
cardano-address key public --with-chain-code < payment.xsk > payment.xvk

cardano-address key child 1852H/1815H/0H/2/0    < root.xsk > stake.xsk
cardano-address key public --with-chain-code < stake.xsk > stake.xvk


cardano-address address payment --network-tag testnet < payment.xvk > payment.addr

cardano-address address stake --network-tag testnet < stake.xvk > stake.addr

cardano-address key hash < stake.xvk > stake.vkh
cardano-address address delegation $(cat stake.vkh) < payment.addr > base.addr