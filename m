From: maximilian attems <max@stro.at>
Subject: [PATCH] [mdadm] config.c include dirent.h instead sys/dir.h
Date: Fri, 21 Sep 2007 19:32:18 +0200
Message-ID: <11903959393989-git-send-email-max@stro.at>
References: <11903959391007-git-send-email-max@stro.at>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11903959391007-git-send-email-max@stro.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, maximilian attems <max@stro.at>
List-Id: linux-raid.ids

sys/dir.h is an old BSD'ism, include dirent directly.
small step for better klibc support.

compile tested against glibc.

Signed-off-by: maximilian attems <max@stro.at>
---
 config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/config.c b/config.c
index 73031b7..68c1507 100644
--- a/config.c
+++ b/config.c
@@ -29,7 +29,7 @@
 
 #include	"mdadm.h"
 #include	"dlink.h"
-#include	<sys/dir.h>
+#include	<dirent.h>
 #include	<glob.h>
 #include	<fnmatch.h>
 #include	<ctype.h>
-- 
1.5.2.4

