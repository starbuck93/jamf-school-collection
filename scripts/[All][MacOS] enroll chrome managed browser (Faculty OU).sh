#!/bin/bash

if [ -f "/Library/Google/Chrome/CloudManagementEnrollmentToken" ]; then
    echo "No update needed"
else 
    mkdir -p /Library/Google/Chrome 
    echo "secrets" > /Library/Google/Chrome/CloudManagementEnrollmentToken
fi



#[All][MacOS] enroll chrome managed browser (Faculty OU)	
