From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Adaptec 39160 RAID ?!
Date: Tue, 10 Feb 2004 15:43:08 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4029425C.A73FDE60@SteelEye.com>
References: <8075D5C3061B9441944E137377645118322A54@cinshrexc03.shermfin.com> <40293C80.7020906@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> 
> Rechenberg, Andrew wrote:
> > The Adaptec 39160 is just a plain SCSI card - the card does not have any
> > RAID capabilities.
> >
> > You can use Linux software RAID to create a RAID array with disks
> > attached to the 39160 (we have 4 our these cards in one of our servers),
> > but the card does not have any RAID capabilities native.
> 
> Yes, but doesn't the card ship with "fake RAID"?  

No, it's just a plain old Ultra160 Dual Channel SCSI Host Adapter.

--
Paul
