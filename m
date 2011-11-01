From: Jes.Sorensen@redhat.com
Subject: [PATCH 08/19] Assemble(): don't dup_super() before we need it.
Date: Tue,  1 Nov 2011 16:09:24 +0100
Message-ID: <1320160175-18976-9-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Avoid resource leak in case we bail loop early

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Assemble.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 05710f5..3c8e74d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -293,7 +293,7 @@ int Assemble(struct supertype *st, char *mddev,
 		char *devname = tmpdev->devname;
 		int dfd;
 		struct stat stb;
-		struct supertype *tst = dup_super(st);
+		struct supertype *tst;
 		struct dev_policy *pol = NULL;
 		int found_container = 0;
 
@@ -306,6 +306,8 @@ int Assemble(struct supertype *st, char *mddev,
 			continue;
 		}
 
+		tst = dup_super(st);
+
 		dfd = dev_open(devname, O_RDONLY|O_EXCL);
 		if (dfd < 0) {
 			if (report_missmatch)
-- 
1.7.6.4

