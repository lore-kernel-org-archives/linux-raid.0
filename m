From: "Yogesh Pahilwan" <pahilwan.yogesh@spsoftindia.com>
Subject: RE: Problem in creating RAID5 MD array with kernel 2.6.15
Date: Tue, 11 Apr 2006 13:34:49 +0530
Message-ID: <WMED1FEC7E29EA4e0dBEDDA102FB63BC25@spsoftindia.com>
References: <17467.23346.965887.568254@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17467.23346.965887.568254@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Actually I want to calculate the performance of a RAID5 MD array in rebuild
state.

For doing this I do the following steps:

# mdadm -f /dev/md0 /dev/sda
mdadm: set /dev/sda faulty in /dev/md0

# mdadm -r /dev/md0 /dev/sda
mdadm: hot remove failed for /dev/sda: Device or resource busy

# tail -f /var/log/messages shows 

Apr 11 01:48:11 localhost kernel:  <1>raid5: Disk failure on sda, disabling
device. Operation continuing on 3 devices
Apr 11 01:48:24 localhost ntpd[3540]: synchronized to LOCAL(0), stratum 10
Apr 11 01:48:24 localhost ntpd[3540]: kernel time sync disabled 0041
Apr 11 01:48:26 localhost kernel: md: cannot remove active disk sda from md0
...
Apr 11 01:49:26 localhost ntpd[3540]: synchronized to 10.8.0.8, stratum 3
Apr 11 01:50:51 localhost kernel: md: cannot remove active disk sda from md0
...
Apr 11 01:51:58 localhost kernel: md: cannot remove active disk sda from md0
...
Apr 11 01:54:16 localhost kernel: md: cannot remove active disk sda from md0
...
Apr 11 01:57:11 localhost kernel: md: cannot remove active disk sda from md0
.

I am not getting why I am not able to hot remove /dev/sda from /dev/md0?


# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Apr 11 01:47:20 2006
     Raid Level : raid5
     Array Size : 1465159488 (1397.29 GiB 1500.32 GB)
    Device Size : 488386496 (465.76 GiB 500.11 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : /tmp/bitmap.txt

    Update Time : Tue Apr 11 01:47:20 2006
          State : clean, degraded
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 5ce49b71:e6083c2a:121b9ac2:cb675771
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0       8        0        0      faulty spare rebuilding   /dev/sda
       1       8       16        1      active sync   /dev/sdb
       2       8       32        2      active sync   /dev/sdc
       3       8       48        3      active sync   /dev/sdd

This output shows that RAID5 /dev/md0 is in the degraded mode?

How should I rebuild this RAID5 so that I can calculate I/O performance
while rebuilding RAID5 MD Array?

Thanks,
Yogesh






-----Original Message-----
From: Neil Brown [mailto:neilb@suse.de] 
Sent: Tuesday, April 11, 2006 1:01 PM
To: Yogesh Pahilwan
Cc: linux-raid@vger.kernel.org
Subject: RE: Problem in creating RAID5 MD array with kernel 2.6.15

On Tuesday April 11, pahilwan.yogesh@spsoftindia.com wrote:
> Hi Neil,
> 
> I have set --bitmap-chunk=1024 and RAID5 gets created successfully.

Good.

> 
> But why I will have to set --bitmap-chunk for big size devices such as
500GB
> each in my case?
> 
> What is the default value of --bitmap-chunk?

4, which is probably too low.

For every 2048 chunks, md potentially needs to allocate one page.
md also needs to allocate a table to hold all these pages.

At a chunk size of 4K, your 500GB would use 125million chunks.
That's 64000 pages - but these are only allocated on demand, and we can
survive failure.
However the table would need 4 bytes per page, or 250K
Allocating a 250K stable is unlikely to succeed due to memory
fragmentation.

With 1024K chunks you only need 1K, which is easy.

You could safely go down to 256K chunks but I'm not sure it would gain
much.

I have put a note on my mdadm todo list to choose a more sensible
default chunk size which limits the number of chunks to 2million.

NeilBrown

