From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH] Fix wrong description in manpage
Date: Tue, 12 Jan 2016 18:08:24 +0300
Message-ID: <1452611304-14648-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The careless change was introduce by 'commit 7e6e839a2651
(mdadm: change the num of cluster node)'. Which should be
revert to avoid misunderstanding.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 mdadm.8.in | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index 2844039..c2f2c95 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1162,9 +1162,7 @@ is given, a random UUID is chosen.
 The
 .B name
 option will change the
-.I name
-of the array as stored in the superblock and bitmap. This option only
-works for clustered environment.
+.I name.
 
 The
 .B nodes
-- 
2.1.4

