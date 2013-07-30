From: Jes.Sorensen@redhat.com
Subject: [PATCH] Avoid double close()
Date: Tue, 30 Jul 2013 18:30:03 +0200
Message-ID: <1375201803-9797-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Coverity discovered a possible double close(fd2) in Grow.c. Avoided by
invalidating fd2 after the first close.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Grow.c b/Grow.c
index c1ae6e8..ff4ed5d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -4685,6 +4685,8 @@ int Grow_continue_command(char *devname, int fd,
 				continue;
 			err = st->ss->load_super(st, fd2, NULL);
 			close(fd2);
+			/* invalidate fd2 to avoid possible double close() */
+			fd2 = -1;
 			if (err)
 				continue;
 			break;
-- 
1.8.3.1

