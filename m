From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: [PATCH v2 6/7] Allow changing the RWH policy for a running array
Date: Mon,  5 Dec 2016 16:32:03 +0100
Message-ID: <20161205153204.7343-7-artur.paszkiewicz@intel.com>
References: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161205153204.7343-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: jes.sorensen@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This extends the --rwh-policy parameter to work also in Misc mode. Using
it changes the currently active RWH policy in the kernel driver and
updates the metadata to make this change permanent. Updating metadata is
not yet implemented for super1, so this is limited to IMSM for now.

Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 Manage.c      | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mdadm.c       |  9 +++++++
 mdadm.h       |  1 +
 super-intel.c | 65 +++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 153 insertions(+), 1 deletion(-)

diff --git a/Manage.c b/Manage.c
index 5c3d2b9..0119684 100644
--- a/Manage.c
+++ b/Manage.c
@@ -1823,4 +1823,83 @@ int move_spare(char *from_devname, char *to_devname, dev_t devid)
 	close(fd2);
 	return 0;
 }
+
+int ChangeRwhPolicy(char *dev, char *update, int verbose)
+{
+	struct supertype *st;
+	struct mdinfo *info;
+	char *subarray = NULL;
+	int ret = 0;
+	int fd;
+	int new_policy = map_name(rwh_policies, update);
+
+	if (new_policy == UnSet)
+		return 1;
+
+	fd = open(dev, O_RDONLY);
+	if (fd < 0)
+		return 1;
+
+	st = super_by_fd(fd, &subarray);
+	if (!st) {
+		close(fd);
+		return 1;
+	}
+
+	info = sysfs_read(fd, NULL, GET_RWH_POLICY|GET_LEVEL);
+	close(fd);
+	if (!info) {
+		ret = 1;
+		goto free_st;
+	}
+
+	if (new_policy == RWH_POLICY_PPL && !st->ss->supports_ppl) {
+		pr_err("%s metadata does not support PPL\n", st->ss->name);
+		ret = 1;
+		goto free_info;
+	}
+
+	if (info->array.level < 4 || info->array.level > 6) {
+		pr_err("Operation not supported for array level %d\n",
+				info->array.level);
+		ret = 1;
+		goto free_info;
+	}
+
+	if (info->rwh_policy != (unsigned)new_policy) {
+		if (!st->ss->external && new_policy == RWH_POLICY_PPL) {
+			pr_err("Operation supported for external metadata only.\n");
+			ret = 1;
+			goto free_info;
+		}
+
+		if (sysfs_set_str(info, NULL, "rwh_policy", update)) {
+			pr_err("Failed to change array RWH Policy\n");
+			ret = 1;
+			goto free_info;
+		}
+		info->rwh_policy = new_policy;
+	}
+
+	if (subarray) {
+		char container_dev[PATH_MAX];
+		struct mddev_ident ident;
+
+		sprintf(container_dev, "/dev/%s", st->container_devnm);
+
+		st->info = info;
+		ident.st = st;
+
+		ret = Update_subarray(container_dev, subarray, "rwh-policy",
+				&ident, verbose);
+	}
+
+free_info:
+	sysfs_free(info);
+free_st:
+	free(st);
+	free(subarray);
+
+	return ret;
+}
 #endif
diff --git a/mdadm.c b/mdadm.c
index 2b6d3a2..ed21f1c 100644
--- a/mdadm.c
+++ b/mdadm.c
@@ -252,6 +252,7 @@ int main(int argc, char *argv[])
 		case UpdateSubarray:
 		case UdevRules:
 		case KillOpt:
+		case RwhPolicy:
 			if (!mode)
 				newmode = MISC;
 			break;
@@ -1211,11 +1212,16 @@ int main(int argc, char *argv[])
 			s.journaldisks = 1;
 			continue;
 		case O(CREATE, RwhPolicy):
+		case O(MISC, RwhPolicy):
 			s.rwh_policy = map_name(rwh_policies, optarg);
 			if (s.rwh_policy == UnSet) {
 				pr_err("Invalid RWH policy: %s\n", optarg);
 				exit(2);
 			}
