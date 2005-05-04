From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: BUGREPORT: mdadm v2.0-devel - can't create array using version
 1 superblock, possibly related to previous bugreport
Date: Wed, 4 May 2005 16:00:18 +1000
Message-ID: <17016.25842.935661.129458@cse.unsw.edu.au>
References: <42775D47.4000805@dtbb.net>
	<17016.3902.917012.297224@cse.unsw.edu.au>
	<4278271B.1020408@dtbb.net>
	<17016.12489.9021.728737@cse.unsw.edu.au>
	<427858EB.4070501@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Tuesday May 3
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


You might find this useful too....

---
Increase max-devs on type-1 superblocks


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./Detail.c |    7 +++++--
 ./Grow.c   |    2 +-
 ./mdadm.c  |    6 ++++--
 ./mdadm.h  |    1 +
 ./super0.c |    2 ++
 ./super1.c |    4 +++-
 6 files changed, 16 insertions(+), 6 deletions(-)

diff ./Detail.c~current~ ./Detail.c
--- ./Detail.c~current~	2005-05-04 09:44:37.000000000 +1000
+++ ./Detail.c	2005-05-04 10:05:54.000000000 +1000
@@ -51,6 +51,7 @@ int Detail(char *dev, int brief, int tes
 	int is_rebuilding = 0;
 	int failed = 0;
 	struct supertype *st = NULL;
+	int max_disks = MD_SB_DISKS;
 
 	void *super = NULL;
 	int rv = test ? 4 : 1;
@@ -89,8 +90,10 @@ int Detail(char *dev, int brief, int tes
 		stb.st_rdev = 0;
 	rv = 0;
 
+	if (st) max_disks = st->max_devs;
+
 	/* try to load a superblock */
-	for (d= 0; d<MD_SB_DISKS; d++) {
+	for (d= 0; d<max_disks; d++) {
 		mdu_disk_info_t disk;
 		char *dv;
 		disk.number = d;
@@ -210,7 +213,7 @@ int Detail(char *dev, int brief, int tes
 
 		printf("    Number   Major   Minor   RaidDevice State\n");
 	}
-	for (d= 0; d<MD_SB_DISKS; d++) {
+	for (d= 0; d < max_disks; d++) {
 		mdu_disk_info_t disk;
 		char *dv;
 		disk.number = d;

diff ./Grow.c~current~ ./Grow.c
--- ./Grow.c~current~	2005-05-04 09:46:34.000000000 +1000
+++ ./Grow.c	2005-05-04 10:06:32.000000000 +1000
@@ -236,7 +236,7 @@ int Grow_addbitmap(char *devname, int fd
 	}
 	if (strcmp(file, "internal") == 0) {
 		int d;
-		for (d=0; d< MD_SB_DISKS; d++) {
+		for (d=0; d< st->max_devs; d++) {
 			mdu_disk_info_t disk;
 			char *dv;
 			disk.number = d;

diff ./mdadm.c~current~ ./mdadm.c
--- ./mdadm.c~current~	2005-05-04 09:46:34.000000000 +1000
+++ ./mdadm.c	2005-05-04 10:03:23.000000000 +1000
@@ -50,6 +50,7 @@ int main(int argc, char *argv[])
 	int level = UnSet;
 	int layout = UnSet;
 	int raiddisks = 0;
+	int max_disks = MD_SB_DISKS;
 	int sparedisks = 0;
 	struct mddev_ident_s ident;
 	char *configfile = NULL;
@@ -302,6 +303,7 @@ int main(int argc, char *argv[])
 				fprintf(stderr, Name ": unrecognised metadata identifier: %s\n", optarg);
 				exit(2);
 			}
+			max_disks = ss->max_devs;
 			continue;
 
 		case O(GROW,'z'):
@@ -425,7 +427,7 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 			raiddisks = strtol(optarg, &c, 10);
-			if (!optarg[0] || *c || raiddisks<=0 || raiddisks > MD_SB_DISKS) {
+			if (!optarg[0] || *c || raiddisks<=0 || raiddisks > max_disks) {
 				fprintf(stderr, Name ": invalid number of raid devices: %s\n",
 					optarg);
 				exit(2);
@@ -451,7 +453,7 @@ int main(int argc, char *argv[])
 				exit(2);
 			}
 			sparedisks = strtol(optarg, &c, 10);
-			if (!optarg[0] || *c || sparedisks < 0 || sparedisks > MD_SB_DISKS - raiddisks) {
+			if (!optarg[0] || *c || sparedisks < 0 || sparedisks > max_disks - raiddisks) {
 				fprintf(stderr, Name ": invalid number of spare-devices: %s\n",
 					optarg);
 				exit(2);

diff ./mdadm.h~current~ ./mdadm.h
--- ./mdadm.h~current~	2005-05-04 09:46:34.000000000 +1000
+++ ./mdadm.h	2005-05-04 10:01:20.000000000 +1000
@@ -194,6 +194,7 @@ extern struct superswitch {
 struct supertype {
 	struct superswitch *ss;
 	int minor_version;
+	int max_devs;
 };
 
 extern struct supertype *super_by_version(int vers, int minor);

diff ./super0.c~current~ ./super0.c
--- ./super0.c~current~	2005-05-04 09:46:40.000000000 +1000
+++ ./super0.c	2005-05-04 10:08:47.000000000 +1000
@@ -582,6 +582,7 @@ static int load_super0(struct supertype 
 	if (st->ss == NULL) {
 		st->ss = &super0;
 		st->minor_version = 90;
+		st->max_devs = MD_SB_DISKS;
 	}
 
 	return 0;
@@ -594,6 +595,7 @@ static struct supertype *match_metadata_
 
 	st->ss = &super0;
 	st->minor_version = 90;
+	st->max_devs = MD_SB_DISKS;
 	if (strcmp(arg, "0") == 0 ||
 	    strcmp(arg, "0.90") == 0 ||
 	    strcmp(arg, "default") == 0

diff ./super1.c~current~ ./super1.c
--- ./super1.c~current~	2005-05-04 09:52:34.000000000 +1000
+++ ./super1.c	2005-05-04 12:06:33.000000000 +1000
@@ -399,7 +399,7 @@ static int init_super1(void **sbp, mdu_a
 
 	sb->ctime = __cpu_to_le64((unsigned long long)time(0));
 	sb->level = __cpu_to_le32(info->level);
-	sb->layout = __cpu_to_le32(info->level);
+	sb->layout = __cpu_to_le32(info->layout);
 	sb->size = __cpu_to_le64(info->size*2ULL);
 	sb->chunksize = __cpu_to_le32(info->chunk_size>>9);
 	sb->raid_disks = __cpu_to_le32(info->raid_disks);
@@ -616,6 +616,7 @@ static int load_super1(struct supertype 
 			int rv;
 			st->minor_version = bestvers;
 			st->ss = &super1;
+			st->max_devs = 384;
 			rv = load_super1(st, fd, sbp, devname);
 			if (rv) st->ss = NULL;
 			return rv;
@@ -714,6 +715,7 @@ static struct supertype *match_metadata_
 	if (!st) return st;
 
 	st->ss = &super1;
+	st->max_devs = 384;
 	if (strcmp(arg, "1") == 0 ||
 	    strcmp(arg, "1.0") == 0) {
 		st->minor_version = 0;
