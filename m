From: NeilBrown <neilb@suse.de>
Subject: Re: stripe cache question
Date: Fri, 25 Feb 2011 14:51:25 +1100
Message-ID: <20110225145125.69dd4b9d@notabene.brown>
References: <20110224210642.GA20306@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110224210642.GA20306@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 24 Feb 2011 22:06:43 +0100 Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
> 
> few posts ago was mentioned that the unit of the stripe
> cache are "pages per device", usually 4K pages.
> 
> Questions:
> 
> 1) Does "device" means raid (md) device or component
> device (HDD)?

component device.
In drivers/md/raid5.[ch] there is a 'struct stripe_head'.
It holds one page per component device (ignoring spares).
Several of these comprise the 'cache'.  The 'size' of the cache is the number
oof 'struct stripe_head' and associated pages that are allocated.


> 
> 2) The max possible value seems to be 32768, which
> means, in case of 4K page per md device, a max of
> 128MiB of RAM.
> Is this by design? Would it be possible to increase
> up to whatever is available?

32768 is just an arbitrary number.  It is there in raid5.c and is easy to
change (for people comfortable with recompiling their kernels).

I wanted an upper limit because setting it too high could easily cause your
machine to run out of memory and become very sluggish - or worse.

Ideally the cache should be automatically sized based on demand and memory
size - with maybe just a tunable to select between "use a much memory as you
need - within reason" verse "use a little memory as you can manage with".

But that requires thought and design and code and .... it just never seemed
like a priority.

NeilBrown


> 
> Thanks,
> 
> bye,
> 

