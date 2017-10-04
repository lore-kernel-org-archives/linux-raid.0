From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: Linux Plumbers MD BOF discussion notes
Date: Wed, 4 Oct 2017 13:23:02 +0200
Message-ID: <076977d4-dfae-e8d3-7606-29e838f422ec@intel.com>
References: <20170915142737.qafwl3vgl6vhfi5q@kernel.org>
 <871sn78pzt.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1709180852450.29378@uplift.swm.pp.se>
 <874ls0s7un.fsf@notabene.neil.brown.name>
 <alpine.DEB.2.20.1710010730210.31961@uplift.swm.pp.se>
 <87lgkr3fgj.fsf@notabene.neil.brown.name>
 <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <619758c0-9ca4-c25d-c61b-f411b095041d@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/04/2017 01:02 PM, Artur Paszkiewicz wrote:
> Applications like mdadm can use this to hide/unhide their component
> devices.

And here is an example patch for mdadm. It adds options to manually hide
or unhide the component devices:

mdadm --hide-components /dev/md0
mdadm --unhide-components /dev/md0

And an option for mdadm.conf that automatically hides the array's member
disks when assembling and when new disks are added:

ARRAY /dev/md/0  metadata=1.2 UUID=c2c4f8c6:cd775924:9cb2cc62:88fa45bd
	name=linux-ns31:0 hide-components=yes

Hidden disks (by mdadm --hide-components or by config) should unhide
when the array is stopped or disks are removed. It only works for whole
devices, not partitions.

Thanks,
Artur

diff --git a/Assemble.c b/Assemble.c
index 3c10b6cd..98dfe20d 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -1029,6 +1029,12 @@ static int start_array(int mdfd,
 			       i/2, mddev);
 	}
 
