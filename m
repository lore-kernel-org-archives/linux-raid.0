From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 30/31] Add mdadm->mdmon sync_max command message
Date: Tue, 9 Nov 2010 17:01:42 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D174A1CAAF@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
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

 mdadm/mdadm/managemon.c |   39 +++++++++++++++++++++++++++++++++++++--
 mdadm/mdadm/mdadm.h     |   18 ++++++++++++++++++
 mdadm/mdadm/mdmon.h     |    3 +++
 mdadm/mdadm/msg.c       |   33 +++++++++++++++++++++++++++++++--
 mdadm/mdadm/msg.h       |    2 ++
 mdadm/mdadm/util.c      |   25 +++++++++++++++++++++++++
 6 files changed, 116 insertions(+), 4 deletions(-)

diff --git a/mdadm/mdadm/managemon.c b/mdadm/mdadm/managemon.c index 608ab4d..34ddc4c 100644
--- a/mdadm/mdadm/managemon.c
+++ b/mdadm/mdadm/managemon.c
@@ -727,13 +727,36 @@ static void handle_message(struct supertype *container, struct metadata_update *
 	}
 }
 
+static void handle_command(struct supertype *container, struct 
+cmd_message *msg) {
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
 void read_sock(struct supertype *container)  {
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
@@ -747,7 +770,9 @@ void read_sock(struct supertype *container)
 		msg.buf = NULL;
 
 		/* read and validate the message */
-		if (receive_message(fd, &msg, tmo) == 0) {
+		rv = receive_message(fd, &msg, tmo);
+		if (rv == 0) {
+			/* metadata update */
 			handle_message(container, &msg);
 			if (msg.len == 0) {
 				/* ping reply with version */
@@ -757,8 +782,18 @@ void read_sock(struct supertype *container)
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
 
diff --git a/mdadm/mdadm/mdadm.h b/mdadm/mdadm/mdadm.h index 4eed084..c19a4f6 100644
--- a/mdadm/mdadm/mdadm.h
+++ b/mdadm/mdadm/mdadm.h
@@ -751,6 +751,23 @@ struct metadata_update {
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
@@ -981,6 +998,7 @@ extern int assemble_container_content(struct supertype *st, int mdfd,  extern int add_disk(int mdfd, struct supertype *st,
 		    struct mdinfo *sra, struct mdinfo *info);  extern int set_array_info(int mdfd, struct supertype *st, struct mdinfo *info);
+extern int send_mdmon_cmd(struct supertype *st, struct mdmon_update 
+*update);
 unsigned long long min_recovery_start(struct mdinfo *array);
 
 extern char *human_size(long long bytes); diff --git a/mdadm/mdadm/mdmon.h b/mdadm/mdadm/mdmon.h index 9cab788..1bc4ee2 100644
--- a/mdadm/mdadm/mdmon.h
+++ b/mdadm/mdadm/mdmon.h
@@ -58,6 +58,9 @@ struct active_array {
 #define RESHAPE_CANCEL_REQUEST	(RESHAPE_IN_PROGRESS-1)
 
 	int reshape_delta_disks;
+	int waiting_resync_max; /* wait for resync_max cmd from mdadm */
+	long long unsigned resync_max;
+	long long unsigned sync_completed;
 
 	int check_degraded; /* flag set by mon, read by manage */
 
diff --git a/mdadm/mdadm/msg.c b/mdadm/mdadm/msg.c index a809c13..a452aef 100644
--- a/mdadm/mdadm/msg.c
+++ b/mdadm/mdadm/msg.c
@@ -32,6 +32,7 @@
 #include "mdmon.h"
 
 static const __u32 start_magic = 0x5a5aa5a5;
+static const __u32 start_magic_cmd = 0x6b6bb6b6;
 static const __u32 end_magic = 0xa5a55a5a;
 
 static int send_buf(int fd, const void* buf, int len, int tmo) @@ -93,14 +94,42 @@ int send_message(int fd, struct metadata_update *msg, int tmo)
 	return rv;
 }
 
+int send_message_cmd(int fd, struct mdmon_update *update, int tmo) {
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
 int receive_message(int fd, struct metadata_update *msg, int tmo)  {
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
diff --git a/mdadm/mdadm/msg.h b/mdadm/mdadm/msg.h index 1f916de..046f7c4 100644
--- a/mdadm/mdadm/msg.h
+++ b/mdadm/mdadm/msg.h
@@ -20,9 +20,11 @@
 
 struct mdinfo;
 struct metadata_update;
+struct mdmon_update;
 
 extern int receive_message(int fd, struct metadata_update *msg, int tmo);  extern int send_message(int fd, struct metadata_update *msg, int tmo);
+extern int send_message_cmd(int fd, struct mdmon_update *update, int 
+tmo);
 extern int ack(int fd, int tmo);
 extern int wait_reply(int fd, int tmo);  extern int connect_monitor(char *devname); diff --git a/mdadm/mdadm/util.c b/mdadm/mdadm/util.c index 412c382..398babb 100644
--- a/mdadm/mdadm/util.c
+++ b/mdadm/mdadm/util.c
@@ -1838,6 +1838,31 @@ int flush_metadata_updates(struct supertype *st)
 	return 0;
 }
 
+int send_mdmon_cmd(struct supertype *st, struct mdmon_update *update) {
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
 void append_metadata_update(struct supertype *st, void *buf, int len)  {
 

