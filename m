From: Doug Ledford <dledford@redhat.com>
Subject: Re: hostRAID, AIC-7901, disable?
Date: Wed, 15 Dec 2004 12:49:20 -0500
Message-ID: <1103132961.3629.41.camel@compaq-rhel4.xsintricity.com>
References: <cpkem3$70s$1@sea.gmane.org>
	 <bbfa52890412131309234b2d09@mail.gmail.com>  <cpl0tm$4sp$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cpl0tm$4sp$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: murray evans <m.evans@rdg.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2004-12-13 at 21:15 +0000, murray evans wrote:
> Colin McDonald wrote:
> 
> > Cntl+A into the SCSI bios & disable it.
> > 
> > Try that.
> > 
> > 
> 
> 
> Like I say, the setup tool has no option to disable it. this includes 
> both the bios, the the Adaptec SCSISelect tool (i.e. Ctrl A). Although
> the instructions do insist it is there, we've had a very thorough look,
> and it's not.

In some BIOSes, you go into the integrated peripherals section of the
setup and it will have a spot for the SCSI controller and you can select
any of RAID/SCSI/disabled.  Obviously, SCSI will enable the chip but not
put it under the control of the RAID hardware.  Check your BIOS and see
if it has anything like that to disable the RAID portion on that
controller.

> 
> > 
> > 
> > On Mon, 13 Dec 2004 16:04:08 +0000, murray evans <m.evans@rdg.ac.uk>
> > wrote:
> >> We have recently aquired a new Dell Precision 670 workstation, on which
> >> we intended to install linux, (Suse 9.1).
> >> In the install, is reports it can not find any hard drives.
> >> We think we have tracked this problem down to the AIC-7901 hostRAID
> >> SCSI controller. From what I we can gather, linux no longer has
> >> drivers for hostRAID hardware. We don't care about having RAID, just
> >> a working system, so we would be content to simply disable the
> >> hostRAID. the problem is, the setup tool does not have any option
> >> to disable hostRAID.
> >> 
> >> Has anyone come across a solution? Is there a driver I don't know of?
> >> Is there a way of disabling hostRAID?
> >> 
> >> *PS: From the SuSe install, when we try to add the appropriate SCSI
> >> module for the AIC-7901, it fails.
> >> 
> >> -
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
  Doug Ledford <dledford@redhat.com>
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606

