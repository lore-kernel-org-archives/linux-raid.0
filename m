From: Phil Turmel <philip@turmel.org>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Fri, 26 Aug 2016 17:57:37 -0400
Message-ID: <51fda2c2-ef42-c052-8f7d-c00af6a30b1a@turmel.org>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <20160824010241.GC57645@kernel.org>
 <CAJvUf-DXC6AtO3a=ox2XOinpRWgAv5NMPkRWAcsSZmBggF5_Dw@mail.gmail.com>
 <83f67452-9f09-2d6f-f82a-77d83309f618@websitemanagers.com.au>
 <CAJvUf-DJJ4ZqR+kS6SCqgaq9_MXuQxFwyHJbv7YH7hVx5xbBRQ@mail.gmail.com>
 <CAFx4rwTekSp6mNUtt7UfEmTi93Fu+25rYLGrp63XwoxYvwV54g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFx4rwTekSp6mNUtt7UfEmTi93Fu+25rYLGrp63XwoxYvwV54g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: doug@easyco.com, Matt Garman <matthew.garman@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/26/2016 04:04 PM, Doug Dumitru wrote:
> I took a simple array from stripe_cache_size 256 => 32K and the system
> allocated 265 MB of RAM (crude number via free), so this implies that
> the stripe cache is 8K per entry.  The stripe cache struct appears to
> have a bio plus a bunch of other control items in the struct.  I am
> not sure if it has a statically allocated page, but at 8K it looks
> like it does.  So I think the minimum/static memory allocated by the
> stripe cache is 8K per entry.  This "might" also be the maximum, or
> the cache size might grow to handle longer requests.

This was answered three days ago.  Allow me to quote myself:

> This is not correct.  Parity operations in MD raid4/5/6 operate on 4k
> blocks.  The stripe cache for an array is a collection of 4k elements
> per member device.  Chunk size doesn't factor into the cache itself.

Phil

