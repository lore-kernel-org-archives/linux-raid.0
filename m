From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: recommended 4port SATA controller ?
Date: Mon, 21 Sep 2009 11:29:41 -0500
Message-ID: <20090921162940.GA26014@sewage>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com> <4AB24BFC.6070800@kaneda.iguw.tuwien.ac.at> <20090917215240.GA418@sewage> <46495.81.217.58.120.1253231296.squirrel@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46495.81.217.58.120.1253231296.squirrel@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry, meant to reply to this earlier...

On Fri, Sep 18, 2009 at 01:48:16AM +0200, Rainer Fuegenstein wrote:
> 
> > Anyway, you asked for four ports, but how about eight?  I'm
> > surprised no one has mentioned this yet---I'd consider it a bit of a
> > "classic": Supermicro AOC-SAT2-MV8.
> >
> >     http://www.newegg.com/Product/Product.aspx?Item=N82E16815121009
> 
> If it really works with PCI, this is my choice. which kernel
> module is handling the card ?

I would be surprised if it didn't work with your system's PCI slot.
I've read lots of threads on various forms (HardForum, ArsTechnica)
where people use this card for massive fileservers, and don't recall
anyone ever saying it didn't work for them in a regular 32-bit PCI
slot.

Worst case, order it from a retailer with liberal return policies.

As for the kernel module, I believe it's sata_mv.

Regards,
Matt

