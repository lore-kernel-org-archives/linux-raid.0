From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Sat, 19 Dec 2009 12:21:06 -0600
Message-ID: <2F.73.01567.6991D2B4@cdptpa-omtalb.mail.rr.com>
References: <27.2B.01550.F982C2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27.2B.01550.F982C2B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Well, the RAID growth completed on the backup system, but now when I attempt
to mount the XFS file system, mount returns the error "mount: Structure
needs cleaning".  When I issue the xfs_repair command, I get this:

Backup:/boot/grub# xfs_repair -v /dev/md0
Phase 1 - find and verify superblock...
        - block cache size set to 28616 entries
Phase 2 - using internal log
        - zero log...
zero_log: head block 38584 tail block 38504
ERROR: The filesystem has valuable metadata changes in a log which needs to
be replayed.  Mount the filesystem to replay the log, and unmount it before
re-running xfs_repair.  If you are unable to mount the filesystem, then use
the -L option to destroy the log and attempt a repair.
Note that destroying the log may cause corruption -- please attempt a mount
of the filesystem before doing this.

	The file system was shut down cleanly with umount prior to starting
the growth, but xfs still seems to think the file system is dirty and the
journal needs to be replayed.  Running xfs_repair with the -n command shows
the file system has a few errors.  Before I purge the log and potentially
lose a few files, is there something else I should try under mdadm to
possibly fix teh array structure?  (I doubt it, but I wanted to check with
others more knowledgeable than I before I proceed.)

