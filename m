From: Lidong Zhong <lzhong@suse.com>
Subject: [PATCH 3/3] mdadm: remove duplicate logic when c.delay is 0
Date: Thu, 27 Aug 2015 15:34:57 +0800
Message-ID: <1440660897-7619-3-git-send-email-lzhong@suse.com>
References: <1440660897-7619-1-git-send-email-lzhong@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1440660897-7619-1-git-send-email-lzhong@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Lidong Zhong <lzhong@suse.com>
---
 mdadm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mdadm.c b/mdadm.c
index 5d5a1b8..9d65abb 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1500,8 +1500,6 @@ int main(int argc, char *argv[])
 			else
 				c.delay = 60;
 		}
-		if (c.delay == 0)
-			c.delay = 60;
 		rv= Monitor(devlist, mailaddr, program,
 			    &c, daemonise, oneshot,
 			    dosyslog, pidfile, increments,
-- 
1.8.1.4

