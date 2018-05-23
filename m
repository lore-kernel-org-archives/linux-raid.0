From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 4/6] openvswitch: convert to genradix
Date: Wed, 23 May 2018 05:34:01 -0700
Message-ID: <20180523123401.GB19987@bombadil.infradead.org>
References: <20180523011821.12165-1-kent.overstreet@gmail.com>
 <20180523011821.12165-4-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180523011821.12165-4-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, dev@openvswitch.org, shli@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 22, 2018 at 09:18:19PM -0400, Kent Overstreet wrote:
> the new generic radix trees have a simpler API and implementation, and
> no limitations on number of elements, so all flex_array users are being
> converted

This doesn't really feel like it should be a flexarray / genradix user.
It just wants to allocate a lot of buckets and use them.  Maybe kvmalloc
is the right approach for this user of flexarray?

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>

 net/openvswitch/flow.h         |  1 -
 net/openvswitch/flow_netlink.h |  1 -
 net/openvswitch/flow_table.c   | 49 +++++++++++-------------------------------
 net/openvswitch/flow_table.h   |  3 +--
 4 files changed, 13 insertions(+), 41 deletions(-)

diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
index c670dd24b8b7..4f06278166d9 100644
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
index 6657606b2b47..66f9553758a5 100644
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
index 80ea2a71852e..909372bd2621 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -111,29 +111,6 @@ int ovs_flow_tbl_count(const struct flow_table *table)
 	return table->count;
 }
 
-static struct flex_array *alloc_buckets(unsigned int n_buckets)
-{
-	struct flex_array *buckets;
-	int i, err;
-
-	buckets = flex_array_alloc(sizeof(struct hlist_head),
-				   n_buckets, GFP_KERNEL);
-	if (!buckets)
-		return NULL;
-
-	err = flex_array_prealloc(buckets, 0, n_buckets, GFP_KERNEL);
-	if (err) {
-		flex_array_free(buckets);
-		return NULL;
-	}
-
-	for (i = 0; i < n_buckets; i++)
-		INIT_HLIST_HEAD((struct hlist_head *)
-					flex_array_get(buckets, i));
-
-	return buckets;
-}
-
 static void flow_free(struct sw_flow *flow)
 {
 	int cpu;
@@ -168,31 +145,30 @@ void ovs_flow_free(struct sw_flow *flow, bool deferred)
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
+	kvfree(ti->buckets);
 	kfree(ti);
 }
 
 static struct table_instance *table_instance_alloc(int new_size)
 {
 	struct table_instance *ti = kmalloc(sizeof(*ti), GFP_KERNEL);
+	int i;
 
 	if (!ti)
 		return NULL;
 
-	ti->buckets = alloc_buckets(new_size);
-
+	ti->buckets = kvmalloc(sizeof(struct hlist_head) * new_size,
+			GFP_KERNEL);
 	if (!ti->buckets) {
 		kfree(ti);
 		return NULL;
 	}
+
+	for (i = 0; i < new_size; i++)
+		INIT_HLIST_HEAD(&ti->buckets[i]);
+
 	ti->n_buckets = new_size;
 	ti->node_ver = 0;
 	ti->keep_flows = false;
@@ -249,7 +225,7 @@ static void table_instance_destroy(struct table_instance *ti,
 
 	for (i = 0; i < ti->n_buckets; i++) {
 		struct sw_flow *flow;
-		struct hlist_head *head = flex_array_get(ti->buckets, i);
+		struct hlist_head *head = &ti->buckets[i];
 		struct hlist_node *n;
 		int ver = ti->node_ver;
 		int ufid_ver = ufid_ti->node_ver;
@@ -294,7 +270,7 @@ struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
 	ver = ti->node_ver;
 	while (*bucket < ti->n_buckets) {
 		i = 0;
-		head = flex_array_get(ti->buckets, *bucket);
+		head = &ti->buckets[*bucket];
 		hlist_for_each_entry_rcu(flow, head, flow_table.node[ver]) {
 			if (i < *last) {
 				i++;
@@ -313,8 +289,7 @@ struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
 static struct hlist_head *find_bucket(struct table_instance *ti, u32 hash)
 {
 	hash = jhash_1word(hash, ti->hash_seed);
-	return flex_array_get(ti->buckets,
-				(hash & (ti->n_buckets - 1)));
+	return &ti->buckets[hash & (ti->n_buckets - 1)];
 }
 
 static void table_instance_insert(struct table_instance *ti,
@@ -349,7 +324,7 @@ static void flow_table_copy_flows(struct table_instance *old,
 		struct sw_flow *flow;
 		struct hlist_head *head;
 
-		head = flex_array_get(old->buckets, i);
+		head = &old->buckets[i];
 
 		if (ufid)
 			hlist_for_each_entry(flow, head,
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 2dd9900f533d..de5ec6cf5174 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -29,7 +29,6 @@
 #include <linux/in6.h>
 #include <linux/jiffies.h>
 #include <linux/time.h>
-#include <linux/flex_array.h>
 
 #include <net/inet_ecn.h>
 #include <net/ip_tunnels.h>
@@ -37,7 +36,7 @@
 #include "flow.h"
 
 struct table_instance {
-	struct flex_array *buckets;
+	struct hlist_head *buckets;
 	unsigned int n_buckets;
 	struct rcu_head rcu;
 	int node_ver;
