From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: [mdadm PATCH 2/2] Fix unterminated buffer after readlink() call
Date: Thu, 13 Oct 2011 11:22:13 +0200
Message-ID: <201110131122.14099.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
---
 mdopen.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index 0a17421..555ab84 100644
--- a/mdopen.c
+++ b/mdopen.c
@@ -360,8 +360,12 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
 
 			if (lstat(chosen, &stb) == 0) {
 				char buf[300];
+				ssize_t link_len = readlink(chosen, buf, sizeof(buf)-1);
+				if (link_len >= 0)
+					buf[link_len] = '\0';
+
 				if ((stb.st_mode & S_IFMT) != S_IFLNK ||
-				    readlink(chosen, buf, 300) <0 ||
+				    link_len < 0 ||
 				    strcmp(buf, devname) != 0) {
 					fprintf(stderr, Name ": %s exists - ignoring\n",
 						chosen);
-- 
1.7.4.4
