From: Jeff Schaller <schaller@freeshell.org>
Subject: Assertion failure, BUG at journal.c:1732
Date: Sat, 23 Nov 2002 19:43:22 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.NEB.4.44.0211231926020.11197-100000@iceland.freeshell.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: sct@redhat.com, akpm@zip.com.au, adilger@clusterfs.com, mingo@redhat.com, neilb@cse.unsw.edu.au
Cc: ext3-users@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all!
I've sent this to the raid and ext3 maintainers because both are
involved.

I just upgraded from 2.4.17 to 2.4.19, and have run into some
trouble with journal.c:1732. Background: 2 40G drives, software
raid level 1'd together, with ext3 on top. The bug occurs during
writes.  The filesystem is approximately 90% full. The system
remains up after the BUG, but the partition does not. After
reboot, the raid reconstructs successfully, and the partition
mounts without errors. I do not at this point suspect memory or
physical drive problems; there are no other random crashes or
lockups, and I've successfully run CPU-, memory-, and
disk-intensive programs to this point.

The first time the error occurred, I really did try to copy too
much data to the partition; the command was similar to:
mv ~/bunch-of-big-files /ext3/partition

The first few files made it, the next few got dropped into the
bitbucket, and the remainder stayed on ~.

I googled for this error but didn't find any similar matches.

I've attached the kernel log file; I left the boot messages in
case they provide helpful information about the system. I am
running debian (stable) with:
e2fsprogs 1.27-2
raidtools2 0.90.20010914-15

Raid (level 1) and ext3 support are both compiled directly into
the kernel. Please let me know if I can provide more information
or be of any help.

Thank you,
-jeff
-- 
It would appear that we have reached the limits of what it is possible to
achieve with computer technology, although one should be careful with such
statements, as they tend to sound pretty silly in 5 years.
        - John Von Neumann (ca. 1949)

