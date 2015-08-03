From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 1/2] Safeguard against writing to an active device of
 another node
Date: Mon, 3 Aug 2015 06:56:58 -0500
Message-ID: <55BF570A.6050403@suse.com>
References: <1438601519-17919-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1438601519-17919-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/03/2015 06:31 AM, Guoqing Jiang wrote:
> Modifying an exiting device's superblock or creating a new superblock
> on an existing device needs to be checked because the device could be
> in use by another node in another array. So, we check this by taking
> all superblock locks in userspace so that we don't  step onto an active
> device used by another node and safeguard against accidental edits.
> After the edit is complete, we release all locks and the lockspace so
> that it can be used by the kernel space.
>
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>   Makefile |   3 +-
>   mdadm.c  |  11 +++++
>   mdadm.h  |  46 ++++++++++++++++++
>   super1.c |  51 ++++++++++++++++++++
>   util.c   | 165 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   5 files changed, 275 insertions(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index c189279..370ef75 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -81,11 +81,12 @@ FAILED_SLOTS_DIR = $(RUN_DIR)/failed-slots
>   SYSTEMD_DIR=/lib/systemd/system
>
>   COROSYNC:=$(shell [ -d /usr/include/corosync ] || echo -DNO_COROSYNC)
> +DLM:=$(shell [ -f /usr/include/libdlm.h ] || echo -DNO_DLM)
>
>   DIRFLAGS = -DMAP_DIR=\"$(MAP_DIR)\" -DMAP_FILE=\"$(MAP_FILE)\"
>   DIRFLAGS += -DMDMON_DIR=\"$(MDMON_DIR)\"
>   DIRFLAGS += -DFAILED_SLOTS_DIR=\"$(FAILED_SLOTS_DIR)\"
> -CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS) $(COROSYNC)
> +CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS) $(COROSYNC) $(DLM)
>
>   VERSION = $(shell [ -d .git ] && git describe HEAD | sed 's/mdadm-//')
>   VERS_DATE = $(shell [ -d .git ] && date --date="`git log -n1 --format=format:%cd --date=short`" '+%0dth %B %Y' | sed -e 's/1th/1st/' -e 's/2th/2nd/' -e 's/11st/11th/' -e 's/12nd/12th/')
> diff --git a/mdadm.c b/mdadm.c
> index c4daf25..d8032c1 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1322,6 +1322,8 @@ int main(int argc, char *argv[])
>   		/* --scan implied --brief unless -vv */
>   		c.brief = 1;
>
> +	set_dlm_hookers(); /* get dlm funcs from libdlm_lt.so.3 */
> +

Universal Comment: Let call it set_dlm_hooks as opposed to hookers.


