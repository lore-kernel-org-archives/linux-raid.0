From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: [Fwd: "Enhanced" MD code avaible for review]
Date: Wed, 17 Mar 2004 21:23:59 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040317192359.GS3245@hvs.envisage.co.za>
References: <405899E8.8070806@pobox.com> <20040317183756.GA23667@lst.de> <2241002704.1079549645@aslan.btc.adaptec.com> <20040317190117.GA23968@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040317190117.GA23968@lst.de>
To: Christoph Hellwig <hch@lst.de>
Cc: "Justin T. Gibbs" <Justin_Gibbs@adaptec.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 17, 2004 at 08:01:17PM +0100, Christoph Hellwig wrote:
> > >> http://people.freebsd.org/~gibbs/linux/SRC/md_announce_whole_device.diff
> > > 
> > > Vetoed.  Kernel-level autodetection code is deprecated already, don't
> > > even try to add functionality for it.
> > 
> > So do you speak for the entire community in expressing that auto-detection
> > will never make sense in the kernel?  Are you completely unwilling to
> > entertain even a minor discussion on the topic for those of us that don't
> > understand the concerns the community has in supporting it?

I personally see the use for it, but alas. This have also been an
for EVMS and the reason they`ve changed so radically change between 1.2 and 2.0
 
> I speak about the concencus the 'community' has reached in the past.
> If you invested the tiniest amount of googling you'd have seen messages
> from Neil where he sais he'd rather get rid of autodetection ioctls
> in favour of mdadm doing the work, and patches extending autodetection
> beeing rejected.  Which pretty much fits into the general do it in
> userspace if you can rule.

Yes.
Personally I have different views on it, but that's the direction that especially the hardcore kernel developers on the linux kernel mailing list views the
world and auto discovery etc.

Hendrik
