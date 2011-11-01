From: Jes.Sorensen@redhat.com
Subject: [PATCH 10/19] Grow_reshape(): Fix another 'sra' leak
Date: Tue,  1 Nov 2011 16:09:26 +0100
Message-ID: <1320160175-18976-11-git-send-email-Jes.Sorensen@redhat.com>
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
 Grow.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index af61fc3..29a9126 100644
--- a/Grow.c
+++ b/Grow.c
@@ -1535,10 +1535,12 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 	frozen = freeze(st);
 	if (frozen < -1) {
 		/* freeze() already spewed the reason */
+		sysfs_free(sra);
 		return 1;
 	} else if (frozen < 0) {
 		fprintf(stderr, Name ": %s is performing resync/recovery and cannot"
 			" be reshaped\n", devname);
+		sysfs_free(sra);
 		return 1;
 	}
 
@@ -1835,6 +1837,7 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 		frozen = 0;
 	}
 release:
+	sysfs_free(sra);
 	if (frozen > 0)
 		unfreeze(st);
 	return rv;
-- 
1.7.6.4

