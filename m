From: Chris Allen <chris@cjx.com>
Subject: making raid5 more robust after a crash?
Date: Fri, 17 Mar 2006 13:02:47 +0000
Message-ID: <20060317130247.GA19878@cjx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear All,

We have a number of machines running 4TB raid5 arrays.
Occasionally one of these machines will lock up solid and
will need power cycling. Often when this happens, the
array will refuse to restart with 'cannot start dirty
degraded array'. Usually  mdadm --assemble --force will
get the thing going again - although it will then do
a complete resync.


My question is: Is there any way I can make the array
more robust? I don't mind it losing a single drive and
having to resync when we get a lockup - but having to
do a forced assemble always makes me nervous, and means
that this sort of crash has to be escalated to a senior
engineer.

Is there any way of making the array so that there is
never more than one drive out of sync? I don't mind
if it slows things down *lots* - I'd just much prefer
robustness over performance.


Thanks,

Chris Allen.


---------------------------------


Typical syslog:


Mar 17 10:45:24 snap27 kernel: md: Autodetecting RAID arrays.
Mar 17 10:45:24 snap27 kernel: md: autorun ...
Mar 17 10:45:24 snap27 kernel: md: considering sdh1 ...
Mar 17 10:45:24 snap27 kernel: md:  adding sdh1 ...
Mar 17 10:45:24 snap27 kernel: md:  adding sdg1 ...
Mar 17 10:45:24 snap27 kernel: md:  adding sdf1 ...
Mar 17 10:45:24 snap27 kernel: md:  adding sde1 ...
Mar 17 10:45:24 snap27 kernel: md:  adding sdd1 ...
Mar 17 10:45:24 snap27 kernel: md:  adding sdc1 ...
Mar 17 10:45:24 snap27 kernel: md:  adding sda1 ...
Mar 17 10:45:24 snap27 kernel: md: created md0
Mar 17 10:45:24 snap27 kernel: md: bind<sda1>
Mar 17 10:45:24 snap27 kernel: md: bind<sdc1>
Mar 17 10:45:24 snap27 kernel: md: bind<sdd1>
Mar 17 10:45:24 snap27 kernel: md: bind<sde1>
Mar 17 10:45:24 snap27 kernel: md: bind<sdf1>
Mar 17 10:45:24 snap27 kernel: md: bind<sdg1>
Mar 17 10:45:24 snap27 kernel: md: bind<sdh1>
Mar 17 10:45:24 snap27 kernel: md: running: <sdh1><sdg1><sdf1><sde1><sdd1><sdc1><sda1>
Mar 17 10:45:24 snap27 kernel: md: md0: raid array is not clean -- starting background reconstruction
Mar 17 10:45:24 snap27 kernel: raid5: device sdh1 operational as raid disk 4
Mar 17 10:45:24 snap27 kernel: raid5: device sdg1 operational as raid disk 5
Mar 17 10:45:24 snap27 kernel: raid5: device sdf1 operational as raid disk 6
Mar 17 10:45:24 snap27 kernel: raid5: device sde1 operational as raid disk 7
Mar 17 10:45:24 snap27 kernel: raid5: device sdd1 operational as raid disk 3
Mar 17 10:45:24 snap27 kernel: raid5: device sdc1 operational as raid disk 2
Mar 17 10:45:24 snap27 kernel: raid5: device sda1 operational as raid disk 0
Mar 17 10:45:24 snap27 kernel: raid5: cannot start dirty degraded array for md0
Mar 17 10:45:24 snap27 kernel: RAID5 conf printout:
Mar 17 10:45:24 snap27 kernel:  --- rd:8 wd:7 fd:1
Mar 17 10:45:24 snap27 kernel:  disk 0, o:1, dev:sda1
Mar 17 10:45:24 snap27 kernel:  disk 2, o:1, dev:sdc1
Mar 17 10:45:24 snap27 kernel:  disk 3, o:1, dev:sdd1
Mar 17 10:45:24 snap27 kernel:  disk 4, o:1, dev:sdh1
Mar 17 10:45:24 snap27 kernel:  disk 5, o:1, dev:sdg1
Mar 17 10:45:24 snap27 kernel:  disk 6, o:1, dev:sdf1
Mar 17 10:45:24 snap27 kernel:  disk 7, o:1, dev:sde1
Mar 17 10:45:24 snap27 kernel: raid5: failed to run raid set md0
Mar 17 10:45:24 snap27 kernel: md: pers->run() failed ...
Mar 17 10:45:24 snap27 kernel: md: do_md_run() returned -22
Mar 17 10:45:24 snap27 kernel: md: md0 stopped.

