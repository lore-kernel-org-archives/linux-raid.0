From: NeilBrown <neilb@suse.com>
Subject: Re: raid1_end_read_request does not retry failed READ from a
 recovering drive
Date: Fri, 24 Jul 2015 09:24:04 +1000
Message-ID: <20150724092404.66dc284d@noble>
References: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
	<20140908171702.5b2853fc@notabene.brown>
	<CAGRgLy54ByqUG8bTyPr_rDrNMbyFYRU+rx4LEWVqMHOw2=k=Dg@mail.gmail.com>
	<20140918110523.3ee5c064@notabene.brown>
	<CAGRgLy7+bN8ztaaN+oh6uATE7=Z=8LnU=R0m2CnVff4ZqgJFKg@mail.gmail.com>
	<20140922101704.53be2056@notabene.brown>
	<CAGRgLy5DsbiPsjJ2ZK_aOZ_UOqxa-zwbdDREv7hdpt7vLXCwOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5DsbiPsjJ2ZK_aOZ_UOqxa-zwbdDREv7hdpt7vLXCwOw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 22 Jul 2015 18:10:31 +0200 Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:

> Hi Neil,
> In continuation of our discussion, I see that you have added a
> commit[1], which has a diff[2].
> But this is only the second part of the fix. We also need the first
> part, I believe, where in raid1_end_read_request we need to replace
> "!test_bit(Faulty)" with "test_bit(In_sync)". Otherwise, we will never
> retry the READ, and thus will never reach the fix_read_error code.
> And we also need to "put all of raid1_spare_active inside the
> spinlock", like you advised.
> Do you agree?
> 
> We tested both parts of the fix, not the second part alone. Quoting myself:
> "With this addition, the problem appears to be fixed", i.e., I meant
> we applied both parts.
> 
> I am sorry for catching this so late. I never looked at what you
> applied until now, because we are moving to kernel 3.18 long term, and
> I am checking the raid1 changes. I just assumed you applied both
> parts.
> 
> If you agree, it would be good if you tag the first part of the fix as
> "cc stable" too.
> 
> Thanks,
> Alex.
> 
> 
> 
> [1]
> commit b8cb6b4c121e1bf1963c16ed69e7adcb1bc301cd
> Author: NeilBrown <neilb@suse.de>
> Date:   Thu Sep 18 11:09:04 2014 +1000
> 
>     md/raid1: fix_read_error should act on all non-faulty devices.
> 
>     If a devices is being recovered it is not InSync and is not Faulty.
> 
>     If a read error is experienced on that device, fix_read_error()
>     will be called, but it ignores non-InSync devices.  So it will
>     neither fix the error nor fail the device.
> 
>     It is incorrect that fix_read_error() ignores non-InSync devices.
>     It should only ignore Faulty devices.  So fix it.
> 
>     This became a bug when we allowed reading from a device that was being
>     recovered.  It is suitable for any subsequent -stable kernel.
> 
>     Fixes: da8840a747c0dbf49506ec906757a6b87b9741e9
>     Cc: stable@vger.kernel.org (v3.5+)
>     Reported-by: Alexander Lyakas <alex.bolshoy@gmail.com>
>     Tested-by: Alexander Lyakas <alex.bolshoy@gmail.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
> 
> [2]
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 35649dd..55de4f6 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2155,7 +2155,7 @@ static void fix_read_error(struct r1conf *conf,
> int read_disk,
>                         d--;
>                         rdev = conf->mirrors[d].rdev;
>                         if (rdev &&
> -                           test_bit(In_sync, &rdev->flags))
> +                           !test_bit(Faulty, &rdev->flags))
>                                 r1_sync_page_io(rdev, sect, s,
>                                                 conf->tmppage, WRITE);
>                 }
> @@ -2167,7 +2167,7 @@ static void fix_read_error(struct r1conf *conf,
> int read_disk,
>                         d--;
>                         rdev = conf->mirrors[d].rdev;
>                         if (rdev &&
> -                           test_bit(In_sync, &rdev->flags)) {
> +                           !test_bit(Faulty, &rdev->flags)) {
>                                 if (r1_sync_page_io(rdev, sect, s,
>                                                     conf->tmppage, READ)) {
>                                         atomic_add(s, &rdev->corrected_errors);
> 
> On Mon, Sep 22, 2014 at 2:17 AM, NeilBrown <neilb@suse.de> wrote:
> > On Sun, 21 Sep 2014 19:47:14 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> > wrote:
> >
> >> Thanks, Neil,
> >>
> >> On Thu, Sep 18, 2014 at 4:05 AM, NeilBrown <neilb@suse.de> wrote:
> >> > On Wed, 17 Sep 2014 20:57:13 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> >> > wrote:
> >> >
> >> >> Hi Neil,
> >> >>
> >> >> On Mon, Sep 8, 2014 at 10:17 AM, NeilBrown <neilb@suse.de> wrote:
> >> >> > On Sun, 7 Sep 2014 17:18:16 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> >> >> > wrote:
> >> >> >
> >> >> >> Hi Neil,
> >> >> >> we see the following issue:
> >> >> >>
> >> >> >> # RAID1 has 2 drives A and B, drive B is recovering
> >> >> >> # READ request arrives
> >> >> >> # read_balanace selects drive B to read from, because READ sector
> >> >> >> comes before B->recovery_offset
> >> >> >> # READ is issued to drive B, but fails (drive B fails again)
> >> >> >>
> >> >> >> Now raid1_end_read_request() has the following code:
> >> >> >>
> >> >> >>     if (uptodate)
> >> >> >>         set_bit(R1BIO_Uptodate, &r1_bio->state);
> >> >> >>     else {
> >> >> >>         /* If all other devices have failed, we want to return
> >> >> >>          * the error upwards rather than fail the last device.
> >> >> >>          * Here we redefine "uptodate" to mean "Don't want to retry"
> >> >> >>          */
> >> >> >>         unsigned long flags;
> >> >> >>         spin_lock_irqsave(&conf->device_lock, flags);
> >> >> >>         if (r1_bio->mddev->degraded == conf->raid_disks ||
> >> >> >>             (r1_bio->mddev->degraded == conf->raid_disks-1 &&
> >> >> >>              !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
> >> >> >>             uptodate = 1;
> >> >> >>         spin_unlock_irqrestore(&conf->device_lock, flags);
> >> >> >>     }
> >> >> >>
> >> >> >> According to this code uptodate wrongly becomes 1, because:
> >> >> >> r1_bio->mddev->degraded == conf->raid_disks-1 is TRUE
> >> >> >> and
> >> >> >> !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags) is also TRUE
> >> >> >>
> >> >> >> Indeed, drive B is not marked as Faulty, but also not marked as In_sync.
> >> >> >> However, this function treats !Faulty being equal to In_Sync, so it
> >> >> >> decides that the last good drive failed, so it does not retry the
> >> >> >> READ.
> >> >> >>
> >> >> >> As a result, there is IO error, while we should have retried the READ
> >> >> >> from the healthy drive.
> >> >> >>
> >> >> >> This is happening in 3.8.13, but your master branch seems to have the
> >> >> >> same issue.
> >> >> >>
> >> >> >> What is a reasonable fix?
> >> >> >> 1) Do not read from drives which are !In_sync (a bit scary to read
> >> >> >> from such drive)
> >> >> >
> >> >> > It is perfectly safe to read from a !In_sync device providing you are before
> >> >> > ->recovery_offset.
> >> >> >
> >> >> >
> >> >> >> 2) replace !Faulty to In_sync check
> >> >> >
> >> >> > That probably makes sense... though that could race with raid1_spare_active().
> >> >> > If a read-error returned just after raid1_spare_active() set In_sync, and
> >> >> > before 'count' was subtracted from ->degraded, we would still set uptodate
> >> >> > when we shouldn't.
> >> >> > It probably make sense to put all of raid1_spare_active inside the spinlock -
> >> >> > it doesn't get call often enough that performance is an issue (I hope).
> >> >> >
> >> >> > So:
> >> >> >  1/ change !Faulty to In_sync
> >> >> >  2/ extend the spinlock in raid1_spare_active to cover the whole function.
> >> >>
> >> >>
> >> >> I made these fixes and reproduced the issue. However, the result is
> >> >> not what we expect:
> >> >>
> >> >> # raid1_end_read_request() now indeed adds the r1_bio into retry_list,
> >> >> as we wanted
> >> >> # raid1d calls fix_read_error()
> >> >> # fix_read_error() searches for an In_sync drive to read the data
> >> >> from. It finds such drive (this is our good drive A)
> >> >> # now fix_read_error() wants to rewrite the bad area. But it rewrites
> >> >> only on those drives that are In_sync (except the drive it got the
> >> >> data from). In our case, it never tries to rewrite the data on drive B
> >> >> (drive B is not marked Faulty and not marked In_sync). As a result,
> >> >> md_error() is not called, so drive B is still not marked as Failed
> >> >> when fix_read_error() completes
> >> >> # so handle_read_error() retries the original READ by calling
> >> >> read_balance(), which again in my case selects the recovering drive
> >> >> B...
> >> >>
> >> >> And then the whole flow repeats itself again and again...and READ
> >> >> never completes.
> >> >>
> >> >> Maybe we should not allow selecting recovering drives for READ? Or
> >> >> some other approach?
> >> >>
> >> >
> >> > Thanks for the testing and analysis.
> >> > Presumably we just want handle_read_error() to write to all non-faulty
> >> > devices, not just the InSync ones.
> >> > i.e. the following patch.
> >> >
> >> > Thanks,
> >> > NeilBrown
> >> >
> >> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> > index 6a9c73435eb8..a95f9e179e6f 100644
> >> > --- a/drivers/md/raid1.c
> >> > +++ b/drivers/md/raid1.c
> >> > @@ -2153,7 +2153,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
> >> >                         d--;
> >> >                         rdev = conf->mirrors[d].rdev;
> >> >                         if (rdev &&
> >> > -                           test_bit(In_sync, &rdev->flags))
> >> > +                           !test_bit(Faulty, &rdev->flags))
> >> >                                 r1_sync_page_io(rdev, sect, s,
> >> >                                                 conf->tmppage, WRITE);
> >> >                 }
> >> > @@ -2165,7 +2165,7 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
> >> >                         d--;
> >> >                         rdev = conf->mirrors[d].rdev;
> >> >                         if (rdev &&
> >> > -                           test_bit(In_sync, &rdev->flags)) {
> >> > +                           !test_bit(Faulty, &rdev->flags)) {
> >> >                                 if (r1_sync_page_io(rdev, sect, s,
> >> >                                                     conf->tmppage, READ)) {
> >> >                                         atomic_add(s, &rdev->corrected_errors);
> >>
> >> With this addition, the problem appears to be fixed. We will give it
> >> some regression testing & will let you know if we see any issues.
> >>
> >> I presume you will be applying this fix upstream as well.
> >
> > Yes, it is already in my for-next branch.
> > I've just added your tested-by.
> >
> > Thanks,
> > NeilBrown

Hi Alex
thanks for noticing!
Just to be sure we mean the same thing: this is the patch which is
missing - correct?

Thanks,
NeilBrown

From: NeilBrown <neilb@suse.com>
Date: Fri, 24 Jul 2015 09:22:16 +1000
Subject: [PATCH] md/raid1: fix test for 'was read error from last working
 device'.

When we get a read error from the last working device, we don't
try to repair it, and don't fail the device.  We simple report a
read error to the caller.

However the current test for 'is this the last working device' is
wrong.
When there is only one fully working device, it assumes that a
non-faulty device is that device.  However a spare which is rebuilding
would be non-faulty but so not the only working device.

So change the test from "!Faulty" to "In_sync".  If ->degraded says
there is only one fully working device and this device is in_sync,
this must be the one.

This bug has existed since we allowed read_balance to read from
a recovering spare in v3.0

Reported-and-tested-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Fixes: 76073054c95b ("md/raid1: clean up read_balance.")
Cc: stable@vger.kernel.org (v3.0+)
Signed-off-by: NeilBrown <neilb@suse.com>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 166616411215..b368307a9651 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -336,7 +336,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (r1_bio->mddev->degraded == conf->raid_disks ||
 		    (r1_bio->mddev->degraded == conf->raid_disks-1 &&
-		     !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
+		     test_bit(In_sync, &conf->mirrors[mirror].rdev->flags)))
 			uptodate = 1;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
