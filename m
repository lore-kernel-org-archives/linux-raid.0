From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Automatically adding spares on boot
Date: Wed, 09 Jan 2013 18:09:05 +0100
Message-ID: <50EDA431.1090905@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000702060502070702090208"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000702060502070702090208
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Over the years I've had various problems with the degree to which the
adding of spares on boot is automatic. There have been times when this
has just worked, and other times (such as now) where it only works very
occasionally (or not at all). Google is full of stories like this.

I have no clue why it's not working automatically, I just know that it
isn't.

So I wrote a little script that automates this, and hooked it up to
mdmon as an event handler.

It can probably do with an elegance upgrade, but it works for me.

HTH, Jan

--------------000702060502070702090208
Content-Type: text/plain; charset=UTF-8;
 name="mdmon_eventhandler"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mdmon_eventhandler"

#!/bin/bash
# mdadm --monitor event handler, by Jan Ceuleers
# Licence: GPL v2
# Handles SparesMissing event. Uses blkid output to find devices that have
# the same UUID as the RAID device, but which are not yet members of the array.
# Have this script executed by mdadm by passing its name to the mdadm --monitor
# daemon using the --program parameter.
# On Debian-like systems this can be accomplished like so:
#   echo "DAEMON_OPTIONS=\"\$DAEMON_OPTIONS --program /pathto/script\"" >> /etc/default/mdadm

BLKID="/sbin/blkid"
MDADM="/sbin/mdadm"

(
  case $1 in
    SparesMissing)
      COMPUUID=`$MDADM  -D $2 | grep UUID | cut -f 2 -d 'D' | cut -f 3 -d ' '`
      COMPUUID2=${COMPUUID//:/}
      COMPUUID3=${COMPUUID2:0:8}-${COMPUUID2:8:4}-${COMPUUID2:12:4}-${COMPUUID2:16:4}-${COMPUUID2:20}
      echo The UUID of component devices is $COMPUUID \($COMPUUID3\)
      blkid | grep $COMPUUID3 | grep linux_raid_member | (
        while read l; do
          COMPDEV=`echo $l | cut -f 1 -d ':'`
          $MDADM -D $2 | grep $COMPDEV > /dev/null
          if [ $? -eq 0 ] ; then
            echo Device $COMPDEV is already a member of the array
          else
            echo Found device $COMPDEV with the same UUID but not yet a component device.
            $MDADM $2 --add $COMPDEV 2>&1
          fi
        done
      )
      ;;
    *)
      echo "Unknown event type; can't handle."
      ;;
  esac

) | mail -s "Handling $1 mdadm event on $2" root

--------------000702060502070702090208--
