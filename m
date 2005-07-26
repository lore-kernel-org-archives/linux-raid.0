From: Gaspar Bakos <gbakos@cfa.harvard.edu>
Subject: 3ware + RAID5 + xfs performance
Date: Mon, 25 Jul 2005 21:11:19 -0400 (EDT)
Message-ID: <Pine.SOL.4.58.0507252110320.2683@titan.cfa.harvard.edu>
Reply-To: gbakos@cfa.harvard.edu
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

Dear all,

The purpose of this email is twofold:
- to share the results of the many tests I performed with
  a 3ware RAID card + RAID-5 + XFS, pushing for better file I/O,
- and to initiate some brainstorming on what parameters can be tuned for
  getting a good performance out of this hardware under 2.6.* kernels.

I started all these tests because the performance was quite poor, meaning
that the write speed was slow, the read speed was barely acceptable, and the
system load went very high (10.0) during bonnie++ tests.
My questions are marked below with "Q".

1.
There are many useful links related to the 3ware card and related anomalies.
The bugzilla page:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=121434
contains some 260 comments. It is mostly 2.4 kernel and RHEL specific.

2.
A newer description of the problem can be found in the thread:
http://lkml.org/lkml/2005/4/20/110
http://openlab-debugging.web.cern.ch/openlab-debugging/raid/
by Andreas Hirstius.
There was a nasty fls() bug, which was eliminated recently, and improved
performance and stability.

3.
There are recommendations by 3ware, which can be
summarized in one line: "blockdev --setra 16384".
http://www.3ware.com/reference/techlibrary.asp
"Maximum Performance for Linux Kernel 2.6 Combined with XFS File System",
which actually leads to a PDF that has a different title:
"Benchmarking the 9000 controller with linux 2.6".


Q: Any other useful links?

Briefly, the hardware setup I use
=================================
- Tyan S2882 Thunder K8S Pro motherboard
- Dual AMD opteron CPUs
- 4Gb RAM
- 3ware 9500-8S 8 port serial ATA controller
- 8 x 300GB ST3300831AS SATA Seagate disks in hardware RAID-5
More details at the end of this email.

OS/setup
=======
- Redhat FC3, first with 2.6.9-1.667smp kernel, then with all the upgrades,
  and finally a self-compiled 2.6.12.3 x86_64 kernel
- XFS filesystem
- Raid strip size = 64k, write-cache enabled
Kernel config attached.

==========================================================================
Tuneable parameters
====================
1. Kernel itself. I tried 2.6.9-1.667smp, 2.6.11-1.14_FC3smp, and 2.6.12.3
(self-compiled)

	1.a Kernel config (NUMA system, etc.)

2. Raid setup on the card.
	- Write-cache enabled? (I use "YES")
	- Raid strip size
	- firmware, bios, etc. on the card
	- staggered spinup (I use "YES", but the drives may not support it.
	  I always "warm up" the unit before the tests, )

3. 3ware driver version
- 3w-9xxx_2.26.02.002 the older version in the kernels
- 3w-9xxx_2.26.03.015fw from the 3ware website, containing the firmware as
  well.

4. Run-time kernel parameters (my device is /dev/sde):

	4.a
		/sys/class/scsi_host/host6/
		cmd_per_lun
		can_queue

	4.b
		/sys/block/sde/queue/, e.g.
		iosched            max_sectors_kb  read_ahead_kb
		max_hw_sectors_kb  nr_requests     scheduler

	4.c
		/sys/block/sde/device/ e.g.
		queue_depth

	4.d Other params from the 2.4 kernel, if they have an alternative in
		2.6:

		/proc/sys/vm/max-readahead

	Q: Anything else?

5. blockdev --setra
	This is possibly belongs to those points mentioned under 4.)

6. For not raw IO (dd), the XFS filesystem parameters.

7. Q: Anything crucial parameter i am missing?

==========================================================================
Tests
=====
I changed the following during the tests. It is not an orthogonal set of
parameters, and I did not try everything with every combination.

