From: Mukund Sivaraman <muks@banu.com>
Subject: RAID-6 recovery questions
Date: Fri, 27 Jan 2012 13:40:25 +0530
Message-ID: <20120127081025.GA22388@jurassic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I am interested in building a 3TB * 8 disk RAID-6 array for
personal use. I am looking for info related to md recovery in the case
of failure.

I want to rely on the md RAID-6 array to some extent. It is a large
capacity array, and it is not financially feasible for me to have an
external mirror of it.

It seems that distributions like Fedora have a raid-check script for
periodic patrol read check, which is bound to reduce the risk of
surprise read errors during recovery.

In the unlikely case of 2 disk failure, a RAID-6 array loses redundancy,
but the array is still available.

When a disk reports errors reading blocks, it's likely that the rest of
the disk is readable, save for the bad blocks. In large capacity disks
available today, bad blocks are very common (as SMART output on year-old
disks will show). (Rewriting these bad blocks should make the disk remap
them and make them available again.)

My questions:

1. During recovery after 1-disk failure, what happens if there are
read errors on more than one disk? From what I've understood it seems
that if there is a read error during recovery, the entire disk is marked
as failed. It's very probable that these bad blocks are in different
places on different disks. Is it mathematically possible (RAID-6) to
recover such an array completely (rewriting the bad blocks with data
from other disks)? What options are available to recover from such a
situation?

Figure:

+---+---+---+---+---+---+---+---+
| 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |  RAID-6 array
+---+---+---+---+---+---+---+---+
  ^   ^   ^  \---------v-------/
  |   |   |           ok
dead  |   |
      |   +- partial read errors
      +----- partial read errors

{read_error_blocks(3)} intersect {read_error_blocks(2)} = NUL.


2. During recovery after 2-disk failure, what happens if there are
read errors?  Is it possible to overwrite the bad blocks with zeros (so
they are remapped and don't error anymore) and force them back into the
same array configuration so that most of the filesystem can be recovered
(except for the data in the bad blocks) ?

3. What is the raid6check(8) tool useful for, which checks non-degraded
arrays?  Doesn't "echo check > /sys/block/$dev/md/sync_action" do the
same?


Kind regards,

Mukund
