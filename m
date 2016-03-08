From: Jes.Sorensen@redhat.com
Subject: [PATCH 4/8] Grow: Grow_addbitmap(): Add check to quiet down static code checkers
Date: Tue,  8 Mar 2016 12:30:48 -0500
Message-ID: <1457458252-20203-5-git-send-email-Jes.Sorensen@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Grow_addbitmap() is only ever called with s->bitmap_file != NULL, but
not all static code checkers catch this. This adds a check to quiet
down the false positive warnings.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index 0fa776d..c453eb6 100755
--- a/Grow.c
+++ b/Grow.c
@@ -297,7 +297,14 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 			"  between different architectures.  Consider upgrading the Linux kernel.\n");
 	}
 
-	if (s->bitmap_file && strcmp(s->bitmap_file, "clustered") == 0)
+	/*
+	 * We only ever get called if s->bitmap_file is != NULL, so this check
+	 * is just here to quiet down static code checkers.
+	 */
+	if (!s->bitmap_file)
+		return 1;
+
+	if (strcmp(s->bitmap_file, "clustered") == 0)
 		major = BITMAP_MAJOR_CLUSTERED;
 
 	if (ioctl(fd, GET_BITMAP_FILE, &bmf) != 0) {
-- 
2.5.0

