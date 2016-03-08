From: Jes.Sorensen@redhat.com
Subject: [PATCH 6/8] bitmap: Fix resource leak in bitmap_file_open()
Date: Tue,  8 Mar 2016 12:30:50 -0500
Message-ID: <1457458252-20203-7-git-send-email-Jes.Sorensen@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The code would leak 'fd' if locate_bitmap() failed.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 bitmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/bitmap.c b/bitmap.c
index 5ad7401..0367d13 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -224,6 +224,7 @@ int bitmap_file_open(char *filename, struct supertype **stp, int node_num)
 		} else {
 			if (st->ss->locate_bitmap(st, fd, node_num)) {
 				pr_err("%s doesn't have bitmap\n", filename);
+				close(fd);
 				fd = -1;
 			}
 		}
-- 
2.5.0

