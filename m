From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH 1/3] mdadm: improve the dlm locking mechanism for
 clustered raid
Date: Mon, 18 Dec 2017 10:42:29 -0500
Message-ID: <59c96891-1e6e-30de-8881-52c357c30fd3@gmail.com>
References: <20171213020040.3603-1-gqjiang@suse.com>
 <20171213020040.3603-2-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171213020040.3603-2-gqjiang@suse.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/12/2017 09:00 PM, Guoqing Jiang wrote:
> Previously, the dlm locking only protects several
> functions which writes to superblock (update_super,
> add_to_super and store_super), and we missed other
> funcs such as add_internal_bitmap. We also need to
> call the funcs which read superblock under the
> locking protection to avoid consistent issue.
> 
> So let's remove the dlm stuffs from super1.c, and
> provide the locking mechanism to the main() except
> assemble mode which will be handled in next commit.
> And since we can identify it is a clustered raid or
> not based on check the different conditions of each
> mode, so the change should not have effect on native
> array.
> 
> And we improve the existed locking stuffs as follows:
> 
> 1. replace ls_unlock with ls_unlock_wait since we
> should return when unlock operation is complete.
> 
> 2. inspired by lvm, let's also try to use the existed
> lockspace first before creat a lockspace blindly if
> the lockspace not released for some reason.
> 
> 3. try more times before quit if EAGAIN happened for
> locking.
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  mdadm.c  | 20 ++++++++++++++++++++
>  mdadm.h  |  8 +++++---
>  super1.c | 42 -----------------------------------------
>  util.c   | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
>  4 files changed, 80 insertions(+), 55 deletions(-)
> 
> diff --git a/mdadm.c b/mdadm.c
> index 62d7ec34a17f..895a9706b1d9 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -57,6 +57,7 @@ int main(int argc, char *argv[])
>  	struct mddev_dev *devlist = NULL;
>  	struct mddev_dev **devlistend = & devlist;
>  	struct mddev_dev *dv;
> +	mdu_array_info_t array;
>  	int devs_found = 0;
>  	char *symlinks = NULL;
>  	int grow_continue = 0;
> @@ -103,6 +104,7 @@ int main(int argc, char *argv[])
>  	FILE *outf;
>  
>  	int mdfd = -1;
> +	int locked = 0;
>  
>  	srandom(time(0) ^ getpid());
>  
> @@ -1434,6 +1436,22 @@ int main(int argc, char *argv[])
>  		/* --scan implied --brief unless -vv */
>  		c.brief = 1;
>  
> +	if (mode == CREATE) {
> +		if (s.bitmap_file && strcmp(s.bitmap_file, "clustered") == 0) {
> +			locked = lock_cluster();
> +			if (locked != 1)
> +				exit(1);
> +		}
> +	} else if (mode == MANAGE || mode == GROW || mode == INCREMENTAL) {
> +		if (!md_get_array_info(mdfd, &array)) {
> +			if (array.state & (1 << MD_SB_CLUSTERED)) {
> +				locked = lock_cluster();
> +				if (locked != 1)
> +					exit(1);
> +			}
> +		}
> +	}
> +

I like the switch to having more generic functions handling this rather
than open coding things too much. However the above still seems to be a
lot of multi case backwards hoops jumping. Anything we can do to
simplify this?

> +static int dlm_lockid = 0;
> +int lock_cluster(void)
> +{
> +	if (dlm_funs_ready()) {
> +		int rv;
> +
> +		rv = cluster_get_dlmlock(&dlm_lockid);
> +		if (rv) {
> +			pr_err("failed to lock cluster\n");
> +			return -1;
> +		}
> +		return 1;
> +	}
> +	pr_err("Something wrong with dlm library (libdlm_lt.so.3)\n");

Please don't refer explicitly to the soname of a library like this. It
is not a good error message.

> +	return 0;
> +}
> +
> +void unlock_cluster(void)
> +{
> +	if (dlm_lockid != 0 && dlm_funs_ready()) {
> +		int rv;
> +
> +		rv = cluster_release_dlmlock(dlm_lockid);
> +		if (rv)
> +			pr_err("failed to unlock cluster\n");
> +	}
> +}
> 

In addition, I don't like the use of a global variable to store this.
While the app isn't multithreaded it's still ugly, why not just return
the lockid itself as an indicator? There must be a known error value for it.

Thanks,
Jes
