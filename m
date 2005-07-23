From: Tyler <pml@dtbb.net>
Subject: Any chance you can look at this Superblock v1 bug Neil?
Date: Sat, 23 Jul 2005 15:30:18 -0700
Message-ID: <42E2C4FA.6060707@dtbb.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020206010307070400080900"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------020206010307070400080900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

[Fwd: bug report: mdadm-devel-2 , superblock version 1]

I believe I've now tryed this with a patched mdadm devel-2, and a 
2.6.13-rc3-mm1 kernel (which as a few recent md patches), with the same 
results.

Thanks,
Tyler.

( I accidentally sent to the list using the wrong email address 
previously, this was originally sent to the list and Neil)

--------------020206010307070400080900
Content-Type: message/rfc822;
 name="bug report: mdadm-devel-2 , superblock version 1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="bug report: mdadm-devel-2 , superblock version 1"

X-Account-Key: account2
Return-Path: <linux-raid-owner@vger.kernel.org>
Delivered-To: 1-pml@dtbb.net
Received: (qmail 17630 invoked from network); 18 Jul 2005 02:12:53 -0000
Received: from vger.kernel.org (12.107.209.244)
  by w2creative.info with SMTP; 18 Jul 2005 02:12:53 -0000
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S261171AbVGRCJF (ORCPT <rfc822;pml@dtbb.net>);
	Sun, 17 Jul 2005 22:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S261196AbVGRCJF
	(ORCPT <rfc822;linux-raid-outgoing>);
	Sun, 17 Jul 2005 22:09:05 -0400
