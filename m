From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/6] Generic radix trees
Date: Tue, 22 May 2018 21:18:16 -0400
Message-ID: <20180523011821.12165-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-raid.ids

Very simple radix tree implementation that supports storing arbitrary
size entries, up to PAGE_SIZE - upcoming patches will convert existing
flex_array users to genradixes. The new genradix code has a much simpler
API and implementation, and doesn't have a hard limit on the number of
elements like flex_array does.

Signed-off-by: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/generic-radix-tree.h | 222 +++++++++++++++++++++++++++++
 lib/Makefile                       |   3 +-
 lib/generic-radix-tree.c           | 180 +++++++++++++++++++++++
 3 files changed, 404 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/generic-radix-tree.h
 create mode 100644 lib/generic-radix-tree.c

diff --git a/include/linux/generic-radix-tree.h b/include/linux/generic-radix-tree.h
new file mode 100644
index 0000000000..3328813322
--- /dev/null
+++ b/include/linux/generic-radix-tree.h
@@ -0,0 +1,222 @@
+#ifndef _LINUX_GENERIC_RADIX_TREE_H
+#define _LINUX_GENERIC_RADIX_TREE_H
+
+/*
+ * Generic radix trees/sparse arrays:
+ *
+ * Very simple and minimalistic, supporting arbitrary size entries up to
+ * PAGE_SIZE.
+ *
+ * A genradix is defined with the type it will store, like so:
+ * static GENRADIX(struct foo) foo_genradix;
+ *
+ * The main operations are:
+ * - genradix_init(radix) - initialize an empty genradix
+ *
+ * - genradix_free(radix) - free all memory owned by the genradix and
+ *   reinitialize it
+ *
+ * - genradix_ptr(radix, idx) - gets a pointer to the entry at idx, returning
+ *   NULL if that entry does not exist
+ *
+ * - genradix_ptr_alloc(radix, idx, gfp) - gets a pointer to an entry,
+ *   allocating it if necessary
+ *
+ * - genradix_for_each(radix, iter, p) - iterate over each entry in a genradix
+ *
+ * The radix tree allocates one page of entries at a time, so entries may exist
+ * that were never explicitly allocated - they will be initialized to all
+ * zeroes.
+ *
+ * Internally, a genradix is just a radix tree of pages, and indexing works in
+ * terms of byte offsets. The wrappers in this header file use sizeof on the
+ * type the radix contains to calculate a byte offset from the index - see
+ * __idx_to_offset.
+ */
+
+#include <asm/page.h>
+#include <linux/bug.h>
+#include <linux/kernel.h>
+#include <linux/log2.h>
+
+struct genradix_node;
+
+struct __genradix {
+	struct genradix_node		*root;
+	size_t				depth;
+};
+
+#define __GENRADIX_INITIALIZER					\
+	{							\
+		.tree = {					\
+			.root = NULL,				\
+			.depth = 0,				\
+		}						\
+	}
+
+/*
+ * We use a 0 size array to stash the type we're storing without taking any
+ * space at runtime - then the various accessor macros can use typeof() to get
+ * to it for casts/sizeof - we also force the alignment so that storing a type
+ * with a ridiculous alignment doesn't blow up the alignment or size of the
+ * genradix.
+ */
+
+#define GENRADIX(_type)						\
+struct {							\
+	struct __genradix	tree;				\
+	_type			type[0] __aligned(1);		\
+}
+
+#define DEFINE_GENRADIX(_name, _type)				\
+	GENRADIX(_type) _name = __GENRADIX_INITIALIZER
+
+/**
+ * genradix_init - initialize a genradix
+ * @_radix:	genradix to initialize
+ *
+ * Does not fail
+ */
+#define genradix_init(_radix)					\
+do {								\
+	*(_radix) = (typeof(*_radix)) __GENRADIX_INITIALIZER;	\
+} while (0)
+
+void __genradix_free(struct __genradix *);
+
+/**
+ * genradix_free: free all memory owned by a genradix
+ *
+ * After freeing, @_radix will be reinitialized and empty
+ */
+#define genradix_free(_radix)	__genradix_free(&(_radix)->tree)
+
+static inline size_t __idx_to_offset(size_t idx, size_t obj_size)
+{
+	if (__builtin_constant_p(obj_size))
+		BUILD_BUG_ON(obj_size > PAGE_SIZE);
+	else
+		BUG_ON(obj_size > PAGE_SIZE);
+
+	if (!is_power_of_2(obj_size)) {
+		size_t objs_per_page = PAGE_SIZE / obj_size;
+
+		return (idx / objs_per_page) * PAGE_SIZE +
+			(idx % objs_per_page) * obj_size;
+	} else {
+		return idx * obj_size;
+	}
+}
+
+#define __genradix_cast(_radix)		(typeof((_radix)->type[0]) *)
+#define __genradix_obj_size(_radix)	sizeof((_radix)->type[0])
+#define __genradix_idx_to_offset(_radix, _idx)			\
+	__idx_to_offset(_idx, __genradix_obj_size(_radix))
+
+void *__genradix_ptr(struct __genradix *, size_t);
+
+/**
+ * genradix_ptr - get a pointer to a genradix entry
+ * @_radix:	genradix to access
+ * @_idx:	index to fetch
+ *
+ * Returns a pointer to entry at @_idx, or NULL if that entry does not exist.
+ */
+#define genradix_ptr(_radix, _idx)				\
+	(__genradix_cast(_radix)				\
+	 __genradix_ptr(&(_radix)->tree,			\
+			__genradix_idx_to_offset(_radix, _idx)))
+
+void *__genradix_ptr_alloc(struct __genradix *, size_t, gfp_t);
+
+/**
+ * genradix_ptr - get a pointer to a genradix entry, allocating it if necessary
+ * @_radix:	genradix to access
+ * @_idx:	index to fetch
+ * @_gfp:	gfp mask
+ *
+ * Returns a pointer to entry at @_idx, or NULL on allocation failure
+ */
+#define genradix_ptr_alloc(_radix, _idx, _gfp)			\
+	(__genradix_cast(_radix)				\
+	 __genradix_ptr_alloc(&(_radix)->tree,			\
+			__genradix_idx_to_offset(_radix, _idx),	\
+			_gfp))
+
+struct genradix_iter {
+	size_t			offset;
+	size_t			pos;
+};
+
+/**
+ * genradix_iter_init - initialize a genradix_iter
+ * @_radix:	genradix that will be iterated over
+ * @_idx	index to start iterating from
+ */
+#define genradix_iter_init(_radix, _idx)			\
+	((struct genradix_iter) {				\
+		.pos	= (_idx),				\
+		.offset	= __genradix_idx_to_offset((_radix), (_idx)),\
+	})
+
+void *__genradix_iter_peek(struct genradix_iter *, struct __genradix *, size_t);
+
+/**
+ * genradix_iter_peek - get first entry at or above iterator's current
+ *			position
+ * @_iter:	a genradix_iter
+ * @_radix:	genradix being iterated over
+ *
+ * If no more entries exist at or above @_iter's current position, returns NULL
+ */
+#define genradix_iter_peek(_iter, _radix)			\
+	(__genradix_cast(_radix)				\
+	 __genradix_iter_peek(_iter, &(_radix)->tree,		\
+			      PAGE_SIZE / __genradix_obj_size(_radix)))
+
+static inline void __genradix_iter_advance(struct genradix_iter *iter,
+					   size_t obj_size)
+{
+	iter->offset += obj_size;
+
+	if (!is_power_of_2(obj_size) &&
+	    (iter->offset & (PAGE_SIZE - 1)) + obj_size > PAGE_SIZE)
+		iter->offset = round_up(iter->offset, PAGE_SIZE);
+
+	iter->pos++;
+}
+
+#define genradix_iter_advance(_iter, _radix)			\
+	__genradix_iter_advance(_iter, __genradix_obj_size(_radix))
+
+/**
+ * genradix_for_each - iterate over entry in a genradix
+ * @_radix:	genradix to iterate over
+ * @_iter:	a genradix_iter to track current position
+ * @_p:		pointer to genradix entry type
+ *
+ * On every iteration, @_p will point to the current entry, and @_iter.pos
+ * will be the current entry's index.
+ */
+#define genradix_for_each(_radix, _iter, _p)			\
+	for (_iter = genradix_iter_init(_radix, 0);		\
+	     _p = genradix_iter_peek(&(_iter), _uradix);	\
+	     genradix_iter_advance(&(_iter), _uradix))
+
+int __genradix_prealloc(struct __genradix *, size_t, gfp_t);
+
+/**
+ * genradix_prealloc - preallocate entries in a generic radix tree
+ * @_radix:	genradix to preallocate
+ * @_nr:	number of entries to preallocate
+ * @_gfp:	gfp mask
+ *
+ * Returns 0 on success, -ENOMEM on failure
+ */
+#define genradix_prealloc(_radix, _nr, _gfp)			\
+	 __genradix_prealloc(&(_radix)->tree,			\
+			__genradix_idx_to_offset(_radix, _nr + 1),\
+			_gfp)
+
+
+#endif /* _LINUX_GENERIC_RADIX_TREE_H */
diff --git a/lib/Makefile b/lib/Makefile
index a90d4fcd74..5db5a7fb1e 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -39,7 +39,8 @@ obj-y += bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
 	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iov_iter.o clz_ctz.o \
 	 bsearch.o find_bit.o llist.o memweight.o kfifo.o \
 	 percpu-refcount.o percpu_ida.o rhashtable.o reciprocal_div.o \