>   	rv = 0;
>   	switch(mode) {
>   	case MANAGE:
> @@ -1362,10 +1364,12 @@ int main(int argc, char *argv[])
>   		else if (devs_found > 0) {
>   			if (c.update && devs_found > 1) {
>   				pr_err("can only update a single array at a time\n");
> +				free_dlm_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			if (c.backup_file && devs_found > 1) {
>   				pr_err("can only assemble a single array when providing a backup file.\n");
> +				free_dlm_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			for (dv = devlist ; dv ; dv=dv->next) {
> @@ -1384,10 +1388,12 @@ int main(int argc, char *argv[])
>   		} else {
>   			if (c.update) {
>   				pr_err("--update not meaningful with a --scan assembly.\n");
> +				free_dlm_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			if (c.backup_file) {
>   				pr_err("--backup_file not meaningful with a --scan assembly.\n");
> +				free_dlm_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			rv = scan_assemble(ss, &c, &ident);
> @@ -1455,12 +1461,14 @@ int main(int argc, char *argv[])
>   		if (devmode == 'E') {
>   			if (devlist == NULL && !c.scan) {
>   				pr_err("No devices to examine\n");
> +				free_dlm_hookers(); /* close dlm stuffs */
>   				exit(2);
>   			}
>   			if (devlist == NULL)
>   				devlist = conf_get_devs();
>   			if (devlist == NULL) {
>   				pr_err("No devices listed in %s\n", configfile?configfile:DefaultConfFile);
> +				free_dlm_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			rv = Examine(devlist, &c, ss);
> @@ -1477,6 +1485,7 @@ int main(int argc, char *argv[])
>   				rv = Write_rules(udev_filename);
>   			else {
>   				pr_err("No devices given.\n");
> +				free_dlm_hookers(); /* close dlm stuffs */
>   				exit(2);
>   			}
>   		} else
> @@ -1615,6 +1624,8 @@ int main(int argc, char *argv[])
>   		autodetect();
>   		break;
>   	}
> +
> +	free_dlm_hookers(); /* close dlm stuffs */
>   	exit(rv);
>   }
>
> diff --git a/mdadm.h b/mdadm.h
> index 97892e6..c53adc5 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -35,6 +35,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
>
>   #include	<sys/types.h>
>   #include	<sys/stat.h>
> +#include	<stdint.h>
>   #include	<stdlib.h>
>   #include	<time.h>
>   #include	<sys/time.h>
> @@ -51,6 +52,25 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
>   #define srandom srand
>   #endif
>
> +#ifndef NO_DLM
> +#include	<libdlm.h>
> +#include	<errno.h>
> +#else
> +#define LKF_NOQUEUE	0x00000001
> +#define LKF_CONVERT	0x00000004
> +#define LKM_PWMODE	4
> +#define EUNLOCK		0x10002
> +
> +typedef void *dlm_lshandle_t;
> +
> +struct dlm_lksb {
> +	int sb_status;
> +	uint32_t sb_lkid;
> +	char sb_flags;
> +	char *sb_lvbptr;
> +};
> +#endif
> +
>   #include	<linux/kdev_t.h>
>   /*#include	<linux/fs.h> */
>   #include	<sys/mount.h>
> @@ -1428,7 +1448,33 @@ extern char *stat2devnm(struct stat *st);
>   extern char *fd2devnm(int fd);
>
>   extern int in_initrd(void);
> +
> +struct dlm_hookers {
> +	void *dlm_handle;	/* dlm lib related */
> +
> +	dlm_lshandle_t (*create_lockspace)(const char *name,
> +					   unsigned int mode);
> +	int (*release_lockspace)(const char *name, dlm_lshandle_t ls,
> +				 int force);
> +	int (*ls_lock)(dlm_lshandle_t lockspace, uint32_t mode,
> +		       struct dlm_lksb *lksb, uint32_t flags,
> +		       const void *name, unsigned int namelen,
> +		       uint32_t parent, void (*astaddr) (void *astarg),
> +		       void *astarg, void (*bastaddr) (void *astarg),
> +		       void *range);
> +	int (*ls_unlock)(dlm_lshandle_t lockspace, uint32_t lkid,
> +			 uint32_t flags, struct dlm_lksb *lksb,
> +			 void *astarg);
> +	int (*ls_get_fd)(dlm_lshandle_t ls);
> +	int (*dispatch)(int fd);
> +};
> +
>   extern int get_cluster_name(char **name);
> +extern int is_clustered(struct supertype *st);
> +extern int cluster_get_dlmlock(struct supertype *st, int *lockid);
> +extern int cluster_release_dlmlock(struct supertype *st, int lockid);
> +extern void set_dlm_hookers(void);
> +extern void free_dlm_hookers(void);
>
>   #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
>   #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
> diff --git a/super1.c b/super1.c
> index fda71e3..bd88c36 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1072,8 +1072,18 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>   	 * ignored.
>   	 */
>   	int rv = 0;
> +	int lockid;
>   	struct mdp_superblock_1 *sb = st->sb;
>
> +	if (is_clustered(st)) {
> +		rv = cluster_get_dlmlock(st, &lockid);
> +		if (rv) {
> +			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
> +			cluster_release_dlmlock(st, lockid);
> +			return rv;
> +		}
> +	}
> +
>   	if (strcmp(update, "homehost") == 0 &&
>   	    homehost) {
>   		/* Note that 'homehost' is special as it is really
> @@ -1330,6 +1340,9 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>   		rv = -1;
>
>   	sb->sb_csum = calc_sb_1_csum(sb);
> +	if (is_clustered(st))
> +		cluster_release_dlmlock(st, lockid);
> +
>   	return rv;
>   }
>
> @@ -1433,6 +1446,16 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
>   	struct mdp_superblock_1 *sb = st->sb;
>   	__u16 *rp = sb->dev_roles + dk->number;
>   	struct devinfo *di, **dip;
> +	int rv, lockid;
> +
> +	if (is_clustered(st)) {
> +		rv = cluster_get_dlmlock(st, &lockid);
> +		if (rv) {
> +			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
> +			cluster_release_dlmlock(st, lockid);
> +			return rv;
> +		}
> +	}
>
>   	if ((dk->state & 6) == 6) /* active, sync */
>   		*rp = __cpu_to_le16(dk->raid_disk);
> @@ -1460,6 +1483,9 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
>   	di->next = NULL;
>   	*dip = di;
>
> +	if (is_clustered(st))
> +		cluster_release_dlmlock(st, lockid);
> +
>   	return 0;
>   }
>   #endif
> @@ -1473,6 +1499,16 @@ static int store_super1(struct supertype *st, int fd)
>   	struct align_fd afd;
>   	int sbsize;
>   	unsigned long long dsize;
> +	int rv, lockid;
> +
> +	if (is_clustered(st)) {
> +		rv = cluster_get_dlmlock(st, &lockid);
> +		if (rv) {
> +			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
> +			cluster_release_dlmlock(st, lockid);
> +			return rv;
> +		}
> +	}
>
>   	if (!get_dev_size(fd, NULL, &dsize))
>   		return 1;
> @@ -1533,6 +1569,9 @@ static int store_super1(struct supertype *st, int fd)
>   		}
>   	}
>   	fsync(fd);
> +	if (is_clustered(st))
> +		cluster_release_dlmlock(st, lockid);
> +
>   	return 0;
>   }
>
> @@ -2282,6 +2321,16 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
>
>   static void free_super1(struct supertype *st)
>   {
> +	int rv, lockid;
> +	if (is_clustered(st)) {
> +		rv = cluster_get_dlmlock(st, &lockid);
> +		if (rv) {
> +			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
> +			cluster_release_dlmlock(st, lockid);
> +			return;
> +		}
> +	}
> +
>   	if (st->sb)
>   		free(st->sb);
>   	while (st->info) {
> @@ -2292,6 +2341,8 @@ static void free_super1(struct supertype *st)
>   		free(di);
>   	}
>   	st->sb = NULL;
> +	if (is_clustered(st))
> +		cluster_release_dlmlock(st, lockid);
>   }
>
>   #ifndef MDASSEMBLE
> diff --git a/util.c b/util.c
> index ea6e688..19ecf9f 100644
> --- a/util.c
> +++ b/util.c
> @@ -24,6 +24,7 @@
>
>   #include	"mdadm.h"
>   #include	"md_p.h"
> +#include	<sys/poll.h>
>   #include	<sys/socket.h>
>   #include	<sys/utsname.h>
>   #include	<sys/wait.h>
> @@ -88,6 +89,135 @@ struct blkpg_partition {
>      aren't permitted). */
>   #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>
> +static struct dlm_hookers *dlm_hookers = NULL;
> +static int is_dlm_hookers_ready = 0;

This should not be required, just checking for dlm_hooks == NULL should 
be enough. This needs to be set accordingly in set_dlm_hooks.

> +static struct dlm_lock_resource *dlm_lock_res = NULL;
> +static int ast_called = 0;
> +
> +struct dlm_lock_resource {
> +	dlm_lshandle_t *ls;
> +	struct dlm_lksb lksb;
> +};
> +
> +int is_clustered(struct supertype *st)
> +{
> +	/* is it a cluster md or not */
> +	if (is_dlm_hookers_ready && st->cluster_name)
> +		return 1;
> +	else
> +		return 0;
> +}
> +
> +/* Using poll(2) to wait for and dispatch ASTs */
> +static int poll_for_ast(dlm_lshandle_t ls)
> +{
> +	struct pollfd pfd;

Shouldn't you check dlm_hooks is NULL here? and starting of every 
function which requires dlm_hooks.

Also, a return value from these functions do not mean an error, it means 
the library is not present.


> +
> +	pfd.fd = dlm_hookers->ls_get_fd(ls);
> +	pfd.events = POLLIN;
> +
> +	while (!ast_called)
> +	{
> +		if (poll(&pfd, 1, 0) < 0)
> +		{
> +			perror("poll");
> +			return -1;
> +		}
> +		dlm_hookers->dispatch(dlm_hookers->ls_get_fd(ls));
> +	}
> +	ast_called = 0;
> +
> +	return 0;
> +}
> +
> +static void dlm_ast(void *arg)
> +{
> +	ast_called = 1;
> +}
> +
> +/* Create the lockspace, take bitmapXXX locks on all the bitmaps. */
> +int cluster_get_dlmlock(struct supertype *st, int *lockid)
> +{
> +	int ret = -1;
> +	char str[64];
> +	int flags = LKF_NOQUEUE;
> +
> +	dlm_lock_res = xmalloc(sizeof(struct dlm_lock_resource));
> +	if (!dlm_lock_res)
> +                goto out;
> +
> +	dlm_lock_res->ls = dlm_hookers->create_lockspace(st->cluster_name, O_RDWR);
> +	if (!dlm_lock_res->ls) {
> +		pr_err("%s failed to create lockspace\n", st->cluster_name);
> +                goto out;
> +	}
> +
> +	/* Conversions need the lockid in the LKSB */
> +	if (flags & LKF_CONVERT)
> +		dlm_lock_res->lksb.sb_lkid = *lockid;
> +
> +	snprintf(str, 64, "bitmap%04d", st->nodes);
> +	/* if flags with LKF_CONVERT causes below return ENOENT which means
> +	 * "No such file or directory" */
> +	ret = dlm_hookers->ls_lock(dlm_lock_res->ls, LKM_PWMODE, &dlm_lock_res->lksb,
> +			  flags, str, strlen(str), 0, dlm_ast,
> +			  dlm_lock_res, NULL, NULL);
> +	if (ret) {
> +		pr_err("error %d when get PW mode on lock %s\n", errno, str);
> +                goto out;
> +	}
> +
> +	/* Wait for it to complete */
> +	poll_for_ast(dlm_lock_res->ls);
> +	*lockid = dlm_lock_res->lksb.sb_lkid;
> +
> +	errno =	dlm_lock_res->lksb.sb_status;
> +	if (errno) {
> +		pr_err("error %d happened in ast with lock %s\n", errno, str);
> +		goto out;
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +int cluster_release_dlmlock(struct supertype *st, int lockid)
> +{
> +	int ret = -1;
> +
> +	/* if flags with LKF_CONVERT causes below return EINVAL which means
> +	 * "Invalid argument" */
> +	ret = dlm_hookers->ls_unlock(dlm_lock_res->ls, lockid, 0,
> +				     &dlm_lock_res->lksb, dlm_lock_res);
> +	if (ret) {
> +		pr_err("error %d happened when unlock\n", errno);
> +		/* XXX make sure the lock is unlocked eventually */
> +                goto out;
> +	}
> +
> +	/* Wait for it to complete */
> +	poll_for_ast(dlm_lock_res->ls);
> +
> +	errno =	dlm_lock_res->lksb.sb_status;
> +	if (errno != EUNLOCK) {
> +		pr_err("error %d happened in ast when unlock lockspace\n", errno);
> +		/* XXX make sure the lockspace is unlocked eventually */
> +                goto out;
> +	}
> +
> +	ret = dlm_hookers->release_lockspace(st->cluster_name, dlm_lock_res->ls, 1);
> +	if (ret) {
> +		pr_err("error %d happened when release lockspace\n", errno);
> +		/* XXX make sure the lockspace is released eventually */
> +                goto out;
> +	}
> +	free(dlm_lock_res);
> +
> +out:
> +	return ret;
> +}
> +
> +
>   /*
>    * Parse a 128 bit uuid in 4 integers
>    * format is 32 hexx nibbles with options :.<space> separator
> @@ -2043,3 +2173,38 @@ out:
>           dlclose(lib_handle);
>           return rv;
>   }
> +
> +void set_dlm_hookers(void)
> +{
> +	dlm_hookers = xmalloc(sizeof(struct dlm_hookers));
> +	if (!dlm_hookers)
> +		return;
> +
> +	dlm_hookers->dlm_handle = dlopen("libdlm_lt.so.3", RTLD_NOW | RTLD_LOCAL);
> +	if (!dlm_hookers->dlm_handle)
> +		return;
> +
> +	dlm_hookers->create_lockspace = dlsym(dlm_hookers->dlm_handle, "dlm_create_lockspace");
> +	dlm_hookers->release_lockspace = dlsym(dlm_hookers->dlm_handle, "dlm_release_lockspace");
> +	dlm_hookers->ls_lock = dlsym(dlm_hookers->dlm_handle, "dlm_ls_lock");
> +	dlm_hookers->ls_unlock = dlsym(dlm_hookers->dlm_handle, "dlm_ls_unlock");
> +	dlm_hookers->ls_get_fd = dlsym(dlm_hookers->dlm_handle, "dlm_ls_get_fd");
> +	dlm_hookers->dispatch = dlsym(dlm_hookers->dlm_handle, "dlm_dispatch");
> +
> +	if (!dlm_hookers->create_lockspace || !dlm_hookers->ls_lock ||
> +	    !dlm_hookers->ls_unlock || !dlm_hookers->release_lockspace ||
> +	    !dlm_hookers->ls_get_fd || !dlm_hookers->dispatch)
> +		dlclose(dlm_hookers->dlm_handle);
> +	else
> +		is_dlm_hookers_ready = 1;
> +}
> +
> +void free_dlm_hookers(void)
> +{
> +	if (is_dlm_hookers_ready) {
> +		dlclose(dlm_hookers->dlm_handle);
> +		is_dlm_hookers_ready = 0;
> +	}
> +	if (dlm_hookers)
> +		free(dlm_hookers);
> +}
>

-- 
Goldwyn