- kernel
- raid strip size: 64K and 256K
- 3ware driver and firmware
- /sys/block/sde/queue/nr_requests
- blockdev --setra xxx /dev/sde
- XFS filesystem parameters

I used 5 bonnie++ commands to do not only simple IO, but also combined
filesystem performance:

MOUNT=/mnt/3w1/un0
SIZE=20480
echo "Bonnie test for IO performance"
sync; time bonnie++ -m cfhat5 -n 0   -u 0 -r 4092 -s $SIZE -f -b -d $MOUNT
echo "Testing with zero size files"
sync; time bonnie++ -m cfhat5 -n 50:0:0:50 -u 0 -r 4092 -s 0 -b -d $MOUNT
echo "Testing with tiny files"
sync; time bonnie++ -m cfhat5 -n 20:10:1:20 -u 0 -r 4092 -s 0 -b -d $MOUNT
echo "Testing with 100Kb to 1Mb files"
sync; time bonnie++ -m cfhat5 -n 10:1000000:100000:10 -u 0 -r 4092 -s 0 -b -d $MOUNT
echo "Testing with 16Mb size files"
sync; time bonnie++ -m cfhat5 -n 1:17000000:17000000:10 -u 0 -r 4092 -s 0 -b -d $MOUNT

==========================================================================
System information during the tests
===================================
This is just to make sure the system is behaving OK, and to catch some
errors. Done only outside the recorded tests, so as not to affect the
results.

1. top, or cat /proc/loadavg
to see the load

2. iostat, iostat -x

3. vmstat

4. ps -eaf
If the system behaves strange, as if locked.

Q: Anything else recommended that can be useful to check healthy system
behaviour?

==========================================================================
Other testing tools?
====================

1.  iozone
mentioning an Excel table in the man page made me uncertain whether
to try it...

2. dd
for raw IO.

Q: What else?

==========================================================================
Conclusions in a nutshell
=========================
1. With any of the kernels below 2.6.12.3, on the ___ x86_64 ___
architecture, the performance is poor. Load becomes huge, system
unresponsive, kswapd0, kswapd1 running on top of the "top".

2. The blockdev --setra 16384 does almost nothing else than increases the
read speed from the disks by also consuming much more CPU time. The write
and re-write speed do not change considerably. It is not really a
solution, when a system is run in hw raid based on an expensive card so as
to save CPU cycles for other tasks. (Then we can use sw RAID-5 on JBOD,
which is just much faster with more CPU usage)

3. The best I got during normal operation (no kswapd anomaly and
unresponsive system) was about 80Mb/s write, 40Mb/s rewrite and 350Mb/s
read. However, this was with "blockdev --setra 4092" and 43% CPU usage.
I would rather quote a more conservative 180Mb/s at setra 256 and 20% CPU.

4. I made tests Migration from 64kb to 256kb stripe size on a 2Tb array would take
forever. The performance during this migration is really bad, indifferent
from what the IO priority is set up in the 3ware interface:
50Mb/s write, 8Mb/s rewrite (!) and 12Mb/s read.

As I had no data yet to loose, it was much faster to reboot, and delete
unit, create one with 256Kb stripe size, and initialize it.

5. The performance of the 3ware card seemed worse with the 256k strip size.
Write: 68 Rewrite: 21, read: 60Mb/s

6. Changing /sys/block/sde/queue/nr_requests from 128 to 512 does a moderate
improvement. Going to higher numbers, such as 1024 does not make it better
any more.

==========================================================================
QUESTIONS:
=========

