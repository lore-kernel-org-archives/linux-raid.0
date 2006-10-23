From: Neil Brown <neilb@suse.de>
Subject: Re: patches
Date: Mon, 23 Oct 2006 14:19:47 +1000
Message-ID: <17724.17123.649113.890603@cse.unsw.edu.au>
References: <20061020170016.C183895C422@futec-gmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Labuschke on Friday October 20
Sender: linux-raid-owner@vger.kernel.org
To: Michael Labuschke <michael@labuschke.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks.  I've modified them a bit as below.
They will be in 2.5.5.

NeilBrown


### Diffstat output
 ./mdopen.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff .prev/mdopen.c ./mdopen.c
--- .prev/mdopen.c	2006-10-16 15:26:58.000000000 +1000
+++ ./mdopen.c	2006-10-23 14:18:05.000000000 +1000
@@ -44,7 +44,8 @@ void make_dev_symlink(char *dev)
 		strcpy(new+7, new+8);
 	else
 		new[7] = '_';
-	symlink(dev+5, new);
+	if (symlink(dev+5, new))
+		perror(new);
 }
 
 
@@ -249,8 +250,10 @@ int open_mddev(char *dev, int autof)
 
 			if (strncmp(dev, "/dev/md/", 8) == 0) {
 				if (mkdir("/dev/md",0700)==0) {
-					chown("/dev/md", ci->uid, ci->gid);
-					chmod("/dev/md", ci->mode| ((ci->mode>>2) & 0111));
+					if (chown("/dev/md", ci->uid, ci->gid))
+						perror("chown /dev/md");
+					if (chmod("/dev/md", ci->mode| ((ci->mode>>2) & 0111)))
+						perror("chmod /dev/md");
 				}
 			}
 			if (mknod(dev, S_IFBLK|0600, makedev(major, minor))!= 0) {
