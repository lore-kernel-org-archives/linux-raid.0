From: mwilck@arcor.de
Subject: [PATCH 7/8] monitor: treat unreadable array_state as clean
Date: Mon, 25 Mar 2013 23:11:14 +0000 (UTC)
Message-ID: <1382695659-6231-8-git-send-email-mwilck@arcor.de>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:38 +0200
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Failure to read array_state can only mean the array has been
deleted by the kernel; it is not an indication that the array
is dirty.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 monitor.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/monitor.c b/monitor.c
index 60c5d5a..47432b2 100644
--- a/monitor.c
+++ b/monitor.c
@@ -265,7 +265,7 @@ static int read_and_act(struct active_array *a)
 		 */
 		a->container->ss->set_array_state(a, 0);
 	}
-	if (a->curr_state <= inactive &&
+	if ((a->curr_state == bad_word || a->curr_state <= inactive) &&
 	    a->prev_state > inactive) {
 		/* array has been stopped */
 		a->container->ss->set_array_state(a, 1);
@@ -288,8 +288,7 @@ static int read_and_act(struct active_array *a)
 		a->container->ss->set_array_state(a, 1);
 	}
 	if (a->curr_state == active ||
-	    a->curr_state == suspended ||
-	    a->curr_state == bad_word)
+	    a->curr_state == suspended)
 		ret |= ARRAY_DIRTY;
 	if (a->curr_state == readonly) {
 		/* Well, I'm ready to handle things.  If readonly
-- 
1.7.1
