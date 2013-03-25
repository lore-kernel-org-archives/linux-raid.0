From: mwilck@arcor.de
Subject: [PATCH 5/8] monitor: don't call pselect() on deleted sysfs files
Date: Mon, 25 Mar 2013 23:11:24 +0000 (UTC)
Message-ID: <1382695659-6231-6-git-send-email-mwilck@arcor.de>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:36 +0200
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

It makes no sense to listen for events on files that have
been deleted. This happens when arrays are stopped and the
kernel removes the associated sysfs structures.

Calling pselect() on the deleted attributes may cause a storm
of wake events.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 monitor.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/monitor.c b/monitor.c
index e034a6a..3cb4214 100644
--- a/monitor.c
+++ b/monitor.c
@@ -38,8 +38,17 @@ static int write_attr(char *attr, int fd)
 
 static void add_fd(fd_set *fds, int *maxfd, int fd)
 {
+	struct stat st;
 	if (fd < 0)
 		return;
+	if (fstat(fd, &st) == -1) {
+		dprintf("%s: Invalid fd %d\n", __func__, fd);
+		return;
+	}
+	if (st.st_nlink == 0) {
+		dprintf("%s: fd %d was deleted\n", __func__, fd);
+		return;
+	}
 	if (fd > *maxfd)
 		*maxfd = fd;
 	FD_SET(fd, fds);
-- 
1.7.1
