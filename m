From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: mdadm --wait returns while array under construction? [patch
	question]
Date: Tue, 27 Nov 2012 18:10:20 -0800
Message-ID: <1354068620.27664.65.camel@corn.betterworld.us>
References: <1353434141.27671.13.camel@corn.betterworld.us>
	 <20121121084357.41f2f9d9@notabene.brown>
	 <1354040913.27664.11.camel@corn.betterworld.us>
	 <20121128083046.31bfa6e4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121128083046.31bfa6e4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: ross@biostat.ucsf.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2012-11-28 at 08:30 +1100, NeilBrown wrote:
> On Tue, 27 Nov 2012 10:28:33 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrote:
> 
> > On Wed, 2012-11-21 at 08:43 +1100, NeilBrown wrote:
> > > On Tue, 20 Nov 2012 09:55:41 -0800 Ross Boylan <ross@biostat.ucsf.edu> wrote:
> > > 
> > > > While switching the disks a RAID 1 is based on I used the --wait command
> > > > to wait for the rebuild to finish.  It returned immediately, but a
> > > > subsequent query showed it had not been rebuilt.  Have I misunderstood
> > > > something, or is this an error?
> > > > 
> > > > While doing these commands a much larger rebuild was going on with a
> > > > different array, involving some of the same physical disks but different
> > > > partitions.  The partitions being rebuilt are on different physical
> > > > disks for the different arrays.
> > > > 
> > > > Here are the logs, with version info at the end (Debian Lenny + more
> > > > recent kernel):
> > > ....
> > > 
> > > > markov:~# uname -a
> > > > Linux markov 2.6.32-5-amd64 #1 SMP Wed Jan 12 03:40:32 UTC 2011 x86_64 GNU/Linux
> > > > markov:~# mdadm --version
> > > > mdadm - v2.6.7.2 - 14th November 2008
> > > > 
> > > > 
> > > > I notice that in this case, unlike the other array, the message during
> > > > the rebuild (the last detail report) does not include a line like
> > > > Rebuild Status : 0% complete
> > > > 
> > > > I just tried --wait again to see if there was some kind of race, but
> > > > once again it returned immediately, though detail says the spare is
> > > > rebuilding.
> > > 
> > > Can you test this patch to see if it fixes the problem?
> > > 
> > > diff --git a/Monitor.c b/Monitor.c
> > > index c4d57c3..a5e7aaa 100644
> > > --- a/Monitor.c
> > > +++ b/Monitor.c
> > > @@ -973,7 +973,7 @@ int Wait(char *dev)
> > >  			if (e->devnum == devnum)
> > >  				break;
> > >  
> > > -		if (!e || e->percent < 0) {
> > > +		if (!e || e->percent == RESYNC_NONE) {
> > >  			if (e && e->metadata_version &&
> > >  			    strncmp(e->metadata_version, "external:", 9) == 0) {
> > >  				if (is_subarray(&e->metadata_version[9]))
> > > 
> > > 
> > > NeilBrown
> > My source for 2.6.7.2 looks somewhat different.  It only has 627 lines;
> > I think this is the relevant code (at the end of the file):
> > /* Not really Monitor but ... */
> > int Wait(char *dev)
> > {
> >         struct stat stb;
> >         int devnum;
> >         int rv = 1;
> > 
> >         if (stat(dev, &stb) != 0) {
> >                 fprintf(stderr, Name ": Cannot find %s: %s\n", dev,
> >                         strerror(errno));
> >                 return 2;
> >         }
> >         if (major(stb.st_rdev) == MD_MAJOR)
> >                 devnum = minor(stb.st_rdev);
> >         else
> >                 devnum = -1-(minor(stb.st_rdev)/64);
> > 
> >         while(1) {
> >                 struct mdstat_ent *ms = mdstat_read(1, 0);
> >                 struct mdstat_ent *e;
> > 
> >                 for (e=ms ; e; e=e->next)
> >                         if (e->devnum == devnum)
> >                                 break;
> > 
> >                 if (!e || e->percent < 0) {
> >                         free_mdstat(ms);
> >                         return rv;
> >                 }
> >                 free(ms);
> >                 rv = 0;
> >                 mdstat_wait(5);
> >         }
> > }
> > 
> > 
> > The section
> >                 if (!e || e->percent < 0) {
> >                         free_mdstat(ms);
> >                         return rv;
> >  is the only one with e->percent < 0.  Is it OK to change that to 
> > if (!e || e->percent == RESYNC_NONE) {?
> > 
> >
> 
> That's the right place to make the change, bit it won't compile.
> RESYNC_NONE isn't defined in that version of mdadm, and you would need to
> make some changes in mdstat.c where ent->percent is set.
> Current code has
> 
> 
> 				if (l > 8 && strcmp(w+l-8, "=DELAYED") == 0)
> 					ent->percent = RESYNC_DELAYED;
> 				if (l > 8 && strcmp(w+l-8, "=PENDING") == 0)
> 					ent->percent = RESYNC_PENDING;
> 
> which is completely missing from 2.6.7.2.  You'd be a lot better off starting
> with 3.2.6 and adding the patch to that.
> 
> NeilBrown
I think I'm going to have to pass on testing for now, as the
alternatives appear too high risk:
1) I got the debianized source for 3.2.5 (for some reason 3.2.6 is not
there yet).  It depends on a variety of package versions that post-date
my lenny system.  So it will not install unless I override those, or
located/backport more recent versions of the other packages.  Since this
is messing with core areas of the system (grub, udev, initscripts) it
seems unwise to attempt backports.

2) I considered patching 2.6.7.2 in place with the additional info you
provided, but I'm not sure if you're sayiing the mdstat.c changes alone
are sufficient, or if I need to change Monitor.c in some way.

3) I could just dump your 3.2.6 upstream source over my current 2.6.7.2
Debianized directory.  But then I'd need to figure out what Debian
patches I need to reapply, and wonder if it would all work in a Lenny
environment.

I'd like to help, but since this is just a reporting problem for me I
don't want to risk screwing things up further.  I might be able to do 2)
with a little more information.

BTW, I reviewed the udev rules for mdadm on my system and in the 2.6.7.2
package, and it does not  appear that incremental assembly is being
attempted.  That's not relevant to this  thread, but does matter for
some of my other ones.  Also, the 3.2.5 Debian package's udev rules say
## DISABLED: Incremental udev assembly disabled
## ** this is a Debian-specific change **
GOTO="md_inc_skip"



