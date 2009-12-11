From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: mdadm creating raid5 with all spare disks
Date: Fri, 11 Dec 2009 06:33:09 -0700
Message-ID: <200912110633.09495.tfjellstrom@shaw.ca>
References: <1D0665FE-138F-480F-9872-48C94CEBC5C2@mac.com> <4B2196B0.2090604@sauce.co.nz> <6E2CD5BC-5F08-44A0-869C-1875DF5CCA9F@mac.com>
Reply-To: tfjellstrom@shaw.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6E2CD5BC-5F08-44A0-869C-1875DF5CCA9F@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: Richard Scobie <richard@sauce.co.nz>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu December 10 2009, Matt Tehonica wrote:
> On Dec 10, 2009, at 7:47 PM, Richard Scobie <richard@sauce.co.nz> wrote:
> > Matthew Tehonica wrote:
> >> After about 5 minutes, I try to cat /proc/mdstat again and it just
> >> freezes and sits there with the cursor flashing.  At this point, I
> >> can do anything with mdadm, not even like a --detail on another
> >> array on the system.  Just sits there and flashes.  I've tried with
> >> a bunch of different disks and same thing all the time.  Here is a
> >> section from my kern.log.  Dec 10 19:01:07 ghostrider kernel: [
> >> 1338.011320 ] /build/buildd/linux-2.6.31/drivers/scsi/mvsas/mv_sas.c
> >> 1669:mvs_abort_task:rc= 5
> >> Dec 10 19:01:07 ghostrider kernel: [ 1338.011330] /build/buildd/
> >> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> >> Dec 10 19:01:07 ghostrider kernel: [ 1338.011343] /build/buildd/
> >> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> >> Dec 10 19:01:07 ghostrider kernel: [ 1338.011349] /build/buildd/
> >> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> >> Dec 10 19:01:07 ghostrider kernel: [ 1338.011443] /build/buildd/
> >> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> >> Dec 10 19:01:07 ghostrider kernel: [ 1338.011449] /build/buildd/
> >> linux-2.6.31/drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> >> Dec 10 19:01:07 ghostrider kernel: [ 1338.011461] end_request: I/O
> >> error, dev sdf, sector 0
> >> Dec 10 19:01:07 ghostrider kernel: [ 1338.011472] md: super_written
> >> gets error=-5, uptodate=0
> >
> > Looks like the drives are being dropped by the controller.
> >
> > I believe there was some recent discussion here about mv_sas, md and
> > failures under heavy I/O load.
> >
> > Regards,
> >
> > Richard
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-
> > raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> Thanks Richard!  After some more review I found many people with this
> problem and appears the linux-scsi devs submitted patches mid last
> month. Building the latest kernel as we speak!

I'd be one of them ;) I have a somewhat old copy of the new mvsas drivers, 
and have been running a 5x1TB raid5 array for about a month now and haven't 
had any problems (other than 2.6.31 being horribly io bound).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
