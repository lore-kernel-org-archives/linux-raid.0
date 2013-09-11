From: Martin Wilck <mwilck@arcor.de>
Subject: Re: mdadm 3.3: issue with mdmon --takeover
Date: Wed, 11 Sep 2013 22:51:20 +0200
Message-ID: <5230D7C8.6080908@arcor.de>
References: <CAC9WiBjg4Tbv_UM4o66-8jtFEYGvh3kuP6xSdnz7uL+fq3fZTQ@mail.gmail.com>	<20130904160832.3627bcb8@notabene.brown>	<CAC9WiBiHkOjqY4nDwMh4S8td9NMz2mrdqK0R7cZp7nKSMyhBvg@mail.gmail.com>	<20130905121123.27968f9f@notabene.brown>	<CAC9WiBiHcS126iFv91250d83sMrBYmRbvoqYAEhjJWjb2p5J3A@mail.gmail.com>	<CAC9WiBgRiu_YL1TpzD4dtLXv=LiA-RERn+C6Q+i=P_WTNdw3+w@mail.gmail.com> <20130911093518.794bbb21@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130911093518.794bbb21@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/11/2013 01:35 AM, NeilBrown wrote:
> I think this patch will help.  The last hunk in particular should make the
> difference.
> 
> Please let me know if it fixes the problem.

Thanks for figuring this out. Indeed I forgot the possibility that
secondary LBA may be unused when I wrote that code.

Are you going to fix this directly? Otherwise I might go over it,
double-check, and submit a patch.

Martin

> 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/super-ddf.c b/super-ddf.c
> index 636d7b4..86f9bb0 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -880,7 +880,7 @@ static int load_ddf_headers(int fd, struct ddf_super *super, char *devname)
>  			super->primary.openflag && !super->secondary.openflag)
>  			)
>  			super->active = &super->secondary;
> -	} else if (devname)
> +	} else if (devname && super->anchor.secondary_lba != ~(__u64)0)
>  		pr_err("Failed to load secondary DDF header on %s\n",
>  		       devname);
>  	if (super->active == NULL)
> @@ -2810,7 +2810,8 @@ static int add_to_super_ddf(struct supertype *st,
>  	} while (0)
>  	__calc_lba(dd, ddf->dlist, workspace_lba, 32);
>  	__calc_lba(dd, ddf->dlist, primary_lba, 16);
> -	__calc_lba(dd, ddf->dlist, secondary_lba, 32);
> +	if (ddf->dlist == NULL || ddf->dlist->secondary_lba != ~(__u64)0)
> +		__calc_lba(dd, ddf->dlist, secondary_lba, 32);
>  	pde->config_size = dd->workspace_lba;
>  
>  	sprintf(pde->path, "%17.17s","Information: nil") ;
> @@ -2892,6 +2893,8 @@ static int __write_ddf_structure(struct dl *d, struct ddf_super *ddf, __u8 type)
>  	default:
>  		return 0;
>  	}
> +	if (sector == ~(__u64)0)
> +		return 0;
>  
>  	header->type = type;
>  	header->openflag = 1;

