From: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Subject: Re: raid5, 2 drives dead at same time,kernel will Oops?
Date: Wed, 21 May 2003 18:04:30 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00a901c31ffe$19ead340$7b07a8c0@pluto>
References: <3EB8441F.8070606@fugmann.dhs.org><16056.19633.400369.451156@notabene.cse.unsw.edu.au><021301c31e67$804eab90$7b07a8c0@pluto> <16074.59292.944191.452983@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,
Preliminary test looks good, will test more
when have time.

Thanks,
-Will.
----- Original Message -----
From: "Neil Brown" <neilb@cse.unsw.edu.au>
To: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Cc: <linux-raid@vger.kernel.org>
Sent: Tuesday, May 20, 2003 7:42 PM
Subject: Re: raid5, 2 drives dead at same time,kernel will Oops?


> On Monday May 19, 3tcdgwg3@prodigy.net wrote:
> > Hi,
> >
> > I am trying to simulate a case that two drives
> > in an array fail ad same time.
> > I use two ide drives, I try to create a
> > raid 5 array with 4 arms, created as following:
> >
> > /dev/hdc1
> > /dev/hde1
> > /dev/hdc2
> > /dev/hde2
> >
> > This is just for test, I know create two arms on
> > one hard drive doesn't make much sense.
> >
> >
> > Anyway, when I run this array, if I power off one
> > of hard drive (/dev/hde) to simulate two arms failing
> > at same  time in an array, I got system Oops. I am using
> > 2.4-18 kernel.
> >
> > Anyone can tell me if this is normal? or if there is a fix for this?
> >
>
> Congratulations and thanks.  You have managed to trigger a bug that
> no-one else has found.
>
> The following patch (against 2.4.20) should fix it.  If you can test
> and confirm I would really appreciate it.
>
> NeilBrown
>
>
> ------------------------------------------------------------
> Handle concurrent failure of two drives in raid5
>
> If two drives both fail during a write request, raid5 doesn't
> cope properly and will eventually oops.
>
> With this patch, blocks that have already been 'written'
> are failed when double drive failure is noticed, as well as
> blocks that are about to be written.
>
>  ----------- Diffstat output ------------
>  ./drivers/md/raid5.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletion(-)
>
> diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
> --- ./drivers/md/raid5.c~current~ 2003-05-21 12:42:07.000000000 +1000
> +++ ./drivers/md/raid5.c 2003-05-21 12:37:37.000000000 +1000
> @@ -882,7 +882,7 @@ static void handle_stripe(struct stripe_
>   /* check if the array has lost two devices and, if so, some requests
might
>   * need to be failed
>   */
> - if (failed > 1 && to_read+to_write) {
> + if (failed > 1 && to_read+to_write+written) {
>   for (i=disks; i--; ) {
>   /* fail all writes first */
>   if (sh->bh_write[i]) to_write--;
> @@ -891,6 +891,14 @@ static void handle_stripe(struct stripe_
>   bh->b_reqnext = return_fail;
>   return_fail = bh;
>   }
> + /* and fail all 'written' */
> + if (sh->bh_written[i]) written--;
> + while ((bh = sh->bh_written[i])) {
> + sh->bh_written[i] = bh->b_reqnext;
> + bh->b_reqnext = return_fail;
> + return_fail = bh;
> + }
> +
>   /* fail any reads if this device is non-operational */
>   if (!conf->disks[i].operational) {
>   spin_lock_irq(&conf->device_lock);
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

