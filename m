From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: Partitioned raid and major number
Date: Mon, 1 Mar 2004 16:38:10 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040301153810.GC8722@traveler.cistron.net>
References: <20040225145624.GA1513@cistron.nl> <16445.12026.812778.621025@notabene.cse.unsw.edu.au> <20040226215144.GC11831@drinkel.cistron.nl> <16446.36226.591283.495194@notabene.cse.unsw.edu.au> <16446.39583.968782.41221@notabene.cse.unsw.edu.au> <20040227165614.GO23988@traveler.cistron.net> <20040228010916.GC13404@drinkel.cistron.nl> <16450.35269.770163.948225@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16450.35269.770163.948225@notabene.cse.unsw.edu.au> (from neilb@cse.unsw.edu.au on Mon, Mar 01, 2004 at 01:54:29 +0100)
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Miquel van Smoorenburg <miquels@cistron.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004.03.01 01:54, Neil Brown wrote:
> Another is to add "rootdev" to /proc/*, as in appended patch. Then
>   ln -s /proc/self/roodev /dev/root
> 
> and providing /proc is mounted, /dev/root will work.
> 
> I think I prefer the /proc/self/rootdev approach despite it being the
> bigger patch.
> 
> I might try to push it on linux-kernel.

It doesn't work. Here's a version that does:

--- linux-2.6.3/fs/proc/base.c	2004-02-18 04:58:32.000000000 +0100
+++ linux-2.6.3-bk8-mdp/fs/proc/base.c	2004-03-01 15:20:22.000000000 +0100
@@ -50,6 +50,7 @@
 	PROC_TGID_MEM,
 	PROC_TGID_CWD,
 	PROC_TGID_ROOT,
+	PROC_TGID_ROOTDEV,
 	PROC_TGID_EXE,
 	PROC_TGID_FD,
 	PROC_TGID_ENVIRON,
@@ -73,6 +74,7 @@
 	PROC_TID_MEM,
 	PROC_TID_CWD,
 	PROC_TID_ROOT,
+	PROC_TID_ROOTDEV,
 	PROC_TID_EXE,
 	PROC_TID_FD,
 	PROC_TID_ENVIRON,
@@ -115,6 +117,7 @@
 	E(PROC_TGID_MEM,       "mem",     S_IFREG|S_IRUSR|S_IWUSR),
 	E(PROC_TGID_CWD,       "cwd",     S_IFLNK|S_IRWXUGO),
 	E(PROC_TGID_ROOT,      "root",    S_IFLNK|S_IRWXUGO),
+	E(PROC_TGID_ROOTDEV,   "rootdev", S_IFBLK|S_IRUSR|S_IWUSR),
 	E(PROC_TGID_EXE,       "exe",     S_IFLNK|S_IRWXUGO),
 	E(PROC_TGID_MOUNTS,    "mounts",  S_IFREG|S_IRUGO),
 #ifdef CONFIG_SECURITY
@@ -137,6 +140,7 @@
 	E(PROC_TID_MEM,        "mem",     S_IFREG|S_IRUSR|S_IWUSR),
 	E(PROC_TID_CWD,        "cwd",     S_IFLNK|S_IRWXUGO),
 	E(PROC_TID_ROOT,       "root",    S_IFLNK|S_IRWXUGO),
+	E(PROC_TID_ROOTDEV,    "rootdev", S_IFBLK|S_IRUSR|S_IWUSR),
 	E(PROC_TID_EXE,        "exe",     S_IFLNK|S_IRWXUGO),
 	E(PROC_TID_MOUNTS,     "mounts",  S_IFREG|S_IRUGO),
 #ifdef CONFIG_SECURITY
@@ -771,6 +775,32 @@
 	.follow_link	= proc_pid_follow_link
 };
 
+static int init_pid_rootdev_inode(struct inode *inode)
+{
+	struct fs_struct *fs;
+	struct vfsmount *vmnt;
+	int result = -ENOENT;
+	dev_t rootdev = 0;
+
+	task_lock(proc_task(inode));
+	fs = proc_task(inode)->fs;
+	if(fs)
+		atomic_inc(&fs->count);
+	task_unlock(proc_task(inode));
+	if (fs) {
+		read_lock(&fs->lock);
+		vmnt = mntget(fs->rootmnt);
+		rootdev = vmnt->mnt_sb->s_dev;
+		mntput(vmnt);
+		read_unlock(&fs->lock);
+		result = 0;
+		put_fs_struct(fs);
+	}
+	init_special_inode(inode, inode->i_mode, rootdev);
+
+	return result;
+}
+
 static int pid_alive(struct task_struct *p)
 {
 	BUG_ON(p->pids[PIDTYPE_PID].pidptr != &p->pids[PIDTYPE_PID].pid);
@@ -958,7 +988,9 @@
 	ei->type = ino;
 	inode->i_uid = 0;
 	inode->i_gid = 0;
-	if (ino == PROC_TGID_INO || ino == PROC_TID_INO || task_dumpable(task)) {
+	if (ino != PROC_TGID_ROOTDEV && ino != PROC_TID_ROOTDEV &&
+	    (ino == PROC_TGID_INO || ino == PROC_TID_INO ||
+	     task_dumpable(task))) {
 		inode->i_uid = task->euid;
 		inode->i_gid = task->egid;
 	}
@@ -988,7 +1020,10 @@
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = proc_task(inode);
 	if (pid_alive(task)) {
-		if (proc_type(inode) == PROC_TGID_INO || proc_type(inode) == PROC_TID_INO || task_dumpable(task)) {
+		int ino = proc_type(inode);
+		if (ino != PROC_TGID_ROOTDEV && ino != PROC_TID_ROOTDEV &&
+		    (ino == PROC_TGID_INO || ino == PROC_TID_INO ||
+		     task_dumpable(task))) {
 			inode->i_uid = task->euid;
 			inode->i_gid = task->egid;
 		} else {
@@ -1319,6 +1354,10 @@
 			inode->i_op = &proc_pid_link_inode_operations;
 			ei->op.proc_get_link = proc_root_link;
 			break;
+		case PROC_TID_ROOTDEV:
+		case PROC_TGID_ROOTDEV:
+			init_pid_rootdev_inode(inode);
+			break;
 		case PROC_TID_ENVIRON:
 		case PROC_TGID_ENVIRON:
 			inode->i_fop = &proc_info_file_operations;

