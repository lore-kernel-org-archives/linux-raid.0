From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: md-cluster Module Requirement
Date: Thu, 1 Sep 2016 05:30:28 -0400
Message-ID: <57C7F534.3040400@suse.com>
References: <CAHkw+Lf82YEZ3qm9KJ_b_2pUiNFh=nDeEBXYV5PdgtEUtij8eg@mail.gmail.com>
 <57C79011.9090404@suse.com> <87h9a0cgkw.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h9a0cgkw.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>, Marc Smith <marc.smith@mcc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 09/01/2016 01:52 AM, NeilBrown wrote:
> On Thu, Sep 01 2016, Guoqing Jiang wrote:
>
>> On 08/26/2016 10:40 AM, Marc Smith wrote:
>>> Hi,
>>>
>>> I'm attempting to use md-cluster from Linux 4.5.2 with mdadm 3.4 and
>>> I'm running into this when attempting to create a RAID1 device with
>>> the clustered bitmap:
>>>
>>> --snip--
>>> [64782.619968] md: bind<dm-4>
>>> [64782.629336] md: bind<dm-3>
>>> [64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
>>> [64782.630528] md-cluster module not found.
>>> [64782.630530] md127: Could not setup cluster service (-2)
>>> [64782.630531] md127: bitmap file superblock:
>>> [64782.630532]          magic: 6d746962
>>> [64782.630533]        version: 5
>>> [64782.630534]           uuid: 10fee18f.f553d7f2.deb926f1.c7c4bd4b
>>> [64782.630534]         events: 0
>>> [64782.630535] events cleared: 0
>>> [64782.630536]          state: 00000000
>>> [64782.630537]      chunksize: 67108864 B
>>> [64782.630537]   daemon sleep: 5s
>>> [64782.630538]      sync size: 878956288 KB
>>> [64782.630539] max write behind: 0
>>> [64782.630541] md127: failed to create bitmap (-2)
>>> [64782.630577] md: md127 stopped.
>>> [64782.630581] md: unbind<dm-3>
>>> [64782.635133] md: export_rdev(dm-3)
>>> [64782.635145] md: unbind<dm-4>
>>> [64782.643111] md: export_rdev(dm-4)
>>> --snip--
>>>
>>> I'm using md-cluster built-in, not as a module:
>>> # zcat /proc/config.gz | grep MD_CLUSTER
>>> CONFIG_MD_CLUSTER=y
>>>
>>> It seems the driver is attempting to load the 'md-cluster' module
>>> (from drivers/md/md.c):
>>> --snip--
>>>           err = request_module("md-cluster");
>>>           if (err) {
>>>                   pr_err("md-cluster module not found.\n");
>>>                   return -ENOENT;
>>>           }
>>> --snip--
> I think this code is wrong.  It should be more like:
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d646f6e444f0..09036add7f33 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7612,15 +7612,13 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
>   {
>   	int err;
>   
> -	err = request_module("md-cluster");
> -	if (err) {
> -		pr_err("md-cluster module not found.\n");
> -		return -ENOENT;
> -	}
> +	if (!md_cluster_ops)
> +		request_module("md-cluster");
>   
>   	spin_lock(&pers_lock);
>   	if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
>   		spin_unlock(&pers_lock);
> +		pr_err("md-cluster module not found.\n");
>   		return -ENOENT;
>   	}
>   	spin_unlock(&pers_lock);

Thanks, how about below changes?

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7619,20 +7619,19 @@ EXPORT_SYMBOL(unregister_md_cluster_operations);

  int md_setup_cluster(struct mddev *mddev, int nodes)
  {
-       int err;
-
-       err = request_module("md-cluster");
-       if (err) {
-               pr_err("md-cluster module not found.\n");
-               return -ENOENT;
-       }
-
         spin_lock(&pers_lock);
-       if (!md_cluster_ops || !try_module_get(md_cluster_mod)) {
-               spin_unlock(&pers_lock);
-               return -ENOENT;
+       if (!md_cluster_ops) {
+               /* load module and ensure it won't be unloaded */
+               if (!request_module("md-cluster") &&
+                   !try_module_get(md_cluster_mod)) {
+                       pr_err("md-cluster module found.\n");
+                       spin_unlock(&pers_lock);
+               } else {
+                       pr_err("md-cluster module not found.\n");
+                       spin_unlock(&pers_lock);
+                       return -ENODEV;
+               }
         }
-       spin_unlock(&pers_lock);

         return md_cluster_ops->join(mddev, nodes);
  }

>>> I looked at linux-next and it appears this code is the same; is there
>>> a test we can do before attempting to load the module in the case that
>>> its built-in, or is there some other requirement that md-cluster needs
>>> to be built as a module?
>> Yes, we need some additional modules corosync/pacemaker and dlm,
> That doesn't explain the error message though.

You are right, I should read carefully :(

> If MD_CLUSTER is built in, then DLM must be too.

Sure,  then only need to ensure cluster is configured right.

Best Regards,
Guoqing