Received: from defout.telus.net ([199.185.220.240]:4761 "EHLO
	priv-edtnes46.telusplanet.net") by vger.kernel.org with ESMTP
	id S261171AbVGRCJD (ORCPT <rfc822;linux-raid@vger.kernel.org>);
	Sun, 17 Jul 2005 22:09:03 -0400
Received: from [192.168.0.28] (really [142.179.55.145])
          by priv-edtnes46.telusplanet.net
          (InterMail vM.6.01.04.04 201-2131-118-104-20050224) with ESMTP
          id <20050718020902.WCNT12195.priv-edtnes46.telusplanet.net@[192.168.0.28]>;
          Sun, 17 Jul 2005 20:09:02 -0600
Message-ID: <42DB0F41.7030806@dtbb.net>
Date: Sun, 17 Jul 2005 19:09:05 -0700
From: Tyler <pml@dtbb.net>
User-Agent: Mozilla Thunderbird 1.0.5 (Windows/20050711)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Neil Brown <neilb@cse.unsw.edu.au>
CC: linux-raid@vger.kernel.org
Subject: bug report: mdadm-devel-2 , superblock version 1
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>	<17114.54800.132155.142544@cse.unsw.edu.au>	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>	<17114.62108.319878.983091@cse.unsw.edu.au>	<010701c58b32$ee423830$c200a8c0@NCNF5131FTH>	<17115.149.130115.176372@cse.unsw.edu.au>	<001601c58b37$620c69d0$c200a8c0@NCNF5131FTH> <17115.1749.370942.838069@cse.unsw.edu.au>
In-Reply-To: <17115.1749.370942.838069@cse.unsw.edu.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
X-Antivirus: AVG for E-mail 7.0.323 [267.9.0]

# uname -a
Linux server 2.6.12.3 #3 SMP Sun Jul 17 14:38:12 CEST 2005 i686 GNU/Linux
# ./mdadm -V
mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 July 2005

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -S /dev/md1

** stop the current array

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -C /dev/md1 -l 5 
--raid-devices 3 -e 1 /dev/sda2 /dev/sdb2 /dev/sdc2
mdadm: /dev/sda2 appears to be part of a raid array:
    level=5 devices=3 ctime=Mon Jul 18 03:22:05 2005
mdadm: /dev/sdb2 appears to be part of a raid array:
    level=5 devices=3 ctime=Mon Jul 18 03:22:05 2005
mdadm: /dev/sdc2 appears to be part of a raid array:
    level=5 devices=3 ctime=Mon Jul 18 03:22:05 2005
Continue creating array? y
mdadm: array /dev/md1 started.

** create and start new array using 3 drives, superblock version 1

root@server:~/dev/mdadm-2.0-devel-2# cat /proc/mdstat
Personalities : [raid5]
md1 : active raid5 sdc2[3] sdb2[1] sda2[0]
      128384 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

** mdstat mostly okay, except sdc2 is listed as device3 instead of 
device2 (from 0,1,2)

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
/dev/md1:
        Version : 01.00.01
  Creation Time : Mon Jul 18 03:56:40 2005
     Raid Level : raid5
     Array Size : 128384 (125.40 MiB 131.47 MB)
    Device Size : 64192 (62.70 MiB 65.73 MB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Jul 18 03:56:42 2005
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
         Events : 1

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/.static/dev/sda2
       1       8       18        1      active sync   /dev/.static/dev/sdb2
       2       0        0        -      removed

       3       8       34        2      active sync   /dev/.static/dev/sdc2

** reports version 01.00.01 superblock, but reports as if there were 4 
devices used

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -S /dev/md1

** stop the array

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1
Segmentation fault

** try to assemble the array

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
mdadm: md device /dev/md1 does not appear to be active.

** check if its active at all

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1 /dev/sda2 
/dev/sdb2 /dev/sdc2
mdadm: device 1 in /dev/md1 has wrong state in superblock, but /dev/sdb2 
seems ok
mdadm: device 2 in /dev/md1 has wrong state in superblock, but /dev/sdc2 
seems ok
mdadm: /dev/md1 has been started with 3 drives.

** try restarting it with drive details, and it starts

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
/dev/md1:
        Version : 00.90.01
  Creation Time : Mon Jul 18 02:53:55 2005
     Raid Level : raid5
     Array Size : 128384 (125.40 MiB 131.47 MB)
    Device Size : 64192 (62.70 MiB 65.73 MB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Mon Jul 18 02:53:57 2005
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : e798f37d:baf98c2f:e714b50c:8d1018b1
         Events : 0.2

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/.static/dev/sda2
       1       8       18        1      active sync   /dev/.static/dev/sdb2
       2       8       34        2      active sync   /dev/.static/dev/sdc2

** magically, we now have a v00.90.01 superblock, it reports the proper 
list of drives

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -S /dev/md1
root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1
Segmentation fault

** try to stop and restart again, doesn't work

root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -E /dev/sda2
/dev/sda2:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
           Name :
  Creation Time : Mon Jul 18 03:56:40 2005
     Raid Level : raid5
   Raid Devices : 3

    Device Size : 128504 (62.76 MiB 65.79 MB)
   Super Offset : 128504 sectors
          State : clean
    Device UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
    Update Time : Mon Jul 18 03:56:42 2005
       Checksum : 903062ed - correct
         Events : 1

         Layout : left-symmetric
     Chunk Size : 64K

   Array State : Uuu 1 failed

** the drives themselves still report a version 1 superblock... wierd
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------020206010307070400080900
Content-Type: message/rfc822;
 name="Re: bug report: mdadm-devel-2 , superblock version 1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Re: bug report: mdadm-devel-2 , superblock version 1"

X-Account-Key: account2
Return-Path: <linux-raid-owner@vger.kernel.org>
Delivered-To: 1-pml@dtbb.net
Received: (qmail 17786 invoked from network); 18 Jul 2005 02:23:16 -0000
Received: from vger.kernel.org (12.107.209.244)
  by needtoreadit.com with SMTP; 18 Jul 2005 02:23:16 -0000
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S261486AbVGRCTi (ORCPT <rfc822;pml@dtbb.net>);
	Sun, 17 Jul 2005 22:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S261487AbVGRCTi
	(ORCPT <rfc822;linux-raid-outgoing>);
	Sun, 17 Jul 2005 22:19:38 -0400
Received: from outbound04.telus.net ([199.185.220.223]:64422 "EHLO
	priv-edtnes51.telusplanet.net") by vger.kernel.org with ESMTP
	id S261486AbVGRCTe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
	Sun, 17 Jul 2005 22:19:34 -0400
Received: from [192.168.0.28] (really [142.179.55.145])
          by priv-edtnes51.telusplanet.net
          (InterMail vM.6.01.04.04 201-2131-118-104-20050224) with ESMTP
          id <20050718021933.ZASQ24306.priv-edtnes51.telusplanet.net@[192.168.0.28]>;
          Sun, 17 Jul 2005 20:19:33 -0600
Message-ID: <42DB11B8.1090501@dtbb.net>
Date: Sun, 17 Jul 2005 19:19:36 -0700
From: Tyler <pml@dtbb.net>
User-Agent: Mozilla Thunderbird 1.0.5 (Windows/20050711)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-raid@vger.kernel.org
CC: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: bug report: mdadm-devel-2 , superblock version 1
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>	<17114.54800.132155.142544@cse.unsw.edu.au>	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>	<17114.62108.319878.983091@cse.unsw.edu.au>	<010701c58b32$ee423830$c200a8c0@NCNF5131FTH>	<17115.149.130115.176372@cse.unsw.edu.au>	<001601c58b37$620c69d0$c200a8c0@NCNF5131FTH> <17115.1749.370942.838069@cse.unsw.edu.au> <42DB0F41.7030806@dtbb.net>
In-Reply-To: <42DB0F41.7030806@dtbb.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
X-Antivirus: AVG for E-mail 7.0.323 [267.9.0]

As a side note, do I need any kernel patches to use the version 1 
superblocks Neil?  That may be what i'm missing.. as the kernel in use 
currently is a vanilla 2.6.12.3.  I'm not trying to use bitmaps or 
anything else at the moment.

Tyler.

Tyler wrote:

> # uname -a
> Linux server 2.6.12.3 #3 SMP Sun Jul 17 14:38:12 CEST 2005 i686 GNU/Linux
> # ./mdadm -V
> mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 
> July 2005
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -S /dev/md1
>
> ** stop the current array
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -C /dev/md1 -l 5 
> --raid-devices 3 -e 1 /dev/sda2 /dev/sdb2 /dev/sdc2
> mdadm: /dev/sda2 appears to be part of a raid array:
>    level=5 devices=3 ctime=Mon Jul 18 03:22:05 2005
> mdadm: /dev/sdb2 appears to be part of a raid array:
>    level=5 devices=3 ctime=Mon Jul 18 03:22:05 2005
> mdadm: /dev/sdc2 appears to be part of a raid array:
>    level=5 devices=3 ctime=Mon Jul 18 03:22:05 2005
> Continue creating array? y
> mdadm: array /dev/md1 started.
>
> ** create and start new array using 3 drives, superblock version 1
>
> root@server:~/dev/mdadm-2.0-devel-2# cat /proc/mdstat
> Personalities : [raid5]
> md1 : active raid5 sdc2[3] sdb2[1] sda2[0]
>      128384 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>
> unused devices: <none>
>
> ** mdstat mostly okay, except sdc2 is listed as device3 instead of 
> device2 (from 0,1,2)
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
> /dev/md1:
>        Version : 01.00.01
>  Creation Time : Mon Jul 18 03:56:40 2005
>     Raid Level : raid5
>     Array Size : 128384 (125.40 MiB 131.47 MB)
>    Device Size : 64192 (62.70 MiB 65.73 MB)
>   Raid Devices : 3
>  Total Devices : 3
> Preferred Minor : 1
>    Persistence : Superblock is persistent
>
>    Update Time : Mon Jul 18 03:56:42 2005
>          State : clean
> Active Devices : 3
> Working Devices : 3
> Failed Devices : 0
>  Spare Devices : 0
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>           UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
>         Events : 1
>
>    Number   Major   Minor   RaidDevice State
>       0       8        2        0      active sync   
> /dev/.static/dev/sda2
>       1       8       18        1      active sync   
> /dev/.static/dev/sdb2
>       2       0        0        -      removed
>
>       3       8       34        2      active sync   
> /dev/.static/dev/sdc2
>
> ** reports version 01.00.01 superblock, but reports as if there were 4 
> devices used
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -S /dev/md1
>
> ** stop the array
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1
> Segmentation fault
>
> ** try to assemble the array
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
> mdadm: md device /dev/md1 does not appear to be active.
>
> ** check if its active at all
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1 /dev/sda2 
> /dev/sdb2 /dev/sdc2
> mdadm: device 1 in /dev/md1 has wrong state in superblock, but 
> /dev/sdb2 seems ok
> mdadm: device 2 in /dev/md1 has wrong state in superblock, but 
> /dev/sdc2 seems ok
> mdadm: /dev/md1 has been started with 3 drives.
>
> ** try restarting it with drive details, and it starts
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
> /dev/md1:
>        Version : 00.90.01
>  Creation Time : Mon Jul 18 02:53:55 2005
>     Raid Level : raid5
>     Array Size : 128384 (125.40 MiB 131.47 MB)
>    Device Size : 64192 (62.70 MiB 65.73 MB)
>   Raid Devices : 3
>  Total Devices : 3
> Preferred Minor : 1
>    Persistence : Superblock is persistent
>
>    Update Time : Mon Jul 18 02:53:57 2005
>          State : clean
> Active Devices : 3
> Working Devices : 3
> Failed Devices : 0
>  Spare Devices : 0
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>           UUID : e798f37d:baf98c2f:e714b50c:8d1018b1
>         Events : 0.2
>
>    Number   Major   Minor   RaidDevice State
>       0       8        2        0      active sync   
> /dev/.static/dev/sda2
>       1       8       18        1      active sync   
> /dev/.static/dev/sdb2
>       2       8       34        2      active sync   
> /dev/.static/dev/sdc2
>
> ** magically, we now have a v00.90.01 superblock, it reports the 
> proper list of drives
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -S /dev/md1
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1
> Segmentation fault
>
> ** try to stop and restart again, doesn't work
>
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -E /dev/sda2
> /dev/sda2:
>          Magic : a92b4efc
>        Version : 01.00
>     Array UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
>           Name :
>  Creation Time : Mon Jul 18 03:56:40 2005
>     Raid Level : raid5
>   Raid Devices : 3
>
>    Device Size : 128504 (62.76 MiB 65.79 MB)
>   Super Offset : 128504 sectors
>          State : clean
>    Device UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
>    Update Time : Mon Jul 18 03:56:42 2005
>       Checksum : 903062ed - correct
>         Events : 1
>
>         Layout : left-symmetric
>     Chunk Size : 64K
>
>   Array State : Uuu 1 failed
>
> ** the drives themselves still report a version 1 superblock... wierd
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------020206010307070400080900--
