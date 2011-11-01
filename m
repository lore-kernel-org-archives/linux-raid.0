From: Jes.Sorensen@redhat.com
Subject: [PATCH 17/19] bitmap_fd_read(): fix memory leak
Date: Tue,  1 Nov 2011 16:09:33 +0100
Message-ID: <1320160175-18976-18-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 bitmap.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/bitmap.c b/bitmap.c
index 2e1ecda..d02f16e 100644
--- a/bitmap.c
+++ b/bitmap.c
@@ -147,6 +147,7 @@ bitmap_info_t *bitmap_fd_read(int fd, int brief)
 		fprintf(stderr, Name ": failed to allocate %zd bytes\n",
 				sizeof(*info));
 #endif
+		free(buf);
 		return NULL;
 	}
 
@@ -154,6 +155,7 @@ bitmap_info_t *bitmap_fd_read(int fd, int brief)
 		fprintf(stderr, Name ": failed to read superblock of bitmap "
 			"file: %s\n", strerror(errno));
 		free(info);
+		free(buf);
 		return NULL;
 	}
 	memcpy(&info->sb, buf, sizeof(info->sb));
@@ -198,6 +200,7 @@ bitmap_info_t *bitmap_fd_read(int fd, int brief)
 		total_bits = read_bits;
 	}
 out:
+	free(buf);
 	info->total_bits = total_bits;
 	info->dirty_bits = dirty_bits;
 	return info;
-- 
1.7.6.4

