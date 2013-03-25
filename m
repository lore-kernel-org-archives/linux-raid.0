From: mwilck@arcor.de
Subject: [PATCH 4/8] DDF: add code to debug state changes
Date: Mon, 25 Mar 2013 23:11:09 +0000 (UTC)
Message-ID: <1382695659-6231-5-git-send-email-mwilck@arcor.de>
References: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Date: Fri, 25 Oct 2013 12:07:35 +0200
In-Reply-To: <1382695659-6231-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

The 10ddf-create test case fails sporadically because wrong meta
data is written, making the array appear inconsistent when it's
restarted. Added code to aid debugging this.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   49 ++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index bd08d85..455f0f8 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -446,6 +446,28 @@ struct ddf_super {
 #define offsetof(t,f) ((size_t)&(((t*)0)->f))
 #endif
 
+#if DEBUG
+static int all_ff(char *guid);
+static void pr_state(struct ddf_super *ddf, const char *msg)
+{
+	unsigned int i;
+	dprintf("%s/%s: ", __func__, msg);
+	for (i = 0; i < __be16_to_cpu(ddf->active->max_vd_entries); i++) {
+		if (all_ff(ddf->virt->entries[i].guid))
+			continue;
+		dprintf("%u(s=%02x i=%02x) ", i,
+			ddf->virt->entries[i].state,
+			ddf->virt->entries[i].init_state);
+	}
+	dprintf("\n");
+}
+#else
+static void pr_state(const struct ddf_super *ddf, const char *msg) {}
+#endif
+
+#define ddf_set_updates_pending(x) \
+	do { (x)->updates_pending = 1; pr_state(x, __func__); } while (0)
+
 static unsigned int calc_crc(void *buf, int len)
 {
 	/* crcs are always at the same place as in the ddf_header */
@@ -1886,7 +1908,7 @@ static int init_super_ddf(struct supertype *st,
 		memset(&vd->entries[i], 0xff, sizeof(struct virtual_entry));
 
 	st->sb = ddf;
-	ddf->updates_pending = 1;
+	ddf_set_updates_pending(ddf);
 	return 1;
 }
 
@@ -2164,7 +2186,7 @@ static int init_super_ddf_bvd(struct supertype *st,
 	vcl->next = ddf->conflist;
 	ddf->conflist = vcl;
 	ddf->currentconf = vcl;
-	ddf->updates_pending = 1;
+	ddf_set_updates_pending(ddf);
 	return 1;
 }
 
@@ -2268,7 +2290,7 @@ static void add_to_super_ddf_bvd(struct supertype *st,
 
 	ddf->phys->entries[dl->pdnum].type &= ~__cpu_to_be16(DDF_Global_Spare);
 	ddf->phys->entries[dl->pdnum].type |= __cpu_to_be16(DDF_Active_in_VD);
-	ddf->updates_pending = 1;
+	ddf_set_updates_pending(ddf);
 }
 
 /* add a device to a container, either while creating it or while
@@ -2371,7 +2393,7 @@ static int add_to_super_ddf(struct supertype *st,
 	} else {
 		dd->next = ddf->dlist;
 		ddf->dlist = dd;
-		ddf->updates_pending = 1;
+		ddf_set_updates_pending(ddf);
 	}
 
 	return 0;
@@ -2520,6 +2542,7 @@ static int __write_init_super_ddf(struct supertype *st)
 	char *null_aligned;
 	__u32 seq;
 
+	pr_state(ddf, __func__);
 	if (posix_memalign((void**)&null_aligned, 4096, NULL_CONF_SZ) != 0) {
 		return -ENOMEM;
 	}
@@ -3599,7 +3622,7 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 	else
 		ddf->virt->entries[inst].state |= DDF_state_inconsistent;
 	if (old != ddf->virt->entries[inst].state)
-		ddf->updates_pending = 1;
+		ddf_set_updates_pending(ddf);
 
 	old = ddf->virt->entries[inst].init_state;
 	ddf->virt->entries[inst].init_state &= ~DDF_initstate_mask;
@@ -3610,7 +3633,7 @@ static int ddf_set_array_state(struct active_array *a, int consistent)
 	else
 		ddf->virt->entries[inst].init_state |= DDF_init_quick;
 	if (old != ddf->virt->entries[inst].init_state)
-		ddf->updates_pending = 1;
+		ddf_set_updates_pending(ddf);
 
 	dprintf("ddf mark %d %s %llu\n", inst, consistent?"clean":"dirty",
 		a->info.resync_start);
@@ -3677,7 +3700,7 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 				~__cpu_to_be16(DDF_Global_Spare);
 			ddf->phys->entries[pd].type |=
 				__cpu_to_be16(DDF_Active_in_VD);
-			ddf->updates_pending = 1;
+			ddf_set_updates_pending(ddf);
 		}
 	} else {
 		int old = ddf->phys->entries[pd].state;
@@ -3688,7 +3711,7 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 			ddf->phys->entries[pd].state  &= __cpu_to_be16(~DDF_Rebuilding);
 		}
 		if (old != ddf->phys->entries[pd].state)
-			ddf->updates_pending = 1;
+			ddf_set_updates_pending(ddf);
 	}
 
 	dprintf("ddf: set_disk %d to %x\n", n, state);
@@ -3743,7 +3766,7 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 		ddf->virt->entries[inst].state =
 			(ddf->virt->entries[inst].state & ~DDF_state_mask)
 			| state;
-		ddf->updates_pending = 1;
+		ddf_set_updates_pending(ddf);
 	}
 
 }
@@ -3836,7 +3859,7 @@ static void ddf_process_update(struct supertype *st,
 					break;
 				}
 			}
-			ddf->updates_pending = 1;
+			ddf_set_updates_pending(ddf);
 			return;
 		}
 		if (!all_ff(ddf->phys->entries[ent].guid))
@@ -3844,7 +3867,7 @@ static void ddf_process_update(struct supertype *st,
 		ddf->phys->entries[ent] = pd->entries[0];
 		ddf->phys->used_pdes = __cpu_to_be16(1 +
 						     __be16_to_cpu(ddf->phys->used_pdes));
-		ddf->updates_pending = 1;
+		ddf_set_updates_pending(ddf);
 		if (ddf->add_list) {
 			struct active_array *a;
 			struct dl *al = ddf->add_list;
@@ -3876,7 +3899,7 @@ static void ddf_process_update(struct supertype *st,
 		ddf->virt->entries[ent] = vd->entries[0];
 		ddf->virt->populated_vdes = __cpu_to_be16(1 +
 							  __be16_to_cpu(ddf->virt->populated_vdes));
-		ddf->updates_pending = 1;
+		ddf_set_updates_pending(ddf);
 		break;
 
 	case DDF_VD_CONF_MAGIC:
@@ -4005,7 +4028,7 @@ static void ddf_process_update(struct supertype *st,
 			pd2++;
 		}
 
-		ddf->updates_pending = 1;
+		ddf_set_updates_pending(ddf);
 		break;
 	case DDF_SPARE_ASSIGN_MAGIC:
 	default: break;
-- 
1.7.1
