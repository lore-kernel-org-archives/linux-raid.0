From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 8/9] mdmon: rework startup and takeover logic
Date: Sun, 28 Feb 2010 15:45:45 +0100
Message-ID: <20100228144545.GG24781@maude.comedia.it>
References: <cover.1267282753.git.bluca@comedia.it> <20100228144123.GA24781@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1267282753.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Cc: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
List-Id: linux-raid.ids

rework startup and takeover logic in order to make it more robust

Signed-off-by: Luca Berra <bluca@comedia.it>
---
  mdmon.c |   45 +++++++++++++++++++++------------------------
  1 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index eef4bfa..b823a8c 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -71,7 +71,7 @@ int mon_tid, mgr_tid;
  
  int sigterm;
  
-static char *pid_dir = VAR_RUN;
+static char *pid_dir = NULL;
  
  int run_child(void *v)
  {
@@ -189,9 +189,6 @@ void remove_pidfile(char *devname)
  	unlink(buf);
  	sprintf(buf, "%s/%s.sock", pid_dir, devname);
  	unlink(buf);
-	if (strcmp(pid_dir, ALT_RUN) == 0)
-		/* try to clean up when we are finished with this dir */
-		rmdir(pid_dir);
  }
  
  static int make_control_sock(char *devname)
@@ -443,26 +440,20 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
  	sigaction(SIGPIPE, &act, NULL);
  
  	if (takeover) {
-		victim = mdmon_pid(container->devnum, pid_dir);
-		if (victim < 0) {
-			pid_dir = ALT_RUN;
-			victim = mdmon_pid(container->devnum, pid_dir);
+		/* Check the parent process by socket, not pid, which could be
+		 * stale, then get the pid from the same pid_dir */
+		char * victim_pid_dir = VAR_RUN;
+		victim_sock = connect_monitor(container->devname, victim_pid_dir);
+		if (victim_sock < 0) {
+			victim_pid_dir = ALT_RUN;
+			victim_sock = connect_monitor(container->devname, victim_pid_dir);
  		}
-		if (victim >= 0)
-			victim_sock = connect_monitor(container->devname, pid_dir);
+		if (victim_sock >= 0)
+ 			victim = mdmon_pid(container->devnum, victim_pid_dir);
  	}
  
  	ignore = chdir("/");
  	if (victim < 0) {
-		pid_dir = ALT_RUN;
-		if (ping_monitor(container->devname) == 0) {
-			fprintf(stderr, "mdmon: %s already managed\n",
-				container->devname);
-			if (!takeover)
-				fprintf(stderr, "\trun mdmon --takeover instead\n");
-			exit(3);
-		}
-		pid_dir = VAR_RUN;
  		if (ping_monitor(container->devname) == 0) {
  			fprintf(stderr, "mdmon: %s already managed\n",
  				container->devname);
@@ -479,14 +470,20 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
  	close(mdfd);
  
  	/* Ok, this is close enough.  We can say goodbye to our parent now.
+	 * take care to remove all possible pid files and sockets.
  	 */
-	if (victim > 0)
+	if (mkdir(ALT_RUN, 0600) >= 0 || (errno == EEXIST && access(ALT_RUN, W_OK) >= 0)) {
+		pid_dir = ALT_RUN;
  		remove_pidfile(devname);
-	if (mkdir(VAR_RUN, 0600) >= 0 || (errno == EEXIST && access(VAR_RUN, W_OK) >= 0))
+	}
+	if (mkdir(VAR_RUN, 0600) >= 0 || (errno == EEXIST && access(VAR_RUN, W_OK) >= 0)) {
+		/* try to clean up when we are finished with ALT_RUN dir */
+		if (pid_dir != NULL)
+			rmdir(pid_dir);
  		pid_dir = VAR_RUN;
-	else if (mkdir(ALT_RUN, 0600) >= 0 || (errno == EEXIST && access(ALT_RUN, W_OK) >= 0))
-		pid_dir = ALT_RUN;
-	else {
+		remove_pidfile(devname);
+	}
+	if (pid_dir == NULL) {
  		fprintf(stderr, "mdmon: Neither %s nor %s are writable\n"
  			"       cannot create .pid or .sock files.  Aborting\n",
  			VAR_RUN, ALT_RUN);
-- 
1.7.0


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
