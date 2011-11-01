From: Jes.Sorensen@redhat.com
Subject: [PATCH 11/19] enough_fd(): remember to free buffer for avail array
Date: Tue,  1 Nov 2011 16:09:27 +0100
Message-ID: <1320160175-18976-12-git-send-email-Jes.Sorensen@redhat.com>
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
 util.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/util.c b/util.c
index 38af6d5..6985a70 100644
--- a/util.c
+++ b/util.c
@@ -363,7 +363,7 @@ int enough_fd(int fd)
 	struct mdu_array_info_s array;
 	struct mdu_disk_info_s disk;
 	int avail_disks = 0;
-	int i;
+	int i, rv;
 	char *avail;
 
 	if (ioctl(fd, GET_ARRAY_INFO, &array) != 0 ||
@@ -386,9 +386,10 @@ int enough_fd(int fd)
 		avail[disk.raid_disk] = 1;
 	}
 	/* This is used on an active array, so assume it is clean */
-	return enough(array.level, array.raid_disks, array.layout,
-		      1,
-		      avail, avail_disks);
+	rv = enough(array.level, array.raid_disks, array.layout,
+		    1, avail, avail_disks);
+	free(avail);
+	return rv;
 }
 
 
-- 
1.7.6.4

