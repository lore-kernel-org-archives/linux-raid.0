From: Johnny Ljunggren <johnny@navtek.no>
Subject: Fix a broken RAID 5 system
Date: Mon, 16 Jan 2006 12:45:45 +0100
Message-ID: <43CB8769.4080505@navtek.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello everyone!

I have a RAID 5 setup of five disks where one of them was set up as 
spare. A while ago the onboard IDE controller stopped working so I had 
to move all my harddrives to another machine. It wouldn't start so 
Knoppix to my rescue.

I did some mdadm --examine, and some tests with mdadm --assemble 
<different options> and where partly successfull with this: mdadm 
--assemble /dev/md0 --force --update=summaries /dev/hda1 /dev/hdc1 
/dev/hde1 /dev/hdf1 /dev/hdg1
It complained about one faulty drive, but could mount. I decided to flag 
drive as faulty, remove and add it. It then started to rebuild the 
entire RAID.
When I checked the next morning though, mdadm --examine showed that 
/two/ drives now where set as spare, and thus I could not mount the 
array anymore.
Examine now shows (edited):
  Active Devices : 3
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 2
    0     0       3        1        0      active sync
    1     1       0        0        1      faulty removed
    2     2       0        0        2      faulty removed
    3     3      33        1        3      active sync
    4     4      33       65        4      active sync
    5     5      34        1        5      spare
    6     6      22        1        6      spare

I'm pretty sure that one of the spare ones is still intact, but how do I 
change it from being a spare to an active sync?

Since I'm still running from Knoppix, please reply to my address too :/

regards
Johnny Ljunggren




