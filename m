From: Jes.Sorensen@redhat.com
Subject: [PATCH 11/11] mdmon(): Error out if failing to connect to victim monitor
Date: Mon, 31 Oct 2011 15:02:39 +0100
Message-ID: <1320069759-13361-12-git-send-email-Jes.Sorensen@redhat.com>
References: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1320069759-13361-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdmon.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index ee68e3c..bdcda0e 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -457,8 +457,14 @@ static int mdmon(char *devname, int devnum, int must_fork, int takeover)
 	sigaction(SIGPIPE, &act, NULL);
 
 	victim = mdmon_pid(container->devnum);
-	if (victim >= 0)
+	if (victim >= 0) {
 		victim_sock = connect_monitor(container->devname);
+		if (victim_sock < 0) {
+			fprintf(stderr, "mdmon: %s unable to connect monitor\n",
+				container->devname);
+			exit(3);
+		}
+	}
 
 	ignore = chdir("/");
 	if (!takeover && victim > 0 && victim_sock >= 0) {
-- 
1.7.6.4