Q: Where is useful information on how to tune the various /sys/*
   parameters.?
   What are recommended values for a 2Tb array running on 3ware card?
   What are the relation between these parameters?

   Notably: nr_requests, can_queue, command_per_lun, max-readahead, etc.

Q: Are there any benchmarks showing better (re)write performance on an eight
   disk SATA RAID-5 with similar capacity (2Tb)?

Q: (mostly to 3ware/amcc inc.) Why is the 256K strip size so inefficient
    compared to the 64k?

==========================================================================
TEST RESULTS
============

	---------------------------------------------------------------------------
	TEST2.1
	-------
	raid strip size = 64k
	blockdev --setra 256 /dev/sde
	/sys/block/sde/queue/nr_requests = 128
	mkfs.xfs -f -b size=4k -d su=64k,sw=7 -i size=1k -l version=2

	xfs_info /mnt/3w1/un0/
	meta-data=/mnt/3w1/un0           isize=1024   agcount=32, agsize=16021136 blks
	         =                       sectsz=512
	data     =                       bsize=4096   blocks=512676288, imaxpct=25
	         =                       sunit=16     swidth=112 blks, unwritten=1
	naming   =version 2              bsize=4096
	log      =internal               bsize=4096   blocks=32768, version=2
	         =                       sectsz=512   sunit=16 blks
	realtime =none                   extsz=65536  blocks=0, rtextents=0

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	            100/100   577   5 +++++ +++   914   5   763   6 +++++ +++    97   0
	real	24m32.187s
	user	0m0.365s
	sys	0m32.705s

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max            /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	       100:10:0/100   125   2 103182 100   824   7   127   2 84106  99    82   1
	real	49m47.104s
	user	0m0.494s
	sys	1m5.833s

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10    42   5    75   5   685  11    41   5    24   1   212   4
	real	18m29.176s
	user	0m0.240s
	sys	0m45.138s

	16Mb files:
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000     4  14     7  14   461  39     4  15     5  10   562  43

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000     3  14     7  14   522  40     4  14     6  11   493  39
	real	13m43.331s
	user	0m0.455s
	sys	1m53.656s

	-----------------------------------------------------------------------------
	TEST 2.2
	--------
	-> change inode size

	Strip size 64Kb
	blockdev --setra 256 /dev/sde
	/sys/block/sde/queue/nr_requests = 128
	mkfs.xfs -f -b size=4k -d su=64k,sw=7 -i size=2k -l version=2 /dev/sde1

	meta-data=/dev/sde1              isize=2048   agcount=32, agsize=16021136 blks
	         =                       sectsz=512
	data     =                       bsize=4096   blocks=512676288, imaxpct=25
	         =                       sunit=16     swidth=112 blks, unwritten=1
	naming   =version 2              bsize=4096
	log      =internal log           bsize=4096   blocks=32768, version=2
	         =                       sectsz=512   sunit=16 blks
	realtime =none                   extsz=65536  blocks=0, rtextents=0

	Disk IO
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G 57019  97 75887  16 47033  10 35907  61 192411  22 311.6   0

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50   655   6 +++++ +++   944   5   717   6 +++++ +++   112   0
	real	10m58.033s
	user	0m0.182s
	sys	0m16.954s

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20   111   2 +++++ +++   805   7   107   2 +++++ +++   126   1
	real	9m23.056s
	user	0m0.105s
	sys	0m12.835s

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10    44   5   221  13   504   7    43   5    22   1   164   2
	real	17m25.308s
	user	0m0.207s
	sys	0m42.914s

	==> Seq. read speed increased to 3x, seq. delete decreased

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10  4  14    10  20   450  34     4  14     5   9   419  34
	real	13m24.856s
	user	0m0.483s
	sys	1m53.478s

	==> Delete speed decreased. Seq. read speed somewhat increased.
	==> No significant difference compared to smaller inode size.

	-----------------------------------------------------------------------------
	TEST2.3
	--------
	Tests done while migrating from Stripe 64kB to Stripe 256kB.
	/sys/block/sde/queue/nr_requests = 128
	blockdev --setra 256 /dev/sde
	Extremely slow.

	Bonnie test for IO performance
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G           53072  11  8848   1           12039   1 139.3   0

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50  289   3 +++++ +++   603   3   444   4 +++++ +++    77   0
	real	17m19.235s
	user	0m0.186s
	sys	0m17.566s

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20   86   1 +++++ +++   564   5    86   1 +++++ +++    90   0
	real	12m16.227s
	user	0m0.099s
	sys	0m12.125s

	Testing with 100Kb to 1Mb files
	Delete files in random order...done.
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10  29   3    13   0   466   6    25   3    11   0   125   2
	real	41m4.151s
	user	0m0.255s
	sys	0m42.095s

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10 2   9     2   5   273  20     2   8     1   3   258  19
	real	29m20.672s
	user	0m0.469s
	sys	1m49.345s

	===> Disk IO becomes extreme slow when array is migrating strip size

	-----------------------------------------------------------------------------
	TEST 2.4
	--------
	Tests done with 256Kb RAID array size
	blockdev --setra 256 /dev/sde
	/sys/block/sde/queue/nr_requests = 128
	mkfs.xfs -f -b size=4k -d su=256k,sw=7 -i size=1k -l version=2 -L cfhat5_1_un0 /dev/sde1

	meta-data=/dev/sde1              isize=1024   agcount=32, agsize=16021184 blks
	         =                       sectsz=512
	data     =                       bsize=4096   blocks=512676288, imaxpct=25
	         =                       sunit=64     swidth=448 blks, unwritten=1
	naming   =version 2              bsize=4096
	log      =internal log           bsize=4096   blocks=32768, version=2
	         =                       sectsz=512   sunit=64 blks
	realtime =none                   extsz=65536  blocks=0, rtextents=0

	top - 11:54:04 up 11:31,  2 users,  load average: 8.52, 7.56, 5.07
	Tasks: 104 total,   1 running, 102 sleeping,   1 stopped,   0 zombie
	Cpu(s):  0.3% us,  4.0% sy,  0.0% ni,  0.7% id, 94.5% wa,  0.0% hi,  0.5% si
	Mem:   4010956k total,  3988284k used,    22672k free,        0k buffers
	Swap:  7823576k total,      224k used,  7823352k free,  3789640k cached
	  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
	30821 root      18   0  8312  916  776 D  5.3  0.0   1:21.60 bonnie++
	  175 root      15   0     0    0    0 D  1.3  0.0   0:16.35 kswapd1
	  176 root      15   0     0    0    0 S  1.0  0.0   0:18.38 kswapd0

	Bonnie test for IO performance
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G           68990  14 21157   5           60837   7 250.2   0
	real	27m58.805s
	user	0m1.118s
	sys	1m58.749s

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50   255   3 +++++ +++   247   2   252   3 +++++ +++    61   0
	real	23m59.997s
	user	0m0.186s
	sys	0m26.721s

	==> Much slower than 64kb size with setra=256

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20   110   3 +++++ +++   243   3   112   3 +++++ +++    77   1
	real	11m57.399s
	user	0m0.100s
	sys	0m17.356s

	==> Much slower than 64kb size with setra=256

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10    36   5    77   5   232   4    40   5    35   2    92   2
	real	18m25.701s
	user	0m0.238s
	sys	0m45.724s

	==> Somewhat slower than 64kb size with setra=256

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10     4  15     3   6   227  18     3  14     2   4   155  13
	real	20m11.168s
	user	0m0.508s
	sys	1m55.892s

	==> Somewhat slower than 64kb size with setra=256

	==> Definitely inferior to the 64kb raid strip size

	------------------------------------------------------------------------------
	TEST2.5
	-------
	raid strip size = 256K
	Change su to 64k
	blockdev --setra 256 /dev/sde
	/sys/block/sde/queue/nr_requests = 128
	mkfs.xfs -f -b size=4k -d su=64k,sw=7 -i size=1k -l version=2 -L cfhat5_1_un0 /dev/sde1

	Bonnie test for IO performance
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G           72627  15 23325   5           63101   7 272.0   0
	real	25m56.324s
	user	0m1.097s
	sys	1m57.267s

	===> General IO was slightly faster with su=64k than su=256k

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50   788   7 +++++ +++   989   6   781   7 +++++ +++    93   0
	real	12m8.633s
	user	0m0.158s
	sys	0m16.578s


	===> Filesystem is much faster with su=64k

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20   135   2 +++++ +++   818   7   133   2 +++++ +++   145   1
	real	7m51.365s
	user	0m0.091s
	sys	0m12.182s

	===> Filesystem is somewhat faster with su=64k

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10    41   5    91   5   787  12    41   5    24   1   224   4
	real	18m6.138s
	user	0m0.243s
	sys	0m42.042s

	===> For larger files, it becomes almost indifferent if we use su=64k or su=256k

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10     4  14     3   6   476  34     3  11     2   5   546  40
	real	19m37.665s
	user	0m0.548s
	sys	1m49.408s

	===> For larger files, it becomes almost indifferent if we use su=64k or su=256k

	------------------------------------------------------------------------------
	TEST 2.6
	---------
	Tests done with 256Kb RAID array size
	blockdev --setra 1024 /dev/sde
	/sys/block/sde/queue/nr_requests = 128
	blockdev --setra 1024 /dev/sde
	mkfs.xfs -f -b size=4k -d su=256k,sw=7 -i size=1k -l version=2 -L cfhat5_1_un0 /dev/sde1

	meta-data=/dev/sde1              isize=1024   agcount=32, agsize=16021184 blks
	         =                       sectsz=512
	data     =                       bsize=4096   blocks=512676288, imaxpct=25
	         =                       sunit=64     swidth=448 blks, unwritten=1
	naming   =version 2              bsize=4096
	log      =internal log           bsize=4096   blocks=32768, version=2
	         =                       sectsz=512   sunit=64 blks
	realtime =none                   extsz=65536  blocks=0, rtextents=0

	Bonnie test for IO performance
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G           68794  14 26139   6           118452  14 255.5   0
	real	22m2.101s
	user	0m1.268s
	sys	1m58.232s

	=> Speed increased compared to TEST 2.4 (setra 256). CPU % didn't increase.

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50   253   3 +++++ +++   247   2   251   3 +++++ +++    60   0
	real	24m14.398s
	user	0m0.178s
	sys	0m27.186s

	=> No change compared to 2.4

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20   112   3 +++++ +++   241   3   109   3 +++++ +++    71   1
	real	12m21.663s
	user	0m0.089s
	sys	0m17.502s

	=> No change.

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10    39   5    90   5   237   4    37   5    32   1    82   1
	real	18m47.223s
	user	0m0.260s
	sys	0m45.430s

	=> No change.

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10 4  13     6  12   215  16     4  14     5   9   171  13
	real	14m21.865s
	user	0m0.474s
	sys	1m49.301s

	==> Improved.

	------------------------------------------------------------------------------
	TEST 2.6
	--------
	Back to raid-strip = 64k
	/sys/block/sde/queue/nr_requests = 128
	mkfs.xfs -f -b size=4k -d su=64k,sw=7 -i size=1k -l version=2 -L cfhat5_1_un0 /dev/sde1
	blockdev --setra 256 /dev/sde

	top - 10:51:03 up  8:06,  3 users,  load average: 9.69, 4.18, 1.63
	Tasks: 128 total,   1 running, 127 sleeping,   0 stopped,   0 zombie
	Cpu(s):  0.2% us,  5.0% sy,  0.0% ni,  5.2% id, 88.5% wa,  0.0% hi,  1.2% si
	Mem:   4010956k total,  3987456k used,    23500k free,       52k buffers
	Swap:  7823576k total,      224k used,  7823352k free,  3677224k cached

	System stays responsive despite the giant load.

	  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
	 5757 root      18   0  8308  916  776 D  6.3  0.0   0:35.69 bonnie++
	  176 root      15   0     0    0    0 D  1.3  0.0   0:05.27 kswapd0
	  175 root      15   0     0    0    0 S  1.0  0.0   0:05.64 kswapd1

	Bonnie test for IO performance
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G           65322  14 46177  10           183637  21 293.2   0
	real	15m23.264s
	user	0m1.118s
	sys	1m58.544s

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50   701   6 +++++ +++   983   5   733   6 +++++ +++   111   0
	real	10m56.735s
	user	0m0.171s
	sys	0m15.877s

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20   109   2 +++++ +++   824   7   108   2 +++++ +++   147   1
	real	8m58.359s
	user	0m0.107s
	sys	0m12.546s

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10    45   5   214  13   642   9    45   5    22   1   211   3
	real	16m59.573s
	user	0m0.230s
	sys	0m42.618s

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10     4  13    11  20   467  32     4  13     5   9   416  30
	real	13m15.243s
	user	0m0.534s
	sys	1m47.777s

	------------------------------------------------------------------------------
	TEST 2.7
	---------
	Change setra:
	blockdev --setra 4092 /dev/sde
	raid-strip = 64k
	/sys/block/sde/queue/nr_requests = 128
	mkfs.xfs -f -b size=4k -d su=64k,sw=7 -i size=1k -l version=2 -L cfhat5_1_un0 /dev/sde1

	[root@cfhat5 diskio]# iostat -x /dev/sde
	Linux 2.6.12.3-GB2 (cfhat5)     07/25/2005

	avg-cpu:  %user   %nice    %sys %iowait   %idle
	           0.29    0.04    1.00    4.88   93.80
	Device:    rrqm/s wrqm/s   r/s   w/s  rsec/s  wsec/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
	sde          0.04 903.28 19.74 44.03 4757.48 8632.40  2378.74  4316.20   209.94     7.73  121.17   1.96  12.51

	Bonnie test for IO performance
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G           66303  13 41254   9           345730  41 274.7   0
	real	15m21.055s
	user	0m1.114s
	sys	1m57.199s

	==> Write does not change. Rewrite decreases. Read increases.

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50   624   6 +++++ +++   904   5   727   6 +++++ +++   113   0
	real	10m59.528s
	user	0m0.189s
	sys	0m16.520s

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20   111   2 +++++ +++   798   7   102   2 +++++ +++   143   1
	real	9m12.536s
	user	0m0.120s
	sys	0m12.467s

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10  46   6   323  20   686  10    43   5    30   1   207   3
	real	14m42.960s
	user	0m0.262s
	sys	0m42.090s

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10     4  14    20  40   524  38     4  13    11  21   492  35
	real	10m42.784s
	user	0m0.453s
	sys	1m51.078s

	------------------------------------------------------------------------------
	TEST 2.8
	---------
	echo 512 > /sys/block/sde/queue/nr_requests
	raid-strip = 64k
	mkfs.xfs -f -b size=4k -d su=64k,sw=7 -i size=1k -l version=2 -L cfhat5_1_un0 /dev/sde1
	blockdev --setra 4092 /dev/sde

	Bonnie test for IO performance
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G           78573  16 42444   9           353894  42 284.6   0
	real	14m14.938s
	user	0m1.213s
	sys	1m55.382s

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50   623   6 +++++ +++   894   5   739   6 +++++ +++   123   0
	real	10m25.379s
	user	0m0.186s
	sys	0m16.846s

	Testing with tiny files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20   107   2 +++++ +++   835   7   100   1 +++++ +++   159   1
	real	9m7.268s
	user	0m0.104s
	sys	0m12.589s

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10    47   6   324  19   697  10    44   5    35   2   232   4
	real	13m41.706s
	user	0m0.234s
	sys	0m42.614s

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10     4  14    19  38   448  32     4  13    11  21   506  36
	real	10m40.404s
	user	0m0.469s
	sys	1m51.098s

	------------------------------------------------------------------------------
	TEST 2.9
	---------
	echo 1024 > /sys/block/sde/queue/nr_requests
	raid-strip = 64k
	mkfs.xfs -f -b size=4k -d su=64k,sw=7 -i size=1k -l version=2 -L cfhat5_1_un0 /dev/sde1
	blockdev --setra 4092 /dev/sde

	Bonnie test for IO performance
	Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
	                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
	Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
	cfhat5          20G           79546  16 41227   9           351637  43 285.0   0
	real	14m26.609s
	user	0m1.136s
	sys	1m57.398s

	==> No improvement

	Testing with zero size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	              50/50   616   5 +++++ +++   880   5   748   6 +++++ +++   123   0
	real	10m25.469s
	user	0m0.186s
	sys	0m16.723s

	Testing with tiny files
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	         20:10:1/20    99   2 +++++ +++   779   7   104   2 +++++ +++   165   1
	real	9m12.385s
	user	0m0.111s
	sys	0m12.947s

	Testing with 100Kb to 1Mb files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	10:1000000:100000/10  47   6   316  20   616   9    47   6    36   2   248   4
	real	13m22.360s
	user	0m0.231s
	sys	0m43.679s

	Testing with 16Mb size files
	Version  1.03       ------Sequential Create------ --------Random Create--------
	cfhat5              -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
	files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
	1:17000000:17000000/10 3  13    16  31   386  27     4  13    11  22   558  40
	real	11m1.018s
	user	0m0.464s
	sys	1m49.534s



============================================================================
Hardware info
=============

[root@cfhat5 diskio]# cat /proc/cpuinfo
processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 5
model name      : AMD Opteron(tm) Processor 246
stepping        : 10
cpu MHz         : 1991.008
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm 3dnowext 3dnow
bogomips        : 3915.77
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 5
model name      : AMD Opteron(tm) Processor 246
stepping        : 10
cpu MHz         : 1991.008
cache size      : 1024 KB
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext lm 3dnowext 3dnow
bogomips        : 3973.12
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp

-----------------------------------------------------------
[root@cfhat5 diskio]# cat /sys/class/scsi_host/host6/stats
3w-9xxx Driver version: 2.26.03.015fw
Current commands posted:      0
Max commands posted:         79
Current pending commands:     0
Max pending commands:         1
Last sgl length:              2
Max sgl length:              32
Last sector count:            0
Max sector count:           256
SCSI Host Resets:             0
AEN's:                        0

--------------------------
3ware card info

Model   9500S-8
Serial #      L19403A5100293
Firmware      FE9X 2.06.00.009
Driver        2.26.03.015fw
BIOS  BE9X 2.03.01.051
Boot Loader   BL9X 2.02.00.001
Memory Installed      112 MB
# of Ports    8
# of Units    1
# of Drives   8

Write cache enabled
Auto-spin up enabled, 2 sec between spin-up
Drives, however, probably do not support spinup.

-------------------------------
Disks:
Drive Information (Controller ID 6)
Port 	Model 	Capacity 	Serial # 	Firmware 	Unit 	Status
0 	ST3300831AS 	279.46 GB 	3NF0BZYJ 	3.02 	0 	OK
1 	ST3300831AS 	279.46 GB 	3NF0AC04 	3.01 	0 	OK
2 	ST3300831AS 	279.46 GB 	3NF0A7JE 	3.01 	0 	OK
3 	ST3300831AS 	279.46 GB 	3NF0ABT1 	3.01 	0 	OK
4 	ST3300831AS 	279.46 GB 	3NF0A63J 	3.01 	0 	OK
5 	ST3300831AS 	279.46 GB 	3NF0ACC5 	3.01 	0 	OK
6 	ST3300831AS 	279.46 GB 	3NF09FLP 	3.01 	0 	OK
7 	ST3300831AS 	279.46 GB 	3NF046WY 	3.01 	0 	OK

----------------------------------
[root@cfhat5 diskio]# vmstat
procs -----------memory---------- ---swap-- -----io---- --system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa
 0  0    380 3781540      0  58004    0    0  2712  3781  243   216  0  2 91  7

[root@cfhat5 diskio]# free
             total       used       free     shared    buffers     cached
Mem:       4010956     229532    3781424          0          0      58004
-/+ buffers/cache:     171528    3839428
Swap:      7823576        380    7823196


============================================================================
Kernel config

See http://www.cfa.harvard.edu/~gbakos/diskio/

