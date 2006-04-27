From: Neil Brown <neilb@suse.de>
Subject: Re: Controlling Reading and Writing in RAID 1 configuration
Date: Fri, 28 Apr 2006 09:06:27 +1000
Message-ID: <17489.20083.873352.723996@cse.unsw.edu.au>
References: <20060425125814.6366.qmail@web52907.mail.yahoo.com>
	<17489.16385.884347.871210@cse.unsw.edu.au>
	<1146177496.11547.147.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ming Zhang on Thursday April 27
Sender: linux-raid-owner@vger.kernel.org
To: mingz@ele.uri.edu
Cc: Rik Herrin <rikherrin@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 27, mingz@ele.uri.edu wrote:
> 
> On Fri, 2006-04-28 at 08:04 +1000, Neil Brown wrote:
> > On Tuesday April 25, rikherrin@yahoo.com wrote:
> > > Hi,
> > >   I have a setup where I want to use RAID 1 to mirror
> > > my data over the LAN.  I am exposing 2x500 GB-sized
> > > devices via iSCSI and was wondering if I could
> > > configure the RAID 1 to write to both members of the
> > > RAID 1 configuration but only read from one as one
> 
> only read from one disk, shall this be a "--read-preferred" ?

No.  The one(s) you don't read from is the odd-one-out.  The one(s)
you read from are 'normal' and don't get a special flag.

> 
> i checked email archive, but still not quite understand on this
> "--write-mostly". for raid1, u anyway need to write all components, so
> why there is a "mostly"?
> 

Mostly it will just write to this device.
But if all the non-write-mostly device fail, then it will read from
this device.  So it isn't write-only.  It is write-mostly.

Make sense?

NeilBrown
