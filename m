From: John Gehring <john.gehring@gmail.com>
Subject: Re: Problem with patch: "reject a re-add request that cannot be
 honoured" (commit bedd86b7773fd97f0d708cc0c371c8963ba7ba9a)
Date: Mon, 2 Jul 2012 11:30:11 -0600
Message-ID: <CALwOXv+bVSQGWjJ3KEW=yCUhkYt0Qze-AwXWCcA8PGL3XGyn0g@mail.gmail.com>
References: <CAGRgLy6We49bW2gA7S-EOmA8sbaXgQeGuTR5Aqrt4y_KyvOrdw@mail.gmail.com>
	<CAGRgLy5OkpZnfOpPS+16Tiep8eisOu9XnK7EcvZygwg22DVTqQ@mail.gmail.com>
	<20120607212434.4d6211d6@notabene.brown>
	<CAGRgLy55si7a8bY_Xuokqb6=cdOJyk_Wq34_DwmmhbpuQSSQug@mail.gmail.com>
	<20120627172255.40ee3a19@notabene.brown>
	<CAGRgLy5U_Xzr=LDuQ6R7dEzx4EiNyWQb1fiSQhq_F+oTmyZw1Q@mail.gmail.com>
	<20120702175715.30724b9d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120702175715.30724b9d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have what I think is a closely related issue, but since this thread
is pretty long already, I will start with a brief description to see
if this should move to a new thread.

I am seeing a repeatable instance where a drive is added to a raid
set, then almost immediately rejected.

- linux 3.2.15 from kernel.org
- mdadm 3.2.5, but I saw this with 3.2, as well
- 8 drive, raid 6

Sequence:

Remove the device
- md created and fully synced. (/dev/md1 in my case)
- no IO
- pull a drive
- issue dd read to /dev/md1 to get it to recognize missing device
- mdadm /dev/md1 -r /dev/sdc2 (for example) to remove device from the md

Add device back in
- insert drive
- mdadm --zero-superblock /dev/sdc2 (or sd<x>, whatever it came back in as)
- mdadm /dev/md1 -a /dev/sdc2

I see the following about 50% of the time:

[ 1813.355806] md: bind<sdc2>
[ 1813.367430] md: recovery of RAID array md1
[ 1813.371570] md: minimum _guaranteed_  speed: 80000 KB/sec/disk.
[ 1813.377481] md: using maximum available idle IO bandwidth (but not
more than 800000 KB/sec) for recovery.
[ 1813.387039] md: using 128k window, over a total of 62467072k.
[ 1813.392789] md/raid:md1: Disk failure on sdc2, disabling device.
[ 1813.392791] md/raid:md1: Operation continuing on 7 devices.
[ 1813.404346] md: md1: recovery done.

I recently found that after this series of events, if I once again
remove the drive from the raid set (mdadm --remove), and do a read of
the md device via dd, I can then successfully add the device back to
the md with the --zero-superblock command followed by the mdadm --add
command. That 'trick' has worked in the first three times that I've
tried it, so not a lot of data points, but interesting nonetheless.

Finally, I applied the patch referenced earlier in this thread and it
did not affect the behavior I've described above.
This has happened on different systems and with different drives; i.e.
it is not a drive failure issue.

Thoughts? Thanks.

On Mon, Jul 2, 2012 at 1:57 AM, NeilBrown <neilb@suse.de> wrote:
>
> On Wed, 27 Jun 2012 19:40:52 +0300 Alexander Lyakas
> <alex.bolshoy@gmail.com>
> wrote:
>
> > Hi Neil,
> >
> > >>
> > >> I would still think that there is value in recoding in a superblock
> > >> that a drive is recovering.
> > >
> > > Probably.  It is a bit unfortunate that if you stop an array that is
> > > recovering after a --re-add, you cannot simply 'assemble' it again and
> > > get it back to the same state.
> > > I'll think more on that.
> >
> > As I mentioned, I see the additional re-add as a minor thing, but
> > agree it's better to fix it. The fact that we don't know that the
> > drive is being recovered, bothers me more. Because user might look at
> > the superblock, and assume the data on the drive is consistent to some
> > point in time (time of the drive failure). While the actual data,
> > while doing bitmap-based recovery, is unusable until recovery
> > successfully completes. So the user might think it's okay to try to
> > run his app on this drive.
> > Yes, please think about this.
> >
> > >
> > > Meanwhile, this patch might address your other problem.  It allows
> > > --re-add
> > > to work if a non-bitmap rebuild fails and is then re-added.
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index c601c4b..d31852e 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -5784,7 +5784,7 @@ static int add_new_disk(struct mddev * mddev,
> > > mdu_disk_info_t *info)
> > >                        super_types[mddev->major_version].
> > >                                validate_super(mddev, rdev);
> > >                if ((info->state & (1<<MD_DISK_SYNC)) &&
> > > -                   (!test_bit(In_sync, &rdev->flags) ||
> > > +                   (test_bit(Faulty, &rdev->flags) ||
> > >                     rdev->raid_disk != info->raid_disk)) {
> > >                        /* This was a hot-add request, but events
> > > doesn't
> > >                         * match, so reject it.
> > >
> >
> > I have tested a slightly different patch that you suggested earlier -
> > just removing the !test_bit(In_sync, &rdev->flags) check. I confirm
> > that it solves the problem.
> >
> > The Faulty bit check seems redundant to me, because:
> > - it can be set by only by validate_super() and only if that drive's
> > role is 0xfffe in sb->roles[] array
> > - Long time ago I asked you, how can it happen that a drive thinks
> > about *itself* that it is Faulty (has 0xfffe for its role in its own
> > superblock), and you said this should never happen.
>
> Yes, you are right.  I've remove the test on 'Faulty' - the test on the
> raid_disk number is sufficient.
>
> >
> > Anyways, I tested also the patch you suggested, and it also works.
>
> Thanks!
>
> >
> > Is there any chance to see this fix in ubuntu-precise?
>
> Not really up to me.  It doesn't fix a crash or corruption so I'm not sure
> it
> is -stable material .... though maybe it is if it fixes a regression.
>
> I suggest you ask the Ubuntu kernel people after it appears in 3.5-rc
> (hopefully later this week).
>
> Thanks,
> NeilBrown
>
>
> >
> > Thanks again for your support,
> > Alex.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
