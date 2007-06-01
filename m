From: "Don Dupuis" <dondster@gmail.com>
Subject: Re: Md corruption using RAID10 on linux-2.6.21
Date: Fri, 1 Jun 2007 10:58:32 -0500
Message-ID: <632b79000706010858y7bbafc11r2867aacf7d25ba69@mail.gmail.com>
References: <632b79000705161138h359f71egdf4ad5d483731dbe@mail.gmail.com>
	 <632b79000705161957j5443e3b9h1d6da8593395f736@mail.gmail.com>
	 <632b79000705161958m67a192bav73ab3dafc08825d0@mail.gmail.com>
	 <632b79000705162050w70a2feb1w14919fde6e98818c@mail.gmail.com>
	 <632b79000705211232gfb57e0focae8cdd0bf25bef@mail.gmail.com>
	 <18002.15951.765872.809204@notabene.brown>
	 <632b79000705211947k471cc6fdr76dc74f334b8112c@mail.gmail.com>
	 <18002.27283.485975.942744@notabene.brown>
	 <632b79000705301852p743be9f1la4fe440940b8f10e@mail.gmail.com>
	 <18014.23068.659646.633140@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18014.23068.659646.633140@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Neil. This took care of my issue. I was doing a full set of
tests to make sure before I replied. Thanks for all your hard work.

Don

On 5/31/07, Neil Brown <neilb@suse.de> wrote:
> On Wednesday May 30, dondster@gmail.com wrote:
> > Neil, I sent the scripts to you. Any update on this issue?
>
> Sorry, I got distracted.
>
> Your scripts are way more complicated than needed.  Most of the logic
> in there is already in mdadm.
>
>    mdadm --assemble /dev/md_d0 --run --uuid=$BOOTUUID /dev/sd[abcd]2
>
> can replace most of it.  And you don't need to wait for resync to
> complete before mounting filesystems.
>
> That said: I cannot see anything in your script that would actually do
> the wrong thing.
>
> Hmmm... I see now I wasn't quite testing the right thing.  I need to
> trigger a resync with one device missing.
> i.e
>   mdadm -C /dev/md0 -l10 -n4 -p n3 /dev/sd[abcd]1
>   mkfs /dev/md0
>   mdadm /dev/md0 -f /dev/sda1
>   mdadm -S /dev/md0
>   mdadm -A /dev/md0 -R --update=resync /dev/sd[bcd]1
>   fsck -f /dev/md0
>
> This fails just as you say.
> Following patch fixes it as well as another problem I found while
> doing this testing.
>
> Thanks for pursuing this.
>
> NeilBrown
>
> diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
> --- .prev/drivers/md/raid10.c   2007-05-21 11:18:23.000000000 +1000
> +++ ./drivers/md/raid10.c       2007-05-31 15:11:42.000000000 +1000
> @@ -1866,6 +1866,7 @@ static sector_t sync_request(mddev_t *md
>                         int d = r10_bio->devs[i].devnum;
>                         bio = r10_bio->devs[i].bio;
>                         bio->bi_end_io = NULL;
> +                       clear_bit(BIO_UPTODATE, &bio->bi_flags);
>                         if (conf->mirrors[d].rdev == NULL ||
>                             test_bit(Faulty, &conf->mirrors[d].rdev->flags))
>                                 continue;
> @@ -2036,6 +2037,11 @@ static int run(mddev_t *mddev)
>         /* 'size' is now the number of chunks in the array */
>         /* calculate "used chunks per device" in 'stride' */
>         stride = size * conf->copies;
> +
> +       /* We need to round up when dividing by raid_disks to
> +        * get the stride size.
> +        */
> +       stride += conf->raid_disks - 1;
>         sector_div(stride, conf->raid_disks);
>         mddev->size = stride  << (conf->chunk_shift-1);
>
>
>
