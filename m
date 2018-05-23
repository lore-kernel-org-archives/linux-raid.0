From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: [PATCH 5/6] selinux: convert to genradix
Date: Tue, 22 May 2018 21:18:20 -0400
Message-ID: <20180523011821.12165-5-kent.overstreet@gmail.com>
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
 security/selinux/ss/avtab.c       |  44 +++++------
 security/selinux/ss/avtab.h       |   5 +-
 security/selinux/ss/conditional.c |   8 +-
 security/selinux/ss/policydb.c    | 127 +++++++++++-------------------
 security/selinux/ss/policydb.h    |  12 ++-
 security/selinux/ss/services.c    |  25 +++---
 6 files changed, 86 insertions(+), 135 deletions(-)

diff --git a/security/selinux/ss/avtab.c b/security/selinux/ss/avtab.c
index 2c3c7d010d..7066d52e74 100644
--- a/security/selinux/ss/avtab.c
+++ b/security/selinux/ss/avtab.c
@@ -93,12 +93,10 @@ avtab_insert_node(struct avtab *h, int hvalue,
 		newnode->next = prev->next;
 		prev->next = newnode;
 	} else {
-		newnode->next = flex_array_get_ptr(h->htable, hvalue);
-		if (flex_array_put_ptr(h->htable, hvalue, newnode,
-				       GFP_KERNEL|__GFP_ZERO)) {
-			kmem_cache_free(avtab_node_cachep, newnode);
-			return NULL;
-		}
+		struct avtab_node **n = genradix_ptr(&h->htable, hvalue);
+
+		newnode->next = *n;
+		*n = newnode;
 	}
 
 	h->nel++;
