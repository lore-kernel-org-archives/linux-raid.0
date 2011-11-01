From: Jes.Sorensen@redhat.com
Subject: [PATCH 01/19] Grow_Add_device(): dev_open() return a negative fd on error
Date: Tue,  1 Nov 2011 16:09:17 +0100
Message-ID: <1320160175-18976-2-git-send-email-Jes.Sorensen@redhat.com>
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
 Grow.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Grow.c b/Grow.c
index b80f202..9ee22e0 100644
--- a/Grow.c
+++ b/Grow.c
@@ -174,7 +174,7 @@ int Grow_Add_device(char *devname, int fd, char *newdev)
 			return 1;
 		}
 		fd2 = dev_open(dv, O_RDWR);
-		if (!fd2) {
+		if (fd2 < 0) {
 			fprintf(stderr, Name ": cannot open device file %s\n", dv);
 			close(nfd);
 			free(st);
-- 
1.7.6.4

