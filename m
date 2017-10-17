From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: Wiki, raid 10, and my new system :-)
Date: Tue, 17 Oct 2017 21:43:03 +0100
Message-ID: <0c360057-f616-dcee-5f0a-59e12cb6ab43@youngman.org.uk>
References: <59E4BA29.4050907@youngman.org.uk>
 <e3ee3a5d-a6b0-49aa-1949-18a248e1397f@thelounge.net>
 <87y3oak3zj.fsf@notabene.neil.brown.name>
 <67a81e49-37b6-b0f7-f9e2-16301ecd4f9a@youngman.org.uk>
 <6c901544-fe5e-fd6a-b3b3-6b8e5edfa36b@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6c901544-fe5e-fd6a-b3b3-6b8e5edfa36b@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, NeilBrown <neilb@suse.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/10/17 20:04, Phil Turmel wrote:
> No, it is*wrong*.  Writes in multiples of 4k and entirely within a
> chunk are passes as-is to the devices.  For mirrors, all affected
> devices get a copy of the request.  For parity raid, the 4k stripes
> corresponding to those 4k blocks will be pulled into the stripe cache
> for recalculation.  Not whole chunk-size stripes.  The stripe cache is
> multiples of 4k, not multiples of the chunk size!
> 
> Writes smaller than 4k, or not aligned to 4k, will generate a
> read-modify-write cycle of the 4k block involved.  Not the whole chunk.
> 
> It is more accurate to say that a chunk may be the*largest*  a request
> can be before it is split between devices.

Okay, I think I need to update my understanding on this ... :-)

Let's say a chunk is 12K. That's three 4K blocks to drive 1, followed by 
three to drive 2 etc. Does that mean that each chunk is split across 
three stripes, or is the stripe all the 12K chunks one per drive?

In other words, does a stripe consist of one block per drive, or one 
chunk per drive?

(I'll put a "sic" on that page then, just to point out it's a 
misunderstanding by the original author. As I said, I'd rather not mess 
around with the page now.)

Cheers,
Wol
