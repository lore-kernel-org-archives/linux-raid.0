From: Jes.Sorensen@redhat.com
Subject: [PATCH 3/4] Add --initrd argument to mdmon
Date: Tue, 17 Jan 2012 11:48:49 +0100
Message-ID: <1326797330-4488-4-git-send-email-Jes.Sorensen@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdmon.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index a65c4a4..139bd85 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -276,6 +276,12 @@ void usage(void)
 	exit(2);
 }
 
+/*
+ * Option values that don't have a short version, to avoid clashing\
+ * with ascii values
+ */
+#define INITRD_OPT	0x100
+
 static int mdmon(char *devname, int devnum, int must_fork, int takeover);
 
 int main(int argc, char *argv[])
@@ -283,6 +289,7 @@ int main(int argc, char *argv[])
 	char *container_name = NULL;
 	int devnum;
 	char *devname;
+	char *c;
 	int status = 0;
 	int opt;
 	int all = 0;
@@ -291,6 +298,7 @@ int main(int argc, char *argv[])
 		{"all", 0, NULL, 'a'},
 		{"takeover", 0, NULL, 't'},
 		{"help", 0, NULL, 'h'},
+		{"initrd", 0, NULL, INITRD_OPT},
 		{NULL, 0, NULL, 0}
 	};
 
@@ -304,6 +312,11 @@ int main(int argc, char *argv[])
 			container_name = optarg;
 			takeover = 1;
 			break;
+		case INITRD_OPT:
+			c = argv[0];
+			c[0] = '@';
+			continue;
+			
 		case 'h':
 		default:
 			usage();
-- 
1.7.8.3

