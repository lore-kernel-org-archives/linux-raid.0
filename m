From: Jes.Sorensen@redhat.com
Subject: [PATCH 09/11] super1.c: use ROUND_UP/ROUND_UP_PTR
Date: Tue, 20 Mar 2012 17:54:14 +0100
Message-ID: <1332262456-5109-10-git-send-email-Jes.Sorensen@redhat.com>
References: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1332262456-5109-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 super1.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/super1.c b/super1.c
index 350e27a..612ae98 100644
--- a/super1.c
+++ b/super1.c
@@ -174,7 +174,7 @@ static int aread(struct align_fd *afd, void *buf, int len)
 				"invalid block size\n");
 		return -1;
 	}
-	b = (char*)(((long)(abuf+4096))&~4095UL);
+	b = ROUND_UP_PTR((char *)abuf, 4096);
 
 	for (iosize = 0; iosize < len; iosize += bsize)
 		;
@@ -207,7 +207,7 @@ static int awrite(struct align_fd *afd, void *buf, int len)
 				"invalid block size\n");
 		return -1;
 	}
-	b = (char*)(((long)(abuf+4096))&~4095UL);
+	b = ROUND_UP_PTR((char *)abuf, 4096);
 
 	for (iosize = 0; iosize < len ; iosize += bsize)
 		;
@@ -1037,8 +1037,7 @@ static int store_super1(struct supertype *st, int fd)
 	if (lseek64(fd, sb_offset << 9, 0)< 0LL)
 		return 3;
 
-	sbsize = sizeof(*sb) + 2 * __le32_to_cpu(sb->max_dev);
-	sbsize = (sbsize+511)&(~511UL);
+	sbsize = ROUND_UP(sizeof(*sb) + 2 * __le32_to_cpu(sb->max_dev), 512);
 
 	if (awrite(&afd, sb, sbsize) != sbsize)
 		return 4;
-- 
1.7.7.6

