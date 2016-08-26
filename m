From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: kernel checksumming performance vs actual raid device performance
Date: Fri, 26 Aug 2016 19:11:47 +0100
Message-ID: <57C08663.1000106@youngman.org.uk>
References: <CAJvUf-C-Nr8sSnSPL-5jt1NLOAiZjhZ=bjDRUbX_RjphRL+yWA@mail.gmail.com>
 <20160824010241.GC57645@kernel.org>
 <CAJvUf-DXC6AtO3a=ox2XOinpRWgAv5NMPkRWAcsSZmBggF5_Dw@mail.gmail.com>
 <83f67452-9f09-2d6f-f82a-77d83309f618@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <83f67452-9f09-2d6f-f82a-77d83309f618@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Matt Garman <matthew.garman@gmail.com>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/08/16 00:39, Adam Goryachev wrote:
> You should find out if you are swapping with vmstat:
> vmstat 5
> Watch the Swap (SI and SO) columns, if they are non-zero, then you are
> indeed swapping.
> 
> You might find that if there is insufficient memory, then the kernel
> will automatically reduce/limit the value for the stripe_cache_size (I'm
> only guessing, but my memory tells me that the kernel locks this memory
> and it can't be swapped/etc).

Are you using a gui :-) ?

Download and build the latest version of xosview (assuming it builds,
when I last tried, "bleeding edge" was bleeding ... :-(

git://github.com/mromberg/xosview

That'll give you a nice little overview of both raid and swap. The
current version of xosview is fine for swap, but the raid monitor is broken.

Cheers,
Wol
