From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Thu, 22 Mar 2007 12:38:57 +0100
Message-ID: <20070322113857.GA13547@lst.de>
References: <20070315232956.37DAB353A6C@atlas.denx.de> <200703170909.13869.sr@denx.de> <e9c3a7c20703171117w7989adfehda99416265eef906@mail.gmail.com> <200703171943.27465.sr@denx.de> <e9c3a7c20703171209m55fd9dfsbba0e4fff5c6350d@mail.gmail.com> <1174320799.5044.21.camel@localhost.localdomain> <582f77296616b0b85ff7533bb7fea05c@kernel.crashing.org> <1174506924.10836.2.camel@localhost.localdomain> <0e5aac2ffcd189dc51f59d5891b2366c@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <0e5aac2ffcd189dc51f59d5891b2366c@kernel.crashing.org>
Sender: linux-raid-owner@vger.kernel.org
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@gmail.com>, Stefan Roese <sr@denx.de>, linuxppc-dev@ozlabs.org
List-Id: linux-raid.ids

On Wed, Mar 21, 2007 at 09:03:27PM +0100, Segher Boessenkool wrote:
> >>> BTW folks. Would it be hard to change your spe_ prefixes to something
> >>> else ? There's already enough confusion between the freescale SPE 
> >>> unit
> >>> and the cell SPEs :-)
> >>
> >> Will you change _your_ prefixes too?  :-) :-)
> >
> > Which ones ? I'm not in charge of the fsl spe thingy nor the spe
> > scheduler code :-)
> 
> I meant the Cell code of course.

Did you ever take a look at the cell code?  The only place 'spe'
is used in a prefix are a handfull of hardware datatstructures and the
sony crap hypervisor hvcalls.  Everything else uses spu_ as a prefix.

But yeah, grep is hard and life is a bitch.. :)
