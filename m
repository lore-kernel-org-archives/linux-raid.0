From: Neil Brown <neilb@suse.de>
Subject: Re: Spare fails to transfer between RAID groups
Date: Tue, 12 May 2009 09:30:21 +1000
Message-ID: <18952.46349.611683.608352@notabene.brown>
References: <001901c9d202$709acad0$51d06070$@us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Garth Snyder on Sunday May 10
Sender: linux-raid-owner@vger.kernel.org
To: garth@grsweb.us
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 10, garth@grsweb.us wrote:
> Hi raiders --
> 
> I'm having a problem getting a spare partition moved to the right RAID group
> after a failure. I see some past discussion of issues related to spare
> groups in the list archive, but no exact fit for the behavior I'm seeing.
> Here's the outline:
> 
> 1) Two RAID arrays (/dev/md_d0 and /dev/md_d3) are assigned to one
> spare-group in /etc/mdadm/mdadm.conf. The spare partition is initially
> assigned to /dev/md_d0.
> 
...
> 6) Two error messages are submitted via syslog to /var/log/kern.log in quick
> succession, both with the same message: "HOT_ADD may only be used with
> version-0 superblocks". The first message is tagged "md_d3" and the second
> "md_d0".
> 
....
> 
> All superblocks involved are version 1.2. This is a new setup, and every
> mdadm --create command has included --metadata=1.2. There should be no
> legacy or old RAID superblocks around.
> 

This would be because no one has tried the spare-group feature with
1.x metadata yet.  You are the first (or the first to report when it
failed at least).

The following patch should make it work for you.  This patch is against
2.6.9, though it should apply to any reasonably recent 2.x mdadm.
(it won't apply to 3.0).

Please let me know if it works for you.

Thanks for the report,
NeilBrown

diff --git a/Manage.c b/Manage.c
index 33a0bc7..fa4bb60 100644
--- a/Manage.c
+++ b/Manage.c
@@ -292,11 +292,15 @@ int Manage_subdevs(char *devname, int fd,
 		} else {
 			j = 0;
 
-			if (stat(dv->devname, &stb)) {
+			tfd = dev_open(dv->devname, O_RDONLY);
+			if (tfd < 0 || fstat(tfd, &stb) != 0) {
 				fprintf(stderr, Name ": cannot find %s: %s\n",
 					dv->devname, strerror(errno));
+				if (tfd >= 0)
+					close(tfd);
 				return 1;
 			}
+			close(tfd);
 			if ((stb.st_mode & S_IFMT) != S_IFBLK) {
 				fprintf(stderr, Name ": %s is not a "
 					"block device.\n",
@@ -313,7 +317,7 @@ int Manage_subdevs(char *devname, int fd,
 			/* add the device */
 
 			/* Make sure it isn't in use (in 2.6 or later) */
-			tfd = open(dv->devname, O_RDONLY|O_EXCL);
+			tfd = dev_open(dv->devname, O_RDONLY|O_EXCL);
 			if (tfd < 0) {
 				fprintf(stderr, Name ": Cannot open %s: %s\n",
 					dv->devname, strerror(errno));
diff --git a/Monitor.c b/Monitor.c
index 3825600..e0a9d2a 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -470,16 +470,25 @@ int Monitor(mddev_dev_t devlist,
 							}
 						}
 						if (dev > 0) {
-							if (ioctl(fd2, HOT_REMOVE_DISK,
-								  (unsigned long)dev) == 0) {
-								if (ioctl(fd1, HOT_ADD_DISK,
-									  (unsigned long)dev) == 0) {
+							struct mddev_dev_s devlist;
+							char devname[20];
+							devlist.next = NULL;
+							devlist.used = 0;
+							devlist.re_add = 0;
+							devlist.writemostly = 0;
+							devlist.devname = devname;
+							sprintf(devname, "%d:%d", major(dev), minor(dev));
+
+							devlist.disposition = 'r';
+							if (Manage_subdevs(st2->devname, fd2, &devlist, -1) == 0) {
+								devlist.disposition = 'a';
+								if (Manage_subdevs(st->devname, fd1, &devlist, -1) == 0) {
 									alert("MoveSpare", st->devname, st2->devname, mailaddr, mailfrom, alert_cmd, dosyslog);
 									close(fd1);
 									close(fd2);
 									break;
 								}
-								else ioctl(fd2, HOT_ADD_DISK, (unsigned long) dev);
+								else Manage_subdevs(st2->devname, fd2, &devlist, -1);
 							}
 						}
 						close(fd1);
diff --git a/super0.c b/super0.c
index 90fdf23..ebba534 100644
--- a/super0.c
+++ b/super0.c
@@ -672,7 +672,7 @@ static int write_init_super0(struct supertype *st,
 			     mdu_disk_info_t *dinfo, char *devname)
 {
 	mdp_super_t *sb = st->sb;
-	int fd = open(devname, O_RDWR|O_EXCL);
+	int fd = dev_open(devname, O_RDWR|O_EXCL);
 	int rv;
 
 	if (fd < 0) {
diff --git a/super1.c b/super1.c
index 037c5eb..b86a28b 100644
--- a/super1.c
+++ b/super1.c
@@ -887,7 +887,7 @@ static int write_init_super1(struct supertype *st,
 {
 	struct mdp_superblock_1 *sb = st->sb;
 	struct supertype refst;
-	int fd = open(devname, O_RDWR | O_EXCL);
+	int fd = dev_open(devname, O_RDWR | O_EXCL);
 	int rfd;
 	int rv;
 	int bm_space;
