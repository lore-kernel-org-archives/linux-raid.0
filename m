From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 6/9] mdmon: connect_monitor should use socket from
	either dir
Date: Sun, 28 Feb 2010 15:44:24 +0100
Message-ID: <20100228144424.GE24781@maude.comedia.it>
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

connect_monitor is called by ping_monitor in various places
the socket should be checked in either VAR_RUN or ALT_RUN

Signed-off-by: Luca Berra <bluca@comedia.it>
---
  mdmon.c |    2 +-
  msg.c   |   15 ++++++++++++---
  msg.h   |    2 +-
  util.c  |    2 +-
  4 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 3410e84..3627a80 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -447,7 +447,7 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
  			victim = mdmon_pid(container->devnum, pid_dir);
  		}
  		if (victim >= 0)
-			victim_sock = connect_monitor(container->devname);
+			victim_sock = connect_monitor(container->devname, pid_dir);
  	}
  
  	ignore = chdir("/");
diff --git a/msg.c b/msg.c
index d2d8445..78a7964 100644
--- a/msg.c
+++ b/msg.c
@@ -138,7 +138,7 @@ int wait_reply(int fd, int tmo)
  	return receive_message(fd, &msg, tmo);
  }
  
-int connect_monitor(char *devname)
+int connect_monitor(char *devname, const char *pid_dir)
  {
  	char path[100];
  	int sfd;
@@ -147,6 +147,15 @@ int connect_monitor(char *devname)
  	int pos;
  	char *c;
  
+	/* if pid_dir is null try to detect it */
+	if (!pid_dir) {
+		sfd = connect_monitor(devname, VAR_RUN);
+		if (sfd >= 0)
+			return sfd;
+		else
+			return connect_monitor(devname, ALT_RUN);
+	}
+
  	pos = sprintf(path, "%s/", pid_dir);
  	if (is_subarray(devname)) {
  		devname++;
@@ -199,7 +208,7 @@ int fping_monitor(int sfd)
  /* give the monitor a chance to update the metadata */
  int ping_monitor(char *devname)
  {
-	int sfd = connect_monitor(devname);
+	int sfd = connect_monitor(devname, NULL);
  	int err = fping_monitor(sfd);
  
  	close(sfd);
@@ -213,7 +222,7 @@ int ping_monitor(char *devname)
   */
  int ping_manager(char *devname)
  {
-	int sfd = connect_monitor(devname);
+	int sfd = connect_monitor(devname, NULL);
  	struct metadata_update msg = { .len = -1 };
  	int err = 0;
  
diff --git a/msg.h b/msg.h
index f8e89fd..46299db 100644
--- a/msg.h
+++ b/msg.h
@@ -25,7 +25,7 @@ extern int receive_message(int fd, struct metadata_update *msg, int tmo);
  extern int send_message(int fd, struct metadata_update *msg, int tmo);
  extern int ack(int fd, int tmo);
  extern int wait_reply(int fd, int tmo);
-extern int connect_monitor(char *devname);
+extern int connect_monitor(char *devname, const char *pid_dir);
  extern int ping_monitor(char *devname);
  extern int fping_monitor(int sock);
  extern int ping_manager(char *devname);
diff --git a/util.c b/util.c
index 50e04bf..c22886b 100644
--- a/util.c
+++ b/util.c
@@ -1585,7 +1585,7 @@ int flush_metadata_updates(struct supertype *st)
  		return -1;
  	}
  
-	sfd = connect_monitor(devnum2devname(st->container_dev));
+	sfd = connect_monitor(devnum2devname(st->container_dev), NULL);
  	if (sfd < 0)
  		return -1;
  
-- 
1.7.0


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
