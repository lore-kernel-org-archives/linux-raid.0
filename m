From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Thu, 22 Mar 2007 14:20:37 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0703221419280.7246@pademelon.sonytel.be>
References: <20070315232956.37DAB353A6C@atlas.denx.de> <200703170909.13869.sr@denx.de>
 <e9c3a7c20703171117w7989adfehda99416265eef906@mail.gmail.com>
 <200703171943.27465.sr@denx.de> <e9c3a7c20703171209m55fd9dfsbba0e4fff5c6350d@mail.gmail.com>
 <1174320799.5044.21.camel@localhost.localdomain>
 <582f77296616b0b85ff7533bb7fea05c@kernel.crashing.org>
 <1174506924.10836.2.camel@localhost.localdomain>
 <0e5aac2ffcd189dc51f59d5891b2366c@kernel.crashing.org> <20070322113857.GA13547@lst.de>
 <856c539083dbd89a6f71edfd46f502f0@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <856c539083dbd89a6f71edfd46f502f0@kernel.crashing.org>
Sender: linux-raid-owner@vger.kernel.org
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@gmail.com>, Stefan Roese <sr@denx.de>, Linux/PPC Development <linuxppc-dev@ozlabs.org>
List-Id: linux-raid.ids

On Thu, 22 Mar 2007, Segher Boessenkool wrote:
> >>>>> BTW folks. Would it be hard to change your spe_ prefixes to 
> >>>>> something
> >>>>> else ? There's already enough confusion between the freescale SPE
> >>>>> unit
> >>>>> and the cell SPEs :-)
> >>>>
> >>>> Will you change _your_ prefixes too?  :-) :-)
> >>>
> >>> Which ones ? I'm not in charge of the fsl spe thingy nor the spe
> >>> scheduler code :-)
> >>
> >> I meant the Cell code of course.
> >
> > Did you ever take a look at the cell code?
> 
> Not often, no.  I'm perfectly happy that I don't have
> to touch that.
> 
> > The only place 'spe'
> > is used in a prefix are a handfull of hardware datatstructures and the
> > sony crap hypervisor hvcalls.  Everything else uses spu_ as a prefix.
> 
> That sounds nice.  There are slightly fewer things called
> SPU than there are called SPE I imagine?  Or is it just a
> historical misnomer.

AFAIK SPE is the preferred name, as the SPU is only a part of the SPE.
That's what I was told.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- Sony Network and Software Technology Center Europe (NSCE)
Geert.Uytterhoeven@sonycom.com ------- The Corporate Village, Da Vincilaan 7-D1
Voice +32-2-7008453 Fax +32-2-7008622 ---------------- B-1935 Zaventem, Belgium
