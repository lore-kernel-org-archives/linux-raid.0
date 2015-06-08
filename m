From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v2 6/8] drivers/md/md.c: Use strreplace
Date: Tue,  9 Jun 2015 01:26:54 +0200
Message-ID: <1433806017-10823-7-git-send-email-linux@rasmusvillemoes.dk>
References: <1433806017-10823-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1433806017-10823-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>
Cc: Joe Perches <joe@perches.com>, Al Viro <viro@ZenIV.linux.org.uk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

There's no point in starting over when we meet a '/'. This also
eliminates a stack variable and a little .text.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
v2: no changes.

 drivers/md/md.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 27506302eb7a..2ea2f28551c5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2024,7 +2024,6 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 {
 	char b[BDEVNAME_SIZE];
 	struct kobject *ko;
-	char *s;
 	int err;
 
 	/* prevent duplicates */
@@ -2070,8 +2069,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 		return -EBUSY;
 	}
 	bdevname(rdev->bdev,b);
-	while ( (s=strchr(b, '/')) != NULL)
-		*s = '!';
+	strreplace(b, '/', '!');
 
 	rdev->mddev = mddev;
 	printk(KERN_INFO "md: bind<%s>\n", b);
-- 
2.1.3

