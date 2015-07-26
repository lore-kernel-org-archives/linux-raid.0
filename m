From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid1_end_read_request does not retry failed READ from a
 recovering drive
Date: Sun, 26 Jul 2015 10:15:05 +0200
Message-ID: <CAGRgLy7qkyQquRDGCShjJsuREQXNN+WaNGaq5wK2psMLQ6BGtw@mail.gmail.com>
References: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
	<20140908171702.5b2853fc@notabene.brown>
	<CAGRgLy54ByqUG8bTyPr_rDrNMbyFYRU+rx4LEWVqMHOw2=k=Dg@mail.gmail.com>
	<20140918110523.3ee5c064@notabene.brown>
	<CAGRgLy7+bN8ztaaN+oh6uATE7=Z=8LnU=R0m2CnVff4ZqgJFKg@mail.gmail.com>
	<20140922101704.53be2056@notabene.brown>
	<CAGRgLy5DsbiPsjJ2ZK_aOZ_UOqxa-zwbdDREv7hdpt7vLXCwOw@mail.gmail.com>
	<20150724092404.66dc284d@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150724092404.66dc284d@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On Fri, Jul 24, 2015 at 1:24 AM, NeilBrown <neilb@suse.com> wrote:
> Hi Alex
> thanks for noticing!
> Just to be sure we mean the same thing: this is the patch which is
> missing - correct?
>
> Thanks,
> NeilBrown
>
> From: NeilBrown <neilb@suse.com>
> Date: Fri, 24 Jul 2015 09:22:16 +1000
> Subject: [PATCH] md/raid1: fix test for 'was read error from last working
>  device'.
>
> When we get a read error from the last working device, we don't
> try to repair it, and don't fail the device.  We simple report a
> read error to the caller.
>
> However the current test for 'is this the last working device' is
> wrong.
> When there is only one fully working device, it assumes that a
> non-faulty device is that device.  However a spare which is rebuilding
> would be non-faulty but so not the only working device.
>
> So change the test from "!Faulty" to "In_sync".  If ->degraded says
> there is only one fully working device and this device is in_sync,
> this must be the one.
>
> This bug has existed since we allowed read_balance to read from
> a recovering spare in v3.0
>
> Reported-and-tested-by: Alexander Lyakas <alex.bolshoy@gmail.com>
> Fixes: 76073054c95b ("md/raid1: clean up read_balance.")
> Cc: stable@vger.kernel.org (v3.0+)
> Signed-off-by: NeilBrown <neilb@suse.com>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 166616411215..b368307a9651 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -336,7 +336,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
>                 spin_lock_irqsave(&conf->device_lock, flags);
>                 if (r1_bio->mddev->degraded == conf->raid_disks ||
>                     (r1_bio->mddev->degraded == conf->raid_disks-1 &&
> -                    !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
> +                    test_bit(In_sync, &conf->mirrors[mirror].rdev->flags)))
>                         uptodate = 1;
>                 spin_unlock_irqrestore(&conf->device_lock, flags);
>         }

Yes, this was the missing piece.

But you also advised to put the whole of "raid1_spare_active" under
the spinlock:
> 2/ extend the spinlock in raid1_spare_active to cover the whole function.
So we did this bit too. Can you pls comment if this is needed?

Also, will you be sending this patch to "stable"? We are moving to
kernel 3.18, so we should get this then.

Thanks!
Alex.
