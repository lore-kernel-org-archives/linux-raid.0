From: linux@horizon.com
Subject: How to verify RAID parity/mirroring?
Date: 13 Apr 2006 01:43:06 -0400
Message-ID: <20060413054306.10106.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

I'm looking forward to testing the new SATA NCQ support that the linux
IDE developers have working, but of course that opens me to the risk of
disk corruption.

So I'd like to be able to do clever things with the existing RAID arrays 
to mitigate the damage.

I have a lot of useful-but-not-essential data (old backups) on a RAID 5
partition.  I'm willing to risk the data but I'd rather not delete it
preemptively.  I also don't want silent corruption.

What I'd like to be able to do is, after a few experiments, verify the
RAID 5 parity to see if I've scrogged things.  Is there some option to
mdadm to do that?  I could just md5sum the component partitions, but it
would be useful information to also know *where* the damage occurred.
Relative to the LBA28 limit, for example.

And similarly for RAID-1 mirrors.  I have the most essential data
(vmlinuz and a basic test mode installation) on a 6-way RAID-1, so if
something doesn't match, it's easy enough to find a valid copy.  But I
need to notice that things aren't right.


The other thing I'd like to do is to be able to reintegrate a mirrored
pair (particularly RAID-10) in the "wrong" direction.  That is:
- I split the mirror and literally unplug half so it can't get
  corrupted.
- I boot with a test kernel and run my tests.  Oops!  It scribbled on
  the disk.
- I want to reboot with a known-good kernel and regenerate the mirrors
  from the old, good data.

One thing I could do is remove the experimental partitions from the mirror
set and generate a fresh RAID-0 md to experiment on.  Then I can mount
the old md without fear of it getting overwritten.  But if I forget,
is there something I can do before plugging in the old, good drives that
will ensure that the kernel doesn't copy the new, corrupted data on top
of the old, good data as soon as I reboot?

Will removing the corrupted drives, booting from the old drives, and then
hot-adding the corrupted drives force a copy in the right direction?
Or will the RAID system get confused about generation numbers?

Is there some way to force the generation number of a partition to a
very low number so it will be the one chosen for overwrite on reboot?


I didn't find anything in the mdadm 2.4.1 man page, but I have a faint
memory of such verification options being discussed.  Did it appear in
a more obscure place?

Thank you for any suggestions.
