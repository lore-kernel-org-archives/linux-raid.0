From: Anton Voloshin <ashutosh@harekrishna.ru>
Subject: RAID 6 reshape failed (false message about critical section)
Date: Wed, 5 Sep 2007 14:33:05 +0400
Message-ID: <515CA0AD-2BAF-437A-8A41-260F7A27BADB@harekrishna.ru>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear all,

I've been using RAID5 on my video archival server with 6 x 750GB  
drives for a year and it was working just fine. Thanks to Niel Brown  
and all the team for great job!

Recently while upgrading server to RAID6 I've created new 5 x 750GB  
drives RAID6 array, waited for parity calculation to finish (it took  
6-7 hours) and started reshaping from 5 to 8 drives. According to  
information on this list 2.6.21 or later kernel is required for RAID6  
reshaping so I upgraded kernel from 2.6.20 to 2.6.22 (both are  
standard Ubuntu server kernels, from Feisty and Gutsy releases resp.).
I started reshape by
mdadm --add /dev/md1 /dev/sda2 /dev/sdb2 /dev/sdd2
mdadm --grow /dev/md1 -n 8
It went through critical section just fine and have been happily  
reshaping for few hours. Estimated completion time according to /proc/ 
mdstat was around 1600-1700 minutes.
Then due to other circumstances I had to reboot my server.
Reboot was going not smoothly (had to reboot few times due to some  
errors in my startup scripts - not connected to md in any way I think).
After I rebooted, I could see that md1 array was not stared  
automatically and when I'm trying to run
mdadm --assemble /dev/md1
it says "Failed to restore critical section for reshape, sorry."  
although it is not the case as far as I can tell (reshaping was going  
for at least one or two hours before first reboot).

Please advise me how should I proceed to resolve this situation and  
save my data if possible (yes, unfortunately I was going to make  
backups in a week but did not had them yet - too bad for me :-( ).

Superblocks on all partitions are fine, mdadm --examine gives the  
same information for all 8 partitions, e.g.
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 00.91.00
>            UUID : 37d56bd1:4f8ccf24:2421b4fc:05cfad50 (local to  
> host videoserver)
>   Creation Time : Mon Sep  3 16:27:04 2007
>      Raid Level : raid6
>   Used Dev Size : 730619904 (696.77 GiB 748.15 GB)
>      Array Size : 4383719424 (4180.64 GiB 4488.93 GB)
>    Raid Devices : 8
>   Total Devices : 8
> Preferred Minor : 1
>
>   Reshape pos'n : 140169216 (133.68 GiB 143.53 GB)
>   Delta Devices : 3 (5->8)
>
>     Update Time : Wed Sep  5 00:15:40 2007
>           State : clean
> Active Devices : 8
> Working Devices : 8
> Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 249b218d - correct
>          Events : 0.15268
>
>      Chunk Size : 1024K
>
>       Number   Major   Minor   RaidDevice State
> this     5       8       98        5      active sync   /dev/sdg2
>
>    0     0       8        2        0      active sync   /dev/sda2
>    1     1       8       34        1      active sync   /dev/sdc2
>    2     2       8       50        2      active sync   /dev/sdd2
>    3     3       8       66        3      active sync   /dev/sde2
>    4     4       8       82        4      active sync   /dev/sdf2
>    5     5       8       98        5      active sync   /dev/sdg2
>    6     6       8      114        6      active sync   /dev/sdh2
>    7     7       8       18        7      active sync   /dev/sdb2

relevant lines from /etc/mdadm/mdadm.conf:
> DEVICE /dev/sd[a-z]*
> ARRAY /dev/md1 level=raid6 num-devices=8  
> UUID=37d56bd1:4f8ccf24:2421b4fc:05cfad50

Kernel version:
> root@videoserver:/# uname -a
> Linux videoserver 2.6.22-10-server #1 SMP Wed Aug 22 08:06:27 GMT  
> 2007 x86_64 GNU/Linux

mdadm version:
> root@videoserver:/# mdadm --version
> mdadm - v2.6.3 - 20th August 2007

I had some programming experience before (in userspace only) so I  
could try to do some debugging in gdb if necessary - but please  
advise me what to look for.

Thank you in advance for any advice and/or help.

Best regards,
Anton Voloshin
Saint Petersburg, Russia
