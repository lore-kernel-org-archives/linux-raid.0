From: Xiao Ni <xni@redhat.com>
Subject: [mdadm PATCH 1/1] Fix some type comparison problems
Date: Wed,  3 Feb 2016 13:24:49 +0800
Message-ID: <1454477089-8166-1-git-send-email-xni@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

It complains when building on s390 and i686 platform.

Signed-off-by : Xiao Ni <xni@redhat.com>
---
 Monitor.c | 2 +-
 util.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Monitor.c b/Monitor.c
index f19c2e5..928aa45 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -542,7 +542,7 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
 		alert("NewArray", st->devname, NULL, ainfo);
 	}
 
-	if (st->utime == array.utime &&
+	if (st->utime == (long)array.utime &&
 	    st->failed == array.failed_disks &&
 	    st->working == array.working_disks &&
 	    st->spare == array.spare_disks &&
diff --git a/util.c b/util.c
index 970d484..ccbb2bc 100644
--- a/util.c
+++ b/util.c
@@ -1288,7 +1288,7 @@ struct supertype *guess_super_type(int fd, enum guess_types guess_type)
 			struct mdinfo info;
 			st->ss->getinfo_super(st, &info, NULL);
 			if (bestsuper == -1 ||
-			    besttime < info.array.ctime) {
+			    besttime < (time_t)info.array.ctime) {
 				bestsuper = i;
 				besttime = info.array.ctime;
 			}
-- 
2.4.3

