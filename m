From: mwilck@arcor.de
Subject: [PATCH 07/10] mdmon: wait_and_act: fix debug message for SIGUSR1
Date: Tue, 30 Jul 2013 23:18:31 +0200
Message-ID: <1375219114-5626-8-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

Correctly print out wake reason if it was a signal. Previous code
would print misleading select events (pselect(2) man page says the
fdsets become undefined in case of error).

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 monitor.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/monitor.c b/monitor.c
index b208168..571698a 100644
--- a/monitor.c
+++ b/monitor.c
@@ -640,10 +640,17 @@ static int wait_and_act(struct supertype *container, int nowait)
 		monitor_loop_cnt |= 1;
 		rv = pselect(maxfd+1, NULL, NULL, &rfds, &ts, &set);
 		monitor_loop_cnt += 1;
-		if (rv == -1 && errno == EINTR)
-			rv = 0;
+		if (rv == -1) {
+			if (errno == EINTR) {
+				rv = 0;
+				dprintf("monitor: caught signal\n");
+			} else
+				dprintf("monitor: error %d in pselect\n",
+					errno);
+		}
 		#ifdef DEBUG
-		dprint_wake_reasons(&rfds);
+		else
+			dprint_wake_reasons(&rfds);
 		#endif
 		container->retry_soon = 0;
 	}
-- 
1.7.1
