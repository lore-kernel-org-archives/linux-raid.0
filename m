From: "David Lethe" <david@santools.com>
Subject: RE: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte Veliciraptors
Date: Sat, 7 Jun 2008 10:54:57 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97CA53294@34093-C3-EVS3.exchange.rackspace.com>
References: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.1.10.0806071015110.23323@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Cc: Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

This is all interesting, but this has no relevance to the real world,
where computers run application software.  You have a great foundation
here, but it won't help anybody who is running a database, mail, or
file/backup server because the I/Os are too large, and homogeneous.  You
will get profoundly different sweet spots for RAID configurations once
you model your bench to match something that people actually run.  I am
not criticizing you for this, it is just that now I have a taste for
what you have accomplished, and I want more more more :)

David

 
-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Justin Piszcz
Sent: Saturday, June 07, 2008 9:23 AM
To: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org;
xfs@oss.sgi.com
Cc: Alan Piszcz
Subject: Linux MD RAID 5 Benchmarks Across (3 to 10) 300 Gigabyte
Veliciraptors

First, the original benchmarks with 6-SATA drives with fixed formatting,
using
right justification and the same decimal point precision throughout:
http://home.comcast.net/~jpiszcz/20080607/raid-benchmarks-decimal-fix-an
d-right-justified/disks.html

Now for for veliciraptors!  Ever wonder what kind of speed is possible
with
3 disk, 4,5,6,7,8,9,10-disk RAID5s?  I ran a loop to find out, each run
is
executed three times and the average is taken of all three runs per each

RAID5 disk set.

In short? The 965 no longer does justice with faster drives, a new
chipset
and motherboard are needed.  After reading or writing to 4-5
veliciraptors
it saturates the bus/965 chipset.

Here is a picture of the 12 veliciraptors I tested with:
http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-velicir
aptors/raptors.jpg

Here are the bonnie++ results:
http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-velicir
aptors/veliciraptor-raid.html

For those who want the results in text:
http://home.comcast.net/~jpiszcz/20080607/raid5-benchmarks-3to10-velicir
aptors/veliciraptor-raid.txt

System used, same/similar as before:
Motherboard: Intel DG965WH
Memory: 8GiB
Kernel: 2.6.25.4
Distribution: Debian Testing x86_64
Filesystem: XFS with default mkfs.xfs parameters [auto-optimized for SW
RAID]
Mount options: defaults,noatime,nodiratime,logbufs=8,logbsize=262144 0 1
Chunk size: 1024KiB
RAID5 Layout: Default (left-symmetric)
Mdadm Superblock used: 0.90

Optimizations used (last one is for the CFQ scheduler), it improves 
performance by a modest 5-10MiB/s:
http://home.comcast.net/~jpiszcz/raid/20080601/raid5.html

# Tell user what's going on.
echo "Optimizing RAID Arrays..."

# Define DISKS.
cd /sys/block
DISKS=$(/bin/ls -1d sd[a-z])

# Set read-ahead.
# > That's actually 65k x 512byte blocks so 32MiB
echo "Setting read-ahead to 32 MiB for /dev/md3"
blockdev --setra 65536 /dev/md3

# Set stripe-cache_size for RAID5.
echo "Setting stripe_cache_size to 16 MiB for /dev/md3"
echo 16384 > /sys/block/md3/md/stripe_cache_size

# Disable NCQ on all disks.
echo "Disabling NCQ on all disks..."
for i in $DISKS
do
   echo "Disabling NCQ on $i"
   echo 1 > /sys/block/"$i"/device/queue_depth
done

# Fix slice_idle.
# See http://www.nextre.it/oracledocs/ioscheduler_03.html
echo "Fixing slice_idle to 0..."
for i in $DISKS
do
   echo "Changing slice_idle to 0 on $i"
   echo 0 > /sys/block/"$i"/queue/iosched/slice_idle
done

----

Order of tests:

1. Create RAID (mdadm)

Example:


   if [ $num_disks -eq 3 ]; then
     mdadm --create /dev/md3 --verbose --level=5 -n $num_disks -c 1024
-e 0.90 \
     /dev/sd[c-e]1 --assume-clean --run
   fi

2. Run optimize script (above)

See above.

3. mkfs.xfs -f /dev/md3

mkfs.xfs auto-optimized for the underlying devices in an mdadm SW RAID.

4. Run bonnie++ as shown below 3 times, averaged:

/usr/bin/time /usr/sbin/bonnie++ -u 1000 -d /x/test -s 16384 -m p34 -n
16:100000:16:64 > $HOME/test"$run"_$num_disks-disks.txt 2>&1


----

A little more info, after 4-5 dd's, I have already maxed out the
performance
of what the chipset can offer, see below:

knoppix@Knoppix:~$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system--
----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy
id wa
  1  0      0 2755556   6176 203584    0    0   153     1   25  371  3
1 84 11
  0  0      0 2755556   6176 203588    0    0     0     0   66  257  0
0 100  0
  0  1      0 2605400 152204 203584    0    0     0 146028  257  396  0
5 77 18
  0  1      0 2478176 277520 203604    0    0     0 125316  345  794  1
4 75 20
  1  0      0 2349472 403984 203592    0    0     0 119136  297  256  0
5 75 20
  2  1      0 2117292 631172 203512    0    0     0 232336  498 1019  0
8 66 26
  0  2      0 2014400 731968 203556    0    0     0 241472  542 2078  1
11 63 25
  3  0      0 2013412 733756 203492    0    0     0 302104  672 2760  0
14 59 27
  0  3      0 2013576 735624 203520    0    0     0 362524  808 3356  0
15 56 29
  0  4      0 2039312 736728 174860    0    0   120 425484  956 4899  1
20 52 26
  0  4      0 2050236 738508 163712    0    0     0 482868 1008 5030  1
24 46 29
  5  3      0 2050192 737916 163756    0    0     0 531532 1175 6033  0
26 43 31
  3  4      0 2050220 738028 163744    0    0     0 606560 1312 6664  1
32 38 30
  1  5      0 2049432 739184 163628    0    0     0 592756 1291 7195  1
30 35 34
  8  3      0 2049488 738868 163580    0    0     0 675228 1721 10540 1
38 30 31
Here, ~5 raptor 300s, no more linear improvement after this:
  4  4      0 2050048 737816 163744    0    0     0 677820 1771 10514 1
36 32 31
  6  4      0 2048764 738612 163684    0    0     0 697640 1842 13231 1
40 27 33

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


