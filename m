From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Subject: RE: Adaptec 39160 RAID ?!
Date: Tue, 10 Feb 2004 13:24:33 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <8075D5C3061B9441944E137377645118322A54@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Thomas Graham <lkthomas@sml.dyndns.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The Adaptec 39160 is just a plain SCSI card - the card does not have any
RAID capabilities.

You can use Linux software RAID to create a RAID array with disks
attached to the 39160 (we have 4 our these cards in one of our servers),
but the card does not have any RAID capabilities native.



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org 
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Thomas Graham
> Sent: Tuesday, February 10, 2004 8:13 AM
> To: linux-raid@vger.kernel.org
> Subject: Adaptec 39160 RAID ?!
> 
> Adaptec 39160 support RAID feature, but how could I config it 
> on linux ?
> Thanks. ( by the way, 39160 is a software or hardware RAID ? )
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
