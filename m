From: mwilck@arcor.de
Subject: [PATCH 06/10] monitor: read_and_act: log status when called
Date: Tue, 30 Jul 2013 23:18:30 +0200
Message-ID: <1375219114-5626-7-git-send-email-mwilck@arcor.de>
References: <51F82D3B.6060104@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F82D3B.6060104@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

From: Martin Wilck <mwilck@arcor.de>

read_and_act() currently prints a debug message only very late.
Print the status seen by mdmon right away, to track mdmon's
actions more closely. Add a time stamp to observe long delays
between read_and_act calls, e.g. caused by meta data writes.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 monitor.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index 67b40b1..b208168 100644
--- a/monitor.c
+++ b/monitor.c
@@ -234,6 +234,7 @@ static int read_and_act(struct active_array *a)
 	struct mdinfo *mdi;
 	int ret = 0;
 	int count = 0;
+	struct timeval tv;
 
 	a->next_state = bad_word;
 	a->next_action = bad_action;
@@ -257,6 +258,17 @@ static int read_and_act(struct active_array *a)
 			mdi->curr_state = read_dev_state(mdi->state_fd);
 		}
 	}
+	
+	gettimeofday(&tv, NULL);
+	fprintf(stderr, "%s(%d): %ld.%06ld state:%s prev:%s action:%s prev: %s start:%llu\n",
+		__func__, a->info.container_member,
+		tv.tv_sec, tv.tv_usec,
+		array_states[a->curr_state],
+		array_states[a->prev_state],
+		sync_actions[a->curr_action],
+		sync_actions[a->prev_action],
+		a->info.resync_start
+		);
 
 	if (a->curr_state > inactive &&
 	    a->prev_state == inactive) {
-- 
1.7.1
