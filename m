From: Jes.Sorensen@redhat.com
Subject: [PATCH 3/8] Grow: Grow_continue_command() remove dead code
Date: Tue,  8 Mar 2016 12:30:47 -0500
Message-ID: <1457458252-20203-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1457458252-20203-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, gqjiang@suse.com, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All cases where fd2 is used are completed with a close(fd2) ; fd2 = -1;
so there is no need to check for fd2 > -1 before exiting.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 Grow.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Grow.c b/Grow.c
index c4f417e..0fa776d 100755
--- a/Grow.c
+++ b/Grow.c
@@ -4924,8 +4924,6 @@ int Grow_continue_command(char *devname, int fd,
 	ret_val = Grow_continue(fd, st, content, backup_file, 1, 0);
 
 Grow_continue_command_exit:
-	if (fd2 > -1)
-		close(fd2);
 	if (cfd > -1)
 		close(cfd);
 	st->ss->free_super(st);
-- 
2.5.0

