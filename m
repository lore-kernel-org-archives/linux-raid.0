From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 2] Mark START_ARRAY deprecated with a date.
Date: Tue, 15 Nov 2005 12:56:36 +1100
Message-ID: <1051115015636.9379@suse.de>
References: <20051115125442.9317.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This was marked deprecated "after 2.6" back in the 2.5 days.  
But now it seems there isn't going to be any "after 2.6", and
we deprecate by date now.  So set a date.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/feature-removal-schedule.txt |    9 +++++++++
 ./drivers/md/md.c                            |    2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff ./Documentation/feature-removal-schedule.txt~current~ ./Documentation/feature-removal-schedule.txt
--- ./Documentation/feature-removal-schedule.txt~current~	2005-11-15 10:25:30.000000000 +1100
+++ ./Documentation/feature-removal-schedule.txt	2005-11-15 10:25:30.000000000 +1100
@@ -131,3 +131,12 @@ What:	EXPORT_SYMBOL(lookup_hash)
 When:	January 2006
 Why:	Too low-level interface.  Use lookup_one_len or lookup_create instead.
 Who:	Christoph Hellwig <hch@lst.de>
+
+---------------------------
+
+What:	START_ARRAY ioctl for md
+When:	July 2006
+Files:	drivers/md/md.c
+Why:	Not reliable by design - can fail when most needed.
+	Alternatives exist
+Who:	NeilBrown <neilb@suse.de>

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-11-15 10:25:30.000000000 +1100
+++ ./drivers/md/md.c	2005-11-15 10:25:30.000000000 +1100
@@ -3156,7 +3156,7 @@ static int md_ioctl(struct inode *inode,
 		if (cnt > 0 ) {
 			printk(KERN_WARNING
 			       "md: %s(pid %d) used deprecated START_ARRAY ioctl. "
-			       "This will not be supported beyond 2.6\n",
+			       "This will not be supported beyond July 2006\n",
 			       current->comm, current->pid);
 			cnt--;
 		}
