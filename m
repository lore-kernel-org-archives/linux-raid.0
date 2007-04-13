From: =?UTF-8?B?TGFzc2UgS8Okcmtrw6RpbmVu?= <tronic+owm8@trn.iki.fi>
Subject: Manually hacking superblocks
Date: Fri, 13 Apr 2007 11:11:23 +0300
Message-ID: <461F3B2B.4030006@trn.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I managed to mess up a RAID-5 array by mdadm -adding a few failed disks 
back, trying to get the array running again. Unfortunately, -add didn't do 
what I expected, but instead made spares out of the failed disks. The 
disks failed due to loose SATA cabling and the data inside should be 
fairly consistent. sdh failed a bit earlier than sdd and sde, so I expect 
to be able to revocer by building a degraded array without sdh and then 
syncing.

The current situation looks like this:
       Number   Major   Minor   RaidDevice State
    0     0       8       33        0      active sync   /dev/sdc1
    1     1       0        0        1      faulty removed
    2     2       8       97        2      active sync   /dev/sdg1
    3     3       8      129        3      active sync   /dev/sdi1
    4     4       0        0        4      faulty removed
    5     5       8       81        5      active sync   /dev/sdf1
    6     6       0        0        6      faulty removed
    7     7       8      177        7      spare
    8     8       8      161        8      spare
    9     9       8      145        9      spare

... and before any of this happened, the configuration was:

disk 0, o:1, dev:sdc1
disk 1, o:1, dev:sde1
disk 2, o:1, dev:sdg1
disk 3, o:1, dev:sdi1
disk 4, o:1, dev:sdh1
disk 5, o:1, dev:sdf1
disk 6, o:1, dev:sdd1

I gather that I need a way to alter the superblocks of sde and sdd so that 
they seem to be clean up-to-date disks, with their original disk numbers 1 
and 6. A hex editor comes to mind, but are there any better tools for that?

