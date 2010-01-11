From: Doug Ledford <dledford@redhat.com>
Subject: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to support handoff after pivotroot
Date: Mon, 11 Jan 2010 15:38:11 -0500
Message-ID: <1263242294-5353-3-git-send-email-dledford@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263242294-5353-1-git-send-email-dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

Signed-off-by: Doug Ledford <dledford@redhat.com>
---
 mdmon.c |   12 ++++++------
 msg.c   |    2 +-
 util.c  |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 0ec4259..b1d7aef 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -118,7 +118,7 @@ static int test_pidfile(char *devname)
 	char path[100];
 	struct stat st;
 
-	sprintf(path, "/var/run/mdadm/%s.pid", devname);
+	sprintf(path, "/dev/.mdadm/%s.pid", devname);
 	return stat(path, &st);
 }
 
@@ -132,7 +132,7 @@ int make_pidfile(char *devname, int o_excl)
 	if (sigterm)
 		return -1;
 
-	sprintf(path, "/var/run/mdadm/%s.pid", devname);
+	sprintf(path, "/dev/.mdadm/%s.pid", devname);
 
 	fd = open(path, O_RDWR|O_CREAT|o_excl, 0600);
 	if (fd < 0)
@@ -163,7 +163,7 @@ pid_t devname2mdmon(char *devname)
 	pid_t pid = -1;
 	int fd;
 
-	sprintf(buf, "/var/run/mdadm/%s.pid", devname);
+	sprintf(buf, "/dev/.mdadm/%s.pid", devname);
 	fd = open(buf, O_RDONLY|O_NOATIME);
 	if (fd < 0)
 		return -1;
@@ -217,9 +217,9 @@ void remove_pidfile(char *devname)
 	if (sigterm)
 		return;
 
-	sprintf(buf, "/var/run/mdadm/%s.pid", devname);
+	sprintf(buf, "/dev/.mdadm/%s.pid", devname);
 	unlink(buf);
-	sprintf(buf, "/var/run/mdadm/%s.sock", devname);
+	sprintf(buf, "/dev/.mdadm/%s.sock", devname);
 	unlink(buf);
 }
 
@@ -233,7 +233,7 @@ int make_control_sock(char *devname)
 	if (sigterm)
 		return -1;
 
-	sprintf(path, "/var/run/mdadm/%s.sock", devname);
+	sprintf(path, "/dev/.mdadm/%s.sock", devname);
 	unlink(path);
 	sfd = socket(PF_LOCAL, SOCK_STREAM, 0);
 	if (sfd < 0)
diff --git a/msg.c b/msg.c
index 8d52b94..c3ab243 100644
--- a/msg.c
+++ b/msg.c
@@ -147,7 +147,7 @@ int connect_monitor(char *devname)
 	int pos;
 	char *c;
 
-	pos = sprintf(path, "/var/run/mdadm/");
+	pos = sprintf(path, "/dev/.mdadm/");
 	if (is_subarray(devname)) {
 		devname++;
 		c = strchr(devname, '/');
diff --git a/util.c b/util.c
index 5feec43..864af69 100644
--- a/util.c
+++ b/util.c
@@ -1469,7 +1469,7 @@ int mdmon_running(int devnum)
 	char pid[10];
 	int fd;
 	int n;
-	sprintf(path, "/var/run/mdadm/%s.pid", devnum2devname(devnum));
+	sprintf(path, "/dev/.mdadm/%s.pid", devnum2devname(devnum));
 	fd = open(path, O_RDONLY, 0);
 
 	if (fd < 0)
@@ -1489,7 +1489,7 @@ int signal_mdmon(int devnum)
 	char pid[10];
 	int fd;
 	int n;
-	sprintf(path, "/var/run/mdadm/%s.pid", devnum2devname(devnum));
+	sprintf(path, "/dev/.mdadm/%s.pid", devnum2devname(devnum));
 	fd = open(path, O_RDONLY, 0);
 
 	if (fd < 0)
-- 
1.6.5.2

