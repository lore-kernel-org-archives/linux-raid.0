From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/6] proc: commit to genradix
Date: Tue, 22 May 2018 21:18:17 -0400
Message-ID: <20180523011821.12165-2-kent.overstreet@gmail.com>
References: <20180523011821.12165-1-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <20180523011821.12165-1-kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

the new generic radix trees have a simpler API and implementation, and
no limitations on number of elements, so all flex_array users are being
converted

Signed-off-by: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/proc/base.c | 48 +++++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9298324325..0a762eda64 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -59,6 +59,7 @@
 #include <linux/capability.h>
 #include <linux/file.h>
 #include <linux/fdtable.h>
+#include <linux/generic-radix-tree.h>
 #include <linux/string.h>
 #include <linux/seq_file.h>
 #include <linux/namei.h>
@@ -92,7 +93,6 @@
 #include <linux/sched/coredump.h>
 #include <linux/sched/debug.h>
 #include <linux/sched/stat.h>
-#include <linux/flex_array.h>
 #include <linux/posix-timers.h>
 #ifdef CONFIG_HARDWALL
 #include <asm/hardwall.h>
@@ -2140,11 +2140,12 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
 	struct task_struct *task;
 	struct mm_struct *mm;
 	unsigned long nr_files, pos, i;
-	struct flex_array *fa = NULL;
-	struct map_files_info info;
+	GENRADIX(struct map_files_info) fa;
 	struct map_files_info *p;
 	int ret;
 
+	genradix_init(&fa);
+
 	ret = -ENOENT;
 	task = get_proc_task(file_inode(file));
 	if (!task)
@@ -2176,35 +2177,21 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
 	 */
 
 	for (vma = mm->mmap, pos = 2; vma; vma = vma->vm_next) {
-		if (vma->vm_file && ++pos > ctx->pos)
-			nr_files++;
-	}
+		if (!vma->vm_file)
+			continue;
+		if (++pos <= ctx->pos)
+			continue;
 
-	if (nr_files) {
-		fa = flex_array_alloc(sizeof(info), nr_files,
-					GFP_KERNEL);
-		if (!fa || flex_array_prealloc(fa, 0, nr_files,
-						GFP_KERNEL)) {
+		p = genradix_ptr_alloc(&fa, nr_files++, GFP_KERNEL);
+		if (!p) {
 			ret = -ENOMEM;
-			if (fa)
-				flex_array_free(fa);
 			up_read(&mm->mmap_sem);
-			mmput(mm);
-			goto out_put_task;
+			goto out_put_mm;
 		}
-		for (i = 0, vma = mm->mmap, pos = 2; vma;
-				vma = vma->vm_next) {
-			if (!vma->vm_file)
-				continue;
-			if (++pos <= ctx->pos)
-				continue;
 
-			info.start = vma->vm_start;
-			info.end = vma->vm_end;
-			info.mode = vma->vm_file->f_mode;
-			if (flex_array_put(fa, i++, &info, GFP_KERNEL))
-				BUG();
-		}
+		p->start = vma->vm_start;
+		p->end = vma->vm_end;
+		p->mode = vma->vm_file->f_mode;
 	}
 	up_read(&mm->mmap_sem);
 
@@ -2212,7 +2199,7 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
 		char buf[4 * sizeof(long) + 2];	/* max: %lx-%lx\0 */
 		unsigned int len;
 
-		p = flex_array_get(fa, i);
+		p = genradix_ptr(&fa, i);
 		len = snprintf(buf, sizeof(buf), "%lx-%lx", p->start, p->end);
 		if (!proc_fill_cache(file, ctx,
 				      buf, len,
@@ -2222,13 +2209,12 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
 			break;
 		ctx->pos++;
 	}
-	if (fa)
-		flex_array_free(fa);
+out_put_mm:
 	mmput(mm);
-
 out_put_task:
 	put_task_struct(task);
 out:
+	genradix_free(&fa);
 	return ret;
 }
 
-- 
2.17.0
