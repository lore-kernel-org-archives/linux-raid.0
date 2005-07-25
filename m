From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: bug report: mdadm-devel-2 , superblock version 1
Date: Mon, 25 Jul 2005 10:36:22 +1000
Message-ID: <17124.13318.958372.399899@cse.unsw.edu.au>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
	<17114.54800.132155.142544@cse.unsw.edu.au>
	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
	<17114.62108.319878.983091@cse.unsw.edu.au>
	<010701c58b32$ee423830$c200a8c0@NCNF5131FTH>
	<17115.149.130115.176372@cse.unsw.edu.au>
	<001601c58b37$620c69d0$c200a8c0@NCNF5131FTH>
	<17115.1749.370942.838069@cse.unsw.edu.au>
	<42DB0F41.7030806@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Sunday July 17
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 17, pml@dtbb.net wrote:
> # uname -a
> Linux server 2.6.12.3 #3 SMP Sun Jul 17 14:38:12 CEST 2005 i686 GNU/Linux
> # ./mdadm -V
> mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 July 2005
> 

...
> root@server:~/dev/mdadm-2.0-devel-2# cat /proc/mdstat
> Personalities : [raid5]
> md1 : active raid5 sdc2[3] sdb2[1] sda2[0]
>       128384 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> 
> unused devices: <none>
> 
> ** mdstat mostly okay, except sdc2 is listed as device3 instead of 

Hmmm, yes....  It is device number 3 in the array, but it is playing
role-2 in the raid5.  When using Version-1 superblocks, we don't moved
devices around, in the "list of all devices".  We just assign them
different roles. (device-N or 'spare').


> device2 (from 0,1,2)
> 
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
> /dev/md1:
>         Version : 01.00.01
>   Creation Time : Mon Jul 18 03:56:40 2005
>      Raid Level : raid5
>      Array Size : 128384 (125.40 MiB 131.47 MB)
>     Device Size : 64192 (62.70 MiB 65.73 MB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Jul 18 03:56:42 2005
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
>          Events : 1
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/.static/dev/sda2
>        1       8       18        1      active sync   /dev/.static/dev/sdb2
>        2       0        0        -      removed
> 
>        3       8       34        2      active sync   /dev/.static/dev/sdc2
> 
> ** reports version 01.00.01 superblock, but reports as if there were 4 
> devices used

Ok, this output definitely needs fixing.  But as you can see, there
are 3 devices playing roles (RaidDevice) 0, 1, and 2.  They reside in
slots 0, 1, and 3 of the array.

> 
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1
> Segmentation fault
> 
> ** try to assemble the array

This is not how you assemble an array.  You need to tell mdadm which
component devices to use, either on command line or in /etc/mdadm.conf
(and give --scan).

> 
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
> mdadm: md device /dev/md1 does not appear to be active.
> 
> ** check if its active at all
> 
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1 /dev/sda2 
> /dev/sdb2 /dev/sdc2
> mdadm: device 1 in /dev/md1 has wrong state in superblock, but /dev/sdb2 
> seems ok
> mdadm: device 2 in /dev/md1 has wrong state in superblock, but /dev/sdc2 
> seems ok
> mdadm: /dev/md1 has been started with 3 drives.
> 
> ** try restarting it with drive details, and it starts

Those message are a bother though.  I think I know roughly what is
going on.  I'll look into it shortly.

> 
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
> /dev/md1:
>         Version : 00.90.01
>   Creation Time : Mon Jul 18 02:53:55 2005
>      Raid Level : raid5
>      Array Size : 128384 (125.40 MiB 131.47 MB)
>     Device Size : 64192 (62.70 MiB 65.73 MB)
>    Raid Devices : 3
>   Total Devices : 3
> Preferred Minor : 1
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Jul 18 02:53:57 2005
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 0
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>            UUID : e798f37d:baf98c2f:e714b50c:8d1018b1
>          Events : 0.2
> 
>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/.static/dev/sda2
>        1       8       18        1      active sync   /dev/.static/dev/sdb2
>        2       8       34        2      active sync   /dev/.static/dev/sdc2
> 
> ** magically, we now have a v00.90.01 superblock, it reports the proper 
> list of drives

Ahhh...  You have assembled a different array (look at create time too).
version-1 superblocks live at a different location to version-0.90
superblocks.  So it is possible to have both on the one drive.  It is
supposed to pick the newest, but appears not to have done.  You should
really remove old superblocks.... maybe mdadm should do that for you
???

> 
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -S /dev/md1
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1
> Segmentation fault
> 
> ** try to stop and restart again, doesn't work

Again, don't do that!

> 
> root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -E /dev/sda2
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 01.00
>      Array UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
>            Name :
>   Creation Time : Mon Jul 18 03:56:40 2005
>      Raid Level : raid5
>    Raid Devices : 3
> 
>     Device Size : 128504 (62.76 MiB 65.79 MB)
>    Super Offset : 128504 sectors
>           State : clean
>     Device UUID : 1baa875e87:9ec208b2:7f5e6a27:db1f5e
>     Update Time : Mon Jul 18 03:56:42 2005
>        Checksum : 903062ed - correct
>          Events : 1
> 
>          Layout : left-symmetric
>      Chunk Size : 64K
> 
>    Array State : Uuu 1 failed
> 
> ** the drives themselves still report a version 1 superblock... wierd

Yeh.  Assemble and Examine should pick the say one by default.  It
appears they don't.  I'll look into it.

Thanks for the very helpful  feedback.

NeilBrown
