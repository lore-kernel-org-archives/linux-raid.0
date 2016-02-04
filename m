From: Xiao Ni <xni@redhat.com>
Subject: [mdadm PATCH 1/1] Fix some type comparison problems
Date: Thu,  4 Feb 2016 20:26:51 +0800
Message-ID: <1454588811-3713-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com, deepa.kernel@gmail.com
List-Id: linux-raid.ids

It complains when building on s390 and i686 platform.

Signed-off-by : Xiao Ni <xni@redhat.com>
---
 Monitor.c | 2 +-
 util.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index f19c2e5..9a6cf7e 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -542,7 +542,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		alert("NewArray", st->devname, NULL, ainfo);
 	}
 
-	if (st->utime == array.utime &&
+	if ((unsigned int)st->utime == array.utime &&
 	    st->failed == array.failed_disks &&
 	    st->working == array.working_disks &&
 	    st->spare == array.spare_disks &&
diff --git a/util.c b/util.c
index 970d484..6e7d3fb 100644
--- a/util.c
+++ b/util.c
@@ -1267,7 +1267,7 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
 	 */
 	struct superswitch  *ss;
 	struct supertype *st;
-	time_t besttime = 0;
+	unsigned int besttime = 0;
 	int bestsuper = -1;
 	int i;
 
-- 
2.4.3

