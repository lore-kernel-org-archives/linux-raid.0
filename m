From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH] fix: mdadm -Ss for external metadata don't stop
 container
Date: Thu, 17 Mar 2011 21:08:33 +0000
Message-ID: <66C59AD0932712458090B447266D638C010FB01046@irsmsx504.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638C010BD52A8E@irsmsx504.ger.corp.intel.com>
	<20101207211611.475410d1@notabene.brown>
	<66C59AD0932712458090B447266D638C010FABEFEC@irsmsx504.ger.corp.intel.com>
 <20110317133802.34f39899@notabene.brown>
 <BE2BFE91933D1B4089447C64486040806ACB0DCF@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040806ACB0DCF@irsmsx503.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>, NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids


> -----Original Message-----
> From: Wojcik, Krzysztof
> Sent: Thursday, March 17, 2011 5:51 PM
> To: NeilBrown
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Hawrylewicz Czarnowski,
> Przemyslaw
> Subject: RE: [PATCH] fix: mdadm -Ss for external metadata don't stop
> container
> 
> Neil,
> 
> We tested proposed patch. It resolve issue discussed bellow.
> But it is not full resolution for problems with array stopping.
> It turned out that another issue exists.
> If we try to write 'inactive' do array state, sometimes operation fails.
> I've send patch for this. Please review it and apply if ok.
> 

On more note: bigger chance that problem shows up can be observed if in mdstat 
container is listed before array (almost always in RHEL, rarely in SLES). Problem
with busy array (not container) is caused mostly by "blockid" and "udisks-part-id"
started by udev.

Przemyslaw Hawrylewicz-Czarnowski

