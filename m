From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Re[2]: Bugreport mdadm-2.0-devel-1
Date: Fri, 15 Jul 2005 11:54:25 +1000
Message-ID: <17111.5969.741703.944406@cse.unsw.edu.au>
References: <1684363827.20050706121331@netvision.net.il>
	<17100.29413.164442.415932@cse.unsw.edu.au>
	<1892534227.20050707043013@netvision.net.il>
	<17103.10618.547298.274604@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Saturday July 9
Sender: linux-raid-owner@vger.kernel.org
To: Maxim Kozover <maximkoz@netvision.net.il>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 9, neilb@cse.unsw.edu.au wrote:
> On Thursday July 7, maximkoz@netvision.net.il wrote:
> > Hi Neil!
> > Thanks much for your help, array creation using devel-2 just works,
> > however, the array can't be assembled again after it's stopped:(
> 
> Hmm, yeh, nor it can :-(
> 
> I'm not sure when I'll have time to look at this (I'm on leave at the
> moment with family visiting and such) but I'll definitely get back to
> you by Thursday if not before.

Sorry for the delay.

The following patch against -devel2 should fix these problems if
(when?) you get more, please let me know.

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
 
