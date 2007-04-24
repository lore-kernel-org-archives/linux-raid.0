From: David Greaves <david@dgreaves.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 13:00:37 +0100
Message-ID: <462DF165.8070308@dgreaves.com>
References: <462CC91B.8030008@dgreaves.com>	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com>	<17965.18112.135843.417561@notabene.brown>	<462DCC4E.2020108@dgreaves.com> <17965.57989.120710.460711@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17965.57989.120710.460711@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday April 24, david@dgreaves.com wrote:
>> Neil Brown wrote:
>>> This problem is very hard to solve inside the kernel.
>>> The partitions will not be visible until the array is opened *after*
>>> it has been created.  Making the partitions visible before that would
>>> be possible, but would be very easy.
>>>
>>> I think the best solution is Mike's solution which is to simply
>>> open/close the array after it has been assembled.  I will make sure
>>> this is in the next release of mdadm.
>>>
>>> Note that you can still access the partitions even though they do not
>>> appear in /proc/partitions. Any attempt to access and of them will
>>> make them all appear in /proc/partitions.  But I understand there is
>>> sometimes value in seeing them before accessing them.
>>>
>>> NeilBrown
>> Um. Are you sure?
> 
> "Works for me".
Lucky you ;)

> What happens if you
>   blockdev --rereadpt /dev/md_d0
> ?? It probably works then.
Well, that's probably the same as my BLKRRPART ioctl so I guess yes.
[confirmed - yes, but blockdev seems to do it twice - I get 2 kernel messages]

> It sounds like someone is deliberately removing all the partition
> info.
Gremlins?

> Can you try this patch and see if it reports anyone calling
> '2' on md_d0 ??

Nope, not being called at all.

teak:~# mdadm --assemble /dev/md_d0 --auto=parts /dev/sd[bcdef]1
mdadm: /dev/md_d0 has been started with 5 drives.

dmesg:
md: bind<sdc1>
md: bind<sdd1>
md: bind<sdb1>
md: bind<sdf1>
md: bind<sde1>
raid5: device sde1 operational as raid disk 0
raid5: device sdf1 operational as raid disk 4
raid5: device sdb1 operational as raid disk 3
raid5: device sdd1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 5236kB for md_d0
raid5: raid level 5 set md_d0 active with 5 out of 5 devices, algorithm 2
RAID5 conf printout:
 --- rd:5 wd:5
 disk 0, o:1, dev:sde1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sdd1
 disk 3, o:1, dev:sdb1
 disk 4, o:1, dev:sdf1
md_d0: bitmap initialized from disk: read 1/1 pages, set 0 bits, status: 0
created bitmap (10 pages) for device md_d0


teak:~# mount /media
mount: special device /dev/md_d0p1 does not exist

no dmesg


teak:~# blockdev --rereadpt /dev/md_d0
dmesg:
 md_d0: p1 p2
 md_d0: p1 p2


did I mention 2.6.20.7 and mdadm v2.5.6 and udev

I'd be happy if I've done something wrong...

anyway, more config data...

teak:~# mdadm --detail /dev/md_d0
/dev/md_d0:
        Version : 01.02.03
  Creation Time : Mon Apr 23 15:13:35 2007
     Raid Level : raid5
     Array Size : 1250241792 (1192.32 GiB 1280.25 GB)
    Device Size : 625120896 (298.08 GiB 320.06 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Tue Apr 24 12:49:26 2007
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : media
           UUID : f7835ba6:e38b6feb:c0cd2e2d:3079db59
         Events : 25292

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync   /dev/sde1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       5       8       17        3      active sync   /dev/sdb1
       4       8       81        4      active sync   /dev/sdf1
teak:~# cat /etc/mdadm/mdadm.conf
DEVICE partitions
ARRAY /dev/md_d0 auto=part level=raid5 num-devices=5
UUID=f7835ba6:e38b6feb:c0cd2e2d:3079db59
MAILADDR david@dgreaves.com



David
