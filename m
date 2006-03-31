From: Paul Clements <paul.clements@steeleye.com>
Subject: [PATCH] mdadm: monitor event argument passing
Date: Fri, 31 Mar 2006 13:43:48 -0500
Message-ID: <442D7864.9020901@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030707050006000101050000"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030707050006000101050000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


I've been looking at the mdadm monitor, and thought it might be useful 
if it allowed extra context information (in the form of command line 
arguments) to be sent to the event program, so instead of just:

# mdadm -F /dev/md0 -p "md_event"

you could do something like:

# mdadm -F /dev/md0 -p "md_event -i <some_info>"

And the "-i <some_info>" will be passed on the command line to the event 
program. Of course you can usually figure out what the extra context 
should be in the event program itself, but it may take more work.

Here's a short patch (against mdadm 2.4) that does this.

Thanks,
Paul

--------------030707050006000101050000
Content-Type: text/plain;
 name="mdadm-2.4-event-args.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mdadm-2.4-event-args.diff"


Signed-Off-By: Paul Clements <paul.clements@steeleye.com>

 Monitor.c |   23 ++++++++++++++++++++++-
 1 files changed, 22 insertions(+), 1 deletion(-)
--- mdadm-2.4/Monitor.c	2006-03-28 17:59:42.000000000 -0500
+++ mdadm-2.4-event-args/Monitor.c	2006-03-31 13:19:40.000000000 -0500
@@ -464,6 +464,27 @@ static void alert(char *event, char *dev
 		  int dosyslog)
 {
 	int priority;
+	int cnt = 0;
+	char path[PATH_MAX];
+	char *space, *ptr;
+	char *args[256];
+
+	if (cmd) {
+		strcpy(path, cmd);
+		ptr = path;
+		do {
+			space = strchr(ptr, ' ');
+			if (!space)
+				break;
+			args[cnt++] = ptr;
+			*space = 0;
+			ptr = space+1;
+		} while (1);
+		args[cnt++] = ptr;
+		args[cnt++] = event;
+		args[cnt++] = dev;
+		args[cnt++] = disc;
+	}
 
 	if (!cmd && !mailaddr) {
 		time_t now = time(0);
@@ -479,7 +500,7 @@ static void alert(char *event, char *dev
 		case -1:
 			break;
 		case 0:
-			execl(cmd, cmd, event, dev, disc, NULL);
+			execv(path, args); //execl(cmd,  cmd, event, dev, disc, NULL);
 			exit(2);
 		}
 	}

--------------030707050006000101050000--
