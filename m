From: dong wu <dongwucs@gmail.com>
Subject: Re: when read error ,where do we rewrite?
Date: Fri, 8 Jan 2010 12:59:26 +0800
Message-ID: <6c394cc31001072059t2669afa8l5fed42ff77b3c134@mail.gmail.com>
References: <6c394cc31001070441r1287f635q9c58dc836ce488b7@mail.gmail.com>
	 <20100107131855.GA10915@cthulhu.home.robinhill.me.uk>
	 <6c394cc31001072054v7368cc05kb7005b39d00c1c07@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c394cc31001072054v7368cc05kb7005b39d00c1c07@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

In the source code of raid5,when write error,it faulty the disk,not remap
the block. why do it use "remap the block"?

2010/1/8, dong wu <dongwucs@gmail.com>:
> If it is written to the same block,will it read error again?
> when read error,the low-level attempts a write and remap the block if
> the write fails.
> where does it remap?
> Is there any spare block in the disk for remap when read or write error occurs?
>
> 2010/1/7, Robin Hill <robin@robinhill.me.uk>:
> > On Thu Jan 07, 2010 at 08:41:20PM +0800, dong wu wrote:
> >
> > > when read error and can rewrite,where do we rewrite?
> > > It can't be rewrited to the old block.
> > > It should be rewrite to other place,where can we find the 'other place'?
> > > In the source code,I don't find the place that should be rewrited to.
> > >
> > It's rewritten to the same block - it's up to the low-level device (the
> > disk) to attempt a write and transparently remap the block if the write
> > fails.
> >
> > Cheers,
> >    Robin
> > --
> >     ___
> >    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
> >   / / )      | Little Jim says ....                            |
> >  // !!       |      "He fallen in de water !!"                 |
> >
> >
>
