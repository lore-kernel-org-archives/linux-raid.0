From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Partitioned raid and major number
Date: Mon, 1 Mar 2004 11:54:29 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16450.35269.770163.948225@notabene.cse.unsw.edu.au>
References: <20040225145624.GA1513@cistron.nl>
	<16445.12026.812778.621025@notabene.cse.unsw.edu.au>
	<20040226215144.GC11831@drinkel.cistron.nl>
	<16446.36226.591283.495194@notabene.cse.unsw.edu.au>
	<16446.39583.968782.41221@notabene.cse.unsw.edu.au>
	<20040227165614.GO23988@traveler.cistron.net>
	<20040228010916.GC13404@drinkel.cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Miquel van Smoorenburg on Saturday February 28
To: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday February 28, miquels@cistron.nl wrote:
> 
> Hmm. With a dynamic major, the system might fail at checking the root
> file system at boot. At that time, /dev is still read-only, and
> /dev/md/d0p1 might not be the correct device yet.
> 
> So either mdp needs its own partition number, or we need a /dev/root
> device that's an alias for the current root (like /dev/console).
> 

Yes, I think this is a real problem.
There are a number of avenues that could be followed to fix it.
One it your suggestion.

Another is to make "rootfs" remountable like this:

--- ./fs/ramfs/inode.c~current~	2004-03-01 11:20:58.000000000 +1100
+++ ./fs/ramfs/inode.c	2004-03-01 11:21:15.000000000 +1100
@@ -207,7 +207,7 @@ static struct super_block *ramfs_get_sb(
 static struct super_block *rootfs_get_sb(struct file_system_type *fs_type,
 	int flags, const char *dev_name, void *data)
 {
-	return get_sb_nodev(fs_type, flags|MS_NOUSER, data, ramfs_fill_super);
+	return get_sb_single(fs_type, flags, data, ramfs_fill_super);
 }
 
 static struct file_system_type ramfs_fs_type = {



And then:

  mount -t rootfs rootfs /mnt/root
  fsck /mnt/root/dev/root

Another is to add "rootdev" to /proc/*, as in appended patch. Then
  ln -s /proc/self/roodev /dev/root

and providing /proc is mounted, /dev/root will work.

I think I prefer the /proc/self/rootdev approach despite it being the
bigger patch.

I might try to push it on linux-kernel.

NeilBrown



diff ./fs/proc/base.c~current~ ./fs/proc/base.c
--- ./fs/proc/base.c~current~	2004-03-01 11:28:24.000000000 +1100
+++ ./fs/proc/base.c	2004-03-01 11:48:07.000000000 +1100
@@ -50,6 +50,7 @@ enum pid_directory_inos {
 	PROC_TGID_MEM,
 	PROC_TGID_CWD,
 	PROC_TGID_ROOT,
+	PROC_TGID_ROOTDEV,
 	PROC_TGID_EXE,
 	PROC_TGID_FD,
 	PROC_TGID_ENVIRON,
@@ -73,6 +74,7 @@ enum pid_directory_inos {
 	PROC_TID_MEM,
 	PROC_TID_CWD,
 	PROC_TID_ROOT,
+	PROC_TID_ROOTDEV,
 	PROC_TID_EXE,
 	PROC_TID_FD,
 	PROC_TID_ENVIRON,
@@ -115,6 +117,7 @@ static struct pid_entry tgid_base_stuff[
 	E(PROC_TGID_MEM,       "mem",     S_IFREG|S_IRUSR|S_IWUSR),
 	E(PROC_TGID_CWD,       "cwd",     S_IFLNK|S_IRWXUGO),
 	E(PROC_TGID_ROOT,      "root",    S_IFLNK|S_IRWXUGO),
+	E(PROC_TGID_ROOTDEV,   "rootdev", S_IFBLK|S_IRUSR|S_IWUSR),
 	E(PROC_TGID_EXE,       "exe",     S_IFLNK|S_IRWXUGO),
 	E(PROC_TGID_MOUNTS,    "mounts",  S_IFREG|S_IRUGO),
 #ifdef CONFIG_SECURITY
@@ -137,6 +140,7 @@ static struct pid_entry tid_base_stuff[]
 	E(PROC_TID_MEM,        "mem",     S_IFREG|S_IRUSR|S_IWUSR),
 	E(PROC_TID_CWD,        "cwd",     S_IFLNK|S_IRWXUGO),
 	E(PROC_TID_ROOT,       "root",    S_IFLNK|S_IRWXUGO),
+	E(PROC_TID_ROOTDEV,    "rootdev", S_IFBLK|S_IRUSR|S_IWUSR),
 	E(PROC_TID_EXE,        "exe",     S_IFLNK|S_IRWXUGO),
 	E(PROC_TID_MOUNTS,     "mounts",  S_IFREG|S_IRUGO),
 #ifdef CONFIG_SECURITY
@@ -771,6 +775,32 @@ static struct inode_operations proc_pid_
 	.follow_link	= proc_pid_follow_link
 };
 
+int proc_pid_get_attr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
+{
+	struct inode *inode = dentry->d_inode;
+	struct fs_struct *fs;
+	int result = -ENOENT;
+	generic_fillattr(inode, stat);
+	task_lock(proc_task(inode));
+	fs = proc_task(inode)->fs;
+	if(fs)
+		atomic_inc(&fs->count);
+	task_unlock(proc_task(inode));
+	if (fs) {
+		read_lock(&fs->lock);
+		stat->rdev = fs->pwdmnt->mnt_sb->s_dev;
+		read_unlock(&fs->lock);
+		result = 0;
+		put_fs_struct(fs);
+	}
+
+	return result;
+}
+
+static struct inode_operations proc_pid_dev_inode_operations = {
+	.getattr	= proc_pid_get_attr,
+};
+
 static int pid_alive(struct task_struct *p)
 {
 	BUG_ON(p->pids[PIDTYPE_PID].pidptr != &p->pids[PIDTYPE_PID].pid);
@@ -1319,6 +1349,10 @@ static struct dentry *proc_pident_lookup
 			inode->i_op = &proc_pid_link_inode_operations;
 			ei->op.proc_get_link = proc_root_link;
 			break;
+		case PROC_TID_ROOTDEV:
+		case PROC_TGID_ROOTDEV:
+			inode->i_op = &proc_pid_dev_inode_operations;
+			break;
 		case PROC_TID_ENVIRON:
 		case PROC_TGID_ENVIRON:
 			inode->i_fop = &proc_info_file_operations;

