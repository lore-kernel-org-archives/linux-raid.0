From: Maurilio Longo <maurilio.longo@libero.it>
Subject: Re: [PATCH md ] Fix up handling for read error in raid1.
Date: Fri, 23 Jul 2004 09:26:36 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4100BDAC.3AF18B6F@libero.it>
References: <20040624143619.5067.patches@notabene>
		<E1BdLyz-0001Jy-Tq@notabene.cse.unsw.edu.au>
		<40F2A055.93DD9C4B@libero.it> <16640.32332.948614.607674@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

I was talking about a read error on a raid1 disk which causes that disk to be removed from
array before trying to do a read on the other disk followed by a write to the failed one to
force disk to remap broken sector.

It seems to me 2.4.x raid1.c code doesn't has got this feature.

regards.

ps. probably I simply don't understand what raid1.c code is doing in 2.4.x and 2.6.x


Neil Brown ha scritto:

> On Monday July 12, maurilio.longo@libero.it wrote:
> > Neil,
> >
> > do you have a similar patch for a 2.4.x (x == 20 in my case) kernel?
> >
> > I can't change kernel easily since I use it to run mars-nwe which is a novell emulator
> > which is going to be removed from every distro I'm aware of :(
>
> This bug is specific to 2.6.  There is no need for anything similar in
> 2.4
>
> NeilBrown
>
> >
> > regards.
> >
> >
> > NeilBrown ha scritto:
> >
> > > There is severe bit-rot in this code, which is to say that it doesn't work
> > > at all: an io error during read will do bad things.  It should work
> > > better with this patch.
> > >
> > > Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>
> > >
> > > ### Diffstat output
> > >  ./drivers/md/raid1.c |   10 +++++++---
> > >  1 files changed, 7 insertions(+), 3 deletions(-)
> > >
> > > diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
> > > --- ./drivers/md/raid1.c~current~       2004-06-23 14:37:05.000000000 +1000
> > > +++ ./drivers/md/raid1.c        2004-06-23 14:37:13.000000000 +1000
> > > @@ -206,7 +206,7 @@ static int map(mddev_t *mddev, mdk_rdev_
> > >                         *rdevp = rdev;
> > >                         atomic_inc(&rdev->nr_pending);
> > >                         spin_unlock_irq(&conf->device_lock);
> > > -                       return 0;
> > > +                       return i;
> > >                 }
> > >         }
> > >         spin_unlock_irq(&conf->device_lock);
> > > @@ -945,18 +945,22 @@ static void raid1d(mddev_t *mddev)
> > >
> > >                 mddev = r1_bio->mddev;
> > >                 conf = mddev_to_conf(mddev);
> > > -               bio = r1_bio->master_bio;
> > >                 if (test_bit(R1BIO_IsSync, &r1_bio->state)) {
> > >                         sync_request_write(mddev, r1_bio);
> > >                         unplug = 1;
> > >                 } else {
> > > -                       if (map(mddev, &rdev) == -1) {
> > > +                       int disk;
> > > +                       bio = r1_bio->bios[r1_bio->read_disk];
> > > +                       if ((disk=map(mddev, &rdev)) == -1) {
> > >                                 printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
> > >                                        " read error for block %llu\n",
> > >                                        bdevname(bio->bi_bdev,b),
> > >                                        (unsigned long long)r1_bio->sector);
> > >                                 raid_end_bio_io(r1_bio);
> > >                         } else {
> > > +                               r1_bio->bios[r1_bio->read_disk] = NULL;
> > > +                               r1_bio->read_disk = disk;
> > > +                               r1_bio->bios[r1_bio->read_disk] = bio;
> > >                                 printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
> > >                                        " another mirror\n",
> > >                                        bdevname(rdev->bdev,b),
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> >  __________
> > |  |  | |__| md2520@mclink.it
> > |_|_|_|____|
> >
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
 __________
|  |  | |__| md2520@mclink.it
|_|_|_|____| Team OS/2 Italia


