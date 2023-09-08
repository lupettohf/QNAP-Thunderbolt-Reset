#!/bin/bash
# luhf @ git.monocul.us - Andrea Santaniello

do_magic() {
  local lockfile="/tmp/TBREBOOT"
  if [ -e "$lockfile" ]; then
    echo "Lockfile already exists. Process might be running."
 
  else
    touch "$lockfile"
    echo "Lockfile created at $lockfile starting procedure."
    # Beep Signal
    /sbin/hal_app --se_buzzer enc_id=0,mode=100
    /sbin/hal_app --se_buzzer enc_id=0,mode=101
    /sbin/hal_app --se_buzzer enc_id=0,mode=100
    # Restart TB services.
    /etc/init.d/thunderbolt.sh stop
    sleep 5
    # Final Beep
    /etc/init.d/thunderbolt.sh start
    /sbin/hal_app --se_buzzer enc_id=0,mode=100
    /sbin/hal_app --se_buzzer enc_id=0,mode=101
    /sbin/hal_app --se_buzzer enc_id=0,mode=100
  fi
}
 
 
while true; do
    # HOW TO: get a usb drive, nothing fancy, create an empty file named RESETTB, change path here.
    if [ -e "/share/external/DEV3301_1/RESETTB" ]; then
        if [ -e "/tmp/TBREBOOT" ]; then
          rm /tmp/TBREBOOT
          /sbin/hal_app --se_buzzer enc_id=0,mode=100
          /sbin/hal_app --se_buzzer enc_id=0,mode=100
        fi
        echo "RESETTB found!"
        sleep 5
    else
        echo "RESETTB not found. Waiting..."
        do_magic
        sleep 5
    fi
done