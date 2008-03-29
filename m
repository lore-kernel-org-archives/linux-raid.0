From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: md: raid5 vs raid10 (f2,n2,o2) benchmarks [w/10 raptors]
Date: Sat, 29 Mar 2008 14:20:03 -0400 (EDT)
Message-ID: <alpine.DEB.1.00.0803291410470.6900@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

There has been a lot of discussion on the mailing list regarding the 
various raid10 replicas so I benchmarked them compared to RAID 5 all with 
no optimizations and then re-ran the tests with optimizations, RAID 5 
still generally turns out the best speed for sequential writes but 
raid10_f2 seems to overtake raid5 for reads.

All tests used the XFS filesystem.

For the results that show 0 this is when bonnie++ reports '+++' for the result
which means it went too fast and needed to capture more data to give an
accurate number; however, I was only interested in the sequential read and
write speeds.  All tests are with default mkfs.xfs options, where I used
optimizations for the filesystem, these are only mount option parameters
as follows: noatime,nodiratime,logbufs=8,logbsize=262144.  I have done a lot
of testing in the past with mkfs.xfs and its default parameters optimize
to a physical HDD or mdraid so there is little point/gain to try to optimize
it any further.

Results:
http://home.comcast.net/~jpiszcz/20080329-raid/

I have gone back to my RAID 5 optimized configuration, I am done testing 
for now :)

__CREATION
1. Test RAID 10 with no optimizations to the disks or filesystems.
    a. mdadm --create /dev/md3 --assume-clean --chunk=256 --level=raid10 --raid-devices=10 --spare-devices=0 --layout=f2 /dev/sd[c-l]1
    b. mdadm --create /dev/md3 --assume-clean --chunk=256 --level=raid10 --raid-devices=10 --spare-devices=0 --layout=n2 /dev/sd[c-l]1
    c. mdadm --create /dev/md3 --assume-clean --chunk=256 --level=raid10 --raid-devices=10 --spare-devices=0 --layout=o2 /dev/sd[c-l]1
2. Test RAID 5 with no optimizations as well using the default layout.
    a. mdadm --create /dev/md3 --assume-clean --chunk=256 --level=raid5 --raid-devices=10 --spare-devices=0 /dev/sd[c-l]1
3. Test RAID 5 with optimizations.
    a. mdadm --create /dev/md3 --assume-clean --chunk=1024 --level=raid5 --raid-devices=10 --spare-devices=0 /dev/sd[c-l]1

__SETUP
2. Format and set permissions and run benchmarks.
    a. mkfs.xfs -f /dev/md3; mount /dev/md3 /r1; mkdir /r1/x
       chown -R jpiszcz:users /r1

__TEST
3. Run the following bonnie++ benchmark 3 times and take the average.
    a. /usr/bin/time /usr/sbin/bonnie++ -d /x/test -s 16384 -m p34 -n 16:100000:16:64
    b. A script will be responsible for running it 3 times and the total time
       of all runs will also be taken.

__RESULTS (REGULAR)
   a. Total time for f2: 34:35.75elapsed 69%CPU
   b. bonnie++ csv line below:
      p34_f2,16G,79314.7,99,261108,43,110668,14,82252,99,529999,38.6667,866.333,1,16:100000:16/64,5910.67,43.3333,0,0,10761,48.3333,6586,47.6667,0,0,9575.33,50

   c. Total time for n2: 36:39.66elapsed 67%CPU
   d. bonnie++ csv line below:
      p34_n2,16G,76630.3,99,290732,48.3333,118666,16,80120.3,99,216790,16,915.433,1,16:100000:16/64,3973.33,29.6667,9661,20,19641.3,87.6667,5568,40.6667,0,0,10982.3,57.3333

   e. Total time for o2: 35:51.84elapsed 67%CPU
   f. bonnie++ csv line below:
      p34_o2,16G,79096.3,99,288396,47,130531,17,80963.3,99,205556,14,867.267,1,16:100000:16/64,5490,40.3333,0,0,9218,41.6667,7504,54.6667,0,0,9896,52

   g. Total time for raid5 (256 KiB chunk): 45:44.73elapsed 54%CPU
   h. bonnie++ csv line below:
      p34_r5d,16G,76698,99,156443,25.6667,83565.7,14.3333,80975.3,98.3333,318142,22.3333,691.067,1,16:100000:16/64,864,7.33333,6716.33,17,542,3.33333,868.333,7.33333,6642,18,491,3.33333

__RESULTS (OPTIMIZED)
   a. Total time for f2 (block+fs optimizations): 33:33.13elapsed 72%CPU
   b. bonnie++ csv line below:
      p34o_f2,16G,79408.7,99,271643,45,133114,17.3333,80911.3,99,436018,31.3333,887.233,1,16:100000:16/64,5649,41.6667,0,0,17981.7,78.3333,4830,36.3333,0,0,17068.7,95

   c. Total time for n2 (block+fs optimizations): 33:45.89elapsed 72%CPU
   d. bonnie++ csv line below:
      p34o_n2,16G,79750,99,272355,45,148752,20,81030.3,99,288662,21,926.733,1,16:100000:16/64,6797.67,50.3333,10022.3,23,12250,56.3333,5875,43.3333,0,0,18063.3,97.3333

   e. Total time for o2 (block+fs optimizations): 34:54.18elapsed 69%CPU
   f. bonnie++ csv line below:
      p34o_o2,16G,79807,99,266949,44,147301,19.3333,80913.3,98.6667,216350,15,853.3,1,16:100000:16/64,6397.33,47.6667,0,0,19130,84.3333,5833.67,43.3333,0,0,13921.7,75.3333

   i. Total time for raid5 (1024 KiB chunk)(block+fs optimizations)
      32:02.28elapsed 79%CPU
   j. bonnie++ csv line below:
      p34o_r5d,16G,75961,99,389603,84.6667,185017,31.3333,81636.7,99,496843,36,659.467,1,16:100000:16/64,2836,24,10498,29,2842.67,18,4686.33,50.6667,13650.3,46.6667,2419.67,19

Notes:
1. Problem found with mkfs.xfs using such a large stripe size with RAID10:
# mkfs.xfs /dev/md3 -f
log stripe unit (1048576 bytes) is too large (maximum is 256KiB)
log stripe unit adjusted to 32KiB
2. I will use 256 KiB for all RAID 10 testing.
    and the non-optimized RAID 5 test.

Other misc info for RAID 10:
p34:~# mkfs.xfs /dev/md3 -f
meta-data=/dev/md3               isize=256    agcount=32, agsize=5723456 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=183150592, imaxpct=25
          =                       sunit=64     swidth=640 blks
naming   =version 2              bsize=4096 
log      =internal log           bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=64 blks, lazy-count=0
realtime =none                   extsz=2621440 blocks=0, rtextents=0
p34:~#

p34:~# mount /dev/md3 /r1
p34:~#

p34:~# df -h
/dev/md3              699G  5.1M  699G   1% /r1
p34:~#


