From: "=?ISO-8859-2?Q?Micha=B3_Przy=B3uski?=" <mikylie@gmail.com>
Subject: Re: mdadm bug - inconsistent output in -D mode
Date: Sun, 18 Jan 2009 21:04:37 +0100
Message-ID: <6c4602af0901181204h4301a37ctdfdf57ec6ac69d3b@mail.gmail.com>
References: <496F22FF.2080305@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496F22FF.2080305@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2009/1/15 Peter Rabbitson <rabbit+list@rabbit.us>:
> Hi,
>
> I suppose this is a remnant of the effort to convert all sector counts
> to bytes. Consider this output:

Hello,
I have the same issue (not a biggie anyway) with a 6*750G raid6. I
guess it might be
related to 1.x superblocks though, I don't recall that happening with
my old 0.9 stuff.

[root@kylie kotek]# ~kotek/mdadm-2.6.4/mdadm --detail /dev/md1
/dev/md1:
        Version : 01.01.03
  Creation Time : Mon Nov 10 19:59:48 2008
     Raid Level : raid6
     Array Size : 2930294784 (2794.55 GiB 3000.62 GB)
  Used Dev Size : 1465147392 (698.64 GiB 750.16 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sun Jan 18 20:44:35 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 1024K

           Name : 1
           UUID : 4eaba5a9:cb767b93:c73450fe:c1dc27c9
         Events : 487870

    Number   Major   Minor   RaidDevice State
       0       8       48        0      active sync   /dev/sdd
       1       8       64        1      active sync   /dev/sde
       4       8       96        2      active sync   /dev/sdg
       5       8       80        3      active sync   /dev/sdf
       7       8       32        4      active sync   /dev/sdc
       6       8       16        5      active sync   /dev/sdb
[root@kylie kotek]# ~kotek/mdadm-2.6.7/mdadm --detail /dev/md1
/dev/md1:
        Version : 01.01
  Creation Time : Mon Nov 10 19:59:48 2008
     Raid Level : raid6
     Array Size : 2930294784 (2794.55 GiB 3000.62 GB)
  Used Dev Size : 1465147392 (1397.27 GiB 1500.31 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Sun Jan 18 20:44:39 2009
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 1024K

           Name : 1
           UUID : 4eaba5a9:cb767b93:c73450fe:c1dc27c9
         Events : 487870

    Number   Major   Minor   RaidDevice State
       0       8       48        0      active sync   /dev/sdd
       1       8       64        1      active sync   /dev/sde
       4       8       96        2      active sync   /dev/sdg
       5       8       80        3      active sync   /dev/sdf
       7       8       32        4      active sync   /dev/sdc
       6       8       16        5      active sync   /dev/sdb

and --examine in all cases gives (what seems to be) correct data, that is

 Avail Dev Size : 1465148904 (698.64 GiB 750.16 GB)
     Array Size : 5860589568 (2794.55 GiB 3000.62 GB)
  Used Dev Size : 1465147392 (698.64 GiB 750.16 GB)



> root@Thesaurus:~# mdadm -E /dev/sda1
[snip]
>
>    Array Slot : 5 (failed, failed, 2, 3, 0, 1)  <--- by the way: wtf?
>   Array State : uUuu 2 failed                   <--- ditto

    Array Slot : 6 (0, 1, failed, failed, 2, 3, 5, 4)
   Array State : uuuuuU 2 failed

That's how it looks here, and I guess that's perfectly OK. There was a
post on the list
by Neil regarding that matter some weeks ago. I believe those 2*fails are
due to a way that raid5/6 is created - as a degraded array, which will
rebuild to the nth disk.

However, in my case, it might be caused by the fact the array was
created with 1 really
missing drive (i.e. it contained 3, then 4, then 6 drives).

Oh, got it:
date	20 December 2008 02:16
subject	Re: can you help explain some --examine output to me?

> root@Thesaurus:~# mdadm -V
> mdadm - v2.6.7.1 - 15th October 2008
here 2.6.2 and 2.6.4 are correct, and 2.6.7 not quite.

Well ok, correct in terms of "human readable output", hard to say if
raw data is
correct, all depends if it's sectors or bytes, as Peter mentioned.

[kotek@kylie ~]$ uname -a
Linux kylie 2.6.23-0.214.rc8.git2.fc8 #1 SMP Fri Sep 28 17:10:49 EDT
2007 x86_64 x86_64 x86_64 GNU/Linux

> root@Thesaurus:~# uname -a
> Linux Thesaurus 2.6.24.7.th1 #1 PREEMPT Sun May 11 20:18:05 CEST 2008
> i686 GNU/Linux
>
> P.S. I know my kernel is old, but I suspect it's a mdadm problem.
Mine is older! ;-)

Greets,
Mike
