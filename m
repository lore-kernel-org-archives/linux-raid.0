From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: Scsi adapters and software raid...
Date: Thu, 19 Feb 2004 19:49:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118322AB5@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Bob Hillegas <bobhillegas@houston.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I would agree.  We have a 56-disk Linux software RAID array running with
4 Adaptec 39160 (they use the aic7xxx module) and we have had great
performance and reliability.

Regards,
Andrew Rechenberg
Infrastructure Team, Sherman Financial Group


> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Kanoa 
> Withington
> Sent: Thursday, February 19, 2004 7:34 PM
> To: Bob Hillegas
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Scsi adapters and software raid...
> 
> 
> Bob,
> 
> All the Adaptec non-RAID SCSI controllers work nicely. The 
> ones based on the 79xx and newer chips require the newer 
> kernel module. The 78xx and older ones are all supported by 
> the old module. They are generally stable, compatible and 
> offer good performance.
> 
> Their SCSI _hardware_ RAID controllers are a different story. 
> Steer clear of those.
> 
> 
> -Kanoa
> 
> 
> On Thu, 19 Feb 2004, Bob Hillegas wrote:
> 
> > It's been interesting reading these comments about adapters 
> to avoid.
> >
> > My question is... what SCSI adapter works WELL with software raid
> > (mdadm) and doesn't get in the way?
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
