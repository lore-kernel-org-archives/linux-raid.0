From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Wed, 21 Mar 2007 21:03:27 +0100
Message-ID: <0e5aac2ffcd189dc51f59d5891b2366c@kernel.crashing.org>
References: <20070315232956.37DAB353A6C@atlas.denx.de> <200703170909.13869.sr@denx.de> <e9c3a7c20703171117w7989adfehda99416265eef906@mail.gmail.com> <200703171943.27465.sr@denx.de> <e9c3a7c20703171209m55fd9dfsbba0e4fff5c6350d@mail.gmail.com> <1174320799.5044.21.camel@localhost.localdomain> <582f77296616b0b85ff7533bb7fea05c@kernel.crashing.org> <1174506924.10836.2.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1174506924.10836.2.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@gmail.com>, linuxppc-dev@ozlabs.org, Stefan Roese <sr@denx.de>
List-Id: linux-raid.ids

>>> BTW folks. Would it be hard to change your spe_ prefixes to something
>>> else ? There's already enough confusion between the freescale SPE 
>>> unit
>>> and the cell SPEs :-)
>>
>> Will you change _your_ prefixes too?  :-) :-)
>
> Which ones ? I'm not in charge of the fsl spe thingy nor the spe
> scheduler code :-)

I meant the Cell code of course.

> Beside, that code is already in vs. new code getting
> in. Thus I fail to see your point.

My point was that spe_ on the existing code is a bad
prefix, too.  And there were a lot of smileys, I don't
actually expect anything to change.

Let's stop this now, there are too many innocents on CC:.
Sorry people.


Segher