+	if (ident->hide_components) {
+		if (Manage_hidden(mdfd, 1, NULL))
+			pr_err("Failed to hide component devices for %s\n",
+			       mddev);
+	}
+
 	if (content->array.level == LEVEL_CONTAINER) {
 		if (c->verbose >= 0) {
 			pr_err("Container %s has been assembled with %d drive%s",
@@ -1500,6 +1506,13 @@ try_again:
 	if (content != &info) {
 		/* This is a member of a container.  Try starting the array. */
 		int err;
+
+		if (ident->hide_components) {
+			pr_err("Ignoring 'hide_components' from config for %s.\n",
+			       mddev);
+			pr_err("This should be set for container, not subarray.\n");
+		}
+
 		err = assemble_container_content(st, mdfd, content, c,
 						 chosen_name, NULL);
 		close(mdfd);
diff --git a/Grow.c b/Grow.c
index 1149753d..ae3ea512 100644
--- a/Grow.c
+++ b/Grow.c
@@ -637,7 +637,7 @@ int Grow_consistency_policy(char *devname, int fd, struct context *c, struct sha
 			int dfd;
 			char *devpath;
 
-			devpath = map_dev(sd->disk.major, sd->disk.minor, 0);
+			devpath = map_dev(sd->disk.major, sd->disk.minor, 1);
 			dfd = dev_open(devpath, O_RDWR);
 			if (dfd < 0) {
 				pr_err("Failed to open %s\n", devpath);
@@ -2461,7 +2461,7 @@ static int set_new_data_offset(struct mdinfo *sra, struct supertype *st,
 
 		if (sd->disk.state & (1<<MD_DISK_FAULTY))
 			continue;
-		dn = map_dev(sd->disk.major, sd->disk.minor, 0);
+		dn = map_dev(sd->disk.major, sd->disk.minor, 1);
 		dfd = dev_open(dn, O_RDONLY);
 		if (dfd < 0) {
 			pr_err("%s: cannot open component %s\n",
@@ -2520,6 +2520,9 @@ static int set_new_data_offset(struct mdinfo *sra, struct supertype *st,
 		char *dn = map_dev(sd->disk.major, sd->disk.minor, 0);
 		unsigned long long new_data_offset;
 
+		if (!dn)
+			dn = sd->sys_name;
+
 		if (sd->disk.state & (1<<MD_DISK_FAULTY))
 			continue;
 		if (delta_disks < 0) {
@@ -2759,7 +2762,7 @@ static void get_space_after(int fd, struct supertype *st, struct mdinfo *info)
 
 		if (sd->disk.state & (1<<MD_DISK_FAULTY))
 			continue;
-		dn = map_dev(sd->disk.major, sd->disk.minor, 0);
+		dn = map_dev(sd->disk.major, sd->disk.minor, 1);
 		dfd = dev_open(dn, O_RDONLY);
 		if (dfd < 0)
 			break;
diff --git a/Incremental.c b/Incremental.c
index 91301eb5..5ce1cf9f 100644
--- a/Incremental.c
+++ b/Incremental.c
@@ -534,6 +534,11 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 		} else if (c->verbose >= 0)
 			pr_err("%s attached to %s which is already active.\n",
 			       devname, chosen_name);
+		if (match && match->hide_components) {
+			if (Manage_hidden(mdfd, 1, &rdev))
+				pr_err("Failed to hide %s for %s\n",
+				       devname, chosen_name);
+		}
 		rv = 0;
 		goto out_unlock;
 	}
@@ -604,6 +609,12 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
 					pr_err("%s re-added to %s\n",
 					       dsk->sys_name, chosen_name);
 			}
+
+			if (match && match->hide_components) {
+				if (Manage_hidden(mdfd, 1, NULL))
+					pr_err("Failed to hide component devices for %s\n",
+					       chosen_name);
+			}
 		} else {
 			pr_err("%s attached to %s, but failed to start: %s.\n",
 			       devname, chosen_name, strerror(errno));
@@ -1401,6 +1412,11 @@ restart:
 				if (c->verbose >= 0)
 					pr_err("started array %s\n",
 					       me->path ?: me->devnm);
+				if (mddev && mddev->hide_components) {
+					if (Manage_hidden(mdfd, 1, NULL))
+						pr_err("Failed to hide component devices for %s\n",
+						       me->path ?: me->devnm);
+				}
 			} else {
 				pr_err("failed to start array %s: %s\n",
 				       me->path ?: me->devnm,
@@ -1450,7 +1466,7 @@ static int Incremental_container(struct supertype *st, char *devname,
 	struct map_ent *map = NULL;
 	struct mdinfo info;
 	int trustworthy;
-	struct mddev_ident *match;
+	struct mddev_ident *match, *ident;
 	int rv = 0;
 	struct domainlist *domains;
 	struct map_ent *smp;
@@ -1477,6 +1493,8 @@ static int Incremental_container(struct supertype *st, char *devname,
 	if (match == NULL && rv == 2)
 		return rv;
 
+	ident = match;
+
 	/* Need to compute 'trustworthy' */
 	if (match)
 		trustworthy = LOCAL;
@@ -1608,6 +1626,17 @@ static int Incremental_container(struct supertype *st, char *devname,
 		printf("\n");
 	}
 
+	if (ident && ident->hide_components) {
+		int mdfd = open(devname, O_RDONLY);
+
+		if (mdfd >= 0) {
+			if (Manage_hidden(mdfd, 1, NULL))
+				pr_err("Failed to hide component devices for %s\n",
+				       devname);
+			close(mdfd);
+		}
+	}
+
 	/* don't move spares to container with volume being activated
 	   when all volumes are blocked */
 	if (ra_all == ra_blocked)
diff --git a/Manage.c b/Manage.c
index 21536f5e..7aa32fa9 100644
--- a/Manage.c
+++ b/Manage.c
@@ -224,6 +224,8 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 			       devname);
 		return 1;
 	}
+	if (container[0] == 0)
+		Manage_hidden(fd, 0, NULL);
 	/* If this is an mdmon managed array, just write 'inactive'
 	 * to the array state and let mdmon clear up.
 	 */
@@ -711,6 +713,34 @@ skip_re_add:
 	return 0;
 }
 
+int Manage_hidden(int fd, int hide, dev_t *rdev)
+{
+	struct mdinfo *sra, *dv;
+	int ret = 0;
+
+	sra = sysfs_read(fd, NULL, GET_DEVS);
+	if (!sra || !sra->devs)
+		return 1;
+
+	for (dv = sra->devs; dv; dv = dv->next) {
+		if ((dv->hidden == hide) ||
+		    (rdev && *rdev != makedev(dv->disk.major, dv->disk.minor)))
+			continue;
+
+		if (!sysfs_attribute_available(sra, dv, "block/hidden")) {
+			ret = 1;
+			break;
+		}
+
+		ret = sysfs_set_num(sra, dv, "block/hidden", hide);
+		if (ret)
+			break;
+	}
+
+	sysfs_free(sra);
+	return ret;
+}
+
 int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	       struct supertype *tst, mdu_array_info_t *array,
 	       int force, int verbose, char *devname,
@@ -721,6 +751,8 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	struct supertype *dev_st;
 	int j;
 	mdu_disk_info_t disc;
+	struct mddev_ident *match;
+	struct mdinfo mdi;
 
 	if (!get_dev_size(tfd, dv->devname, &ldsize)) {
 		if (dv->disposition == 'M')
@@ -909,6 +941,8 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 		disc.number = raid_slot;
 	disc.state = 0;
 
+	tst->ss->getinfo_super(tst, &mdi, NULL);
+
 	/* only add journal to array that supports journaling */
 	if (dv->disposition == 'j') {
 		struct mdinfo *mdp;
@@ -1065,6 +1099,13 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
 	}
 	if (verbose >= 0)
 		pr_err("added %s\n", dv->devname);
+
+	match = conf_match(tst, &mdi, devname, 0, NULL);
+	if (match && match->hide_components) {
+		if (Manage_hidden(fd, 1, &rdev))
+			pr_err("Failed to hide %s for %s", dv->devname, devname);
+	}
+
 	return 1;
 }
 
@@ -1138,6 +1179,8 @@ int Manage_remove(struct supertype *tst, int fd, struct mddev_dev *dv,
 		 */
 		err = sys_hot_remove_disk(sysfd, force);
 	} else {
+		Manage_hidden(fd, 0, &rdev);
+
 		err = hot_remove_disk(fd, rdev, force);
 		if (err && errno == ENODEV) {
 			/* Old kernels rejected this if no personality
diff --git a/ReadMe.c b/ReadMe.c
index 4d871e9d..5ce211dc 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -109,6 +109,9 @@ struct option long_options[] = {
     {"dump", 1, 0, Dump},
     {"restore", 1, 0, Restore},
 
+    {"hide-components", 0, 0, HideComponents},
+    {"unhide-components", 0, 0, UnhideComponents},
+
     /* synonyms */
     {"monitor",   0, 0, 'F'},
 
diff --git a/config.c b/config.c
index 48e02788..f37aeb8a 100644
--- a/config.c
+++ b/config.c
@@ -380,6 +380,7 @@ void arrayline(char *line)
 	mis.name[0] = 0;
 	mis.container = NULL;
 	mis.member = NULL;
+	mis.hide_components = 0;
 
 	for (w = dl_next(line); w != line; w = dl_next(w)) {
 		if (w[0] == '/' || strchr(w, '=') == NULL) {
@@ -493,6 +494,10 @@ void arrayline(char *line)
 			/* The container holding this subarray.
 			 * Either a device name or a uuid */
 			mis.container = xstrdup(w + 10);
+		} else if (strncasecmp(w, "hide-components=yes", 19) == 0) {
+			mis.hide_components = 1;
+		} else if (strncasecmp(w, "hide-components=no", 18) == 0) {
+			mis.hide_components = 0;
 		} else {
 			pr_err("unrecognised word on ARRAY line: %s\n",
 				w);
diff --git a/mdadm.c b/mdadm.c
index 7cdcdba7..2d27019c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -119,6 +119,7 @@ int main(int argc, char *argv[])
 	ident.name[0] = 0;
 	ident.container = NULL;
 	ident.member = NULL;
+	ident.hide_components = 0;
 
 	if (get_linux_version() < 2006015) {
 		pr_err("This version of mdadm does not support kernels older than 2.6.15\n");
@@ -241,6 +242,8 @@ int main(int argc, char *argv[])
 		case Dump:
 		case Restore:
 		case Action:
+		case HideComponents:
+		case UnhideComponents:
 			newmode = MISC;
 			break;
 
@@ -1026,6 +1029,8 @@ int main(int argc, char *argv[])
 		case O(MISC, Dump):
 		case O(MISC, Restore):
 		case O(MISC ,Action):
+		case O(MISC ,HideComponents):
+		case O(MISC ,UnhideComponents):
 			if (opt == KillSubarray || opt == UpdateSubarray) {
 				if (c.subarray) {
 					pr_err("subarray can only be specified once\n");
@@ -1995,6 +2000,11 @@ static int misc_list(struct mddev_dev *devlist,
 			case 'w':
 				rv |= Manage_ro(dv->devname, mdfd, -1);
 				break;
+			case HideComponents:
+			case UnhideComponents:
+				rv |= Manage_hidden(mdfd,
+					dv->disposition == HideComponents,
+					NULL);
 			}
 			close(mdfd);
 		} else
diff --git a/mdadm.h b/mdadm.h
index 85947bf6..7d956a64 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -348,6 +348,7 @@ struct mdinfo {
 		ARRAY_UNKNOWN_STATE,
 	} array_state;
 	struct md_bb bb;
+	int hidden;
 };
 
 struct createinfo {
@@ -454,6 +455,8 @@ enum special_options {
 	ClusterConfirm,
 	WriteJournal,
 	ConsistencyPolicy,
+	HideComponents,
+	UnhideComponents,
 };
 
 enum prefix_standard {
@@ -510,6 +513,8 @@ struct mddev_ident {
 				 */
 	char	*member;	/* subarray within a container */
 
+	int hide_components;
+
 	struct mddev_ident *next;
 	union {
 		/* fields needed by different users of this structure */
@@ -1338,6 +1343,7 @@ extern int Manage_stop(char *devname, int fd, int quiet,
 extern int Manage_subdevs(char *devname, int fd,
 			  struct mddev_dev *devlist, int verbose, int test,
 			  char *update, int force);
+extern int Manage_hidden(int fd, int hide, dev_t *rdev);
 extern int autodetect(void);
 extern int Grow_Add_device(char *devname, int fd, char *newdev);
 extern int Grow_addbitmap(char *devname, int fd,
diff --git a/super-intel.c b/super-intel.c
index 536cb613..d57d22c4 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -3847,6 +3847,7 @@ static void fd2devname(int fd, char *name)
 static int nvme_get_serial(int fd, void *buf, size_t buf_len)
 {
 	char path[60];
+	struct stat st;
 	char *name = fd2kname(fd);
 
 	if (!name)
@@ -3855,7 +3856,15 @@ static int nvme_get_serial(int fd, void *buf, size_t buf_len)
 	if (strncmp(name, "nvme", 4) != 0)
 		return 1;
 
-	snprintf(path, sizeof(path) - 1, "/sys/block/%s/device/serial", name);
+	snprintf(path, sizeof(path), "/sys/block/%s/device/serial", name);
+
+	if (stat(path, &st) != 0) {
+		if (fstat(fd, &st) != 0)
+			return 1;
+
+		snprintf(path, sizeof(path), "/sys/dev/block/%d:%d/../serial",
+			 major(st.st_rdev), minor(st.st_rdev));
+	}
 
 	return load_sys(path, buf, buf_len);
 }
diff --git a/sysfs.c b/sysfs.c
index bf5c8c5d..f079d51b 100644
--- a/sysfs.c
+++ b/sysfs.c
@@ -326,6 +326,11 @@ struct mdinfo *sysfs_read(int fd, char *devnm, unsigned long options)
 			continue;
 		}
 
+		strcpy(dbase, "block/hidden");
+		if (load_sys(fname, buf, sizeof(buf)) == 0 &&
+		    strtoul(buf, NULL, 0) == 1)
+			dev->hidden = 1;
+
 		/* finally add this disk to the array */
 		*devp = dev;
 		devp = & dev->next;
