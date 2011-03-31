From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: [PATCH] RAID-6 check standalone md device
Date: Thu, 31 Mar 2011 20:53:46 +0200
Message-ID: <20110331185346.GA5210@lazy.lzy>
References: <20110221204551.GA15675@lazy.lzy>
 <20110321140244.2314b4b4@notabene.brown>
 <20110321104007.GA15379@lazy.lzy>
 <20110321220457.29d52f5c@notabene.brown>
 <20110321115440.GA15635@lazy.lzy>
 <20110322095905.737fb1d5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110322095905.737fb1d5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

please find below the promised patch for the
RAID-6 check, which allows to pass only the
MD device, start and length.
The three parameters are mandatory.

All necessary information is collected using
the "sysfs_read()" call.
Furthermore, if "length" is "0", then the check
is performed until the end of the array.

The "Makefile" needed modifications too (as done
previously) in order to link "sysfs.c".

Some checks are done, for example if the md device
is really a RAID-6. Nevertheless I guess it is not
bullet proof...

Next patch will include the "suspend" action.
My idea is to do it "per stripe", please let me
know if you've some better options.

bye,

pg

--- cut here ---

diff -uNr a/Makefile b/Makefile
--- a/Makefile	2011-03-24 04:21:58.000000000 +0100
+++ b/Makefile	2011-03-29 21:43:33.495939342 +0200
@@ -98,7 +98,7 @@
 MAN5DIR = $(MANDIR)/man5
 MAN8DIR = $(MANDIR)/man8
 
-OBJS =  mdadm.o config.o policy.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o \
+OBJSX = config.o policy.o mdstat.o  ReadMe.o util.o Manage.o Assemble.o Build.o \
 	Create.o Detail.o Examine.o Grow.o Monitor.o dlink.o Kill.o Query.o \
 	Incremental.o \
 	mdopen.o super0.o super1.o super-ddf.o super-intel.o bitmap.o \
@@ -106,7 +106,7 @@
 	restripe.o sysfs.o sha1.o mapfile.o crc32.o sg_io.o msg.o \
 	platform-intel.o probe_roms.o
 
-OBJSX = restripe.o
+OBJS = mdadm.o $(OBJSX)
 
 SRCS =  mdadm.c config.c policy.c mdstat.c  ReadMe.c util.c Manage.c Assemble.c Build.c \
 	Create.c Detail.c Examine.c Grow.c Monitor.c dlink.c Kill.c Query.c \
