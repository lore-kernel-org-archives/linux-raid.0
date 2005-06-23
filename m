From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: More tales of horror from the linux (HW) raid crypt
Date: Wed, 22 Jun 2005 23:05:51 -0400
Message-ID: <200506230305.j5N35u222988@www.watkins-home.com>
References: <1119487758.5501.185.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1119487758.5501.185.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu, bdameron@pivotlink.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Ming Zhang
> Sent: Wednesday, June 22, 2005 8:49 PM
> To: bdameron@pivotlink.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: More tales of horror from the linux (HW) raid crypt
> 
> On Wed, 2005-06-22 at 17:14 -0700, bdameron@pivotlink.com wrote:
> > Quoting Ming Zhang <mingz@ele.uri.edu>:
> >
> > > will this 24 port card itself will be a bottleneck?
> > >
> > > ming
> >
> > Since the card is PCI-X the only bottleneck on it might be the Processor
> since
> > it is shared with all 24 ports. But I do not know for sure without
> testing it.
> > I personally am going to stick with the new 16 port version. Which is a
> PCI-
> > Express card and has twice the CPU power. Since there are so many
> spindles it
> > should be pretty darn fast. And remember that even tho the drives are
> 150MBps
> > they realistically only do about 25-30MBps.
> 
> the problem here is taht each HD can stably deliver 25-30MBps while the
> PCI-x will not arrive that high if have 16 or 24 ports. i do not have a
> chance to try out though. those bus at most arrive 70-80% the claimed
> peak # :P

Maybe my math is wrong...
But 24 disks at 30 MB/s is 720 MB/s, that is about 68.2% of the PCI-X
bandwidth of 1056 MB/s.

Also, 30 MB/s assumes sequential disk access.  That does not occur in the
real world.  Only during testing.  IMO

Guy

> 
> 
> 
> >
> > Brad Dameron
> > SeaTab Software
> > www.seatab.com
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

