From: Xiao Ni <xni@redhat.com>
Subject: [MDADM PATCH] Check and remove bitmap first when reshape to raid0
Date: Tue, 22 Dec 2015 11:09:34 +0800
Message-ID: <1450753774-4358-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.com
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If reshape one raid device with bitmap to raid0, the reshape progress will
start. But it'll fail and lose some components. So it should remove bitmap 
first. 

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 Grow.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Grow.c b/Grow.c
index 6dfb9c9..db4daa8 100755
--- a/Grow.c
+++ b/Grow.c
@@ -1590,6 +1590,15 @@ int Grow_reshape(char *devname, int fd,
 		pr_err("Cannot increase raid-disks on this array beyond %d\n", st->max_devs);
 		return 1;
 	}
+	if (s->level == 0 && 
+	    (array.state & (1<<MD_SB_BITMAP_PRESENT)) && 
+	    !(array.state & (1<<MD_SB_CLUSTERED))) {
+                array.state &= ~(1<<MD_SB_BITMAP_PRESENT);
+                if (ioctl(fd, SET_ARRAY_INFO, &array)!= 0) {
+                        pr_err("failed to remove internal bitmap.\n");
+                        return 1;
+                }
+        }
 
 	/* in the external case we need to check that the requested reshape is
 	 * supported, and perform an initial check that the container holds the
-- 
2.4.3

