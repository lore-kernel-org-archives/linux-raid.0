From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH] fix: mdadm -Ss for external metadata don't stop
 container
Date: Wed, 16 Mar 2011 22:24:20 +0000
Message-ID: <66C59AD0932712458090B447266D638C010FABEFEC@irsmsx504.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638C010BD52A8E@irsmsx504.ger.corp.intel.com>
 <20101207211611.475410d1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101207211611.475410d1@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Tuesday, December 07, 2010 11:16 AM
> To: Hawrylewicz Czarnowski, Przemyslaw
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed; Labun,
> Marcin; Czarnowska, Anna
> Subject: Re: [PATCH] fix: mdadm -Ss for external metadata don't stop
> container
> 
> On Tue, 7 Dec 2010 06:44:21 +0000 "Hawrylewicz Czarnowski, Przemyslaw"
> <przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
> 
> > Neil,
> >
> > The one below is a fix for the problem we encounter quite often when we
> try to stop all arrays with mdadm -Ss. The main problem is that mdmon holds
> open container device and then exits. The time that system make clean up is
> quite long and mdadm invokes ARRAY_STOP ioctl when device is still opened.
> > Second resolution is to retry ioctl in mdadm after mdmon exits, but
> closing handle is I what should be done before process exist.
> > Take a look at the patch below:
> >
> > --
> > Sometimes (~50%) mdadm -Ss cannot stop container as mdmon opens its
> device
> > and do not close it before exit(). The period between open and release of
> > handle is too long and md is not able stop device. Releasing handle
> before
> > exit does not block md.
> >
> > Signed-off-by: Przemyslaw Czarnowski
> <przemyslaw.hawrylewicz.czarnowski@intel.com>
> 
> I've applied this, but I'm not 100% sure it is completely safe.
> mdmon holds the O_EXCL open to be sure that mdadm isn't creating or
> assembling another array in the container.
> mdadm will get an O_EXCL and then try sending a signal to mdmon.  If it
> succeeds, it knows mdmon is still running.  But this patch might open a
> window where mdadm can get O_EXCL, and a signal still works.

Hi,

As we test new RHEL6.1 snapshots the problem described in this thread shows
up very often. 
As you noticed above, opening container with O_EXCL flag, blocks other
processes to access container which is good (let us name it "case 1"). But 
the problem is that there is always a gap between the time mdmon releases
container handle (either by close() or exit()) and STOP_ARRAY ioctl
invoked by mdadm, where any other process can access container device and
block stop action (case 2).
Right now, ioctl is started without any synchronization, what often leads to
"busy" as mdmon asynchronously cleans up after subarrays are stopped.
First what comes to mind is to store mdmon pid, and create loop waiting for
mdmon to close right before ARRAY_STOP action. It will help with "case 1" but
do not block "case 2". I have noticed that such approach helps in about 90% of
all "busy" errors.
To block against both cases I think that kind mdmon/mdadm/kernel
synchronization is needed. Do you have any ideas how it can be made?

> 
> However I'm not certain that window wasn't already there, and this might
> just
> make it a bit bigger.
> I've put a note in my to-do list to look into this more closely and figure
> out if there is a problem, and if so, how to fix it.
Could you please move that problem to the top of your TODOs? :)

> 
> Thanks,
> NeilBrown
> 
> 
> 
> > ---
> >  monitor.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> >
> > diff --git a/monitor.c b/monitor.c
> > index 59b4181..f166bc8 100644
> > --- a/monitor.c
> > +++ b/monitor.c
> > @@ -525,6 +525,7 @@ static int wait_and_act(struct supertype *container,
> int nowait)
> >  				remove_pidfile(container->devname);
> >  			exit_now = 1;
> >  			signal_manager();
> > +			close(fd);
> >  			exit(0);
> >  		}
> >  	}

