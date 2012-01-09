From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: raid1d crash at boot
Date: Mon, 9 Jan 2012 21:30:54 +0100
Message-ID: <20120109203054.GA11230@rere.qmqm.pl>
References: <20111119134139.GA30570@rere.qmqm.pl>
 <20120107125303.GA4862@rere.qmqm.pl>
 <20120109123552.4a5f44de@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120109123552.4a5f44de@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 09, 2012 at 12:35:52PM +1100, NeilBrown wrote:
> On Sat, 7 Jan 2012 13:53:04 +0100 Micha=B3 Miros=B3aw <mirq-linux@rer=
e.qmqm.pl>
> wrote:
> > On Sat, Nov 19, 2011 at 02:41:39PM +0100, Micha=B3 Miros=B3aw wrote=
:
> > > I get following BUG_ON tripped while booting, before rootfs is mo=
unted by
> > > Debian's initrd. This started to happen for kernels since sometim=
e
> > > during 3.1-rcX.
> > >=20
> > > [    6.246170] ------------[ cut here ]------------
> > > [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/drivers/s=
csi/scsi_lib.c:1153!
[...]
> > > [    6.249414]  [<ffffffff8124a9be>] ? sd_prep_fn+0x2cd/0xb72
> > > [    6.249490]  [<ffffffff811a5d67>] ? cfq_dispatch_requests+0x6f=
2/0x82c
> > > [    6.249567]  [<ffffffff8119a168>] ? blk_peek_request+0xc8/0x1b=
f
> > > [    6.249638]  [<ffffffff81243d83>] ? scsi_request_fn+0x64/0x406
> > > [    6.249708]  [<ffffffff8119a526>] ? blk_flush_plug_list+0x186/=
0x1b7
> > > [    6.249780]  [<ffffffff8119a562>] ? blk_finish_plug+0xb/0x2a
> > > [    6.249849]  [<ffffffff812a400f>] ? raid1d+0x91/0xb22
[...]
> > I've bisected this to following commit. It's not trivially revertab=
le on v3.2,
> > but I'll do some tries with it.
> Thanks for doing that - it is a great help.
> And you were right - the write-mostly flag is relevant.
> Please test this patch - it should fix the problem.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index cc24f0c..a368db2 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -531,8 +531,17 @@ static int read_balance(struct r1conf *conf, str=
uct r1bio *r1_bio, int *max_sect
>  		if (test_bit(WriteMostly, &rdev->flags)) {
>  			/* Don't balance among write-mostly, just
>  			 * use the first as a last resort */
> -			if (best_disk < 0)
> +			if (best_disk < 0) {
> +				if (is_badblock(rdev, this_sector, sectors,
> +						&first_bad, &bad_sectors)) {
> +					if (first_bad < this_sector)
> +						/* Cannot use this */
> +						continue;
> +					best_good_sectors =3D first_bad - this_sector;
> +				} else
> +					best_good_sectors =3D sectors;
>  				best_disk =3D disk;
> +			}
>  			continue;
>  		}
>  		/* This is a reasonable device to use.  It might
>=20

Built and booted fine. Thanks!

Micha=B3 Miros=B3aw
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