> Regards
> Krzysztof
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of NeilBrown
> > Sent: Thursday, March 17, 2011 3:38 AM
> > To: Hawrylewicz Czarnowski, Przemyslaw
> > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed
> > Subject: Re: [PATCH] fix: mdadm -Ss for external metadata don't stop
> > container
> >
> > On Wed, 16 Mar 2011 22:24:20 +0000 "Hawrylewicz Czarnowski, Przemyslaw"
> > <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> >
> > > > -----Original Message-----
> > > > From: Neil Brown [mailto:neilb@suse.de]
> > > > Sent: Tuesday, December 07, 2010 11:16 AM
> > > > To: Hawrylewicz Czarnowski, Przemyslaw
> > > > Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> > Labun,
> > > > Marcin; Czarnowska, Anna
> > > > Subject: Re: [PATCH] fix: mdadm -Ss for external metadata don't
> > stop
> > > > container
> > > >
> > > > On Tue, 7 Dec 2010 06:44:21 +0000 "Hawrylewicz Czarnowski,
> > Przemyslaw"
> > > > <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> > > >
> > > > > Neil,
> > > > >
> > > > > The one below is a fix for the problem we encounter quite often
> > when we
> > > > try to stop all arrays with mdadm -Ss. The main problem is that
> > mdmon holds
> > > > open container device and then exits. The time that system make
> > clean up is
> > > > quite long and mdadm invokes ARRAY_STOP ioctl when device is still
> > opened.
> > > > > Second resolution is to retry ioctl in mdadm after mdmon exits,
> > but
> > > > closing handle is I what should be done before process exist.
> > > > > Take a look at the patch below:
> > > > >
> > > > > --
> > > > > Sometimes (~50%) mdadm -Ss cannot stop container as mdmon opens
> > its
> > > > device
> > > > > and do not close it before exit(). The period between open and
> > release of
> > > > > handle is too long and md is not able stop device. Releasing
> > handle
> > > > before
> > > > > exit does not block md.
> > > > >
> > > > > Signed-off-by: Przemyslaw Czarnowski
> > > > <przemyslaw.hawrylewicz.czarnowski@intel.com>
> > > >
> > > > I've applied this, but I'm not 100% sure it is completely safe.
> > > > mdmon holds the O_EXCL open to be sure that mdadm isn't creating or
> > > > assembling another array in the container.
> > > > mdadm will get an O_EXCL and then try sending a signal to mdmon.
> > If it
> > > > succeeds, it knows mdmon is still running.  But this patch might
> > open a
> > > > window where mdadm can get O_EXCL, and a signal still works.
> > >
> > > Hi,
> > >
> > > As we test new RHEL6.1 snapshots the problem described in this thread
> > shows
> > > up very often.
> > > As you noticed above, opening container with O_EXCL flag, blocks
> > other
> > > processes to access container which is good (let us name it "case
> > 1"). But
> > > the problem is that there is always a gap between the time mdmon
> > releases
> > > container handle (either by close() or exit()) and STOP_ARRAY ioctl
> > > invoked by mdadm, where any other process can access container device
> > and
> > > block stop action (case 2).
> > > Right now, ioctl is started without any synchronization, what often
> > leads to
> > > "busy" as mdmon asynchronously cleans up after subarrays are stopped.
> > > First what comes to mind is to store mdmon pid, and create loop
> > waiting for
> > > mdmon to close right before ARRAY_STOP action. It will help with
> > "case 1" but
> > > do not block "case 2". I have noticed that such approach helps in
> > about 90% of
> > > all "busy" errors.
> > > To block against both cases I think that kind mdmon/mdadm/kernel
> > > synchronization is needed. Do you have any ideas how it can be made?
> >
> > Yes.  I think we can make use of O_EXCL, and a little bit of retry-on-
> > failure
> > to make this all more reliable.  See patch below which will appear in
> > my
> > devel-3.2 tree later today.
> >
> > If this doesn't fix your symptom, then it is possible I have
> > misunderstood.
> > In that case I'll get some more details and try again.
> >
> > >
> > > >
> > > > However I'm not certain that window wasn't already there, and this
> > might
> > > > just
> > > > make it a bit bigger.
> > > > I've put a note in my to-do list to look into this more closely and
> > figure
> > > > out if there is a problem, and if so, how to fix it.
> > > Could you please move that problem to the top of your TODOs? :)
> >
> > The concern that I had was unfounded.  Because mdmon removes its pid
> > file
> > before closing the fd (and losing the O_EXCL lock), there is no race.
> >
> > Thanks,
> > NeilBrown
> >
> > commit eb0af52689656f6526540ee3a72b0647e7a7b20d
> > Author: NeilBrown <neilb@suse.de>
> > Date:   Thu Mar 17 13:35:10 2011 +1100
> >
> >     --stop: separate 'is busy' test for 'did it stop properly'.
> >
> >     Stopping an md array requires that there is no other user of it.
> >     However with udev and udisks and such there can be transient other
> >     users of md devices which can interfere with stopping the array.
> >
> >     If there is a transient users, we really want "mdadm --stop" to
> > wait a
> >     little while and retry.
> >     However if the array is genuinely in-use (e.g. mounted), then we
> >     don't want to wait at all - we want to fail immediately.
> >
> >     So before trying to stop, re-open device with O_EXCL.  If this
> > fails
> >     then the device is probably in use, so give up.
> >
> >     If it succeeds, but a subsequent STOP_ARRAY fails, then it is
> > possibly
> >     a transient failure, so try again for a few seconds.
> >
> >     Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > diff --git a/Manage.c b/Manage.c
> > index 5996646..3361269 100644
> > --- a/Manage.c
> > +++ b/Manage.c
> > @@ -208,10 +208,26 @@ int Manage_runstop(char *devname, int fd, int
> > runstop, int quiet)
> >  		struct stat stb;
> >  		struct mdinfo *mdi;
> >  		int devnum;
> > +		int err;
> > +		int count;
> >  		/* If this is an mdmon managed array, just write 'inactive'
> >  		 * to the array state and let mdmon clear up.
> >  		 */
> >  		devnum = fd2devnum(fd);
> > +		/* Get EXCL access first.  If this fails, then attempting
> > +		 * to stop is probably a bad idea.
> > +		 */
> > +		close(fd);
> > +		fd = open(devname, O_RDONLY|O_EXCL);
> > +		if (fd < 0 || fd2devnum(fd) != devnum) {
> > +			if (fd >= 0)
> > +				close(fd);
> > +			fprintf(stderr,
> > +				Name ": Cannot get exclusive access to %s:"
> > +				" possibly it is still in use.\n",
> > +				devname);
> > +			return 1;
> > +		}
> >  		mdi = sysfs_read(fd, -1, GET_LEVEL|GET_VERSION);
> >  		if (mdi &&
> >  		    mdi->array.level > 0 &&
> > @@ -230,7 +246,14 @@ int Manage_runstop(char *devname, int fd, int
> > runstop, int quiet)
> >  			/* Give monitor a chance to act */
> >  			ping_monitor(mdi->text_version);
> >
> > -			fd = open(devname, O_RDONLY);
> > +			fd = open_dev_excl(devnum);
> > +			if (fd < 0) {
> > +				fprintf(stderr, Name
> > +					": failed to completely stop %s"
> > +					": Device is busy\n",
> > +					devname);
> > +				return 1;
> > +			}
> >  		} else if (mdi &&
> >  			   mdi->array.major_version == -1 &&
> >  			   mdi->array.minor_version == -2 &&
> > @@ -263,7 +286,18 @@ int Manage_runstop(char *devname, int fd, int
> > runstop, int quiet)
> >  				}
> >  		}
> >
> > -		if (fd >= 0 && ioctl(fd, STOP_ARRAY, NULL)) {
> > +		/* As we have an O_EXCL open, any use of the device
> > +		 * which blocks STOP_ARRAY is probably a transient use,
> > +		 * so it is reasonable to retry for a while - 5 seconds.
> > +		 */
> > +		count = 25;
> > +		while (count && fd >= 0
> > +		       && (err = ioctl(fd, STOP_ARRAY, NULL)) < 0
> > +		       && errno == EBUSY) {
> > +			usleep(200000);
> > +			count --;
> > +		}
> > +		if (fd >= 0 && err) {
> >  			if (quiet == 0) {
> >  				fprintf(stderr, Name
> >  					": failed to stop array %s: %s\n",
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
