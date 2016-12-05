From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: MD Remnants After --stop
Date: Mon, 5 Dec 2016 16:37:51 -0500
Message-ID: <CAHkw+Lf4xEnJvAqfjHTOGSUhhKnuLDhds63PFfDZxh6QVSo=pw@mail.gmail.com>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
 <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com>
 <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com>
 <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com>
 <878tsbcbub.fsf@notabene.neil.brown.name> <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com>
 <87oa15938i.fsf@notabene.neil.brown.name> <CAHkw+LfJzZoWVnO8kDi+YVV09fas2DveQoChh10wEBZfYin6aQ@mail.gmail.com>
 <8760n8a7k5.fsf@notabene.neil.brown.name> <CAHkw+Lc9YEdbJcRu2bOLU-gex9UYSXB32iRKD8TPS7JpjSOdQA@mail.gmail.com>
 <87shq8743j.fsf@notabene.neil.brown.name> <CAHkw+LfmEyY8CSumeeftOrcYKzbkumHwtfeTuT0DhHZbaxdUSw@mail.gmail.com>
 <87k2bj6zwf.fsf@notabene.neil.brown.name> <CAHkw+LdhCOGn4ZXOrWMQHFK7RvJ9MA=0_uoN+69ZC3SUWsGaCg@mail.gmail.com>
 <CAHkw+Lfncgkdb8HnbtfGaX0P_KmLmicj3E64JK7oY+1Pv6g_iw@mail.gmail.com> <87r35n5hsn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r35n5hsn.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 4, 2016 at 7:41 PM, NeilBrown <neilb@suse.com> wrote:
> On Sat, Dec 03 2016, Marc Smith wrote:
>
>> Finally, I got it! Why is it when I want it to break, it doesn't. =)
>
> welcome to my world :-)
>
>
>>
>> I will say, using the modified mdadm that prevents the synthesized
>> CHANGE event, it seems to not induce the problem as regularly.
>>
>> Below are the kernel logs after stopping an array:
>
> Thank you so much for persisting with this.
> The logs you provide make it clear that two separate processes (494 and
> 31178) increment the ->active count by opening the device, but never
> decrement that count by closing the device.
> It seems too unlikely that either process would be holding the
> file descriptor open indefinitely, so something must be going wrong
> either as part of 'open', or as part of 'close'.
>
> Now that I know where to look, the bug is obvious.  Why didn't I see
> that before?
>
> The open request is failing, almost certainly because MD_CLOSING is set,
> but the ->active count isn't being decremented on failure.
> This patch should fix it.
>
> Please test and report results.
>
> Thanks,
> NeilBrown
>
> Fixes: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag" v4.9-rc1)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2089d46b0eb8..a8e07eb2ca5f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7087,11 +7087,14 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>         }
>         BUG_ON(mddev != bdev->bd_disk->private_data);
>
> -       if ((err = mutex_lock_interruptible(&mddev->open_mutex)))
> +       if ((err = mutex_lock_interruptible(&mddev->open_mutex))) {
> +               mddev_put(mddev);
>                 goto out;
> +       }
>
>         if (test_bit(MD_CLOSING, &mddev->flags)) {
>                 mutex_unlock(&mddev->open_mutex);
> +               mddev_put(mddev);
>                 return -ENODEV;
>         }
>

That did the trick! I ran 'mdadm --stop' eight different times on two
nodes, and every time it was removed completely from /dev and
/sys/block just like expected. =)

Thanks for your effort and time on this. I think I read in the other
thread RE: this patch, it may make it into 4.9?


--Marc
