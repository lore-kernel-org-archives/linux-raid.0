From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 14:27:16 +0100
Message-ID: <20160321132716.GA4196@EIS>
References: <trinity-235b76ed-571d-4615-b6f7-b4d5ed6a116d-1458509365312@3capp-gmx-bs09>
 <trinity-dd5fc296-8c28-4b99-85de-889a495e6956-1458510296940@3capp-gmx-bs09>
 <20160320223727.GA29895@EIS>
 <56EFEC28.7020207@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56EFEC28.7020207@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Patrick Tschackert <Killing-Time@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2016 at 08:42:16AM -0400, Phil Turmel wrote:
> On 03/20/2016 06:37 PM, Andreas Klauer wrote:
> > This is what you get when you use --create --assume-clean on disks 
> > that are not actually clean... or if you somehow convince md to 
> > integrate a disk that does not have valid data on, for example 
> > because you copied partition table and md metadata - but not  
> > everything else - using dd.
> > 
> > Something really bad happened here and the only person who 
> > can explain it, is probably yourself.
> 
> This is wrong.  Your mdadm -D output clearly shows a 2014 creation date,
> so you definitely hadn't done --create --assume-clean at that point.
> (Don't.)

It was just an example. You get a mismatch if (at least) one disk has 
wrong data on it; this many mismatches means there is a disk full of 
wrong data for some reason we do not know, hence I suggested trying 
to assemble it with disks missing, in the hope the data will start 
making sense once the bad disk(s) are gone.

> Something else is wrong, quite possibly hardware.

Nothing is impossible, but for a hardware error this is very unusual.

> I would use an overlay for that.

Use overlays, and for disks with bad sectors, make good copies of them 
(make sure to remember which of them were bad and where the holes in 
the copies are, i.e. keep the ddrescue logs). If you play around with 
disks that already have bad sectors, they might die completely on you.

Regards
Andreas Klauer
