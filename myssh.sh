#!/bin/sh
ssh -i $GIT_SSHFILE -l git -o StrictHostKeyChecking=no "$@"