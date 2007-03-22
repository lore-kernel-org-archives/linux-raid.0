From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Thu, 22 Mar 2007 13:36:39 +0100
Message-ID: <856c539083dbd89a6f71edfd46f502f0@kernel.crashing.org>
References: <20070315232956.37DAB353A6C@atlas.denx.de> <200703170909.13869.sr@denx.de> <e9c3a7c20703171117w7989adfehda99416265eef906@mail.gmail.com> <200703171943.27465.sr@denx.de> <e9c3a7c20703171209m55fd9dfsbba0e4fff5c6350d@mail.gmail.com> <1174320799.5044.21.camel@localhost.localdomain> <582f77296616b0b85ff7533bb7fea05c@kernel.crashing.org> <1174506924.10836.2.camel@localhost.localdomain> <0e5aac2ffcd189dc51f59d5891b2366c@kernel.crashing.org> <20070322113857.GA13547@lst.de>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070322113857.GA13547@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@gmail.com>, Stefan Roese <sr@denx.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org
List-Id: linux-raid.ids

>>>>> BTW folks. Would it be hard to change your spe_ prefixes to 
>>>>> something
>>>>> else ? There's already enough confusion between the freescale SPE
>>>>> unit
>>>>> and the cell SPEs :-)
>>>>
>>>> Will you change _your_ prefixes too?  :-) :-)
>>>
>>> Which ones ? I'm not in charge of the fsl spe thingy nor the spe
>>> scheduler code :-)
>>
>> I meant the Cell code of course.
>
> Did you ever take a look at the cell code?

Not often, no.  I'm perfectly happy that I don't have
to touch that.

> The only place 'spe'
> is used in a prefix are a handfull of hardware datatstructures and the
> sony crap hypervisor hvcalls.  Everything else uses spu_ as a prefix.

That sounds nice.  There are slightly fewer things called
SPU than there are called SPE I imagine?  Or is it just a
historical misnomer.

> But yeah, grep is hard and life is a bitch.. :)

If I'm told there are all these other things in the kernel
called spe_ I don't feel obliged to grep for it to check
if this is really so.  Maybe I shouldn't trust people that
much, dunno.


Segher

