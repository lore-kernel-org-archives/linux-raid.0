From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: checking state of RAID (for automated notifications)
Date: Thu, 07 Sep 2006 10:30:44 +0200
Message-ID: <44FFD8B4.7080901@wpkg.org>
References: <44FE8A68.8060306@wpkg.org> <44FEFC45.1080500@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FEFC45.1080500@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Hardy wrote:
> <berlin> % rpm -qf /usr/lib/nagios/plugins/contrib/check_linux_raid.pl
> nagios-plugins-1.4.1-1.2.fc4.rf
> 
> It is built in to my nagios plugins package at least, and works great.

All right, I didn't see it.

I was thinking of monitoring remote servers; I wrote something very simple.
It checks how many "U" letters there are in /proc/mdstat, and compares 
it to $DEVICES number we have.

First, run this one on a remote machine, via cron:


#!/bin/bash

# This script prints the status of RAID device on this machine

# how many RAID devices/partitions do we have here?
DEVICES=8


# no need to change anything below...

RUNNING=$(cat /proc/mdstat | tr -cd  "U" | wc -c)

if [ "$DEVICES" == "$RUNNING" ] ; then

echo "RAID status OK" > /tmp/raid-status.txt

else

echo "RAID broken" > /tmp/raid-status.txt

fi


And then poll the results from the nagios server (let's call it 
"check_raid" nagios plugin):

#!/bin/bash

# checks state of software RAID

STATUS=$(ssh -l checkuser -i ~nagios/.ssh/checkuser.rsa $1 "cat 
/tmp/raid-status.txt")

if [ "$STATUS" == "RAID status OK" ] ; then
echo $STATUS
exit 0
else
echo $STATUS
exit 2
fi


-- 
Tomasz Chmielewski
http://wpkg.org
