From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] Work around architectures having statfs.f_type defined as long
Date: Wed, 19 Mar 2014 14:26:02 +0100
Message-ID: <1395235562-24672-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1395235562-24672-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1395235562-24672-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, arnd@arndb.de, ralf@linux-mips.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Having RAMFS_MAGIC defined as 0x858458f6 causing problems when trying
to compare it directly against statfs.f_type being cast from long to
unsigned long.

This hack is extremly ugly, but it should at least do the right thing
for every situation.

Thanks to Arnd Bergmann for suggesting the fix.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 util.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/util.c b/util.c
index e32d97a..afb2bb1 100644
--- a/util.c
+++ b/util.c
@@ -1946,9 +1946,13 @@ int in_initrd(void)
 {
 	/* This is based on similar function in systemd. */
 	struct statfs s;
+	/* statfs.f_type is signed long on s390x and MIPS, causing all
+	   sorts of sign extension problems with RAMFS_MAGIC being
+	   defined as 0x858458f6 */
 	return  statfs("/", &s) >= 0 &&
 		((unsigned long)s.f_type == TMPFS_MAGIC ||
-		 (unsigned long)s.f_type == RAMFS_MAGIC);
+		 ((unsigned long)s.f_type & 0xFFFFFFFFUL) ==
+		 ((unsigned long)RAMFS_MAGIC & 0xFFFFFFFFUL));
 }
 
 void reopen_mddev(int mdfd)
-- 
1.8.5.3

