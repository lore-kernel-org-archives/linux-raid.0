From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 2/4] imsm: FIX: spare cannot be added
Date: Thu, 27 Jan 2011 13:02:36 +1000
Message-ID: <20110127130236.07f70a98@nbeee.brown>
References: <20110120104759.22926.66874.stgit@gklab-128-013.igk.intel.com>
	<20110120105730.22926.93231.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110120105730.22926.93231.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Thu, 20 Jan 2011 11:57:30 +0100
Adam Kwolek <adam.kwolek@intel.com> wrote:

> When Manage.c adds spare, it calls write_init_super() and this
> function is responsible for closing disk handle (Manage.c:812).
> For imsm case this handle is reused for managing this disk and handle
> (due to this it is not closed).
> As handle was opened with flag O_EXCL, adding disk to md fails on
> writing to new_dev (md cannot set lock on device).
> To resolve situation close current handle and open new one without
> O_EXCL flag.

Thanks.
I have created a different solution. write_init_super doesn't close
anything any more. 
Hopefully the new approach works better.

Thanks,
NeilBrown

> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
> 
>  super-intel.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 7f907ef..0d6d2ee 100644
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

