From: Coly Li <colyli@suse.de>
Subject: Re: [md PATCH 2/2] md: support disabling of create-on-open semantics.
Date: Wed, 12 Apr 2017 22:49:34 +0800
Message-ID: <4e185cbe-cdbe-0f45-e060-99e408815e64@suse.de>
References: <149197804398.19936.12809382889200123725.stgit@noble>
 <149197837322.19936.7035050500466184535.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149197837322.19936.7035050500466184535.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2017/4/12 下午2:26, NeilBrown wrote:
> md allows a new array device to be created by simply
> opening a device file.  This make it difficult to
> remove the device and udev is likely to open the device file
> as part of processing the REMOVE event.
> 
> There is an alternate mechanism for creating arrays
> by writing to the new_array module parameter.
> When using tools that work with this parameter, it is
> best to disable the old semantics.
> This new module parameter allows that.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
>  drivers/md/md.c |   14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c3d3bae947a1..a7ab769eacc3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -174,6 +174,16 @@ static const struct block_device_operations md_fops;
>  
>  static int start_readonly;
>  
> +/*
> + * The original mechanism for creating an md device is to create
> + * a device node in /dev and to open it.  This causes races with device-close.
> + * The preferred method is to write to the "new_array" module parameter.
> + * This can avoid races.
> + * Setting create_on_open to false disables the original mechanism
> + * so all the races disappear.
> + */
> +static bool create_on_open = true;
> +
>  /* bio_clone_mddev
>   * like bio_clone_bioset, but with a local bio set
>   */
> @@ -5286,7 +5296,8 @@ static int md_alloc(dev_t dev, char *name)
>  
>  static struct kobject *md_probe(dev_t dev, int *part, void *data)
>  {
> -	md_alloc(dev, NULL);
> +	if (create_on_open)
> +		md_alloc(dev, NULL);
>  	return NULL;
>  }
>  
> @@ -9202,6 +9213,7 @@ static int set_ro(const char *val, struct kernel_param *kp)
>  module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
>  module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
>  module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
> +module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
>  
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("MD RAID framework");
> 
> 

