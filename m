From: Jes.Sorensen@redhat.com
Subject: [PATCH 19/19] make_parts(): Avoid false positive security warning
Date: Tue,  1 Nov 2011 16:09:35 +0100
Message-ID: <1320160175-18976-20-git-send-email-Jes.Sorensen@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

S_ISBLK() and S_ISLNK() are mutually exclusive. By swapping the checks
round and testing S_ISBLK() first, we avoid having to silence the
compiler for uninitialized variable usage, and avoid a warning from
security checking tools.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdopen.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index 555ab84..e6db7d7 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -38,9 +38,9 @@ void make_parts(char *dev, int cnt)
 	 * else that of dev
 	 */
 	struct stat stb;
-	int major_num = major_num; /* quiet gcc -Os unitialized warning */
-	int minor_num = minor_num; /* quiet gcc -Os unitialized warning */
-	int odig = odig; /* quiet gcc -Os unitialized warning */
+	int major_num;
+	int minor_num;
+	int odig;
 	int i;
 	int nlen = strlen(dev) + 20;
 	char *name;
@@ -53,15 +53,15 @@ void make_parts(char *dev, int cnt)
 	if (lstat(dev, &stb)!= 0)
 		return;
 
-	if (S_ISLNK(stb.st_mode)) {
+	if (S_ISBLK(stb.st_mode)) {
+		major_num = major(stb.st_rdev);
+		minor_num = minor(stb.st_rdev);
+	} else if (S_ISLNK(stb.st_mode)) {
 		int len = readlink(dev, orig, sizeof(orig));
 		if (len < 0 || len > 1000)
 			return;
 		orig[len] = 0;
 		odig = isdigit(orig[len-1]);
-	} else if (S_ISBLK(stb.st_mode)) {
-		major_num = major(stb.st_rdev);
-		minor_num = minor(stb.st_rdev);
 	} else
 		   return;
 	name = malloc(nlen);
-- 
1.7.6.4