diff -uNr a/raid6check.c b/raid6check.c
--- a/raid6check.c	2011-03-24 04:21:58.000000000 +0100
+++ b/raid6check.c	2011-03-31 20:44:45.820258613 +0200
@@ -159,7 +159,7 @@
 				       level, layout);
 		}
 		if(disk >= 0) {
-			printf("Possible failed disk: %d --> %s\n", disk, name[disk]);
+			printf("Possible failed disk slot: %d --> %s\n", disk, name[disk]);
 		}
 		if(disk == -65535) {
 			printf("Failure detected, but disk unknown\n");
@@ -192,71 +192,121 @@
 
 int main(int argc, char *argv[])
 {
-	/* raid_disks chunk_size layout start length devices...
-	 */
+	/* md_device start length */
 	int *fds;
 	char *buf;
+	char **disk_name;
 	unsigned long long *offsets;
 	int raid_disks, chunk_size, layout;
 	int level = 6;
 	unsigned long long start, length;
 	int i;
+	int mdfd;
+	struct mdinfo *info, *comp;
+        char *err = NULL;
+	const char prg[] = "raid6check";
+
+        if (argc < 3) {
+                fprintf(stderr, "Usage: %s md_device start length\n", prg);
+                exit(1);
+        }
+
+	mdfd = open(argv[1], O_RDONLY);
+	if(mdfd < 0) {
+		perror(argv[1]);
+		fprintf(stderr,"%s: cannot open %s\n", prg, argv[1]);
+		exit(4);
+	}
+
+	info  = sysfs_read(mdfd, -1,
+		GET_LEVEL|
+		GET_LAYOUT|
+		GET_DISKS|
+		GET_COMPONENT|
+		GET_CHUNK|
+		GET_DEVS|
+		GET_OFFSET|
+		GET_SIZE);
+
+	if(info->array.level != level) {
+		fprintf(stderr, "%s: %s not a RAID-6\n", prg, argv[1]);
+		exit(5);
+	}
+
+	printf("layout: %d\n", info->array.layout);
+	printf("disks: %d\n", info->array.raid_disks);
+	printf("component size: %llu\n", info->component_size*512);
+	printf("chunk size: %d\n", info->array.chunk_size);
+	printf("\n");
+
+	comp = info->devs;
+	for(i = 0; i < info->array.raid_disks; i++) {
+		printf("disk: %d - offset: %llu - size: %llu - name: %s - slot: %d\n",
+			i, comp->data_offset, comp->component_size*512,
+			map_dev(comp->disk.major, comp->disk.minor, 0),
+			comp->disk.raid_disk);
+
+		comp = comp->next;
+	}
+	printf("\n");
+
+	close(mdfd);
+
+	raid_disks = info->array.raid_disks;
+	chunk_size = info->array.chunk_size;
+	layout = info->array.layout;
+	start = getnum(argv[2], &err);
+	length = getnum(argv[3], &err);
 
-	char *err = NULL;
-	if (argc < 8) {
-		fprintf(stderr, "Usage: raid6check raid_disks"
-			" chunk_size layout start length devices...\n");
-		exit(1);
-	}
-
-	raid_disks = getnum(argv[1], &err);
-	chunk_size = getnum(argv[2], &err);
-	layout = getnum(argv[3], &err);
-	start = getnum(argv[4], &err);
-	length = getnum(argv[5], &err);
 	if (err) {
-		fprintf(stderr, "test_stripe: Bad number: %s\n", err);
+		fprintf(stderr, "%s: Bad number: %s\n", prg, err);
 		exit(2);
 	}
-	if (argc != raid_disks + 6) {
-		fprintf(stderr, "test_stripe: wrong number of devices: want %d found %d\n",
-			raid_disks, argc-6);
-		exit(2);
+
+	start = (start / chunk_size) * chunk_size;
+
+	if(length == 0) {
+		length = info->component_size * 512 - start;
 	}
+
+	disk_name = malloc(raid_disks * sizeof(*disk_name));
 	fds = malloc(raid_disks * sizeof(*fds));
 	offsets = malloc(raid_disks * sizeof(*offsets));
 	memset(offsets, 0, raid_disks * sizeof(*offsets));
 
+	comp = info->devs;
 	for (i=0; i<raid_disks; i++) {
-		char *p;
-		p = strchr(argv[6+i], ':');
-
-		if(p != NULL) {
-			*p++ = '\0';
-			offsets[i] = atoll(p) * 512;
-		}
-		fds[i] = open(argv[6+i], O_RDWR);
-		if (fds[i] < 0) {
-			perror(argv[6+i]);
-			fprintf(stderr,"test_stripe: cannot open %s.\n", argv[6+i]);
+		int disk_slot = comp->disk.raid_disk;
+		disk_name[disk_slot] = map_dev(comp->disk.major, comp->disk.minor, 0);
+		offsets[disk_slot] = comp->data_offset * 512;
+		fds[disk_slot] = open(disk_name[disk_slot], O_RDWR);
+		if (fds[disk_slot] < 0) {
+			perror(disk_name[disk_slot]);
+			fprintf(stderr,"%s: cannot open %s\n", prg, disk_name[disk_slot]);
 			exit(3);
 		}
+
+		comp = comp->next;
 	}
 
 	buf = malloc(raid_disks * chunk_size);
 
 	int rv = check_stripes(fds, offsets,
 			       raid_disks, chunk_size, level, layout,
-			       start, length, &argv[6]);
+			       start, length, disk_name);
 	if (rv != 0) {
 		fprintf(stderr,
-			"test_stripe: test_stripes returned %d\n", rv);
+			"%s: check_stripes returned %d\n", prg, rv);
 		exit(1);
 	}
 
+	free(disk_name);
 	free(fds);
 	free(offsets);
 	free(buf);
 
+	for(i=0; i<raid_disks; i++)
+		close(fds[i]);
+
 	exit(0);
 }

--- cut here ---

-- 

piergiorgio
