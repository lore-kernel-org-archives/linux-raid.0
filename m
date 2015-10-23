From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
Date: Fri, 23 Oct 2015 16:35:00 -0400
Message-ID: <wrfjwpud9vd7.fsf@redhat.com>
References: <1445589144-12157-1-git-send-email-xni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1445589144-12157-1-git-send-email-xni@redhat.com> (Xiao Ni's
	message of "Fri, 23 Oct 2015 16:32:24 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Xiao Ni <xni@redhat.com> writes:
> One raid1 with bitmap is composed by 4 disks. It'll fail when rashape to raid0
> and lose 3 disks. It should check bitmap first when reshape raid1 to raid0.
> ---
>  Grow.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)

Xiao,

I believe you are also required to apply a Signed-off-by: line when
posting patches against mdadm.

Cheers,
Jes

>
> diff --git a/Grow.c b/Grow.c
> index 80d7b22..5e9b0bb 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1898,6 +1898,12 @@ size_change_error:
>  	     array.layout == ((1 << 8) + 2) && !(array.raid_disks & 1)) ||
>  	    (s->level == 0 && array.level == 1 && sra)) {
>  		int err;
> +
> +		if (array.state & (1<<MD_SB_BITMAP_PRESENT)) {
> +			cont_err("Bitmap must be removed before level can be changed\n");
> +			rv = 1;
> +			goto release;
> +		}
>  		err = remove_disks_for_takeover(st, sra, array.layout);
>  		if (err) {
>  			dprintf("Array cannot be reshaped\n");
> @@ -2706,9 +2712,6 @@ static int impose_level(int fd, int level, char *devname, int verbose)
>  			err = errno;
>  			pr_err("%s: could not set level to %s\n",
>  				devname, c);
> -			if (err == EBUSY &&
> -			    (array.state & (1<<MD_SB_BITMAP_PRESENT)))
> -				cont_err("Bitmap must be removed before level can be changed\n");
>  			return err;
>  		}
>  		if (verbose >= 0)
