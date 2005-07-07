From: Maxim Kozover <maximkoz@netvision.net.il>
Subject: Re[2]: Bugreport mdadm-2.0-devel-1
Date: Thu, 07 Jul 2005 04:30:13 +0300
Message-ID: <1892534227.20050707043013@netvision.net.il>
References: <1684363827.20050706121331@netvision.net.il>
 <17100.29413.164442.415932@cse.unsw.edu.au>
Reply-To: Maxim Kozover <maximkoz@netvision.net.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <17100.29413.164442.415932@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil!
Thanks much for your help, array creation using devel-2 just works,
however, the array can't be assembled again after it's stopped:(

# mdadm --zero-superblock -e 1 /dev/sdb
# mdadm --zero-superblock -e 1 /dev/sdc
# /bin/rm -rf /bitmap
# mdadm -C /dev/md0 -e 1 --bitmap /bitmap -l 1 -n 2 /dev/sdb /dev/sdc
mdadm: array /dev/md0 started.
# more /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdc[1] sdb[0]
      33554424 blocks [2/2] [UU]
      [>....................]  resync =  0.6% (206400/33554424) finish=16.1min s
peed=34400K/sec
      bitmap: 4096/4096 pages [16384KB], 4KB chunk, file: /bitmap

unused devices: <none>
# mdadm -S /dev/md0
# more /proc/mdstat
Personalities : [raid1]
unused devices: <none>
# mdadm -A /dev/md0 -e 1 --bitmap /bitmap /dev/sdb /dev/sdc
mdadm: device 1 in /dev/md0 has wrong state in superblock, but /dev/sdc seems ok
mdadm: failed to add /dev/sdc to /dev/md0: Invalid argument
mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 0 drives - not enough to start the array.
(even if you stop the array after resync completes, it doesn't matter
as expected).

Please advise.

BTW, my endian.h (and the files it includes) also doesn't provide various
conversion functions, although byteorder.h advises to use it.

Thanks,

Maxim.

Thursday, July 7, 2005, 3:10:13 AM, you wrote:

NB> On Wednesday July 6, maximkoz@netvision.net.il wrote:
>> Hi!
>> I'm getting problems with raid1 creation using new superblock format.
>> Kernel used is 2.6.12.2 (with drivers/md and include/linux/raid taken from
>> 2.6.13-rc1 to have a support for bitmaps and bug correction of md
>> failing when starting resync), all compiled together.
>> 
>> For mdadm I tried both mdadm-2.0-devel-1 and mdadm-2.0-devel-1a.
>> Compiles only if -Werror is removed from the Makefile, otherwise
>> /usr/include/asm/byteorder.h:6:2: #warning using private kernel
>> header; include <endian.h> instead!

NB> Hmmm... I don't get that.  I must have different header files.  And my
NB> <endian.h> doesn't provide the needed functionality :-(

NB> Anyway, try
NB>  
NB> http://www.cse.unsw.edu.au/~neilb/source/mdadm/mdadm-2.0-devel-2.tgz

NB> (and remove -Werror).  It works for me with the command line that you
NB> give.

NB> NeilBrown


