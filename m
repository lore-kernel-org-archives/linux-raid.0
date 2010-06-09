From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: [PATCH 22/23] imsm: Add start limitation for container
Date: Wed, 9 Jun 2010 15:44:09 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11EECE8FD@irsmsx503.ger.corp.intel.com>
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
For IMSM, it is not allowed that in reshaped container exists other raid volume than raid5 or raid0 type. If container has any other raid volume type, grow operation has to be rejected.
To implement metadata specific limitation is_allowed() function was introduced. Implementation for imsm lets mdadm to know if grow operation is allowed on passed device in particular configuration.
For imsm it checks if operation is run on container. For container it checks if operation is permitted based on volumes raid levels limitation.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 Grow.c        |   58 ++++++++++++++++++++++++++
 mdadm.h       |   27 ++++++++++++
 super-intel.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 util.c        |   33 +++++++++++++++
 4 files changed, 243 insertions(+), 0 deletions(-)

diff --git a/Grow.c b/Grow.c
index 5046e56..2a2234d 100644
--- a/Grow.c
+++ b/Grow.c
@@ -88,6 +88,9 @@ char *get_first_device_from_container(char *devname, int fd, int raid_disks, cha
 	char *ret_val = NULL;
 	struct supertype *st = NULL;
 	struct mdinfo *sra = NULL;
+	int operation = OPERATION_CHECK_NOT_IMPLEMENTED;
+	int status;
+	struct is_allowed_params params;
 
 	if ((devname == NULL) ||
 	    (fd < 0) ||
@@ -110,7 +113,62 @@ char *get_first_device_from_container(char *devname, int fd, int raid_disks, cha
 	if (sra == NULL)
 		goto exit_get_first_device_from_container;
 
+	/* if personality is not prepared for is_allowed()
+	 * we cannot modify input parametes,
+	 * return NULL to indicate this
+	 */
+	if (st->ss->is_allowed == NULL)
+		goto exit_get_first_device_from_container;
+
+	memset(&params, 0, sizeof(struct is_allowed_params));
 	ret_val = get_first_volume(fd, raid_disks, first_volume_buf);
+	if (ret_val == NULL) {
+		/* cannot get first volume,
+		 * so passed name should be volume name.
+		 */
+		dprintf("We are running on Volume (return what was passed in)\n");
+		ret_val = devname;
+		operation = OPERATION_GROW_VOLUME;
+	} else {
+		dprintf("We are running on Container\n");
+		operation = OPERATION_GROW_CONTAINER;
+		params.sra = sra;
+	}
+
+	/* when is_allowed() returns success - keep selection
+	 */
+	params.fd = fd;
+	params.name = devname;
+	params.raid_disks = raid_disks;
+	status = st->ss->is_allowed(operation, &params);
+	if (status == operation)
+		goto exit_get_first_device_from_container;
+
+	/* error and not implemented cases,
+	 * do not modify parameters
+	 */
+	ret_val = NULL;
+	if (status == OPERATION_WRONG_PARAMETERS) {
+		fprintf(stderr,
+			Name ": %s cannot be reshaped due to"\
+			" wrong input parameters.\n",
+			devname);
+		goto exit_get_first_device_from_container;
+	}
+
+	switch (operation) {
+	case OPERATION_GROW_VOLUME:
+		fprintf(stderr,
+		Name": This command has to be executed on container "\
+		"for this array type.\n");
+	break;
+	case OPERATION_GROW_CONTAINER:
+		fprintf(stderr,
+			Name ": %s cannot be reshaped due to"\
+			" Online Capacity Expansion limitations.\n",
+			devname);
+	break;
+	}
 
 exit_get_first_device_from_container:
 	if (st)
diff --git a/mdadm.h b/mdadm.h
index a01c8cd..9889c60 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -457,6 +457,7 @@ extern char *map_dev(int major, int minor, int create);
 
 struct active_array;
 struct metadata_update;
+struct is_allowed_params;
 
 /* A superswitch provides entry point the a metadata handler.
  *
@@ -649,6 +650,24 @@ extern struct superswitch {
 	struct mdinfo *(*activate_spare)(struct active_array *a,
 					 struct metadata_update **updates);
 
+
+#define OPERATION_NOT_ALLOWED                  -1
+#define OPERATION_CHECK_NOT_IMPLEMENTED         0
+#define OPERATION_GROW_VOLUME                   1
+#define OPERATION_GROW_CONTAINER                2
+#define OPERATION_WRONG_PARAMETERS              3
+	/* is_allowed will check if operation is allowed for external meta
+	 * parameters usage depends of operation passed in to the function
+	 * function can return:
+	 *     OPERATION_NOT_ALLOWED
+	 *           passed operation is not allowed
+	 *     OPERATION_CHECK_NOT_IMPLEMENTED
+	 *          [assed operation status cannot be evaluated
+	 * when operation is allowed function returns requested check operation id
+	 * i.e.: OPERATION_GROW_VOLUME
+	 */
+	int (*is_allowed)(int operation, struct is_allowed_params *params);
+
 	int (*grow_array)(struct active_array *a, int new_raid_disks);
 
 	int swapuuid; /* true if uuid is bigending rather than hostendian */ @@ -665,6 +684,13 @@ struct metadata_update {
 	struct metadata_update *next;
 };
 
+struct is_allowed_params {
+	int		fd;
+	int		raid_disks;
+	char		*name;
+	struct mdinfo	*sra;
+};
+
 /* A supertype holds a particular collection of metadata.
  * It identifies the metadata type by the superswitch, and the particular
  * sub-version of that metadata type.
@@ -861,6 +887,7 @@ extern int conf_name_is_free(char *name);  extern int devname_matches(char *name, char *match);  extern struct mddev_ident_s *conf_match(struct mdinfo *info, struct supertype *st);  extern void sleep2(unsigned int sec, unsigned int usec);
+extern int find_array_minor(char *text_version, int external, int 
+*minor);
 extern int read_attr(char *buf, int len, int fd);  extern int read_dev_state(int fd);
 
diff --git a/super-intel.c b/super-intel.c index b92a787..db4055d 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -5954,6 +5954,130 @@ static void imsm_delete(struct intel_super *super, struct dl **dlp, int index)
 	}
 }
 
+int imsm_reshape_is_allowed_on_container(struct is_allowed_params 
+*params) {
+	int ret_val = OPERATION_NOT_ALLOWED;
+	struct mdinfo info;
+	char buf[1024];
+	struct supertype *st = NULL;
+	int device_num;
+
+	if ((params->sra == NULL) || (params->fd < 0))
+		goto exit_imsm_reshape_is_allowed_on_container;
+
+	st = super_by_fd(params->fd);
+	if (st == NULL)
+		goto exit_imsm_reshape_is_allowed_on_container;
+
+	device_num = 0;
+	ret_val = OPERATION_GROW_CONTAINER;
+	while (device_num > -1) {
+		int result;
+		int minor;
+		sprintf(st->subarray, "%i", device_num);
+		load_super_imsm(st, params->fd, NULL);
+		if (st->sb == NULL) {
+			if (device_num == 0)
+				ret_val = OPERATION_WRONG_PARAMETERS;
+			break;
+		}
+		st->ss->getinfo_super(st, &info);
+
+		if (params->raid_disks <= info.array.raid_disks) {
+			/* we work on container for
+			 * Online Capacity Expansion
+			 * only
+			 * so raid_disks has to grow
+			 */
+			ret_val = OPERATION_WRONG_PARAMETERS;
+			break;
+		}
+
+		if ((info.array.level != 0) &&
+		    (info.array.level != 5)) {
+			/* we cannot use this container
+			 * other raid level
+			 */
+			ret_val = OPERATION_NOT_ALLOWED;
+			break;
+		}
+		/* all raid5 and raid0 volumes in container
+		 * has to be ready for Online Capacity Expansion
+		 */
+		result = find_array_minor(info.text_version,
+					  st->ss->external,
+					   &minor);
+		if (result > -1) {
+			sprintf(info.sys_name, "md%i", minor);
+			if (sysfs_get_str(&info, NULL, "array_state",
+					  buf, 20) <= 0) {
+				ret_val = OPERATION_NOT_ALLOWED;
+				break;
+			}
+			if (strcmp(buf, "clean\n") != 0 &&
+			    strcmp(buf, "active\n") != 0) {
+				ret_val = OPERATION_NOT_ALLOWED;
+				break;
+			}
+			if (info.array.level == 5) {
+				if (sysfs_get_str(&info, NULL, "sync_action",
+						  buf, 20) <= 0) {
+					ret_val = OPERATION_NOT_ALLOWED;
+					break;
+				}
+				if (strcmp(buf, "idle\n") != 0 &&
+				    strcmp(buf, "active\n") != 0 &&
+				    strcmp(buf, "frozen\n") != 0) {
+					ret_val = OPERATION_NOT_ALLOWED;
+					break;
+				}
+			}
+		} else {
+			ret_val = OPERATION_NOT_ALLOWED;
+			break;
+		}
+		device_num++;
+	}
+
+exit_imsm_reshape_is_allowed_on_container:
+	if (st)
+		free_super_imsm(st);
+
+	return ret_val;
+}
+
+int  imsm_is_allowed(int operation, struct is_allowed_params *params) {
+	int ret_val = OPERATION_CHECK_NOT_IMPLEMENTED;
+
+	if ((params == NULL) || (params->name == NULL))
+		goto exit_imsm_is_allowed;
+
+	switch (operation) {
+	case OPERATION_GROW_VOLUME: {
+		struct mdinfo *sra;
+
+		ret_val = OPERATION_NOT_ALLOWED;
+		if (params->fd > -1) {
+			sra = sysfs_read(params->fd, 0, GET_VERSION | GET_DISKS);
+			if (sra) {
+				if (params->raid_disks <= sra->array.raid_disks)
+					ret_val = OPERATION_GROW_VOLUME;
+				sysfs_free(sra);
+			}
+		}
+	break;
+	}
+	case OPERATION_GROW_CONTAINER: {
+		ret_val = imsm_reshape_is_allowed_on_container(params);
+		break;
+	}
+	}
+
+exit_imsm_is_allowed:
+	return ret_val;
+}
+
 struct mdinfo *get_spares_imsm(int devnum)  {
 	int fd = -1;
@@ -6047,6 +6171,7 @@ struct superswitch super_imsm = {
 	.match_metadata_desc = match_metadata_desc_imsm,
 	.container_content = container_content_imsm,
 	.default_layout = imsm_level_to_layout,
+	.is_allowed	= imsm_is_allowed,
 	.grow_array	= imsm_grow_array,
 	.external	= 1,
 	.name = "imsm",
diff --git a/util.c b/util.c
index 7f5e20a..46e8785 100644
--- a/util.c
+++ b/util.c
@@ -1657,6 +1657,39 @@ void sleep2(unsigned int sec, unsigned int usec)
 	select(0, NULL, NULL, NULL, &tv);
 }
 
+int find_array_minor(char *text_version, int external, int *minor) {
+	int i;
+	char path[PATH_MAX];
+	struct stat s;
+
+	if (minor == NULL)
+		return -2;
+
+	for (i = 127; i >= 0; i--) {
+		char buf[1024];
+
+		snprintf(path, PATH_MAX, "/sys/block/md%d/md/", i);
+		if (stat(path, &s) != -1) {
+			strcat(path, "metadata_version");
+			if (load_sys(path, buf))
+				continue;
+			if (external) {
+				char *version = strchr(buf, ':');
+				if (version && strcmp(version + 1,
+							text_version))
+					continue;
+			} else {
+				if (strcmp(buf, text_version))
+					continue;
+			}
+			*minor = i;
+			return 0;
+		}
+	}
+	return -1;
+}
+
 int read_attr(char *buf, int len, int fd)  {
 	int n;

