From: Luis de Bethencourt <luisbg@kernel.org>
Subject: [PATCH] md/raid1: Fix trailing semicolon
Date: Wed, 17 Jan 2018 13:38:02 +0000
Message-ID: <20180117133802.8879-1-luisbg@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Luis de Bethencourt <luisbg@kernel.org>
List-Id: linux-raid.ids

The trailing semicolon is an empty statement that does no operation.
Removing it since it doesn't do anything.

Signed-off-by: Luis de Bethencourt <luisbg@kernel.org>
---

Hi,

After fixing the same thing in drivers/staging/rtl8723bs/, Joe Perches
suggested I fix it treewide [0].

Best regards,
Luis


[0] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115410.html
[1] http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2018-January/115390.html

 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b2eae332e1a2..f978eddc7a21 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1108,7 +1108,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 
 	bio_copy_data(behind_bio, bio);
 skip_copy:
-	r1_bio->behind_master_bio = behind_bio;;
+	r1_bio->behind_master_bio = behind_bio;
 	set_bit(R1BIO_BehindIO, &r1_bio->state);
 
 	return;
-- 
2.15.1
