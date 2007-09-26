From: maximilian attems <max@stro.at>
Subject: [PATCH] [mdadm] Monitor.c include signal.h directly
Date: Wed, 26 Sep 2007 18:12:45 +0200
Message-ID: <11908231671738-git-send-email-max@stro.at>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, maximilian attems <max@stro.at>
List-Id: linux-raid.ids

another small step for better klibc support, glibc compile tested.

Signed-off-by: maximilian attems <max@stro.at>
---
 Monitor.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index 91f02a4..246bdc0 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -31,7 +31,7 @@
 #include	"md_p.h"
 #include	"md_u.h"
 #include	<sys/wait.h>
-#include	<sys/signal.h>
+#include	<signal.h>
 #include	<values.h>
 #include	<syslog.h>
 
-- 
1.5.3.1

