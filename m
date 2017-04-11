From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: [PATCH] md: return 0 instead of error in rdev_attr_show()
Date: Tue, 11 Apr 2017 12:32:56 +0200
Message-ID: <af0d5660-f4cc-2e7d-61f2-9f313c8dadb2@profitbricks.com>
References: <769019bb-84a1-044f-bac1-d44ff1ee9177@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <769019bb-84a1-044f-bac1-d44ff1ee9177@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

We found the upstream fix, sorry for the noise...

Regards,
Michael Wang

On 04/11/2017 12:14 PM, Michael Wang wrote:
> 
> sysfs_kf_read() expect the show() callback return the dumped
> length, while rdev_attr_show() can return the error which lead
> into overflow:
> 
>  BUG: unable to handle kernel paging request at ffff88040b084000
>  IP: [<ffffffff812fe8f4>] __memmove+0x24/0x1a0
>  PGD 1edb067 PUD 1ede067 PMD 406b9a063 PTE 800000040b084161
>  Oops: 0003 [#1] SMP 
>  [snip]
>  Call Trace:
>   [<ffffffff81208c30>] ? sysfs_kf_read+0x80/0xb0
>   [<ffffffff81207e0b>] kernfs_fop_read+0xab/0x160
>   [<ffffffff81190be8>] __vfs_read+0x28/0xd0
>   [<ffffffff811911f6>] vfs_read+0x86/0x130
>   [<ffffffff81191fa6>] SyS_read+0x46/0xa0
>   [<ffffffff8158bc97>] entry_SYSCALL_64_fastpath+0x12/0x6a
> 
> Simply return 0 in case of error solved the problem.
> 
> Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
> ---
>  drivers/md/md.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1db88d7..d46d714 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3271,10 +3271,9 @@ rdev_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
>  	struct rdev_sysfs_entry *entry = container_of(attr, struct rdev_sysfs_entry, attr);
>  	struct md_rdev *rdev = container_of(kobj, struct md_rdev, kobj);
>  
> -	if (!entry->show)
> -		return -EIO;
> -	if (!rdev->mddev)
> -		return -EBUSY;
> +	if (!entry->show || !rdev->mddev)
> +		return 0;
> +
>  	return entry->show(rdev, page);
>  }
>  
> 
