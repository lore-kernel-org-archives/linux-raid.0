From: Sergey Vidishev <sergeyv@yandex-team.ru>
Subject: [PATCH v3] mdadm: monitor: fix nullptr dereference when get_md_name() returns NULL
Date: Tue, 19 May 2015 22:02:46 +0300
Message-ID: <7486089.5E28xkmWcx@sergeyv_box>
References: <1531453.K804EMet0W@sergeyv_box> <CAGRSmLuzqwn=7LQZx_CA1VE4SsGTHMEWU-TJkuHUeeaa8XUQ1Q@mail.gmail.com> <1916694.4Z1o92rJfN@sergeyv_box>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1916694.4Z1o92rJfN@sergeyv_box>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

From fce3be7200e84665cdae58ba44d5c61af094af3b Mon Sep 17 00:00:00 2001
From: Sergey Vidishev <sergeyv@yandex-team.ru>
Date: Tue, 19 May 2015 20:34:58 +0300
Subject: [PATCH] mdadm: monitor: fix nullptr dereference when get_md_name()
 returns NULL

Function add_new_arrays() expects that function get_md_name() should
return pointer to devname, but also get_md_name() may return NULL. So
check the pointer before use it in add_new_arrays().

Signed-off-by: Sergey Vidishev <sergeyv@yandex-team.ru>
---

v2 -> v3: - continue instead of return
          - avoid mem leak (thanks to David F.)
v1 -> v2: more verbose commit message

 Monitor.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index 1cd378b..a530032 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -687,6 +687,7 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 {
 	struct mdstat_ent *mse;
 	int new_found = 0;
+	char *name;
 
 	for (mse=mdstat; mse; mse=mse->next)
 		if (mse->devnm[0] &&
@@ -697,7 +698,14 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			struct state *st = xcalloc(1, sizeof *st);
 			mdu_array_info_t array;
 			int fd;
-			st->devname = xstrdup(get_md_name(mse->devnm));
+
+			name = get_md_name(mse->devnm);
+			if (!name) {
+				free(st);
+				continue;
+			}
+
+			st->devname = xstrdup(name);
 			if ((fd = open(st->devname, O_RDONLY)) < 0 ||
 			    ioctl(fd, GET_ARRAY_INFO, &array)< 0) {
 				/* no such array */
-- 
2.0.4

