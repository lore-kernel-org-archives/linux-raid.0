From: Xiao Ni <xni@redhat.com>
Subject: Fwd: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
Date: Sun, 25 Oct 2015 01:38:51 -0400 (EDT)
Message-ID: <284284227.42321345.1445751531086.JavaMail.zimbra@redhat.com>
References: <1445751362-15677-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445751362-15677-1-git-send-email-xni@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jes Sorensen <jes.sorensen@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

I encountered one problem. When reshape one raid1 with bitmap to raid0, it'll
lose legs.

I sent the patch by git-send-email, but I can't see the mail in linux-raid. So
I forward it again. And add signed-off-by line.

Best Regards
Xiao

----- Forwarded Message -----
From: "Xiao Ni" <xni@redhat.com>
To: xni@redhat.com
Sent: Sunday, October 25, 2015 1:36:02 PM
Subject: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0

One raid1 with bitmap is composed by 4 disks. It'll fail when rashape to raid0
and lose 3 disks. It should check bitmap first when reshape raid1 to raid0.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/Grow.c b/Grow.c
index 80d7b22..5e9b0bb 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1898,6 +1898,12 @@ size_change_error:
 	     array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) ||
 	    (s->level == 0 && array.level == 1 && sra)) {
 		int err;
+
+		if (array.state & (1<<MD_SB_BITMAP_PRESENT)) {
+			cont_err("Bitmap must be removed before level can be changed\n");
+			rv = 1;
+			goto release;
+		}
 		err = remove_disks_for_takeover(st, sra, array.layout);
 		if (err) {
 			dprintf("Array cannot be reshaped\n");
@@ -2706,9 +2712,6 @@ static int impose_level(int fd, int level, char *devname, int verbose)
 			err = errno;
 			pr_err("%s: could not set level to %s\n",
 				devname, c);
-			if (err == EBUSY &&
-			    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
-				cont_err("Bitmap must be removed before level can be changed\n");
 			return err;
 		}
 		if (verbose >= 0)
-- 
1.8.3.1

