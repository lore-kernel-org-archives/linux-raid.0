From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 4/6] openvswitch: convert to genradix
Date: Tue, 22 May 2018 21:18:19 -0400
Message-ID: <20180523011821.12165-4-kent.overstreet@gmail.com>
References: <20180523011821.12165-1-kent.overstreet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180523011821.12165-1-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, willy@infradead.org, gregkh@linuxfoundation.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, dev@openvswitch.org, shli@kernel.org, linux-raid@vger.kernel.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>
List-Id: linux-raid.ids

the new generic radix trees have a simpler API and implementation, and
no limitations on number of elements, so all flex_array users are being
converted

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
---
 net/openvswitch/flow.h         |  1 -
 net/openvswitch/flow_netlink.h |  1 -
 net/openvswitch/flow_table.c   | 45 ++++++++++------------------------
 net/openvswitch/flow_table.h   |  4 +--
 4 files changed, 15 insertions(+), 36 deletions(-)

diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index c670dd24b8..4f06278166 100644
--- a/net/openvswitch/flow.h
+++ b/net/openvswitch/flow.h
@@ -30,7 +30,6 @@
 #include <linux/in6.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
-#include <linux/flex_array.h>
 #include <linux/cpumask.h>
 #include <net/inet_ecn.h>
 #include <net/ip_tunnels.h>
diff --git a/net/openvswitch/flow_netlink.h b/net/openvswitch/flow_netlink.h
index 6657606b2b..66f9553758 100644
--- a/net/openvswitch/flow_netlink.h
+++ b/net/openvswitch/flow_netlink.h
@@ -30,7 +30,6 @@
 #include <linux/in6.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
-#include <linux/flex_array.h>
 
 #include <net/inet_ecn.h>
 #include <net/ip_tunnels.h>
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 80ea2a7185..284f44d832 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -111,27 +111,19 @@ int ovs_flow_tbl_count(const struct flow_table *table)
 	return table->count;
 }
 
-static struct flex_array *alloc_buckets(unsigned int n_buckets)
+static int alloc_buckets(struct table_instance *ti, unsigned int n_buckets)
 {
-	struct flex_array *buckets;
-	int i, err;
+	int i;
 
-	buckets = flex_array_alloc(sizeof(struct hlist_head),
-				   n_buckets, GFP_KERNEL);
-	if (!buckets)
-		return NULL;
+	genradix_init(&ti->buckets);
 
-	err = flex_array_prealloc(buckets, 0, n_buckets, GFP_KERNEL);
-	if (err) {
-		flex_array_free(buckets);
-		return NULL;
-	}
+	if (genradix_prealloc(&ti->buckets, n_buckets, GFP_KERNEL))
+		return -ENOMEM;
 
 	for (i = 0; i < n_buckets; i++)
-		INIT_HLIST_HEAD((struct hlist_head *)
-					flex_array_get(buckets, i));
+		INIT_HLIST_HEAD(genradix_ptr(&ti->buckets, i));
 
-	return buckets;
+	return 0;
 }
 
 static void flow_free(struct sw_flow *flow)
@@ -168,15 +160,9 @@ void ovs_flow_free(struct sw_flow *flow, bool deferred)
 		flow_free(flow);
 }
 
-static void free_buckets(struct flex_array *buckets)
-{
-	flex_array_free(buckets);
-}
-
-
 static void __table_instance_destroy(struct table_instance *ti)
 {
-	free_buckets(ti->buckets);
+	genradix_free(&ti->buckets);
 	kfree(ti);
 }
 
@@ -187,9 +173,7 @@ static struct table_instance *table_instance_alloc(int new_size)
 	if (!ti)
 		return NULL;
 
-	ti->buckets = alloc_buckets(new_size);
-
-	if (!ti->buckets) {
+	if (alloc_buckets(ti, new_size)) {
 		kfree(ti);
 		return NULL;
 	}
@@ -249,7 +233,7 @@ static void table_instance_destroy(struct table_instance *ti,
 
 	for (i = 0; i < ti->n_buckets; i++) {
 		struct sw_flow *flow;
-		struct hlist_head *head = flex_array_get(ti->buckets, i);
+		struct hlist_head *head = genradix_ptr(&ti->buckets, i);
 		struct hlist_node *n;
 		int ver = ti->node_ver;
 		int ufid_ver = ufid_ti->node_ver;
@@ -294,7 +278,7 @@ struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
 	ver = ti->node_ver;
 	while (*bucket < ti->n_buckets) {
 		i = 0;
-		head = flex_array_get(ti->buckets, *bucket);
+		head = genradix_ptr(&ti->buckets, *bucket);
 		hlist_for_each_entry_rcu(flow, head, flow_table.node[ver]) {
 			if (i < *last) {
 				i++;
@@ -313,8 +297,7 @@ struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
 static struct hlist_head *find_bucket(struct table_instance *ti, u32 hash)
 {
 	hash = jhash_1word(hash, ti->hash_seed);
-	return flex_array_get(ti->buckets,
-				(hash & (ti->n_buckets - 1)));
+	return genradix_ptr(&ti->buckets, hash & (ti->n_buckets - 1));
 }
 
 static void table_instance_insert(struct table_instance *ti,
@@ -347,9 +330,7 @@ static void flow_table_copy_flows(struct table_instance *old,
 	/* Insert in new table. */
 	for (i = 0; i < old->n_buckets; i++) {
 		struct sw_flow *flow;
-		struct hlist_head *head;
-
-		head = flex_array_get(old->buckets, i);
+		struct hlist_head *head = genradix_ptr(&old->buckets, i);
 
 		if (ufid)
 			hlist_for_each_entry(flow, head,
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 2dd9900f53..57fe93570a 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -29,7 +29,7 @@
 #include <linux/in6.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
-#include <linux/flex_array.h>
+#include <linux/generic-radix-tree.h>
 
 #include <net/inet_ecn.h>
 #include <net/ip_tunnels.h>
@@ -37,7 +37,7 @@
 #include "flow.h"
 
 struct table_instance {
-	struct flex_array *buckets;
+	GENRADIX(struct hlist_head) buckets;
 	unsigned int n_buckets;
 	struct rcu_head rcu;
 	int node_ver;
-- 
2.17.0