-	 once.o refcount.o usercopy.o errseq.o bucket_locks.o
+	 once.o refcount.o usercopy.o errseq.o bucket_locks.o \
+	 generic-radix-tree.o
 obj-$(CONFIG_STRING_SELFTEST) += test_string.o
 obj-y += string_helpers.o
 obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
diff --git a/lib/generic-radix-tree.c b/lib/generic-radix-tree.c
new file mode 100644
index 0000000000..4537c7c62c
--- /dev/null
+++ b/lib/generic-radix-tree.c
@@ -0,0 +1,180 @@
+
+#include <linux/export.h>
+#include <linux/generic-radix-tree.h>
+#include <linux/gfp.h>
+
+#define GENRADIX_ARY		(PAGE_SIZE / sizeof(struct genradix_node *))
+#define GENRADIX_ARY_SHIFT	ilog2(GENRADIX_ARY)
+
+struct genradix_node {
+	union {
+		/* Interior node: */
+		struct genradix_node	*children[GENRADIX_ARY];
+
+		/* Leaf: */
+		u8			data[PAGE_SIZE];
+	};
+};
+
+static inline unsigned genradix_depth_shift(unsigned depth)
+{
+	return PAGE_SHIFT + GENRADIX_ARY_SHIFT * depth;
+}
+
+/*
+ * Returns size (of data, in bytes) that a tree of a given depth holds:
+ */
+static inline size_t genradix_depth_size(unsigned depth)
+{
+	return 1UL << genradix_depth_shift(depth);
+}
+
+/*
+ * Returns pointer to the specified byte @offset within @radix, or NULL if not
+ * allocated
+ */
+void *__genradix_ptr(struct __genradix *radix, size_t offset)
+{
+	size_t level = radix->depth;
+	struct genradix_node *n = radix->root;
+
+	if (offset >= genradix_depth_size(radix->depth))
+		return NULL;
+
+	while (1) {
+		if (!n)
+			return NULL;
+		if (!level)
+			break;
+
+		level--;
+
+		n = n->children[offset >> genradix_depth_shift(level)];
+		offset &= genradix_depth_size(level) - 1;
+	}
+
+	return &n->data[offset];
+}
+EXPORT_SYMBOL(__genradix_ptr);
+
+/*
+ * Returns pointer to the specified byte @offset within @radix, allocating it if
+ * necessary - newly allocated slots are always zeroed out:
+ */
+void *__genradix_ptr_alloc(struct __genradix *radix, size_t offset,
+			   gfp_t gfp_mask)
+{
+	struct genradix_node **n;
+	size_t level;
+
+	/* Increase tree depth if necessary: */
+
+	while (offset >= genradix_depth_size(radix->depth)) {
+		struct genradix_node *new_root =
+			(void *) __get_free_page(gfp_mask|__GFP_ZERO);
+
+		if (!new_root)
+			return NULL;
+
+		new_root->children[0] = radix->root;
+		radix->root = new_root;
+		radix->depth++;
+	}
+
+	n = &radix->root;
+	level = radix->depth;
+
+	while (1) {
+		if (!*n) {
+			*n = (void *) __get_free_page(gfp_mask|__GFP_ZERO);
+			if (!*n)
+				return NULL;
+		}
+
+		if (!level)
+			break;
+
+		level--;
+
+		n = &(*n)->children[offset >> genradix_depth_shift(level)];
+		offset &= genradix_depth_size(level) - 1;
+	}
+
+	return &(*n)->data[offset];
+}
+EXPORT_SYMBOL(__genradix_ptr_alloc);
+
+void *__genradix_iter_peek(struct genradix_iter *iter,
+			   struct __genradix *radix,
+			   size_t objs_per_page)
+{
+	struct genradix_node *n;
+	size_t level, i;
+
+	if (!radix->root)
+		return NULL;
+restart:
+	if (iter->offset >= genradix_depth_size(radix->depth))
+		return NULL;
+
+	n	= radix->root;
+	level	= radix->depth;
+
+	while (level) {
+		level--;
+
+		i = (iter->offset >> genradix_depth_shift(level)) &
+			(GENRADIX_ARY - 1);
+
+		while (!n->children[i]) {
+			i++;
+			iter->offset = round_down(iter->offset +
+					   genradix_depth_size(level),
+					   genradix_depth_size(level));
+			iter->pos = (iter->offset >> PAGE_SHIFT) *
+				objs_per_page;
+			if (i == GENRADIX_ARY)
+				goto restart;
+		}
+
+		n = n->children[i];
+	}
+
+	return &n->data[iter->offset & (PAGE_SIZE - 1)];
+}
+EXPORT_SYMBOL(__genradix_iter_peek);
+
+static void genradix_free_recurse(struct genradix_node *n, unsigned level)
+{
+	if (level) {
+		unsigned i;
+
+		for (i = 0; i < GENRADIX_ARY; i++)
+			if (n->children[i])
+				genradix_free_recurse(n->children[i], level - 1);
+	}
+
+	free_page((unsigned long) n);
+}
+
+int __genradix_prealloc(struct __genradix *radix, size_t size,
+			gfp_t gfp_mask)
+{
+	size_t offset;
+
+	for (offset = 0; offset < size; offset += PAGE_SIZE)
+		if (!__genradix_ptr_alloc(radix, offset, gfp_mask))
+			return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL(__genradix_prealloc);
+
+void __genradix_free(struct __genradix *radix)
+{
+	genradix_free_recurse(radix->root, radix->depth);
+
+	radix->root = NULL;
+	radix->depth = 0;
+}
+EXPORT_SYMBOL(__genradix_free);
-- 
2.17.0
