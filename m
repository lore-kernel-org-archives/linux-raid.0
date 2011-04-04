From: Robin Humble <robin.humble+raid@anu.edu.au>
Subject: rhel5 raid6 corruption
Date: Mon, 4 Apr 2011 09:59:02 -0400
Message-ID: <20110404135902.GA20052@grizzly.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

we are finding non-zero mismatch_cnt's and getting data corruption when
using RHEL5/CentOS5 kernels with md raid6.
actually, all kernels prior to 2.6.32 seem to have the bug.

the corruption only happens after we replace a failed disk, and the
incorrect data is always on the replacement disk. i.e. the problem is
with rebuild. mismatch_cnt is always a multiple of 8, so I suspect
pages are going astray.

hardware and disk drivers are NOT the problem as I've reproduced it on
2 different machines with FC disks and SATA disks which have completely
different drivers.

rebuilding the raid6 very very slowly (sync_speed_max=5000) mostly
avoids the problem. the faster the rebuild goes or the more i/o to the
raid whilst it's rebuilding, the more likely we are to see mismatches
afterwards.

git bisecting through drivers/md/raid5.c between 2.6.31 (has mismatches)
and .32 (no problems) says that one of these (unbisectable) commits
fixed the issue:
  a9b39a741a7e3b262b9f51fefb68e17b32756999  md/raid6: asynchronous handle_stripe_dirtying6
  5599becca4bee7badf605e41fd5bcde76d51f2a4  md/raid6: asynchronous handle_stripe_fill6
  d82dfee0ad8f240fef1b28e2258891c07da57367  md/raid6: asynchronous handle_parity_check6
  6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8  md/raid6: asynchronous handle_stripe6

any ideas?
were any "write i/o whilst rebuilding from degraded" issues fixed by
the above patches?

I was hoping to find something specific and hopefully easily
backportable to .18, but the above looks quite major :-/

which stripe flags are associated with a degraded array that's
rebuilding and also writing data to the disk being reconstructed?

any help would be very much appreciated!

we have asked our hw+sw+filesystem vendor to fix the problem, but I
suspect this will take a very long time. for a variety of reasons (not
the least being we run modified CentOS kernels in production and don't
have a RedHat contract) we can't ask RedHat directly.

there is much more expertise on this list than with any vendor anyway :-)


in case anyone is interested (or is seeing similar corruption and has a
RedHat contract) below are steps to reproduce.

the i/o load that reproduces the mismatch problem is 32-way IOR
http://sourceforge.net/projects/ior-sio/ with small random direct i/o's.
this pattern mimics a small subset of the real i/o on our filesystem.
eg. to local ext3 ->
  mpirun -np 32 ./IOR -a POSIX -B -w -z -F -k -Y -e -i3 -m -t4k -b 200MB -o /mnt/blah/testFile

steps to reproduce are:
  1) create a md raid6 8+2, 128k chunk, 50GB in size
  2) format as ext3 and mount
  3) run the above IOR infinitely in a loop
  4) mdadm --fail a disk, --remove, then --add it back in
  5) killall -STOP the IOR just before the md rebuild finishes
  6) let the md rebuild finish
  7) run a md check
  8) if there are mismatches then exit
  9) if no mismatches then killall -CONT IOR
  10) goto 4)

step 5) is needed because the corruption is always on the replacement
disk. the replacement disk goes from write-only during rebuild to
read-write when the rebuild finishes. so stopping all i/o to the raid
just before the rebuild finishes leaves any corruption on the
replacement disk and does not allow subsequent i/o to overwrite it,
propagate the corruption to other disks, or otherwise hide the
mismatches.

mismatches can usually be found using the above procedure in <100
iterations through the loop (roughly <36 hours). I've been running 2
machines in the above loops - one to FC disks and one to SATA disks.
so the disks and drivers are eliminated as a source of the problem.
the slower older FC disks usually hit the mismatches before the SATA
disks. mismatch_cnt's are always multiples of 8.

cheers,
robin
--
Dr Robin Humble, HPC Systems Analyst, NCI National Facility
