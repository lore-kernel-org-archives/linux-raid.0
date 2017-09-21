From: Nate Dailey <nate.dailey@stratus.com>
Subject: Re: raid1 IO hang - md_submit_flush_data ignores md_write_start
 return value
Date: Thu, 21 Sep 2017 11:42:47 -0400
Message-ID: <be2cc6e8-7cc5-7af1-ecd0-d8d76eac6f25@stratus.com>
References: <b3764c9a-5a43-d901-a0ef-5a6989e8e81d@stratus.com>
 <20170920193522.y3frgknwpm42h5yt@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170920193522.y3frgknwpm42h5yt@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I applied your change to the RHEL kernel on which I'm hitting the bug. It seems 
to be working; I'm not hitting the bug (or any other bad behavior).

Thank you!

Nate


On 09/20/2017 03:35 PM, Shaohua Li wrote:
> On Wed, Sep 20, 2017 at 08:49:30AM -0400, Nate Dailey wrote:
> > I'm seeing an occasional XFS IO hang with raid1 (INFO: task
> > xfsaild/md20:17963 blocked for more than 120 seconds).
> >
> > It turns out that this is because md_submit_flush_data calls
> > pers->make_request, and doesn't check the return value (unlike
> > md_make_request, which checks the return value and retries). So if
> > raid1_make_request/md_write_start return false, md_submit_flush_data drops
> > the write on the floor.
> >
> > I'm hitting this on a RHEL kernel, but looking at the upstream code it
> > appears that the same thing could happen.
> >
> > Not sure how best to deal with this... thank you for any advice!
>
> Thanks for reporting! Looks like a regression introduced recently:
> cc27b0c78c79 md: fix deadlock between mddev_suspend() and md_write_start()
>
> I think we can just reuse md_make_request. To avoid deadlock, we cleanup the
> mddev->flush_bio before we handle the bio. Something like this should fix it:
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b01e458d31e9..3978607e390e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -439,16 +439,16 @@ static void md_submit_flush_data(struct work_struct *ws)
> struct mddev *mddev = container_of(ws, struct mddev, flush_work);
> struct bio *bio = mddev->flush_bio;
>
> + mddev->flush_bio = NULL;
> + wake_up(&mddev->sb_wait);
> +
> if (bio->bi_iter.bi_size == 0)
> /* an empty barrier - all done */
> bio_endio(bio);
> else {
> bio->bi_opf &= ~REQ_PREFLUSH;
> - mddev->pers->make_request(mddev, bio);
> + md_make_request(mddev->queue, bio);
> }
> -
> - mddev->flush_bio = NULL;
> - wake_up(&mddev->sb_wait);
> }
>
> void md_flush_request(struct mddev *mddev, struct bio *bio)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html 
> <http://vger.kernel.org/majordomo-info.html>


