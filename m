From: Michael Tokarev <mjt@tls.msk.ru>
Subject: mdadm: super0: do not override uuid with homehost
Date: Sat, 20 Oct 2012 19:40:02 +0400 (MSK)
Message-ID: <20121020154002.F24612C12@gandalf.tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Michael Tokarev <mjt@tls.msk.ru>, linux RAID <linux-raid@vger.kernel.org>, 686703@bugs.debian.org
List-Id: linux-raid.ids

When --uuid is specified in the command line, even for v0.90
superblock we override last portion of uuid with data from
--homehost, which is wrong (and disagrees with the manpage).
Only use homehost in super0 if no uuid is specified.

Signed-off-By: Michael Tokarev <mjt@tls.msk.ru>

diff --git a/super0.c b/super0.c
index 1375799..ca4c082 100644
--- a/super0.c
+++ b/super0.c
@@ -657,7 +657,7 @@ static int init_super0(struct supertype *st, mdu_array_info_t *info,
 		if (rfd >= 0)
 			close(rfd);
 	}
-	if (homehost) {
+	if (homehost && !uuid) {
 		char buf[20];
 		char *hash = sha1_buffer(homehost,
 					 strlen(homehost),
