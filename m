From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 44/53] Add mdadm->mdmon sync_max command message
Date: Fri, 26 Nov 2010 09:09:32 +0100
Message-ID: <20101126080932.5221.41940.stgit@gklab-170-024.igk.intel.com>
References: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101126075407.5221.62582.stgit@gklab-170-024.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Currently only metadata_update messages can be send from mdadm do mdmon using a socket.
For the external metadata reshape implementation a support for sending sync_max command will be also needed.

A new type of message "cmd_message" was defined.
cmd_message is a generic structure that enables to define different types of commands to be send from mdadm to mdmon.

cmd_message's and update_message's are recognized by different start magic numbers sent through the socket.

In this patch only one type of cmd_message was defined:
'SET_SYNC_MAX'

Signed-off-by: Maciej Trela <maciej.trela@intel.com>
Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 managemon.c |   39 +++++++++++++++++++++++++++++++++++++--
 mdadm.h     |   18 ++++++++++++++++++
 mdmon.h     |    3 +++
 msg.c       |   33 +++++++++++++++++++++++++++++++--
 msg.h       |    2 ++
 util.c      |   25 +++++++++++++++++++++++++
 6 files changed, 116 insertions(+), 4 deletions(-)

diff --git a/managemon.c b/managemon.c
index d9eb743..9ff3632 100644
--- a/managemon.c
+++ b/managemon.c
@@ -729,13 +729,36 @@ static void handle_message(struct supertype *container, struct metadata_update *
 	}
 }
 
+static void handle_command(struct supertype *container, struct cmd_message *msg)
+{
+	struct active_array *a;
+
+	/* Search for a member of this container */
+	for (a = container->arrays; a; a = a->next)
+		if (msg->devnum == a->devnum)
+			break;
+
+	if (!a)
+		return;
+
+	/* check command msg type */
+	switch (msg->type) {
+	case SET_SYNC_MAX:
+		/* Add SET_SYNC_MAX handler here */
+		break;
+	}
+}
+
 void read_sock(struct supertype *container)
 {
 	int fd;
 	struct metadata_update msg;
+	struct mdmon_update *update;
+	struct cmd_message *cmd_msg;
 	int terminate = 0;
 	long fl;
 	int tmo = 3; /* 3 second timeout before hanging up the socket */
+	int rv;
 
 	fd = accept(container->sock, NULL, NULL);
 	if (fd < 0)
@@ -749,7 +772,9 @@ void read_sock(struct supertype *container)
 		msg.buf = NULL;
 
 		/* read and validate the message */
-		if (receive_message(fd, &msg, tmo) == 0) {
+		rv = receive_message(fd, &msg, tmo);
+		if (rv == 0) {
+			/* metadata update */
 			handle_message(container, &msg);
 			if (msg.len == 0) {
 				/* ping reply with version */
@@ -759,8 +784,18 @@ void read_sock(struct supertype *container)
 					terminate = 1;
 			} else if (ack(fd, tmo) < 0)
 				terminate = 1;
-		} else
+		} else if (rv == 1) {
+			/* mdmon_update received */
+			update = (struct mdmon_update *)&msg;
+			cmd_msg = (struct cmd_message *)(update->buf);
+			handle_command(container, cmd_msg);
+
+			free(msg.buf);
+			if (ack(fd, tmo) < 0)
+				terminate = 1;
+		} else {
 			terminate = 1;
+		}
 
 	} while (!terminate);
 
diff --git a/mdadm.h b/mdadm.h
index be9a93e..eacf0f5 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -750,6 +750,23 @@ struct metadata_update {
 	struct metadata_update *next;
 };
 
+struct mdmon_update {
+	int len;
+	char *buf;
+};
+
+enum cmd_type {
+	SET_SYNC_MAX,
+};
+
+struct cmd_message {
+	enum cmd_type type;
+	int devnum;
+	union {
+		unsigned long long new_sync_max;
+	} msg_buf;
+};
+
 /* A supertype holds a particular collection of metadata.
  * It identifies the metadata type by the superswitch, and the particular
  * sub-version of that metadata type.
@@ -979,6 +996,7 @@ extern int assemble_container_content(struct supertype *st, int mdfd,
 extern int add_disk(int mdfd, struct supertype *st,
 		    struct mdinfo *sra, struct mdinfo *info);
 extern int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info);
+extern int send_mdmon_cmd(struct supertype *st, struct mdmon_update *update);
 unsigned long long min_recovery_start(struct mdinfo *array);
 
 extern char *human_size(long long bytes);
diff --git a/mdmon.h b/mdmon.h
index 9ea0b93..2c41e47 100644
--- a/mdmon.h
+++ b/mdmon.h
@@ -49,6 +49,9 @@ struct active_array {
 
 	enum state_of_reshape reshape_state;
 	int reshape_delta_disks;
+	int waiting_resync_max; /* wait for resync_max cmd from mdadm */
+	long long unsigned resync_max;
+	long long unsigned sync_completed;
 
 	int check_degraded; /* flag set by mon, read by manage */
 