+			if (mode == MISC) {
+				devmode = opt;
+				c.update = optarg;
+			}
 			continue;
 		}
 		/* We have now processed all the valid options. Anything else is
@@ -1927,6 +1933,9 @@ static int misc_list(struct mddev_dev *devlist,
 		case Action:
 			rv |= SetAction(dv->devname, c->action);
 			continue;
+		case RwhPolicy:
+			rv |= ChangeRwhPolicy(dv->devname, c->update, c->verbose);
+			continue;
 		}
 		if (dv->devname[0] == '/')
 			mdfd = open_mddev(dv->devname, 1);
diff --git a/mdadm.h b/mdadm.h
index 6d52bdf..53f8bd1 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -1367,6 +1367,7 @@ extern int Update_subarray(char *dev, char *subarray, char *update, struct mddev
 extern int Wait(char *dev);
 extern int WaitClean(char *dev, int sock, int verbose);
 extern int SetAction(char *dev, char *action);
+extern int ChangeRwhPolicy(char *dev, char *update, int verbose);
 
 extern int Incremental(struct mddev_dev *devlist, struct context *c,
 		       struct supertype *st);
diff --git a/super-intel.c b/super-intel.c
index e524ef0..3b40429 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -448,6 +448,7 @@ enum imsm_update_type {
 	update_general_migration_checkpoint,
 	update_size_change,
 	update_prealloc_badblocks_mem,
+	update_rwh_policy,
 };
 
 struct imsm_update_activate_spare {
@@ -540,6 +541,12 @@ struct imsm_update_prealloc_bb_mem {
 	enum imsm_update_type type;
 };
 
+struct imsm_update_rwh_policy {
+	enum imsm_update_type type;
+	int new_policy;
+	int dev_idx;
+};
+
 static const char *_sys_dev_type[] = {
 	[SYS_DEV_UNKNOWN] = "Unknown",
 	[SYS_DEV_SAS] = "SAS",
@@ -3175,7 +3182,6 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 	info->custom_array_size   <<= 32;
 	info->custom_array_size   |= __le32_to_cpu(dev->size_low);
 	info->recovery_blocked = imsm_reshape_blocks_arrays_changes(st->sb);
-	info->journal_clean = dev->rwh_policy;
 
 	if (is_gen_migration(dev)) {
 		info->reshape_active = 1;
@@ -3347,6 +3353,8 @@ static void getinfo_super_imsm_volume(struct supertype *st, struct mdinfo *info,
 			info->rwh_policy = RWH_POLICY_PPL;
 		else
 			info->rwh_policy = RWH_POLICY_UNKNOWN;
+
+		info->journal_clean = info->rwh_policy == RWH_POLICY_PPL;
 	}
 }
 
@@ -7183,6 +7191,41 @@ static int update_subarray_imsm(struct supertype *st, char *subarray,
 			}
 			super->updates_pending++;
 		}
+	} else if (strcmp(update, "rwh-policy") == 0) {
+		struct mdinfo *info;
+		int new_policy;
+		char *ep;
+		int vol = strtoul(subarray, &ep, 10);
+
+		if (!ident->st || !ident->st->info)
+			return 2;
+
+		info = ident->st->info;
+
+		if (*ep != '\0' || vol >= super->anchor->num_raid_devs)
+			return 2;
+
+		if (info->rwh_policy == RWH_POLICY_OFF)
+			new_policy = RWH_OFF;
+		else if (info->rwh_policy == RWH_POLICY_PPL)
+			new_policy = RWH_DISTRIBUTED;
+		else
+			return 2;
+
+		if (st->update_tail) {
+			struct imsm_update_rwh_policy *u = xmalloc(sizeof(*u));
+
+			u->type = update_rwh_policy;
+			u->dev_idx = vol;
+			u->new_policy = new_policy;
+			append_metadata_update(st, u, sizeof(*u));
+		} else {
+			struct imsm_dev *dev;
+
+			dev = get_imsm_dev(super, vol);
+			dev->rwh_policy = new_policy;
+			super->updates_pending++;
+		}
 	} else
 		return 2;
 
@@ -9400,6 +9443,21 @@ static void imsm_process_update(struct supertype *st,
 	}
 	case update_prealloc_badblocks_mem:
 		break;
+	case update_rwh_policy: {
+		struct imsm_update_rwh_policy *u = (void *)update->buf;
+		int target = u->dev_idx;
+		struct imsm_dev *dev = get_imsm_dev(super, target);
+		if (!dev) {
+			dprintf("could not find subarray-%d\n", target);
+			break;
+		}
+
+		if (dev->rwh_policy != u->new_policy) {
+			dev->rwh_policy = u->new_policy;
+			super->updates_pending++;
+		}
+		break;
+	}
 	default:
 		pr_err("error: unsuported process update type:(type: %d)\n",	type);
 	}
@@ -9645,6 +9703,11 @@ static int imsm_prepare_update(struct supertype *st,
 		super->extra_space += sizeof(struct bbm_log) -
 			get_imsm_bbm_log_size(super->bbm_log);
 		break;
+	case update_rwh_policy: {
+		if (update->len < (int)sizeof(struct imsm_update_rwh_policy))
+			return 0;
+		break;
+	}
 	default:
 		return 0;
 	}
-- 
2.10.1

