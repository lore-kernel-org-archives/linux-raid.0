From: Lidong Zhong <lidong.zhong@suse.com>
Subject: [PATCH] Monitor: remove autorebuild pidfile when it exits
Date: Mon, 9 Mar 2020 11:24:36 +0800
Message-ID: <20200309032436.5902-1-lidong.zhong@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: jsorensen@fb.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Though the mdadm monitor is supposed to run in background and never
exit, user may want to restart it and kill the daemon forcefully. If
the pid stored in autorebuild.pid is taken by some other process, it
reports that
"mdadm: Only one autorebuild process allowed in scan mode, aborting"
even though no autorebuild process exists. With this patch this file
will be removed at the end to fix this error.

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
Hi Jes, 

could you please share your opinion about this patch? TIA.
---
 Monitor.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/Monitor.c b/Monitor.c
index b527165..4cb113d 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -62,6 +62,7 @@ struct alert_info {
 	int dosyslog;
 };
 static int make_daemon(char *pidfile);
+static int cleanup_sharer_pidfile();
 static int check_one_sharer(int scan);
 static void alert(char *event, char *dev, char *disc, struct alert_info *info);
 static int check_array(struct state *st, struct mdstat_ent *mdstat,
@@ -71,6 +72,12 @@ static int add_new_arrays(struct mdstat_ent *mdstat, struct state **statelist,
 			  int test, struct alert_info *info);
 static void try_spare_migration(struct state *statelist, struct alert_info *info);
 static void link_containers_with_subarrays(struct state *list);
+static volatile sig_atomic_t finished = 0;
+
+static void _exit_handler(int sig)                                                                                               
+{
+	finished= 1;
+}
 
 int Monitor(struct mddev_dev *devlist,
 	    char *mailaddr, char *alert_cmd,
@@ -123,7 +130,6 @@ int Monitor(struct mddev_dev *devlist,
 
 	struct state *statelist = NULL;
 	struct state *st2;
-	int finished = 0;
 	struct mdstat_ent *mdstat = NULL;
 	char *mailfrom;
 	struct alert_info info;
@@ -157,6 +163,11 @@ int Monitor(struct mddev_dev *devlist,
 		if (rv >= 0)
 			return rv;
 	}
+	
+	signal(SIGTERM, &_exit_handler);  
+	signal(SIGKILL, &_exit_handler);  
+	signal(SIGINT, &_exit_handler);
+	signal(SIGQUIT, &_exit_handler);
 
 	if (share)
 		if (check_one_sharer(c->scan))
@@ -260,6 +271,8 @@ int Monitor(struct mddev_dev *devlist,
 
 	if (pidfile)
 		unlink(pidfile);
+	if (cleanup_sharer_pidfile())
+		pr_err("Cannot remove autorebuild.pidfile\n");
 	return 0;
 }
 
@@ -299,6 +312,30 @@ static int make_daemon(char *pidfile)
 	return -1;
 }
 
+static int cleanup_sharer_pidfile()
+{
+	int pid, rv;
+	FILE *fp;
+	char path[100];
+	char dir[20];
+	struct stat buf;
+	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
+	fp = fopen(path, "r");
+	if (fp) {
+		if (fscanf(fp, "%d", &pid) != 1)
+			pid = -1;
+		sprintf(dir, "/proc/%d", pid);
+		rv = stat(dir, &buf);
+		if (rv != -1) {
+			fclose(fp);
+			unlink(path);
+		} else
+			return 1;
+	}
+
+	return 0;
+}
+
 static int check_one_sharer(int scan)
 {
 	int pid, rv;
-- 
2.16.4
