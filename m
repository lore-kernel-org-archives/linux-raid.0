From: John Sutton <john@scl.co.uk>
Subject: raidhotremove always busy!
Date: Sat, 19 Oct 2002 16:12:16 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <02101915322700.23139@diva.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there

I'm having trouble with raidhotremove.  I'm using kernel 2.4.18 and
raidtools 0.90.

# raidhotremove /dev/md0 /dev/sda5
/dev/md0: can not hot-remove disk: disk busy!

This is despite the fact that md0 is not mounted (and there are no other
md devices running which might have been using other partitions on the
same disk).

In addition, I usually also get a weird message:

------------------------------------
md: bug in file md.c, line 2341

followed by a <COMPLETE RAID STATE PRINTOUT>

and then:

md: cannot remove active disk sda5 from md0 ...
------------------------------------

All of this message goes to the console rather than stdout or stderr.

So I'm baffled!  What am I doing wrong?

I'm interested in getting raidhotremove to work to try to be able to deal
with badblocks on my scsi disks.  The accepted wisdom (see
http://linas.org/linux/raid.html) seems to be that this can't be done:

"Another serious drawback of this RAID+LVM combo is that neither Linux
Software RAID (MD) nor LVM have any sort of bad-block replacement
mechanisms.  If (or rather, when) disks start manifesting bad blocks, one
is up a creak without a paddle."

But why should the following prescription _not_ work:

Start with md0 using sda5 and sdb5 and say sda5 develops a bad block (this
is actually happening to me so it's not just an academic concern ;-()

First remove the bad partition from the array (if it has not already been
booted out):

raidhotremove /dev/md0 /dev/sda5

Then badblock the partition:

badblocks /dev/sda5 > bblist

Unmount the md device if mounted:

umount /dev/md0

Add the badblocks to the filesystem:

e2fsck -l bblist /dev/md0

Finally, add the disk back in to the array:

raidhotadd /dev/md0 /dev/sda5

I can't see why that shouldn't work?  Of course, if a badblock has been
detected which lies beyond the fs i.e. in the raid superblock, then you've
had it.  (This will be obvious because the block will be rejected by the
e2fsck as being out of range.)

I've seen mention on this list of a low level scsi formatting utility
(scsiformat) for remapping bad blocks but I don't seem to have it on my
RH7.1 system.  Can anyone tell me where I can find it (preferably the
source)?

Comments greatly appreciated!

TIA

***************************************************
John Sutton
SCL Internet
URL http://www.scl.co.uk/
Tel. +44 (0) 1239 711 888
***************************************************
