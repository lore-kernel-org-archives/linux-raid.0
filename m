From: Jes.Sorensen@redhat.com
Subject: [PATCH 09/19] Detail(): Remember to free 'avail'
Date: Tue,  1 Nov 2011 16:09:25 +0100
Message-ID: <1320160175-18976-10-git-send-email-Jes.Sorensen@redhat.com>
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
 Detail.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/Detail.c b/Detail.c
index c564786..e7d1681 100644
--- a/Detail.c
+++ b/Detail.c
@@ -58,7 +58,7 @@ int Detail(char *dev, int brief, int export, int test, char *homehost)
 
 	int rv = test ? 4 : 1;
 	int avail_disks = 0;
-	char *avail;
+	char *avail = NULL;
 
 	if (fd < 0) {
 		fprintf(stderr, Name ": cannot open %s: %s\n",
@@ -587,6 +587,7 @@ This is pretty boring
 out:
 	close(fd);
 	free(subarray);
+	free(avail);
 	sysfs_free(sra);
 	return rv;
 }
-- 
1.7.6.4

