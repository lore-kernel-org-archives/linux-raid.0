From: Phil Turmel <philip@turmel.org>
Subject: Re: Wiki, raid 10, and my new system :-)
Date: Tue, 17 Oct 2017 16:57:14 -0400
Message-ID: <9cfedac1-aaa2-a53d-4ece-97a63ecfb355@turmel.org>
References: <59E4BA29.4050907@youngman.org.uk>
 <e3ee3a5d-a6b0-49aa-1949-18a248e1397f@thelounge.net>
 <87y3oak3zj.fsf@notabene.neil.brown.name>
 <67a81e49-37b6-b0f7-f9e2-16301ecd4f9a@youngman.org.uk>
 <6c901544-fe5e-fd6a-b3b3-6b8e5edfa36b@turmel.org>
 <0c360057-f616-dcee-5f0a-59e12cb6ab43@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0c360057-f616-dcee-5f0a-59e12cb6ab43@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/17/2017 04:43 PM, Anthony Youngman wrote:
> On 17/10/17 20:04, Phil Turmel wrote:
>> No, it is*wrong*.  Writes in multiples of 4k and entirely within a
>> chunk are passes as-is to the devices.  For mirrors, all affected
>> devices get a copy of the request.  For parity raid, the 4k stripes
>> corresponding to those 4k blocks will be pulled into the stripe cache
>> for recalculation.  Not whole chunk-size stripes.  The stripe cache is
>> multiples of 4k, not multiples of the chunk size!
>>
>> Writes smaller than 4k, or not aligned to 4k, will generate a
>> read-modify-write cycle of the 4k block involved.  Not the whole chunk.
>>
>> It is more accurate to say that a chunk may be the*largest*  a request
>> can be before it is split between devices.
> 
> Okay, I think I need to update my understanding on this ... :-)
> 
> Let's say a chunk is 12K. That's three 4K blocks to drive 1, followed by
> three to drive 2 etc. Does that mean that each chunk is split across
> three stripes, or is the stripe all the 12K chunks one per drive?

A stripe is still a chunk on each driver.  You are confusing the chunk
as part of the layout with the read/write operations on the underlying
devices.  Read/write operations to the array obviously have to be split
at chunk boundaries because that's where the layout divides the
underlying space between devices.  But *within* a single chunk, the
operation simply passes through (plus mirrors or write recalc as
needed).  Minimum-size operations on underlying devices are 4k.

> In other words, does a stripe consist of one block per drive, or one
> chunk per drive?

The *stripe* is one chunk per drive.

But the stripe *cache* is one block per drive per cache entry, because
operations on devices are multiples of blocks, not chunks.

> (I'll put a "sic" on that page then, just to point out it's a
> misunderstanding by the original author. As I said, I'd rather not mess
> around with the page now.)

The number one pitch point for wikis is that they can be edited, and the
wiki keeps a history.  I don't get why you don't want to fix it.

{ But then, I'm not really a fan of wikis .... }

Phil
