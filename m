From: Sergey Vidishev <sergeyv@yandex-team.ru>
Subject: [PATCH] monitor: fix nullptr dereference when get_md_name() returns NULL
Date: Fri, 10 Oct 2014 17:23:18 +0400
Message-ID: <1531453.K804EMet0W@sergeyv_box>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, sergeyv@yandex-team.ru
List-Id: linux-raid.ids

From f35857936a8df2155b9aee3759c91fc19b77842c Mon Sep 17 00:00:00 2001
From: Sergey Vidishev <sergeyv@yandex-team.ru>
Date: Wed, 8 Oct 2014 21:51:03 +0400
Subject: [PATCH] monitor: fix nullptr dereference when get_md_name() returns NULL

Signed-off-by: Sergey Vidishev <sergeyv@yandex-team.ru>
---

This patch against fresh git://neil.brown.name/mdadm.
I'm not subscribed to the list, please CC me in replies.

 Monitor.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index 5cb24fa..1919f99 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -668,6 +668,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 {
 	struct mdstat_ent *mse;
 	int new_found = 0;
+	char *name;
 
 	for (mse=mdstat; mse; mse=mse->next)
 		if (mse->devnm[0] &&
@@ -678,7 +679,12 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			struct state *st = xcalloc(1, sizeof *st);
 			mdu_array_info_t array;
 			int fd;
-			st->devname = xstrdup(get_md_name(mse->devnm));
+
+			name = get_md_name(mse->devnm);
+			if (!name)
+				return 0;
+
+			st->devname = xstrdup(name);
 			if ((fd = open(st->devname, O_RDONLY)) < 0 ||
 			    ioctl(fd, GET_ARRAY_INFO, &array)< 0) {
 				/* no such array */
-- 
1.9.1


