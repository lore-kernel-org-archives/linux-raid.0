From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 2/2] Make cmap_* also has same policy as dlm_*
Date: Mon, 3 Aug 2015 06:58:30 -0500
Message-ID: <55BF5766.9070008@suse.com>
References: <1438601519-17919-1-git-send-email-gqjiang@suse.com>
 <1438601519-17919-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1438601519-17919-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, neilb@suse.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 08/03/2015 06:31 AM, Guoqing Jiang wrote:
> Let libcmap lib and related funs also only need one-time
> setup during mdadm running period.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>   mdadm.c | 23 +++++++++++--------
>   mdadm.h | 20 ++++++++++++++++
>   util.c  | 81 +++++++++++++++++++++++++++++++++++++++--------------------------
>   3 files changed, 82 insertions(+), 42 deletions(-)
>
> diff --git a/mdadm.c b/mdadm.c
> index d8032c1..4812fc5 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1293,18 +1293,22 @@ int main(int argc, char *argv[])
>   		c.require_homehost = 0;
>   	}
>
> +	set_hookers(); /* set hookers from libs */
> +
>   	if (c.homecluster == NULL && (c.nodes > 0)) {
>   		c.homecluster = conf_get_homecluster();
>   		if (c.homecluster == NULL)
>   			rv = get_cluster_name(&c.homecluster);
>   		if (rv != 0) {
>   			pr_err("The md can't get cluster name\n");
> +			free_hookers();
>   			exit(1);
>   		}
>   	}
>
>   	if (c.backup_file && data_offset != INVALID_SECTORS) {
>   		pr_err("--backup-file and --data-offset are incompatible\n");
> +		free_hookers();
>   		exit(2);
>   	}
>
> @@ -1313,6 +1317,7 @@ int main(int argc, char *argv[])
>   		/* Anyone may try this */;
>   	else if (geteuid() != 0) {
>   		pr_err("must be super-user to perform this action\n");
> +		free_hookers();
>   		exit(1);
>   	}
>
> @@ -1322,8 +1327,6 @@ int main(int argc, char *argv[])
>   		/* --scan implied --brief unless -vv */
>   		c.brief = 1;
>
> -	set_dlm_hookers(); /* get dlm funcs from libdlm_lt.so.3 */
> -
>   	rv = 0;
>   	switch(mode) {
>   	case MANAGE:
> @@ -1364,12 +1367,12 @@ int main(int argc, char *argv[])
>   		else if (devs_found > 0) {
>   			if (c.update && devs_found > 1) {
>   				pr_err("can only update a single array at a time\n");
> -				free_dlm_hookers(); /* close dlm stuffs */
> +				free_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			if (c.backup_file && devs_found > 1) {
>   				pr_err("can only assemble a single array when providing a backup file.\n");
> -				free_dlm_hookers(); /* close dlm stuffs */
> +				free_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			for (dv = devlist ; dv ; dv=dv->next) {
> @@ -1388,12 +1391,12 @@ int main(int argc, char *argv[])
>   		} else {
>   			if (c.update) {
>   				pr_err("--update not meaningful with a --scan assembly.\n");
> -				free_dlm_hookers(); /* close dlm stuffs */
> +				free_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			if (c.backup_file) {
>   				pr_err("--backup_file not meaningful with a --scan assembly.\n");
> -				free_dlm_hookers(); /* close dlm stuffs */
> +				free_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			rv = scan_assemble(ss, &c, &ident);
> @@ -1461,14 +1464,14 @@ int main(int argc, char *argv[])
>   		if (devmode == 'E') {
>   			if (devlist == NULL && !c.scan) {
>   				pr_err("No devices to examine\n");
> -				free_dlm_hookers(); /* close dlm stuffs */
> +				free_hookers(); /* close dlm stuffs */
>   				exit(2);
>   			}
>   			if (devlist == NULL)
>   				devlist = conf_get_devs();
>   			if (devlist == NULL) {
>   				pr_err("No devices listed in %s\n", configfile?configfile:DefaultConfFile);
> -				free_dlm_hookers(); /* close dlm stuffs */
> +				free_hookers(); /* close dlm stuffs */
>   				exit(1);
>   			}
>   			rv = Examine(devlist, &c, ss);
> @@ -1485,7 +1488,7 @@ int main(int argc, char *argv[])
>   				rv = Write_rules(udev_filename);
>   			else {
>   				pr_err("No devices given.\n");
> -				free_dlm_hookers(); /* close dlm stuffs */
> +				free_hookers(); /* close dlm stuffs */
>   				exit(2);
>   			}
>   		} else
> @@ -1625,7 +1628,7 @@ int main(int argc, char *argv[])
>   		break;
>   	}
>
> -	free_dlm_hookers(); /* close dlm stuffs */
> +	free_hookers(); /* close dlm stuffs */
>   	exit(rv);
>   }
>
> diff --git a/mdadm.h b/mdadm.h
> index c53adc5..dd7fef4 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -52,6 +52,12 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
>   #define srandom srand
>   #endif
>
> +#ifdef NO_COROSYNC
> +#define CS_OK 1
> +#else
> +#include	<corosync/cmap.h>
> +#endif
> +
>   #ifndef NO_DLM
>   #include	<libdlm.h>
>   #include	<errno.h>
> @@ -1449,6 +1455,16 @@ extern char *fd2devnm(int fd);
>
>   extern int in_initrd(void);
>
> +struct cmap_hookers {
> +	void *cmap_handle;	/* corosync lib related */
> +
> +	int (*initialize)(cmap_handle_t *handle);
> +	int (*get_string)(cmap_handle_t handle,
> +			  const char *string,
> +			  char **name);
> +	int (*finalize)(cmap_handle_t handle);
> +};
> +
>   struct dlm_hookers {
>   	void *dlm_handle;	/* dlm lib related */
>
> @@ -1475,6 +1491,10 @@ extern int cluster_get_dlmlock(struct supertype *st, int *lockid);
>   extern int cluster_release_dlmlock(struct supertype *st, int lockid);
>   extern void set_dlm_hookers(void);
>   extern void free_dlm_hookers(void);
> +extern void set_cmap_hookers(void);
> +extern void free_cmap_hookers(void);
> +extern void set_hookers(void);
> +extern void free_hookers(void);
>
>   #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
>   #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
> diff --git a/util.c b/util.c
> index 19ecf9f..1c87eb5 100644
> --- a/util.c
> +++ b/util.c
> @@ -36,13 +36,6 @@
>   #include	<dirent.h>
>   #include	<signal.h>
>   #include	<dlfcn.h>
> -#include	<stdint.h>
> -#ifdef NO_COROSYNC
> - typedef uint64_t cmap_handle_t;
> - #define CS_OK 1
> -#else
> - #include	<corosync/cmap.h>
> -#endif
>
>
>   /*
> @@ -2126,40 +2119,53 @@ void reopen_mddev(int mdfd)
>   		dup2(fd, mdfd);
>   }
>
> -int get_cluster_name(char **cluster_name)
> +static struct cmap_hookers *cmap_hookers = NULL;
> +static int is_cmap_hookers_ready = 0;
> +
> +void set_cmap_hookers(void)
>   {
> -        void *lib_handle = NULL;
> -        int rv = -1;
> +	cmap_hookers = xmalloc(sizeof(struct cmap_hookers));
> +	if (!cmap_hookers)
> +		return;
>
> -        cmap_handle_t handle;
> -        static int (*initialize)(cmap_handle_t *handle);
> -        static int (*get_string)(cmap_handle_t handle,
> -				 const char *string,
> -				 char **name);
> -        static int (*finalize)(cmap_handle_t handle);
> +	cmap_hookers->cmap_handle = dlopen("libcmap.so.4", RTLD_NOW | RTLD_LOCAL);
> +	if (!cmap_hookers->cmap_handle)
> +		return;
>
> +	cmap_hookers->initialize = dlsym(cmap_hookers->cmap_handle, "cmap_initialize");
> +	cmap_hookers->get_string = dlsym(cmap_hookers->cmap_handle, "cmap_get_string");
> +	cmap_hookers->finalize = dlsym(cmap_hookers->cmap_handle, "cmap_finalize");
>
> -        lib_handle = dlopen("libcmap.so.4", RTLD_NOW | RTLD_LOCAL);
> -        if (!lib_handle)
> -                return rv;
> +	if (!cmap_hookers->initialize || !cmap_hookers->get_string ||
> +	    !cmap_hookers->finalize)
> +		dlclose(cmap_hookers->cmap_handle);
> +	else
> +		is_cmap_hookers_ready = 1;
> +}
>
> -        initialize = dlsym(lib_handle, "cmap_initialize");
> -        if (!initialize)
> -                goto out;
> +void free_cmap_hookers(void)
> +{
> +	if (is_cmap_hookers_ready) {
> +		dlclose(cmap_hookers->cmap_handle);
> +		is_cmap_hookers_ready = 0;
> +	}
> +	if (cmap_hookers)
> +		free(cmap_hookers);
> +}
>
> -        get_string = dlsym(lib_handle, "cmap_get_string");
> -        if (!get_string)
> -                goto out;
> +int get_cluster_name(char **cluster_name)
> +{
> +        int rv = -1;
> +	cmap_handle_t handle;
>
> -        finalize = dlsym(lib_handle, "cmap_finalize");
> -        if (!finalize)
> -                goto out;
> +	if (!is_cmap_hookers_ready)
> +		return rv;
>
> -        rv = initialize(&handle);
> +        rv = cmap_hookers->initialize(&handle);
>           if (rv != CS_OK)
>                   goto out;
>
> -        rv = get_string(handle, "totem.cluster_name", cluster_name);
> +        rv = cmap_hookers->get_string(handle, "totem.cluster_name", cluster_name);
>           if (rv != CS_OK) {
>                   free(*cluster_name);
>                   rv = -1;
> @@ -2168,9 +2174,8 @@ int get_cluster_name(char **cluster_name)
>
>           rv = 0;
>   name_err:
> -        finalize(handle);
> +        cmap_hookers->finalize(handle);
>   out:
> -        dlclose(lib_handle);
>           return rv;
>   }
>
> @@ -2208,3 +2213,15 @@ void free_dlm_hookers(void)
>   	if (dlm_hookers)
>   		free(dlm_hookers);
>   }
> +
> +void set_hookers(void)
> +{
> +	set_dlm_hookers();
> +	set_cmap_hookers();
> +}
> +
> +void free_hookers(void)
> +{
> +	free_dlm_hookers();
> +	free_cmap_hookers();
> +}
>

You could put both functions in a single structure called cluster_hooks.

-- 
Goldwyn
