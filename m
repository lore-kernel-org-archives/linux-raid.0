From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/1] mddev_create(): choose /dev/md/ name over /dev/mdX
Date: Wed, 11 Feb 2015 14:53:09 -0500
Message-ID: <1423684389-10977-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1423684389-10977-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

/dev/mdX is created automatically if we create /dev/md/X, but
/dev/md/X isn't created automatically if we create /dev/mdX.

By chosing /dev/md/X as the default name from /dev/mdX, we achieve
consistency when creating new arrays.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdopen.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mdopen.c b/mdopen.c
index 2c9d745..db75d09 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -338,7 +338,11 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 
 	sprintf(devname, "/dev/%s", devnm);
 
-	if (dev && dev[0] == '/')
+	if (dev && strncmp(dev, "/dev/md", 7) == 0 &&
+	    dev[7] != '/' && strlen(dev) > 7) {
+		strcpy(chosen, "/dev/md/");
+		strcpy(chosen + 8, dev + 7);
+	} else if (dev && dev[0] == '/')
 		strcpy(chosen, dev);
 	else if (cname[0] == 0)
 		strcpy(chosen, devname);
-- 
2.1.0

