From: maarten van den Berg <maarten@vbvb.nl>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 20:51:06 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310282051.06208.maarten@vbvb.nl>
References: <Pine.LNX.4.44.0310281327090.8137-100000@redhat1.mmaero.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0310281327090.8137-100000@redhat1.mmaero.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 28 October 2003 19:28, jlewis@lewis.org wrote:
> On Tue, 28 Oct 2003, maarten van den Berg wrote:
> > Promise cards do suck somewhat -albeit I use them- but what else is there
> > ? The highpoint-equipped cards are even more sucky in many cases.
>
> What about Adaptec's IDE/ATA versions of their DPT RAID controllers?
> AFAIK, they even use the same dpt driver.

Can't comment on the adaptec.  Adaptec usually makes a good product, so...

My experiences with HPT chipsets were that it _seems_ to work at first but 
then when you turn on DMA all hell breaks loose. Either the chipset or the 
linux driver just can't cope with DMA (and we all know how fast PIO is...)
This behaviour was observed with a HPT366 onboard version, and (much) later 
again with a standalone HPT370. From then on, I refused to touch highpoint 
chipset based cards with a 10' pole.     ( YMMV )

Maarten

-- 
Yes of course I'm sure it's the red cable. I guarante[^%!/+)F#0c|'NO CARRIER
