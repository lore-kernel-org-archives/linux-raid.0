From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Raid5 Failure
Date: Fri, 15 Jul 2005 11:43:09 +1000
Message-ID: <17111.5293.613636.774198@cse.unsw.edu.au>
References: <001401c588d5$b0b15370$c200a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David M. Strang on Thursday July 14
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 14, dstrang@shellpower.net wrote:
> 
> It looks like the first 'segment of discs' sda->sdm are all marked clean; 
> while sdn->sdab are marked active.
> 
> What can I do to resolve this issue? Any assistance would be greatly 
> appreciated.


Apply the following patch to mdadm-2.0-devel2 (it fixes a few bugs and
particularly make --assemble work) then try:

mdadm -A /dev/md0 /dev/sd[a-z] /dev/sd....

Just list all 28 SCSI devices, I'm not sure what their names are.

This will quite probably fail.
If it does, try again with 
   --force

NeilBrown



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./Assemble.c |   13 ++++++++++++-
 ./Query.c    |   33 +++++++++++++++++++--------------
 ./mdadm.h    |    2 +-
 ./super0.c   |    1 +
 ./super1.c   |    4 ++--
 5 files changed, 35 insertions(+), 18 deletions(-)

diff ./Assemble.c~current~ ./Assemble.c
--- ./Assemble.c~current~	2005-07-15 10:13:04.000000000 +1000
+++ ./Assemble.c	2005-07-15 10:37:59.000000000 +1000
@@ -473,6 +473,7 @@ int Assemble(struct supertype *st, char 
 		if (!devices[j].uptodate)
 			continue;
 		info.disk.number = i;
+		info.disk.raid_disk = i;
 		info.disk.state = desired_state;
 
 		if (devices[j].uptodate &&
@@ -526,7 +527,17 @@ int Assemble(struct supertype *st, char 
 
 	/* Almost ready to actually *do* something */
 	if (!old_linux) {
-		if (ioctl(mdfd, SET_ARRAY_INFO, NULL) != 0) {
+		int rv;
+		if ((vers % 100) >= 1) { /* can use different versions */
+			mdu_array_info_t inf;
+			memset(&inf, 0, sizeof(inf));
+			inf.major_version = st->ss->major;
+			inf.minor_version = st->minor_version;
+			rv = ioctl(mdfd, SET_ARRAY_INFO, &inf);
+		} else 
+			rv = ioctl(mdfd, SET_ARRAY_INFO, NULL);
+
+		if (rv) {
 			fprintf(stderr, Name ": SET_ARRAY_INFO failed for %s: %s\n",
 				mddev, strerror(errno));
 			return 1;

diff ./Query.c~current~ ./Query.c
--- ./Query.c~current~	2005-07-07 09:19:53.000000000 +1000
+++ ./Query.c	2005-07-15 11:38:18.000000000 +1000
@@ -105,26 +105,31 @@ int Query(char *dev)
 	if (superror == 0) {
 		/* array might be active... */
 		st->ss->getinfo_super(&info, super);
-		mddev = get_md_name(info.array.md_minor);
-		disc.number = info.disk.number;
-		activity = "undetected";
-		if (mddev && (fd = open(mddev, O_RDONLY))>=0) {
-			if (md_get_version(fd) >= 9000 &&	
-			    ioctl(fd, GET_ARRAY_INFO, &array)>= 0) {
-				if (ioctl(fd, GET_DISK_INFO, &disc) >= 0 &&
-				    makedev((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
-					activity = "active";
-				else
-					activity = "mismatch";
+		if (st->ss->major == 0) {
+			mddev = get_md_name(info.array.md_minor);
+			disc.number = info.disk.number;
+			activity = "undetected";
+			if (mddev && (fd = open(mddev, O_RDONLY))>=0) {
+				if (md_get_version(fd) >= 9000 &&	
+				    ioctl(fd, GET_ARRAY_INFO, &array)>= 0) {
+					if (ioctl(fd, GET_DISK_INFO, &disc) >= 0 &&
+					    makedev((unsigned)disc.major,(unsigned)disc.minor) == stb.st_rdev)
+						activity = "active";
+					else
+						activity = "mismatch";
+				}
+				close(fd);
 			}
-			close(fd);
+		} else {
+			activity = "unknown";
+			mddev = "array";
 		}
-		printf("%s: device %d in %d device %s %s md%d.  Use mdadm --examine for more detail.\n",
+		printf("%s: device %d in %d device %s %s %s.  Use mdadm --examine for more detail.\n",
 		       dev, 
 		       info.disk.number, info.array.raid_disks,
 		       activity,
 		       map_num(pers, info.array.level),
-		       info.array.md_minor);
+		       mddev);
 	}
 	return 0;
 }

diff ./mdadm.h~current~ ./mdadm.h
--- ./mdadm.h~current~	2005-07-07 09:19:53.000000000 +1000
+++ ./mdadm.h	2005-07-15 10:15:51.000000000 +1000
@@ -73,7 +73,7 @@ struct mdinfo {
 	mdu_array_info_t	array;
 	mdu_disk_info_t		disk;
 	__u64			events;
-	unsigned int		uuid[4];
+	int			uuid[4];
 };
 
 #define Name "mdadm"

diff ./super0.c~current~ ./super0.c
--- ./super0.c~current~	2005-07-07 09:19:53.000000000 +1000
+++ ./super0.c	2005-07-15 11:27:12.000000000 +1000
@@ -205,6 +205,7 @@ static void getinfo_super0(struct mdinfo
 	info->disk.major = sb->this_disk.major;
 	info->disk.minor = sb->this_disk.minor;
 	info->disk.raid_disk = sb->this_disk.raid_disk;
+	info->disk.number = sb->this_disk.number;
 
 	info->events = md_event(sb);
 

diff ./super1.c~current~ ./super1.c
--- ./super1.c~current~	2005-07-07 09:19:53.000000000 +1000
+++ ./super1.c	2005-07-15 11:25:04.000000000 +1000
@@ -278,7 +278,7 @@ static void getinfo_super1(struct mdinfo
 
 	info->disk.major = 0;
 	info->disk.minor = 0;
-
+	info->disk.number = __le32_to_cpu(sb->dev_number);
 	if (__le32_to_cpu(sb->dev_number) >= __le32_to_cpu(sb->max_dev) ||
 	    __le32_to_cpu(sb->max_dev) > 512)
 		role = 0xfffe;
@@ -303,7 +303,7 @@ static void getinfo_super1(struct mdinfo
 
 	for (i=0; i< __le32_to_cpu(sb->max_dev); i++) {
 		role = __le16_to_cpu(sb->dev_roles[i]);
-		if (role == 0xFFFF || role < info->array.raid_disks)
+		if (/*role == 0xFFFF || */role < info->array.raid_disks)
 			working++;
 	}
 
