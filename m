From: Chris Birkinshaw <chris@postbox.org.uk>
Subject: Raid 5 always degraded!
Date: Sat, 26 Jun 2004 20:09:19 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <533299FD-C7A4-11D8-BDC2-000A959A30DC@postbox.org.uk>
Mime-Version: 1.0 (Apple Message framework v618)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Whenever I reboot my computer the RAID5 comes back in degraded mode, 
and mdadm outputs the following info:

       Number   Major   Minor   RaidDevice State
this     0      34        1        0      active sync   /dev/hdg1
    0     0      34        1        0      active sync   /dev/hdg1
    1     1      34       65        1      active sync   /dev/hdh1
    2     2      33        1        2      active sync   /dev/hde1
    3     3      33       65        3      active sync   /dev/hdf1
    4     4      22        1        4      active sync   /dev/hdc1
    5     5       0        0        5      faulty removed
    6     6       3       65        6      active sync   /dev/hdb1

If I do a mdadm /dev/md0 --add /dev/hdd3 the missing disk is re-added 
and everything seems fine after it has worked away for a few hours - 
however after another reboot the disk has gone again.

Does anyone have any idea what is going on?

Thanks,

Chris

