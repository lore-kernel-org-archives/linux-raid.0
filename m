From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 2/8] imsm: write bad block log on metadata sync
Date: Wed, 16 Nov 2016 09:47:52 -0500
Message-ID: <wrfjd1hvmqg7.fsf@redhat.com>
References: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
        <1477925454-16809-2-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477925454-16809-2-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Mon, 31 Oct 2016 15:50:48 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> Pre-allocate memory for largest possible bad block sectionwhen monitor
> is being opened to avoid a need for memory allocation on metadata sync.
>
> If memory for a structure has been allocated in mpb buffer but it hasn't
> been used yet, it will be taken by next buffer grow, leading to
> insufficient memory on metadata flush. Start tracking such memory and
> take it into calculation when growing a buffer. Also assert has been
> added to debug mode to warn when more metadata has been written than
> memory allocated.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  super-intel.c | 49 +++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 45 insertions(+), 4 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index 5d6d534..0591c55 100644
> --- a/super-intel.c
> +++ b/super-intel.c

[snip]

> @@ -8854,6 +8886,9 @@ static void imsm_process_update(struct supertype *st,
>  		}
>  		break;
>  	}
> +	case update_prealloc_badblocks_mem: {
> +		break;
> +	}
>  	default:
>  		pr_err("error: unsuported process update type:(type: %d)\n",	type);
>  	}

Please don't include those awful brackets if you don't need them here.

> @@ -9094,6 +9129,11 @@ static int imsm_prepare_update(struct supertype *st,
>  	case update_add_remove_disk:
>  		/* no update->len needed */
>  		break;
> +	case update_prealloc_badblocks_mem: {
> +		super->extra_space += sizeof(struct bbm_log) -
> +			get_imsm_bbm_log_size(super->bbm_log);
> +		break;
> +	}
>  	default:
>  		return 0;
>  	}

Same here

Thanks,
Jes