@@ -111,11 +109,11 @@ static int avtab_insert(struct avtab *h, struct avtab_key *key, struct avtab_dat
 	struct avtab_node *prev, *cur, *newnode;
 	u16 specified = key->specified & ~(AVTAB_ENABLED|AVTAB_ENABLED_OLD);
 
-	if (!h || !h->htable)
+	if (!h)
 		return -EINVAL;
 
 	hvalue = avtab_hash(key, h->mask);
-	for (prev = NULL, cur = flex_array_get_ptr(h->htable, hvalue);
+	for (prev = NULL, cur = *genradix_ptr(&h->htable, hvalue);
 	     cur;
 	     prev = cur, cur = cur->next) {
 		if (key->source_type == cur->key.source_type &&
@@ -156,10 +154,10 @@ avtab_insert_nonunique(struct avtab *h, struct avtab_key *key, struct avtab_datu
 	struct avtab_node *prev, *cur;
 	u16 specified = key->specified & ~(AVTAB_ENABLED|AVTAB_ENABLED_OLD);
 
-	if (!h || !h->htable)
+	if (!h)
 		return NULL;
 	hvalue = avtab_hash(key, h->mask);
-	for (prev = NULL, cur = flex_array_get_ptr(h->htable, hvalue);
+	for (prev = NULL, cur = *genradix_ptr(&h->htable, hvalue);
 	     cur;
 	     prev = cur, cur = cur->next) {
 		if (key->source_type == cur->key.source_type &&
@@ -186,11 +184,11 @@ struct avtab_datum *avtab_search(struct avtab *h, struct avtab_key *key)
 	struct avtab_node *cur;
 	u16 specified = key->specified & ~(AVTAB_ENABLED|AVTAB_ENABLED_OLD);
 
-	if (!h || !h->htable)
+	if (!h)
 		return NULL;
 
 	hvalue = avtab_hash(key, h->mask);
-	for (cur = flex_array_get_ptr(h->htable, hvalue); cur;
+	for (cur = *genradix_ptr(&h->htable, hvalue); cur;
 	     cur = cur->next) {
 		if (key->source_type == cur->key.source_type &&
 		    key->target_type == cur->key.target_type &&
@@ -222,11 +220,11 @@ avtab_search_node(struct avtab *h, struct avtab_key *key)
 	struct avtab_node *cur;
 	u16 specified = key->specified & ~(AVTAB_ENABLED|AVTAB_ENABLED_OLD);
 
-	if (!h || !h->htable)
+	if (!h)
 		return NULL;
 
 	hvalue = avtab_hash(key, h->mask);
-	for (cur = flex_array_get_ptr(h->htable, hvalue); cur;
+	for (cur = *genradix_ptr(&h->htable, hvalue); cur;
 	     cur = cur->next) {
 		if (key->source_type == cur->key.source_type &&
 		    key->target_type == cur->key.target_type &&
@@ -281,11 +279,11 @@ void avtab_destroy(struct avtab *h)
 	int i;
 	struct avtab_node *cur, *temp;
 
-	if (!h || !h->htable)
+	if (!h)
 		return;
 
 	for (i = 0; i < h->nslot; i++) {
-		cur = flex_array_get_ptr(h->htable, i);
+		cur = *genradix_ptr(&h->htable, i);
 		while (cur) {
 			temp = cur;
 			cur = cur->next;
@@ -295,15 +293,14 @@ void avtab_destroy(struct avtab *h)
 			kmem_cache_free(avtab_node_cachep, temp);
 		}
 	}
-	flex_array_free(h->htable);
-	h->htable = NULL;
+	genradix_free(&h->htable);
 	h->nslot = 0;
 	h->mask = 0;
 }
 
 int avtab_init(struct avtab *h)
 {
-	h->htable = NULL;
+	genradix_init(&h->htable);
 	h->nel = 0;
 	return 0;
 }
@@ -329,9 +326,8 @@ int avtab_alloc(struct avtab *h, u32 nrules)
 		nslot = MAX_AVTAB_HASH_BUCKETS;
 	mask = nslot - 1;
 
-	h->htable = flex_array_alloc(sizeof(struct avtab_node *), nslot,
-				     GFP_KERNEL | __GFP_ZERO);
-	if (!h->htable)
+	genradix_init(&h->htable);
+	if (genradix_prealloc(&h->htable, nslot, GFP_KERNEL))
 		return -ENOMEM;
 
  avtab_alloc_out:
@@ -353,7 +349,7 @@ void avtab_hash_eval(struct avtab *h, char *tag)
 	max_chain_len = 0;
 	chain2_len_sum = 0;
 	for (i = 0; i < h->nslot; i++) {
-		cur = flex_array_get_ptr(h->htable, i);
+		cur = *genradix_ptr(&h->htable, i);
 		if (cur) {
 			slots_used++;
 			chain_len = 0;
@@ -645,7 +641,7 @@ int avtab_write(struct policydb *p, struct avtab *a, void *fp)
 		return rc;
 
 	for (i = 0; i < a->nslot; i++) {
-		for (cur = flex_array_get_ptr(a->htable, i); cur;
+		for (cur = *genradix_ptr(&a->htable, i); cur;
 		     cur = cur->next) {
 			rc = avtab_write_item(p, cur, fp);
 			if (rc)
diff --git a/security/selinux/ss/avtab.h b/security/selinux/ss/avtab.h
index 725853cadc..7f00c41e96 100644
--- a/security/selinux/ss/avtab.h
+++ b/security/selinux/ss/avtab.h
@@ -24,7 +24,7 @@
 #define _SS_AVTAB_H_
 
 #include "security.h"
-#include <linux/flex_array.h>
+#include <linux/generic-radix-tree.h>
 
 struct avtab_key {
 	u16 source_type;	/* source type */
@@ -84,11 +84,10 @@ struct avtab_node {
 };
 
 struct avtab {
-	struct flex_array *htable;
+	GENRADIX(struct avtab_node *) htable;
 	u32 nel;	/* number of elements */
 	u32 nslot;      /* number of hash slots */
 	u32 mask;       /* mask to compute hash func */
-
 };
 
 int avtab_init(struct avtab *);
diff --git a/security/selinux/ss/conditional.c b/security/selinux/ss/conditional.c
index c91543a617..d25ef70748 100644
--- a/security/selinux/ss/conditional.c
+++ b/security/selinux/ss/conditional.c
@@ -195,7 +195,6 @@ int cond_index_bool(void *key, void *datum, void *datap)
 {
 	struct policydb *p;
 	struct cond_bool_datum *booldatum;
-	struct flex_array *fa;
 
 	booldatum = datum;
 	p = datap;
@@ -203,10 +202,9 @@ int cond_index_bool(void *key, void *datum, void *datap)
 	if (!booldatum->value || booldatum->value > p->p_bools.nprim)
 		return -EINVAL;
 
-	fa = p->sym_val_to_name[SYM_BOOLS];
-	if (flex_array_put_ptr(fa, booldatum->value - 1, key,
-			       GFP_KERNEL | __GFP_ZERO))
-		BUG();
+	*genradix_ptr(&p->sym_val_to_name[SYM_BOOLS],
+		      booldatum->value - 1) = key;
+
 	p->bool_val_to_struct[booldatum->value - 1] = booldatum;
 
 	return 0;
diff --git a/security/selinux/ss/policydb.c b/security/selinux/ss/policydb.c
index 6e8c8056d7..3df39258c9 100644
--- a/security/selinux/ss/policydb.c
+++ b/security/selinux/ss/policydb.c
@@ -36,7 +36,6 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/audit.h>
-#include <linux/flex_array.h>
 #include "security.h"
 
 #include "policydb.h"
@@ -341,17 +340,15 @@ static int common_index(void *key, void *datum, void *datap)
 {
 	struct policydb *p;
 	struct common_datum *comdatum;
-	struct flex_array *fa;
 
 	comdatum = datum;
 	p = datap;
 	if (!comdatum->value || comdatum->value > p->p_commons.nprim)
 		return -EINVAL;
 
-	fa = p->sym_val_to_name[SYM_COMMONS];
-	if (flex_array_put_ptr(fa, comdatum->value - 1, key,
-			       GFP_KERNEL | __GFP_ZERO))
-		BUG();
+	*genradix_ptr(&p->sym_val_to_name[SYM_COMMONS],
+		      comdatum->value - 1) = key;
+
 	return 0;
 }
 
@@ -359,16 +356,15 @@ static int class_index(void *key, void *datum, void *datap)
 {
 	struct policydb *p;
 	struct class_datum *cladatum;
-	struct flex_array *fa;
 
 	cladatum = datum;
 	p = datap;
 	if (!cladatum->value || cladatum->value > p->p_classes.nprim)
 		return -EINVAL;
-	fa = p->sym_val_to_name[SYM_CLASSES];
-	if (flex_array_put_ptr(fa, cladatum->value - 1, key,
-			       GFP_KERNEL | __GFP_ZERO))
-		BUG();
+
+	*genradix_ptr(&p->sym_val_to_name[SYM_CLASSES],
+		      cladatum->value - 1) = key;
+
 	p->class_val_to_struct[cladatum->value - 1] = cladatum;
 	return 0;
 }
@@ -377,7 +373,6 @@ static int role_index(void *key, void *datum, void *datap)
 {
 	struct policydb *p;
 	struct role_datum *role;
-	struct flex_array *fa;
 
 	role = datum;
 	p = datap;
@@ -386,10 +381,9 @@ static int role_index(void *key, void *datum, void *datap)
 	    || role->bounds > p->p_roles.nprim)
 		return -EINVAL;
 
-	fa = p->sym_val_to_name[SYM_ROLES];
-	if (flex_array_put_ptr(fa, role->value - 1, key,
-			       GFP_KERNEL | __GFP_ZERO))
-		BUG();
+	*genradix_ptr(&p->sym_val_to_name[SYM_ROLES],
+		      role->value - 1) = key;
+
 	p->role_val_to_struct[role->value - 1] = role;
 	return 0;
 }
@@ -398,7 +392,6 @@ static int type_index(void *key, void *datum, void *datap)
 {
 	struct policydb *p;
 	struct type_datum *typdatum;
-	struct flex_array *fa;
 
 	typdatum = datum;
 	p = datap;
@@ -408,15 +401,11 @@ static int type_index(void *key, void *datum, void *datap)
 		    || typdatum->value > p->p_types.nprim
 		    || typdatum->bounds > p->p_types.nprim)
 			return -EINVAL;
-		fa = p->sym_val_to_name[SYM_TYPES];
-		if (flex_array_put_ptr(fa, typdatum->value - 1, key,
-				       GFP_KERNEL | __GFP_ZERO))
-			BUG();
+		*genradix_ptr(&p->sym_val_to_name[SYM_TYPES],
+			      typdatum->value - 1) = key;
 
-		fa = p->type_val_to_struct_array;
-		if (flex_array_put_ptr(fa, typdatum->value - 1, typdatum,
-				       GFP_KERNEL | __GFP_ZERO))
-			BUG();
+		*genradix_ptr(&p->type_val_to_struct_array,
+			     typdatum->value - 1) = typdatum;
 	}
 
 	return 0;
@@ -426,7 +415,6 @@ static int user_index(void *key, void *datum, void *datap)
 {
 	struct policydb *p;
 	struct user_datum *usrdatum;
-	struct flex_array *fa;
 
 	usrdatum = datum;
 	p = datap;
@@ -435,10 +423,9 @@ static int user_index(void *key, void *datum, void *datap)
 	    || usrdatum->bounds > p->p_users.nprim)
 		return -EINVAL;
 
-	fa = p->sym_val_to_name[SYM_USERS];
-	if (flex_array_put_ptr(fa, usrdatum->value - 1, key,
-			       GFP_KERNEL | __GFP_ZERO))
-		BUG();
+	*genradix_ptr(&p->sym_val_to_name[SYM_USERS],
+		      usrdatum->value - 1) = key;
+
 	p->user_val_to_struct[usrdatum->value - 1] = usrdatum;
 	return 0;
 }
@@ -447,7 +434,6 @@ static int sens_index(void *key, void *datum, void *datap)
 {
 	struct policydb *p;
 	struct level_datum *levdatum;
-	struct flex_array *fa;
 
 	levdatum = datum;
 	p = datap;
@@ -456,10 +442,8 @@ static int sens_index(void *key, void *datum, void *datap)
 		if (!levdatum->level->sens ||
 		    levdatum->level->sens > p->p_levels.nprim)
 			return -EINVAL;
-		fa = p->sym_val_to_name[SYM_LEVELS];
-		if (flex_array_put_ptr(fa, levdatum->level->sens - 1, key,
-				       GFP_KERNEL | __GFP_ZERO))
-			BUG();
+		*genradix_ptr(&p->sym_val_to_name[SYM_LEVELS],
+			      levdatum->level->sens - 1) = key;
 	}
 
 	return 0;
@@ -469,7 +453,6 @@ static int cat_index(void *key, void *datum, void *datap)
 {
 	struct policydb *p;
 	struct cat_datum *catdatum;
-	struct flex_array *fa;
 
 	catdatum = datum;
 	p = datap;
@@ -477,10 +460,8 @@ static int cat_index(void *key, void *datum, void *datap)
 	if (!catdatum->isalias) {
 		if (!catdatum->value || catdatum->value > p->p_cats.nprim)
 			return -EINVAL;
-		fa = p->sym_val_to_name[SYM_CATS];
-		if (flex_array_put_ptr(fa, catdatum->value - 1, key,
-				       GFP_KERNEL | __GFP_ZERO))
-			BUG();
+		*genradix_ptr(&p->sym_val_to_name[SYM_CATS],
+			      catdatum->value - 1) = key;
 	}
 
 	return 0;
@@ -566,15 +547,10 @@ static int policydb_index(struct policydb *p)
 	if (!p->user_val_to_struct)
 		return -ENOMEM;
 
-	/* Yes, I want the sizeof the pointer, not the structure */
-	p->type_val_to_struct_array = flex_array_alloc(sizeof(struct type_datum *),
-						       p->p_types.nprim,
-						       GFP_KERNEL | __GFP_ZERO);
-	if (!p->type_val_to_struct_array)
-		return -ENOMEM;
+	genradix_init(&p->type_val_to_struct_array);
 
-	rc = flex_array_prealloc(p->type_val_to_struct_array, 0,
-				 p->p_types.nprim, GFP_KERNEL | __GFP_ZERO);
+	rc = genradix_prealloc(&p->type_val_to_struct_array,
+			       p->p_types.nprim, GFP_KERNEL);
 	if (rc)
 		goto out;
 
@@ -583,15 +559,10 @@ static int policydb_index(struct policydb *p)
 		goto out;
 
 	for (i = 0; i < SYM_NUM; i++) {
-		p->sym_val_to_name[i] = flex_array_alloc(sizeof(char *),
-							 p->symtab[i].nprim,
-							 GFP_KERNEL | __GFP_ZERO);
-		if (!p->sym_val_to_name[i])
-			return -ENOMEM;
+		genradix_init(&p->sym_val_to_name[i]);
 
-		rc = flex_array_prealloc(p->sym_val_to_name[i],
-					 0, p->symtab[i].nprim,
-					 GFP_KERNEL | __GFP_ZERO);
+		rc = genradix_prealloc(&p->sym_val_to_name[i],
+				       p->symtab[i].nprim, GFP_KERNEL);
 		if (rc)
 			goto out;
 
@@ -807,16 +778,13 @@ void policydb_destroy(struct policydb *p)
 		hashtab_destroy(p->symtab[i].table);
 	}
 
-	for (i = 0; i < SYM_NUM; i++) {
-		if (p->sym_val_to_name[i])
-			flex_array_free(p->sym_val_to_name[i]);
-	}
+	for (i = 0; i < SYM_NUM; i++)
+		genradix_free(&p->sym_val_to_name[i]);
 
 	kfree(p->class_val_to_struct);
 	kfree(p->role_val_to_struct);
 	kfree(p->user_val_to_struct);
-	if (p->type_val_to_struct_array)
-		flex_array_free(p->type_val_to_struct_array);
+	genradix_free(&p->type_val_to_struct_array);
 
 	avtab_destroy(&p->te_avtab);
 
@@ -869,17 +837,15 @@ void policydb_destroy(struct policydb *p)
 	hashtab_map(p->range_tr, range_tr_destroy, NULL);
 	hashtab_destroy(p->range_tr);
 
-	if (p->type_attr_map_array) {
-		for (i = 0; i < p->p_types.nprim; i++) {
-			struct ebitmap *e;
+	for (i = 0; i < p->p_types.nprim; i++) {
+		struct ebitmap *e;
 
-			e = flex_array_get(p->type_attr_map_array, i);
-			if (!e)
-				continue;
-			ebitmap_destroy(e);
-		}
-		flex_array_free(p->type_attr_map_array);
+		e = genradix_ptr(&p->type_attr_map_array, i);
+		if (!e)
+			continue;
+		ebitmap_destroy(e);
 	}
+	genradix_free(&p->type_attr_map_array);
 
 	ebitmap_destroy(&p->filename_trans_ttypes);
 	ebitmap_destroy(&p->policycaps);
@@ -1760,8 +1726,8 @@ static int type_bounds_sanity_check(void *key, void *datum, void *datap)
 			return -EINVAL;
 		}
 
-		upper = flex_array_get_ptr(p->type_val_to_struct_array,
-					   upper->bounds - 1);
+		upper = *genradix_ptr(&p->type_val_to_struct_array,
+				      upper->bounds - 1);
 		BUG_ON(!upper);
 
 		if (upper->attribute) {
@@ -2518,21 +2484,16 @@ int policydb_read(struct policydb *p, void *fp)
 	if (rc)
 		goto bad;
 
-	rc = -ENOMEM;
-	p->type_attr_map_array = flex_array_alloc(sizeof(struct ebitmap),
-						  p->p_types.nprim,
-						  GFP_KERNEL | __GFP_ZERO);
-	if (!p->type_attr_map_array)
-		goto bad;
+	genradix_init(&p->type_attr_map_array);
 
 	/* preallocate so we don't have to worry about the put ever failing */
-	rc = flex_array_prealloc(p->type_attr_map_array, 0, p->p_types.nprim,
-				 GFP_KERNEL | __GFP_ZERO);
+	rc = genradix_prealloc(&p->type_attr_map_array, p->p_types.nprim,
+			       GFP_KERNEL);
 	if (rc)
 		goto bad;
 
 	for (i = 0; i < p->p_types.nprim; i++) {
-		struct ebitmap *e = flex_array_get(p->type_attr_map_array, i);
+		struct ebitmap *e = genradix_ptr(&p->type_attr_map_array, i);
 
 		BUG_ON(!e);
 		ebitmap_init(e);
@@ -3523,7 +3484,7 @@ int policydb_write(struct policydb *p, void *fp)
 		return rc;
 
 	for (i = 0; i < p->p_types.nprim; i++) {
-		struct ebitmap *e = flex_array_get(p->type_attr_map_array, i);
+		struct ebitmap *e = genradix_ptr(&p->type_attr_map_array, i);
 
 		BUG_ON(!e);
 		rc = ebitmap_write(e, fp);
diff --git a/security/selinux/ss/policydb.h b/security/selinux/ss/policydb.h
index 215f8f30ac..1ba102463e 100644
--- a/security/selinux/ss/policydb.h
+++ b/security/selinux/ss/policydb.h
@@ -24,7 +24,7 @@
 #ifndef _SS_POLICYDB_H_
 #define _SS_POLICYDB_H_
 
-#include <linux/flex_array.h>
+#include <linux/generic-radix-tree.h>
 
 #include "symtab.h"
 #include "avtab.h"
@@ -251,13 +251,13 @@ struct policydb {
 #define p_cats symtab[SYM_CATS]
 
 	/* symbol names indexed by (value - 1) */
-	struct flex_array *sym_val_to_name[SYM_NUM];
+	GENRADIX(char *) sym_val_to_name[SYM_NUM];
 
 	/* class, role, and user attributes indexed by (value - 1) */
 	struct class_datum **class_val_to_struct;
 	struct role_datum **role_val_to_struct;
 	struct user_datum **user_val_to_struct;
-	struct flex_array *type_val_to_struct_array;
+	GENRADIX(struct type_datum *) type_val_to_struct_array;
 
 	/* type enforcement access vectors and transitions */
 	struct avtab te_avtab;
@@ -294,7 +294,7 @@ struct policydb {
 	struct hashtab *range_tr;
 
 	/* type -> attribute reverse mapping */
-	struct flex_array *type_attr_map_array;
+	GENRADIX(struct ebitmap) type_attr_map_array;
 
 	struct ebitmap policycaps;
 
@@ -369,9 +369,7 @@ static inline int put_entry(const void *buf, size_t bytes, int num, struct polic
 
 static inline char *sym_name(struct policydb *p, unsigned int sym_num, unsigned int element_nr)
 {
-	struct flex_array *fa = p->sym_val_to_name[sym_num];
-
-	return flex_array_get_ptr(fa, element_nr);
+	return *genradix_ptr(&p->sym_val_to_name[sym_num], element_nr);
 }
 
 extern u16 string_to_security_class(struct policydb *p, const char *name);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 8900ea5cba..79a56e4653 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -50,7 +50,6 @@
 #include <linux/audit.h>
 #include <linux/mutex.h>
 #include <linux/selinux.h>
-#include <linux/flex_array.h>
 #include <linux/vmalloc.h>
 #include <net/netlabel.h>
 
@@ -562,15 +561,15 @@ static void type_attribute_bounds_av(struct context *scontext,
 	struct type_datum *target;
 	u32 masked = 0;
 
-	source = flex_array_get_ptr(policydb.type_val_to_struct_array,
-				    scontext->type - 1);
+	source = *genradix_ptr(&policydb.type_val_to_struct_array,
+			       scontext->type - 1);
 	BUG_ON(!source);
 
 	if (!source->bounds)
 		return;
 
-	target = flex_array_get_ptr(policydb.type_val_to_struct_array,
-				    tcontext->type - 1);
+	target = *genradix_ptr(&policydb.type_val_to_struct_array,
+			       tcontext->type - 1);
 	BUG_ON(!target);
 
 	memset(&lo_avd, 0, sizeof(lo_avd));
@@ -669,9 +668,9 @@ static void context_struct_compute_av(struct context *scontext,
 	 */
 	avkey.target_class = tclass;
 	avkey.specified = AVTAB_AV | AVTAB_XPERMS;
-	sattr = flex_array_get(policydb.type_attr_map_array, scontext->type - 1);
+	sattr = genradix_ptr(&policydb.type_attr_map_array, scontext->type - 1);
 	BUG_ON(!sattr);
-	tattr = flex_array_get(policydb.type_attr_map_array, tcontext->type - 1);
+	tattr = genradix_ptr(&policydb.type_attr_map_array, tcontext->type - 1);
 	BUG_ON(!tattr);
 	ebitmap_for_each_positive_bit(sattr, snode, i) {
 		ebitmap_for_each_positive_bit(tattr, tnode, j) {
@@ -895,8 +894,8 @@ int security_bounded_transition(u32 old_sid, u32 new_sid)
 
 	index = new_context->type;
 	while (true) {
-		type = flex_array_get_ptr(policydb.type_val_to_struct_array,
-					  index - 1);
+		type = *genradix_ptr(&policydb.type_val_to_struct_array,
+				     index - 1);
 		BUG_ON(!type);
 
 		/* not bounded anymore */
@@ -1053,11 +1052,11 @@ void security_compute_xperms_decision(u32 ssid,
 
 	avkey.target_class = tclass;
 	avkey.specified = AVTAB_XPERMS;
-	sattr = flex_array_get(policydb.type_attr_map_array,
-				scontext->type - 1);
+	sattr = genradix_ptr(&policydb.type_attr_map_array,
+			     scontext->type - 1);
 	BUG_ON(!sattr);
-	tattr = flex_array_get(policydb.type_attr_map_array,
-				tcontext->type - 1);
+	tattr = genradix_ptr(&policydb.type_attr_map_array,
+			     tcontext->type - 1);
 	BUG_ON(!tattr);
 	ebitmap_for_each_positive_bit(sattr, snode, i) {
 		ebitmap_for_each_positive_bit(tattr, tnode, j) {
-- 
2.17.0
