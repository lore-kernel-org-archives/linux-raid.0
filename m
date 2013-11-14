From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 3.12: raid-1 mismatch_cnt question
Date: Thu, 14 Nov 2013 12:22:26 -0500
Message-ID: <007301cee15e$178969e0$469c3da0$@lucidpixels.com>
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <527E8B74.70301@shiftmail.org> <008301cedd9d$fc254cf0$f46fe6d0$@lucidpixels.com> <527F7FF5.3000002@shiftmail.org> <000301cedec0$1fa72d60$5ef58820$@lucidpixels.com> <5280BA1E.6060604@shiftmail.org> <CAO9zADyyXiw91y=GwArcC9wUrhRPNNxp_XMAgtcPxR=fiZZY1g@mail.gmail.com> <5281F53D.4060703@shiftmail.org> <528202ED.1040307@fastmail.fm> <000001cee0bd$1979da60$4c6d8f20$@lucidpixels.com> <52848D5C.7020701@shiftmail.org> <002201cee126$5c390290$14ab07b0$@lucidpixels.com> <5284F5B2.3040307@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5284F5B2.3040307@shiftmail.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'joystick' <joystick@shiftmail.org>
Cc: 'Bernd Schubert' <bernd.schubert@fastmail.fm>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



-----Original Message-----
From: joystick [mailto:joystick@shiftmail.org] 
Sent: Thursday, November 14, 2013 11:09 AM
To: Justin Piszcz
Cc: 'Bernd Schubert'; 'linux-raid'
Subject: Re: 3.12: raid-1 mismatch_cnt question

[ .. ]

>> At the end of the procedure (like now, if you didn't resync or repair in 
>> the meanwhile) is mismatch_cnt still so high?
After a reboot, I ran the check and yes it was still high.

[ .. ]

>> no, not that one...
>> it would be helpful to know the kernel version that *creates* 
>> mismatches, the one that you have running normally on the live system.
Version: 3.12.0 (and typically always use the latest)
That's the "bugged" one, supposing this is really a bug (until we find 
where the mismatches are, it's difficult to say wether this is a data 
loss or not)

>> Maybe the mismatched are located ext4 metadata areas which are not files 
>> and so can't be seen with md5sums... That would still be as much 
>> worrisome, unless some expert of ext4 can tell that it's ok (it can be 
>> OK if the region with mismatches is an old metadata area, currently 
>> unused; the mechanism that can create harmless mismatches in this case 
>> has been described by Neil)

If that is what is occurring, is it possible to exclude them from mismatch_cnt?

[ .. ]

- First confirm that mismatch_cnt is still high..
It was 0 after reboot.

[ .. ]


- Then if this does not disrupt your system operation too much, i would 
suggest to fill 95% of free space with a zeroes file like you did in 
earlier tests. Otherwise for a mismatch happening in non-file area we 
won't be sure of what kind of area is that. Maybe recompute mismatch_cnt 
after this.

Create file up to 95% utilization on /root:
/dev/root       219G  205G   12G  95% /

Re-check:
# echo check > /sys/devices/virtual/block/md1/md/sync_action
# cat /sys/devices/virtual/block/md1/md/mismatch_cnt
27520

then, copypasting the procedure with some modifications:
----
... to determine the location of mismatches (...)
Unfortunately I don't think MD tells you the location of mismatches 
directly. Do you want to try the following:
/sys/block/md1/md/sync_min and /sys/block/md1/md/sync_max should allow 
you to narrow the region of the next check.
Set them, then perform check, then cat mismatch_cnt.
Narrow progressively sync_min and sync_max so that you identify the most 
dense areas of mismatches, or a few single blocks that mismatch.
When you have identified some regions or isolated blocks, invoke "sync" 
from bash and then check again the same region a couple of times so to 
be sure that it stays mismatched and it's not just a transient situation.
Then try with debugfs (in readonly mode can be used with fs mounted): 
there should be an option to get the inode number from a block number of 
the device... I hope that block numbers are not offset by MD... I think 
it's icheck and after that you might need "find -inum <inode_number>" 
launched on the same filesystem to find the corresponding filename from 
the inode number. That should be the file that contains the mismatch.
[ .. ]
When I do this, the speed of check thereafter is very slow:

Personalities : [raid1]
md1 : active raid1 sdc2[0] sdb2[1]
      233381376 blocks [2/2] [UU]
      [>....................]  check =  0.0% (4500/233381376) finish=80387.9min speed=48K/sec (55 days)

The speed continues to decrease when the sync_min is set to 1000 and sync_max is 9000 (this won't work).

A few minutes later:

Personalities : [raid1]
md1 : active raid1 sdc2[0] sdb2[1]
      233381376 blocks [2/2] [UU]
      [>....................]  check =  0.0% (4500/233381376) finish=200485.5min speed=19K/sec

It would be interesting if someone else on this list has ext4 and sees similar results (mismatch_cnt) with their SSDs vs. another FS (XFS/etc).

Justin.



