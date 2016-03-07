From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: dead code question
Date: Mon, 07 Mar 2016 21:18:32 +0800
Message-ID: <56DD7FA8.5070504@suse.com>
References: <wrfjpovaylve.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjpovaylve.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids


On 03/05/2016 05:27 AM, Jes Sorensen wrote:
> Hi,
>
> Another question regarding the cluster code. This one was introduced
> with:
>
> commit d15a1f72bd92bc4724ee94b2ae8132633ffeb72b
> Author: Guoqing Jiang <gqjiang@suse.com>
> Date:   Mon Oct 19 16:03:19 2015 +0800
>
>      Safeguard against writing to an active device of another node
>      
>      Modifying an exiting device's superblock or creating a new superblock
>      on an existing device needs to be checked because the device could be
>      in use by another node in another array. So, we check this by taking
>      all superblock locks in userspace so that we don't  step onto an active
>      device used by another node and safeguard against accidental edits.
>      After the edit is complete, we release all locks and the lockspace so
>      that it can be used by the kernel space.
>      
>      Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>      Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>      Signed-off-by: NeilBrown <neilb@suse.com>
>
> [snip]
>
> +/* Create the lockspace, take bitmapXXX locks on all the bitmaps. */
> +int cluster_get_dlmlock(struct supertype *st, int *lockid)
> +{
> +       int ret = -1;
> +       char str[64];
> +       int flags = LKF_NOQUEUE;
> +
> +       dlm_lock_res = xmalloc(sizeof(struct dlm_lock_resource));
> +       dlm_lock_res->ls = dlm_hooks->create_lockspace(st->cluster_name, O_RDWR);
> +       if (!dlm_lock_res->ls) {
> +               pr_err("%s failed to create lockspace\n", st->cluster_name);
> +                goto out;
> +       }
> +
> +       /* Conversions need the lockid in the LKSB */
> +       if (flags & LKF_CONVERT)
> +               dlm_lock_res->lksb.sb_lkid = *lockid;
>
> You set flags = LKF_NOQUEUE but later check (flags & LKF_CONVERT), which
> cannot be true given that:
>
> mdadm.h:#define LKF_NOQUEUE	0x00000001
> mdadm.h:#define LKF_CONVERT	0x00000004
>
> Is this a bug, or do you have pending patches for this?

Oops, I should remove the later check and will send the fix.

Thanks,
Guoqing
