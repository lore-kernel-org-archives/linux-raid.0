From: Jes.Sorensen@redhat.com
Subject: [PATCH 1/4] mdmon: Use getopt_long() to parse command line options
Date: Tue, 17 Jan 2012 11:48:47 +0100
Message-ID: <1326797330-4488-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This changes mdmon over to use getopt_long() for option parsing,
making it easier to add new options. In addition this patch introduces
a short version -t for --takeover and adds -h/--help.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 mdmon.c |   51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index b6ae0e6..a65c4a4 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -265,7 +265,14 @@ static int do_fork(void)
 
 void usage(void)
 {
-	fprintf(stderr, "Usage: mdmon [--all] [--takeover] CONTAINER\n");
+	fprintf(stderr,
+"Usage: mdmon [options] CONTAINER\n"
+"\n"
+"Options are:\n"
+"  --help        -h   : This message\n"
+"  --all              : All devices\n"
+"  --takeover    -t   : Takeover container\n"
+);
 	exit(2);
 }
 
@@ -277,25 +284,47 @@ int main(int argc, char *argv[])
 	int devnum;
 	char *devname;
 	int status = 0;
-	int arg;
+	int opt;
 	int all = 0;
 	int takeover = 0;
-
-	for (arg = 1; arg < argc; arg++) {
-		if (strncmp(argv[arg], "--all",5) == 0 ||
-		    strcmp(argv[arg], "/proc/mdstat") == 0) {
-			container_name = argv[arg];
+	static struct option options[] = {
+		{"all", 0, NULL, 'a'},
+		{"takeover", 0, NULL, 't'},
+		{"help", 0, NULL, 'h'},
+		{NULL, 0, NULL, 0}
+	};
+
+	while ((opt = getopt_long(argc, argv, "th", options, NULL)) != -1) {
+		switch (opt) {
+		case 'a':
+			container_name = argv[optind-1];
 			all = 1;
-		} else if (strcmp(argv[arg], "--takeover") == 0)
+			break;
+		case 't':
+			container_name = optarg;
 			takeover = 1;
-		else if (container_name == NULL)
-			container_name = argv[arg];
-		else
+			break;
+		case 'h':
+		default:
 			usage();
+			break;
+		}
 	}
+
+	if (all == 0 && container_name == NULL) {
+		if (argv[optind])
+			container_name = argv[optind];
+	}
+
 	if (container_name == NULL)
 		usage();
 
+	if (argc - optind > 1)
+		usage();
+
+	if (strcmp(container_name, "/proc/mdstat") == 0)
+		all = 1;
+
 	if (all) {
 		struct mdstat_ent *mdstat, *e;
 		int container_len = strlen(container_name);
-- 
1.7.8.3

