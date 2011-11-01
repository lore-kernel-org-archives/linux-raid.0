From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 19/19] make_parts(): Avoid false positive security warning
Date: Tue, 01 Nov 2011 21:30:12 +0100
Message-ID: <4EB056D4.1040402@redhat.com>
References: <1320160175-18976-1-git-send-email-Jes.Sorensen@redhat.com> <1320160175-18976-20-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040905070206030400020104"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320160175-18976-20-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------040905070206030400020104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 11/01/11 16:09, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> S_ISBLK() and S_ISLNK() are mutually exclusive. By swapping the checks
> round and testing S_ISBLK() first, we avoid having to silence the
> compiler for uninitialized variable usage, and avoid a warning from
> security checking tools.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Looking at this one again, I realized it doesn't solve the real problem.
In particular if /dev/md64 already exists as a symlink and /dev/md64p1
exists as a device node, we end up comparing against random stack data.

Please discard the previous patch and use this one instead.

Sorry for the noise.

Cheers,
Jes

--------------040905070206030400020104
Content-Type: text/x-patch;
 name="0019-make_parts-Fix-case-of-comparing-against-uninitializ.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0019-make_parts-Fix-case-of-comparing-against-uninitializ.pa";
 filename*1="tch"

From a6411e70a8074d13f9ad0af6d68a6d8bb550c317 Mon Sep 17 00:00:00 2001
From: Jes Sorensen <Jes.Sorensen@redhat.com>
Date: Tue, 1 Nov 2011 14:53:37 +0100
Subject: [PATCH 19/19] make_parts(): Fix case of comparing against
 uninitialized variables

Silencing gcc's warning of uninitialized variables was hiding a bug
where if we have /dev/md64 as a symlink, and /dev/md64p1 was a real
device node.

In this case major_num and minor_num would not get populated, but we
end up comparing against them because the stat for md64p1 succeeds.

Instead of using the int foo = foo trick, change the code to set
set the variables to invalid values so comparisons will fail.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdopen.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index 555ab84..eac1c1f 100644
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
@@ -53,23 +53,26 @@ void make_parts(char *dev, int cnt)
 	if (lstat(dev, &stb)!= 0)
 		return;
 
-	if (S_ISLNK(stb.st_mode)) {
+	if (S_ISBLK(stb.st_mode)) {
+		major_num = major(stb.st_rdev);
+		minor_num = minor(stb.st_rdev);
+		odig = -1;
+	} else if (S_ISLNK(stb.st_mode)) {
 		int len = readlink(dev, orig, sizeof(orig));
 		if (len < 0 || len > 1000)
 			return;
 		orig[len] = 0;
 		odig = isdigit(orig[len-1]);
-	} else if (S_ISBLK(stb.st_mode)) {
-		major_num = major(stb.st_rdev);
-		minor_num = minor(stb.st_rdev);
+		major_num = -1;
+		minor_num = -1;
 	} else
-		   return;
+		return;
 	name = malloc(nlen);
 	for (i=1; i <= cnt ; i++) {
 		struct stat stb2;
 		snprintf(name, nlen, "%s%s%d", dev, dig?"p":"", i);
 		if (stat(name, &stb2)==0) {
-			if (!S_ISBLK(stb2.st_mode))
+			if (!S_ISBLK(stb2.st_mode) || !S_ISBLK(stb.st_mode))
 				continue;
 			if (stb2.st_rdev == makedev(major_num, minor_num+i))
 				continue;
-- 
1.7.6.4


--------------040905070206030400020104--
