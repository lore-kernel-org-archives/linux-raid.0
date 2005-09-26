From: linux@horizon.com
Subject: Root RAID 1+0 micro-HOWTO
Date: 26 Sep 2005 02:23:00 -0400
Message-ID: <20050926062300.31150.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Just in case anyone's feeling shy bout trying this, I've been running
RAID 1+0 on the root file system of an important server since 2.4 kernels
(or was it 2.2?).

This predates the raid10 personality, so it's done as RAID 0 on top of
RAID 1.

I have a 6-way mirrored RAID-1 /boot partition for LILO to use.
It can't deal with striping, but it has basic RAID-1 support in that
it will install its boot sector in every drive in the array, so you
can boot any of them.  (Actually, it's half a gigabyte, and contains
a complete console-only Linux install with lots of recovery tools.
In the days before good boot CDs, it was a real pain to reassemble a
non-booting root file system.)

Anyway, I have 4 main drives in the machine.  If you want cheap drive
trays, the all-aluminum Kingwin KF series is barely more expensive than
the plastic options and will give drive temperatures 15 C lower.

They're on two PATA drive controllers, one drive per IDE channel.

At the bottom are two RAID-1 mirrors:
md3 : active raid1 hdi3[1] hde3[0]
      58612096 blocks [2/2] [UU]

md2 : active raid1 hdk3[1] hdg3[0]
      58612096 blocks [2/2] [UU]

These are on standard 2-port PCI IDE controllers, and you may notice
that I have them split so even the complete failure of one controller
card (such as hde..hdh) will only take out half of each.

This much is automatically recognized and assembled by the kernel with
no special effort except marking the partitions as "RAID autodetect".

These are then striped into a RAID-1+0 array:

md4 : active raid0 md3[1] md2[0]
      117223936 blocks 256k chunks

Because the component parts don't have a partition type, this level can't
be autodetected.  But there is a kernel command line parameter which
will fix this, and is easily added with an "append=" line in lilo.conf:

append="md=4,/dev/md2,/dev/md3"

The kernel command line "md=<number>,<device>,<device>" will assemble
/dev/md<number> out of the specified <device>s before mounting the
root file system.

I have the root file system on /dev/md4, and it's worked file this way
for years.  About once a year, I get a glitch that kicks a drive out of
the array, but I only panicked the first time.  Now, after a brief
functionality check, I just add it back.


I'd definitely like to vote for "try a small fix before kicking a drive out"
as the next needed md feature, before anything exotic like RAID-6 or
novel new RAID-10 layouts :-)

Rather than have a list of scattered bad blocks, I was thinking that
it made sense to support just a single burst error.  A single block
range that needs resyncing, but that doesn't have to end at the end
of the drive.  This makes the interaction with drive syncing simple
and straightforward.

It's very straightforward how to add a new bad block to the existing
out-of-sync range.  A basic error recovery state machine:
- Binary search between the start of the drive and the bad block to find the
  first unreadable block.
- Binary search from the bad block to the end of the drive to find the last
  unreadable block.
- If the unreadable range you discover spans the whole partition, fail it out.
- Add the discovered bad range to the out-of-sync range.
- Start syncing.
- If we get a persistent *write* error while syncing, kick the drive out.
- Think of a way to try re-reading the bad sector(s) after the sync
  completes.

But regardless of these complaints, thanks for a very reliable RAID
system over the tears!
