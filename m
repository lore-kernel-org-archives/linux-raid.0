From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Without tweaking ,  (was:Re: mkfs options for a 16x hw raid5
 and xfs ...)
Date: Wed, 26 Sep 2007 14:12:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0709261406010.24646@p34.internal.lan>
References: <Pine.LNX.4.64.0709260953580.12074@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0709260953580.12074@filesrv1.baby-dragons.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Wed, 26 Sep 2007, Mr. James W. Laferriere wrote:

> 	Hello Justin & all ,
>
>> ----------Justin Piszcz Wrote: ----------
>> Date: Wed, 26 Sep 2007 12:24:20 -0400 (EDT)
>> From: Justin Piszcz <jpiszcz@lucidpixels.com>
>> Subject: Re: mkfs options for a 16x hw raid5 and xfs (mostly large files)
>> 
>> I have a question, when I use multiple writer threads (2 or 3) I see 
>> 550-600 MiB/s write speed (vmstat) but when using only 1 thread, ~420-430 
>> MiB/s... Also without tweaking, SW RAID is very slow (180-200 MiB/s) using 
>> the same disks.
>> Justin.
> 	Speaking of 'without tweaking' ,  Might you have or know of a 
> relatively accurate list of points to begin tweaking & possible( even guesses 
> at the) out come of making those changes ?
>
> 	We(maybe even I) could put together a patch for tuning options in the 
> Documentation directory (&/or other files if necessary) .
> 	The kernel method would allow those with 'doxygen' (amongst other 
> installed tools ) acquire a mediocum of information .
> 	The info could be ,  ear marked .  Such as fs-tunable ,  disk-tunable 
> ,
> for ease of identification of the intended subject matter .
> 	Tho without a list of the present known tunables I am probably going 
> to find the challenge a bit confusing as well as time consuming .
> 	At present I believe I (just might) be able to ,  with everyones help 
> ,
> put together a list for the linux-raid tunables .  Note: 'with everyones 
> help' .
>
> 	Just thoughts .
>

Well here is a start:

I am sure these will be highly argued over but after weeks of
benchmarking these "work for me" with a 10-disk Raptor Software RAID5
disk set.  They may not be good for all workloads.  I also have a 6-disk
400GB SATA RAID5 and I find a 256k chunk size offers the best
performance.

Here is what I optimize:

Stripe size of the volume is 1 megabyte, mainly dealing with large files 
here:  I use the default, left-symmetric layout for the RAID5.

I utilize XFS on-top of the MD, it has been mentioned you may incur a 
'hit' if using LVM.

# mdadm -D /dev/md3
/dev/md3:
         Version : 00.90.03
   Creation Time : Wed Aug 22 10:38:53 2007
      Raid Level : raid5
      Array Size : 1318680576 (1257.59 GiB 1350.33 GB)
   Used Dev Size : 146520064 (139.73 GiB 150.04 GB)
    Raid Devices : 10
   Total Devices : 10
Preferred Minor : 3
     Persistence : Superblock is persistent

     Update Time : Wed Sep 26 14:02:18 2007
           State : clean
  Active Devices : 10
Working Devices : 10
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 1024K

            UUID : e37a12d1:1b0b989a:083fb634:68e9eb49
          Events : 0.4178


Without any optimizations I get very poor performance, again, 160-220 
MiB/s with no optimizations for read and write.

With the optimizations, yes just sequential performance, but I see ~430 
MiB/s reads with ~500-630 MiB/s writes using XFS.

I use the following mount options as I have found them to offer the best 
overall performance, I have tried various logbufs settings: 2,4,8 and 
different log buffer sizes and have found these to be the best.
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
/dev/md3        /r1             xfs     noatime,nodiratime,logbufs=8,logbsize=262144 0 1


Now for the specific optimizations:
echo "Setting max_sectors_kb to 128 KiB"
for i in $DISKS
do
   echo "Setting /dev/$i to 128 KiB..."
   echo 128 > /sys/block/"$i"/queue/max_sectors_kb
done

echo "Setting nr_requests to 512 KiB"
for i in $DISKS
do
   echo "Setting /dev/$i to 512K KiB"
   echo 512 > /sys/block/"$i"/queue/nr_requests
done

echo "Setting read-ahead to 64 MiB for /dev/md3"
blockdev --setra 65536 /dev/md3

echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
echo 16384 > /sys/block/md3/md/stripe_cache_size

# Set minimum and maximum raid rebuild speed to 30MB/s.
echo "Setting minimum and maximum resync speed to 30 MiB/s..."
echo 30000 > /sys/block/md3/md/sync_speed_min
echo 30000 > /sys/block/md3/md/sync_speed_max
^ The above step is needed because there is a bug in the md raid code if you
use stripe sizes larger than 128k or so with a big stripe_cache_size, it does 
not know how to handle that and the RAID verifies/etc run at a paltry 1 MiB/s 
or less.

For raptors, they are inheriently known for their poor speed when NCQ is
enabled, I see 20-30MiB/s better performance with NCQ off.
echo "Disabling NCQ on all disks..."
for i in $DISKS
do
   echo "Disabling NCQ on $i"
   echo 1 > /sys/block/"$i"/device/queue_depth
done

Justin.
