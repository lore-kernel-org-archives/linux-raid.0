From: Luca Berra <bluca@comedia.it>
Subject: [mdadm PATCH 1/2] fix mdmon option parsing
Date: Sat, 27 Feb 2010 16:07:04 +0100
Message-ID: <1-2.1267282753.git.bluca@comedia.it>
References: <cover.1267282753.git.bluca@comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1267282753.git.bluca@comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: "Neil Brown (neilb@suse.de)" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

running mdmon --takeover --all resulted in a segfault.
also hide "--takeover" from ps and update usage message.

Signed-off-by: Luca Berra <bluca@comedia.it>
---
  mdmon.c |   13 +++++++++----
  1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/mdmon.c b/mdmon.c
index 70fbd0b..d593ebc 100644
--- a/mdmon.c
+++ b/mdmon.c
@@ -244,7 +244,7 @@ static int do_fork(void)
  
  void usage(void)
  {
-	fprintf(stderr, "Usage: mdmon /device/name/for/container [target_dir]\n");
+	fprintf(stderr, "Usage: mdmon [--all] [--takeover] CONTAINER");
  	exit(2);
  }
  
@@ -262,15 +262,20 @@ int main(int argc, char *argv[])
  
  	for (arg = 1; arg < argc; arg++) {
  		if (strcmp(argv[arg], "--all") == 0 ||
-		    strcmp(argv[arg], "/proc/mdstat") == 0)
+		    strcmp(argv[arg], "/proc/mdstat") == 0) {
+			container_name = argv[arg];
  			all = 1;
-		else if (strcmp(argv[arg], "--takeover") == 0)
+		} else if (strcmp(argv[arg], "--takeover") == 0) {
+			/* hide the --takeover arg from commandline */
+			memset(argv[arg], 0, strlen(argv[arg]));
  			takeover = 1;
-		else if (container_name == NULL)
+		} else if (container_name == NULL)
  			container_name = argv[arg];
  		else
  			usage();
  	}
+	if (container_name == NULL)
+		usage();
  
  	if (all) {
  		struct mdstat_ent *mdstat, *e;
-- 
1.7.0

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
