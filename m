From: Jes.Sorensen@redhat.com
Subject: [PATCH 2/2] Create() check malloc() return value
Date: Fri, 21 Oct 2011 17:15:59 +0200
Message-ID: <1319210159-8711-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1319210159-8711-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319210159-8711-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Create.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Create.c b/Create.c
index 3e85785..5d1548b 100644
--- a/Create.c
+++ b/Create.c
@@ -790,6 +790,10 @@ int Create(struct supertype *st, char *mddev,
 	}
 
 	infos = malloc(sizeof(*infos) * total_slots);
+	if (!infos) {
+		fprintf(stderr, Name ": Unable to allocate memory\n");
+		goto abort;
+	}
 
 	for (pass=1; pass <=2 ; pass++) {
 		struct mddev_dev *moved_disk = NULL; /* the disk that was moved out of the insert point */
-- 
1.7.4.4

