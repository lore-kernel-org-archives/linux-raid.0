From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 21/23] imsm: Run Online Capacity Expansion on container
Date: Wed, 9 Jun 2010 15:43:22 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8FB@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

(Online Capacity Expansion for IMSM)
For IMSM, Online Capacity Expansion has to be run for whole container due to compatibility reasons.
When container is passed during expansion, mdadm searches for first volume in container. For this volume grow operation is started.
When firs volume is reshaped process is run for every next volume that is left in container.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c  |  295 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 mdadm.c |    2 
 mdadm.h |    6 +
 3 files changed, 296 insertions(+), 7 deletions(-)

diff --git a/Grow.c b/Grow.c
index 5e84c2a..5046e56 100644
--- a/Grow.c
+++ b/Grow.c
@@ -35,6 +35,178 @@
 #define offsetof(t,f) ((size_t)&(((t*)0)->f))  #endif
 
+#define GROW_RESHAPE_BUFFER_SIZE	1024
+char *get_first_volume(int fd, int raid_disks, char *retBuf) {
+	char *ret_val = NULL;
+	struct supertype *st = NULL;
+	struct mdinfo *sra = NULL;
+	struct mdinfo info;
+
+	if ((retBuf == NULL) || (fd < 0))
+		goto exit_get_first_volume;
+
+	st = super_by_fd(fd);
+	if (st == NULL)
+		goto exit_get_first_volume;
+
+	if (st->ss->external == 0)
+		goto exit_get_first_volume;
+
+	sra = sysfs_read(fd, 0, GET_VERSION);
+	if (sra == NULL)
+		goto exit_get_first_volume;
+
+	/* check if we have got something
+	 * nad it starts form '/', means points somewhere
+	 */
+	if ((strlen(sra->text_version) > 1) &&
+	    (*(sra->text_version) == '/'))
+		goto exit_get_first_volume;
+	dprintf("Container detected.\n");
+
+	sprintf(st->subarray, "0");
+	st->ss->load_super(st, fd, NULL);
+	if (st->sb == NULL)
+		goto exit_get_first_volume;
+
+	st->ss->getinfo_super(st, &info);
+	snprintf(retBuf, GROW_RESHAPE_BUFFER_SIZE,
+		"/dev/md/%s",  info.name);
+	ret_val = retBuf;
+
+exit_get_first_volume:
+	sysfs_free(sra);
+	if (st)
+		st->ss->free_super(st);
+
+	return ret_val;
+}
+
+char *get_first_device_from_container(char *devname, int fd, int 
+raid_disks, char *first_volume_buf) {
+	char *ret_val = NULL;
+	struct supertype *st = NULL;
+	struct mdinfo *sra = NULL;
+
+	if ((devname == NULL) ||
+	    (fd < 0) ||
+	    (first_volume_buf == NULL))
+		goto exit_get_first_device_from_container;
+
+	st = super_by_fd(fd);
+	if (st == NULL)
+		goto exit_get_first_device_from_container;
+
+	if (st->ss->external == 0) {
+		/* rerurn input, as it has to be array
+		 * if not this is Grow_reshape() problem
+		 */
+		ret_val = devname;
+		goto exit_get_first_device_from_container;
+	}
+
+	sra = sysfs_read(fd, 0, GET_VERSION);
+	if (sra == NULL)
+		goto exit_get_first_device_from_container;
+
+	ret_val = get_first_volume(fd, raid_disks, first_volume_buf);
+
+exit_get_first_device_from_container:
+	if (st)
+		st->ss->free_super(st);
+	sysfs_free(sra);
+
+	return ret_val;
+}
+
+char *get_next_volume(int fd, int raid_disks, char *retBuf) {
+	char *ret_val = NULL;
+	struct supertype *st = NULL;
+	int container_fd = -1;
+	int dn = -1;
+	struct mdinfo *sra = NULL;
+	struct mdinfo info;
+	struct mdu_array_info_s test_array;
+	int device_num;
+
+	if ((retBuf == NULL) || (fd < 0))
+		goto exit_get_next_volume;
+
+	st = super_by_fd(fd);
+	if (st == NULL)
+		goto exit_get_next_volume;
+
+	if (st->ss->external == 0)
+		goto exit_get_next_volume;
+
+	sra = sysfs_read(fd, 0, GET_VERSION);
+	if (sra == NULL)
+		goto exit_get_next_volume;
+
+	dn = devname2devnum(sra->text_version + 1);
+	sysfs_free(sra);
+	sra = NULL;
+	container_fd = open_dev_excl(dn);
+	if (container_fd < 0)
+		goto exit_get_next_volume;
+
+	sra = sysfs_read(container_fd, 0, GET_VERSION);
+	if (sra == NULL)
+		goto exit_get_next_volume;
+
+	device_num = 1;
+	while (device_num > 0) {
+		sprintf(st->subarray, "%i", device_num);
+		st->ss->load_super(st, container_fd, NULL);
+		if (st->sb == NULL)
+			break;
+
+		st->ss->getinfo_super(st, &info);
+		if ((info.array.level == 0) ||
+		    (info.array.level == 5)) {
+			int delta_disks = raid_disks - info.array.raid_disks;
+			if (delta_disks > 0) {
+				int fd2;
+				snprintf(retBuf, GROW_RESHAPE_BUFFER_SIZE,
+					"/dev/md/%s",  info.name);
+				/* in case raid0 "degradation" -> takeovered raid0
+				 * we have to correct delta_disks
+				 */
+				fd2 = open_mddev(retBuf, 1);
+				if (ioctl(fd2, GET_ARRAY_INFO, &test_array) >= 0) {
+					int degradation;
+
+					degradation = test_array.raid_disks - test_array.working_disks;
+
+					if ((degradation == 1) && (info.array.level == 0))
+						delta_disks--;
+
+					if (delta_disks == 0) {
+						close(fd2);
+						continue;
+					}
+				}
+				close(fd2);
+				ret_val = retBuf;
+				device_num = -1;
+				break;
+			}
+		}
+		device_num++;
+	}
+
+exit_get_next_volume:
+	sysfs_free(sra);
+	if (st)
+		st->ss->free_super(st);
+	if (container_fd > -1)
+		close(container_fd);
+
+	return ret_val;
+}
+
 void ping_container(char *devname)
 {
 	struct supertype *st = NULL;
@@ -586,9 +758,16 @@ exit_grow_manage_size_ext_meta:
 
 #define	EXTERNAL_META_STATUS_OK		1
 #define	EXTERNAL_META_STATUS_ERROR	2
+int grow_reshape_process_next_volume(char *devname,
+			   int quiet,
+			   char *backup_file,
+			   long long size, int level, char *layout_str,
+			   int chunksize,
+			   int raid_disks);
+
 int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
-		 long long size,
-		 int level, char *layout_str, int chunksize, int raid_disks)
+		 long long size, int level, char *layout_str,
+		 int chunksize, int raid_disks, int do_it_for_container)
 {
 	/* Make some changes in the shape of an array.
 	 * The kernel must support the change.
@@ -632,6 +811,9 @@ int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
 
 	struct mdinfo *sra, ext_sra;
 	struct mdinfo *sd;
+	int raid_disks2 = raid_disks;
+	long long size2 = size;
+
 
 	if (ioctl(fd, GET_ARRAY_INFO, &array) < 0) {
 		fprintf(stderr, Name ": %s is not an active md array - aborting\n", @@ -1525,7 +1707,6 @@ ext_array_configured:
 			else
 				fd = -1;
 			mlockall(MCL_FUTURE);
-
 			if (odata < ndata)
 				done = child_grow(st, fd, sra, stripes,
 						  fdlist, offsets,
@@ -1571,6 +1752,17 @@ ext_array_configured:
 				 */
 				ping_container(devname);
 			}