diff --git a/msg.c b/msg.c
index 95c6f0b..f413824 100644
--- a/msg.c
+++ b/msg.c
@@ -32,6 +32,7 @@
 #include "mdmon.h"
 
 static const __u32 start_magic = 0x5a5aa5a5;
+static const __u32 start_magic_cmd = 0x6b6bb6b6;
 static const __u32 end_magic = 0xa5a55a5a;
 
 static int send_buf(int fd, const void* buf, int len, int tmo)
@@ -93,14 +94,42 @@ int send_message(int fd, struct metadata_update *msg, int tmo)
 	return rv;
 }
 
+int send_message_cmd(int fd, struct mdmon_update *update, int tmo)
+{
+	__s32 len = update->len;
+	int rv;
+
+	rv = send_buf(fd, &start_magic_cmd, 4, tmo);
+	rv = rv ?: send_buf(fd, &len, 4, tmo);
+	if (len > 0)
+		rv = rv ?: send_buf(fd, update->buf, update->len, tmo);
+	rv = send_buf(fd, &end_magic, 4, tmo);
+
+	return rv;
+}
+
+/*
+ * return:
+ *  0 - metadata_update received
+ *  1 - mdmon_update received
+ * -1 - error case
+ */
 int receive_message(int fd, struct metadata_update *msg, int tmo)
 {
 	__u32 magic;
 	__s32 len;
 	int rv;
+	int msg_type;
 
 	rv = recv_buf(fd, &magic, 4, tmo);
-	if (rv < 0 || magic != start_magic)
+	if (rv < 0)
+		return -1;
+
+	if (magic == start_magic)
+		msg_type = 0;
+	else if (magic == start_magic_cmd)
+		msg_type = 1;
+	else
 		return -1;
 	rv = recv_buf(fd, &len, 4, tmo);
 	if (rv < 0 || len > MSG_MAX_LEN)
@@ -122,7 +151,7 @@ int receive_message(int fd, struct metadata_update *msg, int tmo)
 		return -1;
 	}
 	msg->len = len;
-	return 0;
+	return msg_type;
 }
 
 int ack(int fd, int tmo)
diff --git a/msg.h b/msg.h
index 1f916de..046f7c4 100644
--- a/msg.h
+++ b/msg.h
@@ -20,9 +20,11 @@
 
 struct mdinfo;
 struct metadata_update;
+struct mdmon_update;
 
 extern int receive_message(int fd, struct metadata_update *msg, int tmo);
 extern int send_message(int fd, struct metadata_update *msg, int tmo);
+extern int send_message_cmd(int fd, struct mdmon_update *update, int tmo);
 extern int ack(int fd, int tmo);
 extern int wait_reply(int fd, int tmo);
 extern int connect_monitor(char *devname);
diff --git a/util.c b/util.c
index 396f6d8..ea9b148 100644
--- a/util.c
+++ b/util.c
@@ -1840,6 +1840,31 @@ int flush_metadata_updates(struct supertype *st)
 	return 0;
 }
 
+int send_mdmon_cmd(struct supertype *st, struct mdmon_update *update)
+{
+	int sfd;
+	char *devname;
+
+	devname = devnum2devname(st->container_dev);
+	if (devname == NULL)
+		return -1;
+	sfd = connect_monitor(devname);
+	if (sfd < 0) {
+		free(devname);
+		return -1;
+	}
+
+	send_message_cmd(sfd, update, 0);
+	wait_reply(sfd, 0);
+
+	ack(sfd, 0);
+	wait_reply(sfd, 0);
+	close(sfd);
+	st->update_tail = NULL;
+	free(devname);
+	return 0;
+}
+
 void append_metadata_update(struct supertype *st, void *buf, int len)
 {
 

