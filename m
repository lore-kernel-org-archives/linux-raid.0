From: mwilck@arcor.de
Subject: [PATCH 1/4] mdmon: always get layout from sysfs
Date: Fri,  2 Aug 2013 00:35:14 +0200
Message-ID: <1375396517-8479-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

commit 71d68ff62 uses the array layout. It needs to be initialized.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 managemon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/managemon.c b/managemon.c
index 6cd93e5..21bf2bd 100644
--- a/managemon.c
+++ b/managemon.c
@@ -652,7 +652,7 @@ static void manage_new(struct mdstat_ent *mdstat,
 	mdi = sysfs_read(-1, mdstat->devnm,
 			 GET_LEVEL|GET_CHUNK|GET_DISKS|GET_COMPONENT|
 			 GET_DEGRADED|GET_SAFEMODE|
-			 GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE);
+			 GET_DEVS|GET_OFFSET|GET_SIZE|GET_STATE|GET_LAYOUT);
 
 	if (!mdi)
 		return;
-- 
1.7.1