+
+			/* external metadata can continue growing
+			 * for next array in container
+			 * when previous grow is finished
+			 */
+			if ((odata < ndata) && (done >= 0) && do_it_for_container) {
+				done = grow_reshape_process_next_volume(devname, quiet, backup_file,
+						size2, UnSet, layout_str, chunksize,
+						raid_disks2);
+			}
+
 			exit(0);
 		case -1:
 			fprintf(stderr, Name ": Cannot run child to monitor reshape: %s\n", @@ -1597,6 +1789,103 @@ ext_array_configured:
 	return rv;
 }
 
+int grow_reshape_process_next_volume(char *devname,
+			   int quiet,
+			   char *backup_file,
+			   long long size, int level, char *layout_str,
+			   int chunksize,
+			   int raid_disks)
+{
+	int fd;
+	char next_volume_buf[GROW_RESHAPE_BUFFER_SIZE];
+	char *next_volume;
+	int ret_val = 1;
+
+	fd = open(devname, O_RDONLY | O_DIRECT);
+	if (fd < 0)
+		goto exit_grow_reshape_process_next_volume;
+
+
+	next_volume = get_next_volume(fd, raid_disks, next_volume_buf);
+	close(fd);
+
+	if (next_volume == NULL)
+		goto exit_grow_reshape_process_next_volume;
+
+	fd = open_mddev(next_volume, 1);
+	if (fd > -1) {
+		/* work for next volume
+		 */
+		ret_val = Grow_reshape(next_volume, fd, quiet, backup_file, size,
+				level, layout_str, chunksize, raid_disks, 1);
+		close(fd);
+	}
+
+exit_grow_reshape_process_next_volume:
+	return ret_val;
+}
+
+int Grow_reshape_container(char *devname, int fd, int quiet,
+			   char *backup_file, long long size,
+			   int level, char *layout_str,
+			   int chunksize, int raid_disks)
+{
+	/* Some external metadada supports Online Capacity Expansion
+	 * for whole array only.
+	 * For those case:
+	 *   1. check if mdadm was executed on container
+	 *   2. get first volume from container
+	 *   3. Execute Grow_reshape()
+	 *
+	 * On the end of Grow_reshape() next volume reshape will be triggered
+	 * if particular metadata requires this.
+	 */
+	int rv = 0;
+	char first_volume_buf[GROW_RESHAPE_BUFFER_SIZE];
+	char *devname2;
+	int do_it_for_container = 0;
+
+	devname2 = get_first_device_from_container(devname, fd,
+				    raid_disks, first_volume_buf);
+	if (devname2 == NULL) {
+		rv = 1;
+		fprintf(stderr, Name ": Cannot continue for specified device : %s\n", devname);
+		goto exit_Grow_reshape_container;
+	}
+
+	if (devname != devname2) {
+		int fd2;
+
+		/* it seams that passed device is container
+		 * switch to first volume in container now
+		 * as it is checked and allowed
+		 */
+		devname = devname2;
+		do_it_for_container = 1;
+
+		fd2 = open_mddev(devname, 1);
+		if (fd2 < 0) {
+			rv = 1;
+			fprintf(stderr, Name ": Cannot open device : %s\n", devname);
+			goto exit_Grow_reshape_container;
+		}
+		close(fd);
+		fd = fd2;
+	}
+
+	rv = Grow_reshape(devname, fd, quiet, backup_file,
+			  size, level, layout_str,
+			  chunksize, raid_disks,
+			  do_it_for_container);
+
+	/* work for next array in container will be executed
+	 * in fork-ed part of Grow
+	 */
+
+exit_Grow_reshape_container:
+	return rv;
+}
+
 /*
  * We run a child process in the background which performs the following
  * steps:
diff --git a/mdadm.c b/mdadm.c
index d5e34c0..7216870 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1502,7 +1502,7 @@ int main(int argc, char *argv[])
 					    bitmap_chunk, delay, write_behind, force);
 		} else if (size >= 0 || raiddisks != 0 || layout_str != NULL
 			   || chunk != 0 || level != UnSet) {
-			rv = Grow_reshape(devlist->devname, mdfd, quiet, backup_file,
+			rv = Grow_reshape_container(devlist->devname, mdfd, quiet, 
+backup_file,
 					  size, level, layout_str, chunk, raiddisks);
 		} else if (array_size < 0)
 			fprintf(stderr, Name ": no changes to --grow\n"); diff --git a/mdadm.h b/mdadm.h index ecef25c..a01c8cd 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -766,9 +766,9 @@ extern int Manage_subdevs(char *devname, int fd,  extern int autodetect(void);  extern int Grow_Add_device(char *devname, int fd, char *newdev);  extern int Grow_addbitmap(char *devname, int fd, char *file, int chunk, int delay, int write_behind, int force); -extern int Grow_reshape(char *devname, int fd, int quiet, char *backup_file,
-			long long size,
-			int level, char *layout_str, int chunksize, int raid_disks);
+extern int Grow_reshape_container(char *devname, int fd, int quiet, char *backup_file,
+				  long long size,
+				  int level, char *layout_str, int chunksize, int raid_disks);
 extern int Grow_restart(struct supertype *st, struct mdinfo *info,
 			int *fdlist, int cnt, char *backup_file, int verbose);  extern int Grow_continue(int mdfd, struct supertype *st,

