From: Jes.Sorensen@redhat.com
Subject: [PATCH 01/11] super1.c don't keep recalculating bitmap pointer
Date: Tue, 20 Mar 2012 17:54:06 +0100
Message-ID: <1332262456-5109-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

We just calculated the pointer to the bitmap, so use it instead of
recalculating.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/super1.c b/super1.c
index 341ad53..4e3bf7b 100644
--- a/super1.c
+++ b/super1.c
@@ -1389,8 +1389,7 @@ static int load_super1(struct supertype *st, int fd, char *devname)
 	 * should get that written out.
 	 */
 	locate_bitmap1(st, fd);
-	if (aread(fd, ((char*)super)+1024, 512)
-	    != 512)
+	if (aread(fd, bsb, 512) != 512)
 		goto no_bitmap;
 
 	uuid_from_super1(st, uuid);
@@ -1657,7 +1656,7 @@ static int write_bitmap1(struct supertype *st, int fd)
 		return -ENOMEM;
 
 	memset(buf, 0xff, 4096);
-	memcpy(buf, ((char*)sb)+1024, sizeof(bitmap_super_t));
+	memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
 
 	towrite = __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chunksize)>>9);
 	towrite = (towrite+7) >> 3; /* bits to bytes */
-- 
1.7.7.6

