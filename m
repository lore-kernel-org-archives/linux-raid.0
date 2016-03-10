From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH mdadm] ddf: use 64bit 'size', not 32bit 'info->size' for create.
Date: Thu, 10 Mar 2016 11:43:46 -0500
Message-ID: <wrfjio0u1dx9.fsf@redhat.com>
References: <87a8m6ke0c.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a8m6ke0c.fsf@notabene.neil.brown.name> (NeilBrown's message of
	"Thu, 10 Mar 2016 18:06:59 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Dan Russell <dpr@aol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.com> writes:
> The 'size' field of mdu_disk_info_t is 32bit and should not be used
> except for legacy ioctls.  super-ddf got this wrong :-(
>
> This change makes it possible to create ddf arrays which used more than
> 2TB of each device.
>
> Reported-by: Dan Russell <dpr@aol.com>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  super-ddf.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/super-ddf.c b/super-ddf.c
> index faaf0a7ca9e0..0e00d17dd169 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -2688,10 +2688,10 @@ static int init_super_ddf_bvd(struct supertype *st,
>  		free(vcl);
>  		return 0;
>  	}
> -	vc->blocks = cpu_to_be64(info->size * 2);
> +	vc->blocks = cpu_to_be64(size * 2);
>  	vc->array_blocks = cpu_to_be64(
>  		calc_array_size(info->level, info->raid_disks, info->layout,
> -				info->chunk_size, info->size*2));
> +				info->chunk_size, size*2));
>  	memset(vc->pad1, 0xff, 8);
>  	vc->spare_refs[0] = cpu_to_be32(0xffffffff);
>  	vc->spare_refs[1] = cpu_to_be32(0xffffffff);

Thanks for the fix! I applied it with a small mod, adding the missing
spaces in the last line:

> +				info->chunk_size, size * 2));

Cheers,
Jes
