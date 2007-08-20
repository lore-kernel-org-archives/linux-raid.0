From: "Greg Nicholson" <d0gz.net@gmail.com>
Subject: Re: Raid5 Reshape gone wrong, please help
Date: Sun, 19 Aug 2007 21:44:31 -0500
Message-ID: <c92bcddf0708191944x4aab7770ga6815210109dca6f@mail.gmail.com>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>
	 <18118.46141.966406.577626@notabene.brown>
	 <c92bcddf0708180837y4d92d2b4x3a4308e77b515ab3@mail.gmail.com>
	 <18120.9950.578786.624453@notabene.brown>
	 <c92bcddf0708190845k485a8460q609b16a8795bc288@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c92bcddf0708190845k485a8460q609b16a8795bc288@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/19/07, Greg Nicholson <d0gz.net@gmail.com> wrote:
> On 8/19/07, Neil Brown <neilb@suse.de> wrote:
> > On Saturday August 18, d0gz.net@gmail.com wrote:
> > >
> > > That looks to me like the first 2 gig is completely empty on the
> > > drive.  I really don't think it actually started to do anything.
> >
> > The backup data is near the end of the device.  If you look at the
> > last 2 gig you should see something.
> >
>
> I figured something like that after I started thinking about it...
> That device is currently offline while I do some DD's to new devices.
>
> > >
> > > Do you have further suggestions on where to go now?
> >
> > Maybe an 'strace' of "mdadm -A ...." might show me something.
> >
> > If you feel like following the code, Assemble (in Assemble.c) should
> > call Grow_restart.
> > This should look in /dev/sdb1 (which is already open in 'fdlist') by
> > calling 'load_super'.  It should then seek to 8 sectors before the
> > superblock (or close to there) and read a secondary superblock which
> > describes the backup data.
> > If this looks good, it seeks to where the backup data is (which is
> > towards the end of the device) and reads that.  It uses this to
> > restore the 'critical section', and then updates the superblock on all
> > devices.
> >
> > As you aren't getting the messages 'restoring critical section',
> > something is going wrong before there.  It should fail:
> >   /dev/md0: Failed to restore critical section for reshape, sorry.
> > but I can see that there is a problem with the error return from
> > 'Grow_restart'.  I'll get that fixed.
> >
> >
> > >
> > > Oh, and thank you very much for your help.  Most of the data on this
> > > array I can stand to loose... It's not critical, but there are some of
> > > my photographs on this that my backup is out of date on.  I can
> > > destroy it all and start over, but really want to try to recover this
> > > if it's possible.  For that matter, if it didn't actually start
> > > rewriting the stripes, is there anyway to push it back down to 4 disks
> > > to recover ?
> >
> > You could always just recreate the array:
> >
> >  mdadm -C /dev/md0 -l5 -n4 -c256 --assume-clean /dev/sdf1 /dev/sde1  \
> >     /dev/sdd1 /dev/sdc1
> >
> > and make sure the data looks good (which it should).
> >
> > I'd still like to know that the problem is though....
> >
> > Thanks,
> > NeilBeon
> >
>
> My current plan of attack, which I've been proceeding upon for the
> last 24 hours... I'm DDing the original drives to new devices.  Once I
> have copies of the drives, I'm going to try to recreate the array as a
> 4 device array.  Hopefully, at that point, the raid will come up, LVM
> will initialize, and it's time to saturate the GigE offloading
> EVERYTHING.
>
> Assuming the above goes well.... which will definitely take some time,
> Then I'll take the original drives, run the strace and try to get some
> additional data for you.  I'd love to know what's up with this as
> well.  If there is additional information I can get you to help, let
> me know.  I've grown several arrays before without any issue, which
> frankly is why I didn't think this would have been an issue.... thus,
> my offload of the stuff I actually cared about wasn't up to date.
>
> At the end of day (or more likely, week)  I'll completely destroy the
> existing raid, and rebuild the entire thing to make sure I'm starting
> from a good base.  At least at that point, I'll have additional
> drives.  Given that I have dual File-servers that will have drives
> added, it seems likely that I'll be testing the code again soon.  Big
> difference being that this time, I won't make the assumption that
> everything will be perfect. :)
>
> Thanks again for your help, I'll post on my results as well as try to
> get you that strace.  It's been quite a while since I dove into kernel
> internals, or C for that matter, so it's unlikely I'm going to find
> anything myself.... But I'll definitely send results back if I can.
>


Ok, as an update.  ORDER MATTERS.  :)

The above command didn't work.  It built, but LVM didn't recognize.
So, after despair, I thought, that's not the way I built it.  So, I
redid it in Alphabetical order... and it worked.

I'm in the process of taring and pulling everything off.

Once that is done, I'll put the original drives back in, and try to
understand what went wrong with the original grow/build.
