From: Markus Schoder <markus_schoder@yahoo.de>
Subject: resizing RAID0 in-place
Date: Tue, 23 Apr 2002 19:33:07 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1704AK-2FyAT2C@fmrl00.sul.t-online.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I want to resize a RAID0 device in-place to eventually switch from
reiserfs to ext3.  I thought of doing it like

1. Shrink reiserfs (already done with resize_reiserfs tool).
2. Shrink raid device where fs lives on.  This is the tricky bit because
   it would involve running mkraid where it says in the man page that it
   destroys all data.

   However if I just shrink the partitions, keeping their
   starting blocks the same and of course keep the chunk
   size the same I would hope that I can do a mkraid without
   loosing data.  Is that true?

3. Create 2 more partitions and new raid device on disks.
4. Create ext2 fs on new raid device.
5. Copy file system on file level from reiserfs to new ext2 fs.
6. Format original raid device to ext2.
7. Copy file system created in 5 to ext2 fs created in 6 on file level.

8. Delete additional partitions and extend original raid device to full
   size again.  This is the other critical bit, but if step 2 works I
   hope this does work too.

9. Extend ext2 fs (with resize2fs).
10. Convert to ext3

Optionally I would like to replace step 7 with a run of raidreconf so I
could change the chunk size of the raid.

Does this sound feasible?  Or is there a simpler way (not involving
additional hardware) that would accomplish the same thing?

--
Markus
