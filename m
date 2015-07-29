From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] Safeguard against writing to an active device of
 another node
Date: Wed, 29 Jul 2015 17:28:53 +1000
Message-ID: <20150729172853.33d44808@noble>
References: <1436172732-21021-1-git-send-email-gqjiang@suse.com>
	<1436172732-21021-3-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436172732-21021-3-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon,  6 Jul 2015 16:52:12 +0800 Guoqing Jiang <gqjiang@suse.com>
wrote:

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

Hi,
 thanks for these.
 I've applied 1 and 2.

 Could you re-do this on to follow the kernel style of #ifdefs,
 so that the #ifdefs only appear in header files.
 i.e. when NO_DLM is defined, is_clustered() always evaluates to zero
 and clustered_get_dlmlock() always succeeds etc.

Thanks,
NeilBrown



> ---
> Against cluster branch.
> 
>  Makefile |   6 ++-
>  mdadm.h  |   3 ++
>  super1.c |  62 +++++++++++++++++++++++++++++++
>  util.c   | 127 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 197 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index c189279..a76ae13 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -81,11 +81,12 @@ FAILED_SLOTS_DIR = $(RUN_DIR)/failed-slots
>  SYSTEMD_DIR=/lib/systemd/system
>  
>  COROSYNC:=$(shell [ -d /usr/include/corosync ] || echo -DNO_COROSYNC)
> +DLM:=$(shell [ -f /usr/include/libdlm.h ] || echo -DNO_DLM)
>  
>  DIRFLAGS = -DMAP_DIR=\"$(MAP_DIR)\" -DMAP_FILE=\"$(MAP_FILE)\"
>  DIRFLAGS += -DMDMON_DIR=\"$(MDMON_DIR)\"
>  DIRFLAGS += -DFAILED_SLOTS_DIR=\"$(FAILED_SLOTS_DIR)\"
> -CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS) $(COROSYNC)
> +CFLAGS = $(CWFLAGS) $(CXFLAGS) -DSendmail=\""$(MAILCMD)"\" $(CONFFILEFLAGS) $(DIRFLAGS) $(COROSYNC) $(DLM)
>  
>  VERSION = $(shell [ -d .git ] && git describe HEAD | sed 's/mdadm-//')
>  VERS_DATE = $(shell [ -d .git ] && date --date="`git log -n1 --format=format:%cd --date=short`" '+%0dth %B %Y' | sed -e 's/1th/1st/' -e 's/2th/2nd/' -e 's/11st/11th/' -e 's/12nd/12th/')
> @@ -105,6 +106,9 @@ endif
>  # LDFLAGS = -static
>  # STRIP = -s
>  LDLIBS=-ldl
> +ifneq ($(DLM), -DNO_DLM)
> +LDLIBS += -ldlm_lt
> +endif
>  
>  INSTALL = /usr/bin/install
>  DESTDIR =
> diff --git a/mdadm.h b/mdadm.h
> index 97892e6..59f851e 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1429,6 +1429,9 @@ extern char *fd2devnm(int fd);
>  
>  extern int in_initrd(void);
>  extern int get_cluster_name(char **name);
> +extern int is_clustered(struct supertype *st);
> +extern int cluster_get_dlmlock(struct supertype *st, int *lockid);
> +extern int cluster_release_dlmlock(struct supertype *st, int lockid);
>  
>  #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
>  #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
> diff --git a/super1.c b/super1.c
> index 9b991e6..f4d6345 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1074,6 +1074,18 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>  	int rv = 0;
>  	struct mdp_superblock_1 *sb = st->sb;
>  
> +#ifndef NO_DLM
> +	int lockid;
> +	if (is_clustered(st)) {
> +		rv = cluster_get_dlmlock(st, &lockid);
> +		if (rv) {
> +			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
> +			cluster_release_dlmlock(st, lockid);
> +			return rv;
> +		}
> +	}
> +#endif
> +
>  	if (strcmp(update, "homehost") == 0 &&
>  	    homehost) {
>  		/* Note that 'homehost' is special as it is really
> @@ -1330,6 +1342,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>  		rv = -1;
>  
>  	sb->sb_csum = calc_sb_1_csum(sb);
> +#ifndef NO_DLM
> +	if (is_clustered(st))
> +		cluster_release_dlmlock(st, lockid);
> +#endif
>  	return rv;
>  }
>  
> @@ -1434,6 +1450,17 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
>  	__u16 *rp = sb->dev_roles + dk->number;
>  	struct devinfo *di, **dip;
>  
> +#ifndef NO_DLM
> +	int rv, lockid;
> +	if (is_clustered(st)) {
> +		rv = cluster_get_dlmlock(st, &lockid);
> +		if (rv) {
> +			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
> +			cluster_release_dlmlock(st, lockid);
> +			return rv;
> +		}
> +	}
> +#endif
>  	if ((dk->state & 6) == 6) /* active, sync */
>  		*rp = __cpu_to_le16(dk->raid_disk);
>  	else if ((dk->state & ~2) == 0) /* active or idle -> spare */
> @@ -1460,6 +1487,10 @@ static int add_to_super1(struct supertype *st, mdu_disk_info_t *dk,
>  	di->next = NULL;
>  	*dip = di;
>  
> +#ifndef NO_DLM
> +	if (is_clustered(st))
> +		cluster_release_dlmlock(st, lockid);
> +#endif
>  	return 0;
>  }
>  #endif
> @@ -1474,6 +1505,18 @@ static int store_super1(struct supertype *st, int fd)
>  	int sbsize;
>  	unsigned long long dsize;
>  
> +#ifndef NO_DLM
> +	int rv, lockid;
> +	if (is_clustered(st)) {
> +		rv = cluster_get_dlmlock(st, &lockid);
> +		if (rv) {
> +			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
> +			cluster_release_dlmlock(st, lockid);
> +			return rv;
> +		}
> +	}
> +#endif
> +
>  	if (!get_dev_size(fd, NULL, &dsize))
>  		return 1;
>  
> @@ -1533,6 +1576,10 @@ static int store_super1(struct supertype *st, int fd)
>  		}
>  	}
>  	fsync(fd);
> +#ifndef NO_DLM
> +	if (is_clustered(st))
> +		cluster_release_dlmlock(st, lockid);
> +#endif
>  	return 0;
>  }
>  
> @@ -2282,6 +2329,17 @@ static int write_bitmap1(struct supertype *st, int fd, enum bitmap_update update
>  
>  static void free_super1(struct supertype *st)
>  {
> +#ifndef NO_DLM
> +	int rv, lockid;
> +	if (is_clustered(st)) {
> +		rv = cluster_get_dlmlock(st, &lockid);
> +		if (rv) {
> +			pr_err("Cannot get dlmlock in %s return %d\n", __func__, rv);
> +			cluster_release_dlmlock(st, lockid);
> +			return;
> +		}
> +	}
> +#endif
>  	if (st->sb)
>  		free(st->sb);
>  	while (st->info) {
> @@ -2292,6 +2350,10 @@ static void free_super1(struct supertype *st)
>  		free(di);
>  	}
>  	st->sb = NULL;
> +#ifndef NO_DLM
> +	if (is_clustered(st))
> +		cluster_release_dlmlock(st, lockid);
> +#endif
>  }
>  
>  #ifndef MDASSEMBLE
> diff --git a/util.c b/util.c
> index ea6e688..3357957 100644
> --- a/util.c
> +++ b/util.c
> @@ -24,6 +24,7 @@
>  
>  #include	"mdadm.h"
>  #include	"md_p.h"
> +#include	<sys/poll.h>
>  #include	<sys/socket.h>
>  #include	<sys/utsname.h>
>  #include	<sys/wait.h>
> @@ -42,6 +43,10 @@
>  #else
>   #include	<corosync/cmap.h>
>  #endif
> +#ifndef NO_DLM
> +#include	<libdlm.h>
> +#include	<errno.h>
> +#endif
>  
>  
>  /*
> @@ -88,6 +93,128 @@ struct blkpg_partition {
>     aren't permitted). */
>  #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>  
> +#ifndef NO_DLM
> +struct dlm_lock_resource {
> +	dlm_lshandle_t *ls;
> +	struct dlm_lksb lksb;
> +};
> +
> +struct dlm_lock_resource *dlm_lock_res = NULL;
> +static int ast_called = 0;
> +
> +int is_clustered(struct supertype *st)
> +{
> +	/* is it a cluster md or not */
> +	return st->cluster_name ? 1 :0;
> +}
> +
> +/* Using poll(2) to wait for and dispatch ASTs */
> +static int poll_for_ast(dlm_lshandle_t ls)
> +{
> +	struct pollfd pfd;
> +
> +	pfd.fd = dlm_ls_get_fd(ls);
> +	pfd.events = POLLIN;
> +
> +	while (!ast_called)
> +	{
> +		if (poll(&pfd, 1, 0) < 0)
> +		{
> +			perror("poll");
> +			return -1;
> +		}
> +		dlm_dispatch(dlm_ls_get_fd(ls));
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
> +	int ret;
> +	char str[64];
> +	int flags = LKF_NOQUEUE;
> +
> +	dlm_lock_res = xmalloc(sizeof(struct dlm_lock_resource));
> +	if (!dlm_lock_res)
> +		return -ENOMEM;
> +
> +	dlm_lock_res->ls = dlm_create_lockspace(st->cluster_name, O_RDWR);
> +	if (!dlm_lock_res->ls) {
> +		pr_err("%s failed to create lockspace\n", st->cluster_name);
> +		return -1;
> +	}
> +
> +	/* Conversions need the lockid in the LKSB */
> +	if (flags & LKF_CONVERT)
> +		dlm_lock_res->lksb.sb_lkid = *lockid;
> +
> +	snprintf(str, 64, "bitmap%04d", st->nodes);
> +	/* if flags with LKF_CONVERT causes below return ENOENT which means
> +	 * "No such file or directory" */
> +	ret = dlm_ls_lock(dlm_lock_res->ls, LKM_PWMODE, &dlm_lock_res->lksb,
> +			  flags, str, strlen(str), 0, dlm_ast,
> +			  dlm_lock_res, NULL, NULL);
> +	if (ret) {
> +		pr_err("error %d when get PW mode on lock %s\n", errno, str);
> +		return ret;
> +	}
> +
> +	/* Wait for it to complete */
> +	poll_for_ast(dlm_lock_res->ls);
> +	*lockid = dlm_lock_res->lksb.sb_lkid;
> +
> +	errno =	dlm_lock_res->lksb.sb_status;
> +	if (errno) {
> +	    pr_err("error %d happened in ast with lock %s\n", errno, str);
> +	    return -1;
> +	}
> +
> +	return 0;
> +}
> +
> +int cluster_release_dlmlock(struct supertype *st, int lockid)
> +{
> +	int ret;
> +
> +	/* if flags with LKF_CONVERT causes below return EINVAL which means
> +	 * "Invalid argument" */
> +	ret = dlm_ls_unlock(dlm_lock_res->ls, lockid, 0, &dlm_lock_res->lksb, dlm_lock_res);
> +	if (ret) {
> +		pr_err("error %d happened when unlock\n", errno);
> +		/* XXX make sure the lock is unlocked eventually */
> +		return ret;
> +	}
> +
> +	/* Wait for it to complete */
> +	poll_for_ast(dlm_lock_res->ls);
> +
> +	errno =	dlm_lock_res->lksb.sb_status;
> +	if (errno != EUNLOCK) {
> +		pr_err("error %d happened in ast when unlock lockspace\n", errno);
> +		/* XXX make sure the lockspace is unlocked eventually */
> +		return -1;
> +	}
> +
> +	ret = dlm_release_lockspace(st->cluster_name, dlm_lock_res->ls, 1);
> +	if (ret) {
> +		pr_err("error %d happened when release lockspace\n", errno);
> +		/* XXX make sure the lockspace is released eventually */
> +		return ret;
> +	}
> +	free(dlm_lock_res);
> +
> +	return 0;
> +}
> +#endif
> +
>  /*
>   * Parse a 128 bit uuid in 4 integers
>   * format is 32 hexx nibbles with options :.<space> separator

