From: Jes.Sorensen@redhat.com
Subject: [PATCH 02/13] Catch malloc() failures
Date: Wed, 26 Oct 2011 17:30:15 +0200
Message-ID: <1319643026-11501-3-git-send-email-Jes.Sorensen@redhat.com>
References: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319643026-11501-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 util.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/util.c b/util.c
index f785f03..5bb71b2 100644
--- a/util.c
+++ b/util.c
@@ -370,6 +370,11 @@ int enough_fd(int fd)
 	    array.raid_disks <= 0)
 		return 0;
 	avail = calloc(array.raid_disks, 1);
+	if (!avail) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		exit(1);
+	}
 	for (i=0; i < 1024 && array.nr_disks > 0; i++) {
 		disk.number = i;
 		if (ioctl(fd, GET_DISK_INFO, &disk) != 0)
@@ -1035,8 +1040,10 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
 	int bestsuper = -1;
 	int i;
 
-	st = malloc(sizeof(*st));
-	memset(st, 0, sizeof(*st));
+	st = calloc(sizeof(*st), 1);
+	if (!st)
+		return st;
+
 	st->container_dev = NoMdDev;
 
 	for (i=0 ; superlist[i]; i++) {
@@ -1479,6 +1486,8 @@ int add_disk(int mdfd, struct supertype *st,
 					break;
 			if (sd2 == NULL) {
 				sd2 = malloc(sizeof(*sd2));
+				if (!sd2)
+					return -ENOMEM;
 				*sd2 = *info;
 				sd2->next = sra->devs;
 				sra->devs = sd2;
@@ -1688,7 +1697,11 @@ void append_metadata_update(struct supertype *st, void *buf, int len)
 {
 
 	struct metadata_update *mu = malloc(sizeof(*mu));
-
+	if (!mu) {
+		fprintf(stderr, Name ": %s unable to allocate memory\n",
+			__func__);
+		exit(1);
+	}
 	mu->buf = buf;
 	mu->len = len;
 	mu->space = NULL;
-- 
1.7.6.4

