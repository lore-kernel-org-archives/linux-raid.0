From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: badblock handling
Date: Thu, 5 Feb 2004 00:26:46 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402050525.i155P1i31302@dns1.watkins-home.com>
References: <001601c3eba2$e6110410$df01010a@moon>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001601c3eba2$e6110410$df01010a@moon>
To: 'Donghui Wen' <dhwen@protegonetworks.com>, linux-raid@vger.kernel.org
Cc: 'Neil Brown' <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

I have had the same problems.  Once there is a bad block on the disk, you
can't read it.  However, if you overwrite the bad block with new data (or
the same data) the disk drive will relocate the bad block to a spare block.
Once relocated, the disk is good again.  This auto relocation of bad blocks
(or sectors) has been around since IDE disks.  Not sure all IDE disk, but
all that I know about.

What I think should happen is:
If Read error,
  re-create missing data,
  re-write the data to the "bad" disk.
  If write fails,
    fail the disk,
  else,
    go on with life.

In the past 2 years I have had to remove and re-add failed disks about 5-10
times.  I never had to replace a bad disk.

If something like the above could be implemented, it would save a lot of
effort.

Also, if the bad block table is almost full, then fail the drive regardless.
Maybe a threshold that can be set.  Like 90% full.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Donghui Wen
Sent: Wednesday, February 04, 2004 11:46 PM
To: linux-raid@vger.kernel.org
Cc: Neil Brown
Subject: badblock handling

Hi,
     I am running a server with Linux software-raid (3ware controller). But
from time to time,
a disk is kicked out by md. This will happen when 3ware card reports a
unrecovered read error
for a sector. But when I run raidhotadd, the disk can added back to raid
with no problem.
     So my questions are:
        (1) Will md  kick out one disk if it find out ONE bad block?
        (2) Is it possible to set up a threshold, only the amount of bad
blocks pass this threshold,
            the disk will be kicked out.
        (3) Is it possible to remap the bad blocks to some spare blocks
automatically on the fly?

Thanks!

Donghui

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

