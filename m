From: Chris Webb <chris@arachsys.com>
Subject: [PATCH] Segfault with --assemble --force
Date: Wed, 18 Jun 2008 20:35:54 +0100
Message-ID: <20080618193554.GA30682@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm --assemble --force repeatedly segfaults when run on a raid6 array with
more than two components marked as failed, so at least one needs its event
count forcibly updated. sb->events is accessed with sb NULL in update_super1,
called from Assemble (line 667 of Assemble.c). I think the following patch is
correct:

diff -uNrp mdadm-2.6.7.orig/Assemble.c mdadm-2.6.7/Assemble.c
--- mdadm-2.6.7.orig/Assemble.c	2008-06-18 20:23:36.000000000 +0100
+++ mdadm-2.6.7/Assemble.c	2008-06-18 20:23:47.000000000 +0100
@@ -656,7 +656,7 @@ int Assemble(struct supertype *st, char 
 			continue;
 		}
 		tst = dup_super(st);
-		if (tst->ss->load_super(st,fd, NULL)) {
+		if (tst->ss->load_super(tst, fd, NULL)) {
 			close(fd);
 			fprintf(stderr, Name ": RAID superblock disappeared from %s - not updating.\n",
 				devices[chosen_drive].devname);

Cheers,

Chris.
