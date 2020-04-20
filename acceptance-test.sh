#!/bin/bash
set - x

NODE_IP=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="ExternalIP")].address }')
NODE_PORT=$(kubectl get svc calculator-service -o=jsonpath='{.spec.ports[0].nodePort}')
./gradlew acceptanceTest -Dcalculator.url=http://${NODE_IP}:${NODE_PORT}
  //test $(curl ec2-35-181-151-53.eu-west-3.compute.amazonaws.com:8765/suma? a=1 \& b=2 ) - eq 3