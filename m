From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: FIX: spare cannot be added
Date: Tue, 25 Jan 2011 07:58:56 +1100
Message-ID: <20110125075856.1b2e5cd6@notabene.brown>
References: <20110114121304.14523.87734.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110114121304.14523.87734.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Fri, 14 Jan 2011 13:13:04 +0100 Adam Kwolek <adam.kwolek@intel.com> wrote:

> When Manage.c adds spare, it calls write_init_super() and this function
> is responsible for closing disk handle (Manage.c:812).
> For imsm case this handle is reused for managing this disk and handle
> (due to this it is not closed).
> As handle was opened with flag O_EXCL, adding disk to md fails on writing
> to new_dev (md cannot set lock on device).
> To resolve situation close current handle and open new one without O_EXCL flag.
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---

Thanks for the patch.
I think the real problem is that write_init_super show not be closing
the fds.  That seemed to make sense once, but it really doesn't now.
So I have:
  - made sure that free_super always closed the fds
  - stopped write_init_super from ever closing fds
  - added a few more calls to free_super.

In particular, the bug you found is now simply fixed by calling
free_super before calling sysfs_add_disk.

Thanks,
NeilBrown

> 
>  super-intel.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 4cbb070..4e1be5d 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3714,6 +3714,7 @@ static int mgmt_disk(struct supertype *st)
>  	struct intel_super *super = st->sb;
>  	size_t len;
>  	struct imsm_update_add_remove_disk *u;
> +	struct dl *d;
>  
>  	if (!super->disk_mgmt_list)
>  		return 0;
> @@ -3729,6 +3730,14 @@ static int mgmt_disk(struct supertype *st)
>  	u->type = update_add_remove_disk;
>  	append_metadata_update(st, u, len);
>  
> +	for (d = super->disk_mgmt_list; d ; d = d->next) {
> +		char buf[PATH_MAX];
> +
> +		close(d->fd);
> +		sprintf(buf, "%d:%d", d->major, d->minor);
> +		d->fd = dev_open(buf, O_RDWR | O_DIRECT);
> +	}
> +
>  	return 0;
>  }
>  

