From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v3 6/6] Grow: support consistency policy change
Date: Thu, 16 Mar 2017 22:09:48 +0100
Message-ID: <20170316210948.21093-7-artur.paszkiewicz@intel.com>
References: <20170316210948.21093-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170316210948.21093-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

Extend the --consistency-policy parameter to work also in Grow mode.
Using it changes the currently active consistency policy in the kernel
driver and updates the metadata to make this change permanent. Currently
this supports only changing between "ppl" and "resync" policies, that is
enabling or disabling PPL at runtime.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Grow.c     | 172 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.8.in |  18 ++++++-
 mdadm.c    |   3 ++
 mdadm.h    |   2 +
 4 files changed, 194 insertions(+), 1 deletion(-)

diff --git a/Grow.c b/Grow.c
index e4351d7f..c01d0945 100755
--- a/Grow.c
+++ b/Grow.c
@@ -528,6 +528,178 @@ int Grow_addbitmap(char *devname, int fd, struct context *c, struct shape *s)
 	return 0;
 }
 
+int Grow_consistency_policy(char *devname, int fd, struct context *c, struct shape *s)
+{
+	struct supertype *st;
+	struct mdinfo *sra;
+	struct mdinfo *sd;
+	char *subarray = NULL;
+	int ret = 0;
+	char container_dev[PATH_MAX];
+
+	if (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
+	    s->consistency_policy != CONSISTENCY_POLICY_PPL) {
+		pr_err("Operation not supported for consistency policy %s\n",
+		       map_num(consistency_policies, s->consistency_policy));
+		return 1;
+	}
+
+	st = super_by_fd(fd, &subarray);
+	if (!st)
+		return 1;
+
+	sra = sysfs_read(fd, NULL, GET_CONSISTENCY_POLICY|GET_LEVEL|
+				   GET_DEVS|GET_STATE);
+	if (!sra) {
+		ret = 1;
+		goto free_st;
+	}
+
+	if (s->consistency_policy == CONSISTENCY_POLICY_PPL &&
+	    !st->ss->write_init_ppl) {
+		pr_err("%s metadata does not support PPL\n", st->ss->name);
+		ret = 1;
+		goto free_info;
+	}
+
+	if (sra->array.level != 5) {
+		pr_err("Operation not supported for array level %d\n",
+				sra->array.level);
+		ret = 1;
+		goto free_info;
+	}
+
+	if (sra->consistency_policy == (unsigned)s->consistency_policy) {
+		pr_err("Consistency policy is already %s\n",
+		       map_num(consistency_policies, s->consistency_policy));
+		ret = 1;
+		goto free_info;
+	} else if (sra->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
+		   sra->consistency_policy != CONSISTENCY_POLICY_PPL) {
+		pr_err("Current consistency policy is %s, cannot change to %s\n",
+		       map_num(consistency_policies, sra->consistency_policy),
+		       map_num(consistency_policies, s->consistency_policy));
+		ret = 1;
+		goto free_info;
+	}
+
+	if (subarray) {
+		char *update;
+
+		if (s->consistency_policy == CONSISTENCY_POLICY_PPL)
+			update = "ppl";
+		else
+			update = "no-ppl";
+
+		sprintf(container_dev, "/dev/%s", st->container_devnm);
+
+		ret = Update_subarray(container_dev, subarray, update, NULL,
+				      c->verbose);
+		if (ret)
+			goto free_info;
+	}
+
+	if (s->consistency_policy == CONSISTENCY_POLICY_PPL) {
+		struct mdinfo info;
+
+		if (subarray) {
+			struct mdinfo *mdi;
+			int cfd;
+
+			cfd = open(container_dev, O_RDWR|O_EXCL);
+			if (cfd < 0) {
+				pr_err("Failed to open %s\n", container_dev);
+				ret = 1;
+				goto free_info;
+			}
+
+			ret = st->ss->load_container(st, cfd, st->container_devnm);
+			close(cfd);
+
+			if (ret) {
+				pr_err("Cannot read superblock for %s\n",
+				       container_dev);
+				goto free_info;
+			}
+
+			mdi = st->ss->container_content(st, subarray);
+			info = *mdi;
+			free(mdi);
+		}
+
+		for (sd = sra->devs; sd; sd = sd->next) {
+			int dfd;
+			char *devpath;
+
+			if ((sd->disk.state & (1 << MD_DISK_SYNC)) == 0)
+				continue;
+
+			devpath = map_dev(sd->disk.major, sd->disk.minor, 0);
+			dfd = dev_open(devpath, O_RDWR);
+			if (dfd < 0) {
+				pr_err("Failed to open %s\n", devpath);
+				ret = 1;
+				goto free_info;
+			}
+
+			if (!subarray) {
+				ret = st->ss->load_super(st, dfd, NULL);
+				if (ret) {
+					pr_err("Failed to load super-block.\n");
+					close(dfd);
+					goto free_info;
+				}
+
+				ret = st->ss->update_super(st, sra, "ppl", devname,
+							   c->verbose, 0, NULL);
+				if (ret) {
+					close(dfd);
+					st->ss->free_super(st);
+					goto free_info;
+				}
+				st->ss->getinfo_super(st, &info, NULL);
+			}
+
+			ret |= sysfs_set_num(sra, sd, "ppl_sector", info.ppl_sector);
+			ret |= sysfs_set_num(sra, sd, "ppl_size", info.ppl_size);
+
+			if (ret) {
+				pr_err("Failed to set PPL attributes for %s\n",
+				       sd->sys_name);
+				close(dfd);
+				st->ss->free_super(st);
+				goto free_info;
+			}
+
+			ret = st->ss->write_init_ppl(st, &info, dfd);
+			if (ret)
+				pr_err("Failed to write PPL\n");
+
+			close(dfd);
+
+			if (!subarray)
+				st->ss->free_super(st);
+
+			if (ret)
+				goto free_info;
+		}
+	}
+
+	ret = sysfs_set_str(sra, NULL, "consistency_policy",
+			    map_num(consistency_policies,
+				    s->consistency_policy));
+	if (ret)
+		pr_err("Failed to change array consistency policy\n");
+
+free_info:
+	sysfs_free(sra);
+free_st:
+	free(st);
+	free(subarray);
+
+	return ret;
+}
+
 /*
  * When reshaping an array we might need to backup some data.
  * This is written to all spares with a 'super_block' describing it.
diff --git a/mdadm.8.in b/mdadm.8.in
index 1178ed9b..744c12b5 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -126,7 +126,7 @@ of component devices and changing the number of active devices in
 Linear and RAID levels 0/1/4/5/6,
 changing the RAID level between 0, 1, 5, and 6, and between 0 and 10,
 changing the chunk size and layout for RAID 0,4,5,6,10 as well as adding or
-removing a write-intent bitmap.
+removing a write-intent bitmap and changing the array's consistency policy.
 
 .TP
 .B "Incremental Assembly"
@@ -1050,6 +1050,10 @@ after unclean shutdown. Implicitly selected when using
 For RAID5 only, Partial Parity Log is used to close the write hole and
 eliminate resync. PPL is stored in the metadata region of RAID member drives,
 no additional journal drive is needed.
+
+.PP
+Can be used with \-\-grow to change the consistency policy of an active array
+in some cases. See CONSISTENCY POLICY CHANGES below.
 .RE
 
 
@@ -2694,6 +2698,8 @@ RAID0, RAID4, and RAID5, and between RAID0 and RAID10 (in the near-2 mode).
 .IP \(bu 4
 add a write-intent bitmap to any array which supports these bitmaps, or
 remove a write-intent bitmap from such an array.
+.IP \(bu 4
+change the array's consistency policy.
 .PP
 
 Using GROW on containers is currently supported only for Intel's IMSM
@@ -2850,6 +2856,16 @@ can be added.  Note that if you add a bitmap stored in a file which is
 in a filesystem that is on the RAID array being affected, the system
 will deadlock.  The bitmap must be on a separate filesystem.
 
+.SS CONSISTENCY POLICY CHANGES
+
+The consistency policy of an active array can be changed by using the
+.B \-\-consistency\-policy
+option in Grow mode. Currently this works only for the
+.B ppl
+and
+.B resync
+policies and allows to enable or disable the RAID5 Partial Parity Log (PPL).
+
 .SH INCREMENTAL MODE
 
 .HP 12
diff --git a/mdadm.c b/mdadm.c
index 3d0da1ec..0db4cb33 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -1217,6 +1217,7 @@ int main(int argc, char *argv[])
 			s.journaldisks = 1;
 			continue;
 		case O(CREATE, 'k'):
+		case O(GROW, 'k'):
 			s.consistency_policy = map_name(consistency_policies,
 							optarg);
 			if (s.consistency_policy == UnSet ||
@@ -1675,6 +1676,8 @@ int main(int argc, char *argv[])
 			rv = Grow_reshape(devlist->devname, mdfd,
 					  devlist->next,
 					  data_offset, &c, &s);
+		} else if (s.consistency_policy != UnSet) {
+			rv = Grow_consistency_policy(devlist->devname, mdfd, &c, &s);
 		} else if (array_size == 0)
 			pr_err("no changes to --grow\n");
 		break;
diff --git a/mdadm.h b/mdadm.h
index ab1b7fc6..7173b258 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1331,6 +1331,8 @@ extern int Grow_restart(struct supertype *st, struct mdinfo *info,
 extern int Grow_continue(int mdfd, struct supertype *st,
 			 struct mdinfo *info, char *backup_file,
 			 int forked, int freeze_reshape);
+extern int Grow_consistency_policy(char *devname, int fd,
+				   struct context *c, struct shape *s);
 
 extern int restore_backup(struct supertype *st,
 			  struct mdinfo *content,
-- 
2.11.0

