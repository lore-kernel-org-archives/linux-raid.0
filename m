From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Wed, 6 Jun 2012 18:37:21 +0100
Message-ID: <20431.38249.763231.295942@tree.ty.sabi.co.UK>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
	<CA+sTkh6rA_yoeM3Fw1s47sgEsJRWG7vbtXH9QaPWbwG6Mvt7fQ@mail.gmail.com>
	<CA+4vN7zTmKPuyseOO9QhSKO3vjeLpt8pQ76W-MwZg1-YCz+vLA@mail.gmail.com>
	<20429.60634.655908.243729@tree.ty.sabi.co.UK>
	<CA+4vN7xoNyvK5VnVX0DsP9T-g1_mYoN49gKOTR+Ff8=5nCCBOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7xoNyvK5VnVX0DsP9T-g1_mYoN49gKOTR+Ff8=5nCCBOA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> A 21+2 drive RAID6 set is (euphemism) brave, and perhaps it
>> matches the (euphemism) strategic insight that only
>> checksumming withing MD could account for 100% CPU time in a
>> single threaded way.

> It is not a guess that md0_raid6 takes up 100% of 1 core. It
> is reported by 'top'.

> But maybe you are right: The 100% that md0_raid6 uses could be
> due to something other than checksumming. But the test clearly
> show that chunk size has a huge impact on the amount of CPU
> time md0_raid6 has to use.

The (euphemism) test(s) much more "clearly show" something else
entirely :-).

For a (euphemism) different approach here is in three lines a
"test" that in its minuscule simplicity (lots of improvements
could be made) illustrates several things in which it is
(euphemism) different from the one reported above:

------------------------------------------------------------------------
  base#  mdadm --create /dev/md0 -c 64 --level=6 --raid-devices=16 /dev/ram{0..15}
  mdadm: array /dev/md0 started.
------------------------------------------------------------------------
  base#  time dd bs=$((14 * 64 * 1024)) of=/dev/zero iflag=direct if=/dev/md0
  255+0 records in
  255+0 records out
  233963520 bytes (234 MB) copied, 0.0453674 seconds, 5.2 GB/s

  real    0m0.047s
  user    0m0.000s
  sys     0m0.047s
------------------------------------------------------------------------
  base#  sysctl vm/drop_caches=1; time dd bs=$((14 * 64 * 1024)) of=/dev/zero if=/dev/md0
vm.drop_caches = 1
  255+0 records in
  255+0 records out
  233963520 bytes (234 MB) copied, 0.285007 seconds, 821 MB/s

  real    0m0.360s
  user    0m0.000s
  sys     0m0.286s
------------------------------------------------------------------------

Note that this is about *reading* and thus there is no
"checksum" calculation involved. It was amusing also to rerun
the above on 'ram0' instead of 'md0' for comparison.

It was also quite depressing to me to try the same for *writing*
and try different 'bs=' values.

Other (euphemism) different tests: I have compared writing to a
RAID0 set of equivalent stripe width (14) and to a RAID5 set of
equivalent stripe width (14+1).

PS: Running any "test" on a RAID set of in-memory block devices
    seems to me to be (euphemism) entertaining rather than
    useful as RAM accesses are not that parallelizable, and this
    breaks a pretty fundamental assumption.

[ ... ]
