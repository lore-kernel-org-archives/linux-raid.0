From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH V2 2/2] Add casts for the addr arg of connect and bind
Date: Wed, 13 Jan 2016 22:32:39 -0800
Message-ID: <1452753159-1527-2-git-send-email-raj.khem@gmail.com>
References: <1452753159-1527-1-git-send-email-raj.khem@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1452753159-1527-1-git-send-email-raj.khem@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>
List-Id: linux-raid.ids

glibc allows the addr arg to connect and socket to be any of a number
of 'sockaddr_*' types, but musl requires 'const struct sockaddr *'
which is in line with open group specs.  So add casts to allow
compilation with musl.

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
Changes since v1:
- Improve the commit meesage
- Divide into separate commit

 mdmon.c | 2 +-
 msg.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index ee12b7c..e4b73d9 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -235,7 +235,7 @@ static int make_control_sock(char *devname)
 	addr.sun_family = PF_LOCAL;
 	strcpy(addr.sun_path, path);
 	umask(077); /* ensure no world write access */
-	if (bind(sfd, &addr, sizeof(addr)) < 0) {
+	if (bind(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
 		close(sfd);
 		return -1;
 	}
diff --git a/msg.c b/msg.c
index 754630b..45cd450 100644
--- a/msg.c
+++ b/msg.c
@@ -170,7 +170,7 @@ int connect_monitor(char *devname)
 
 	addr.sun_family = PF_LOCAL;
 	strcpy(addr.sun_path, path);
-	if (connect(sfd, &addr, sizeof(addr)) < 0) {
+	if (connect(sfd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
 		close(sfd);
 		return -1;
 	}
-- 
2.7.0

