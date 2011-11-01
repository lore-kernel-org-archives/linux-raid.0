From: Jes.Sorensen@redhat.com
Subject: [PATCH 02/19] Grow_addbitmap(): don't try to close a file descriptor which failed to open
Date: Tue,  1 Nov 2011 16:09:18 +0100
Message-ID: <1320160175-18976-3-git-send-email-Jes.Sorensen@redhat.com>
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
 Grow.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/Grow.c b/Grow.c
index 9ee22e0..93a1fba 100644
--- a/Grow.c
+++ b/Grow.c
@@ -442,13 +442,14 @@ int Grow_addbitmap(char *devname, int fd, char *file, int chunk, int delay, int
 			dv = map_dev(disk.major, disk.minor, 1);
 			if (!dv) continue;
 			fd2 = dev_open(dv, O_RDONLY);
-			if (fd2 >= 0 &&
-			    st->ss->load_super(st, fd2, NULL) == 0) {
+			if (fd2 >= 0) {
+				if (st->ss->load_super(st, fd2, NULL) == 0) {
+					close(fd2);
+					st->ss->uuid_from_super(st, uuid);
+					break;
+				}
 				close(fd2);
-				st->ss->uuid_from_super(st, uuid);
-				break;
 			}
-			close(fd2);
 		}
 		if (d == max_devs) {
 			fprintf(stderr, Name ": cannot find UUID for array!\n");
-- 
1.7.6.4

