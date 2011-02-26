From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: stripe cache question
Date: Sat, 26 Feb 2011 11:21:28 +0100
Message-ID: <20110226102128.GA15074@lazy.lzy>
References: <20110224210642.GA20306@lazy.lzy>
 <20110225145125.69dd4b9d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110225145125.69dd4b9d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 25, 2011 at 02:51:25PM +1100, NeilBrown wrote:
> On Thu, 24 Feb 2011 22:06:43 +0100 Piergiorgio Sartor
> <piergiorgio.sartor@nexgo.de> wrote:
> 
> > Hi all,
> > 
> > few posts ago was mentioned that the unit of the stripe
> > cache are "pages per device", usually 4K pages.
> > 
> > Questions:
> > 
> > 1) Does "device" means raid (md) device or component
> > device (HDD)?
> 
> component device.
> In drivers/md/raid5.[ch] there is a 'struct stripe_head'.
> It holds one page per component device (ignoring spares).
> Several of these comprise the 'cache'.  The 'size' of the cache is the number
> oof 'struct stripe_head' and associated pages that are allocated.
> 
> 
> > 
> > 2) The max possible value seems to be 32768, which
> > means, in case of 4K page per md device, a max of
> > 128MiB of RAM.
> > Is this by design? Would it be possible to increase
> > up to whatever is available?
> 
> 32768 is just an arbitrary number.  It is there in raid5.c and is easy to
> change (for people comfortable with recompiling their kernels).

Ah! I found it. Maybe, considering currently
available memory you should think about incresing
it to, for example, 128K or 512K.
 
> I wanted an upper limit because setting it too high could easily cause your
> machine to run out of memory and become very sluggish - or worse.
> 
> Ideally the cache should be automatically sized based on demand and memory
> size - with maybe just a tunable to select between "use a much memory as you
> need - within reason" verse "use a little memory as you can manage with".
> 
> But that requires thought and design and code and .... it just never seemed
> like a priority.

You're a bit contraddicting your philosopy of
"let's do the smart things in user space"... :-)

IMHO, if really necessary, it could be enough to
have this "upper limit" avaialable in sysfs.

Then user space can decide what to do with it.

For example, at boot the amount of memory is checked
and the upper limit set.
I see a duplication here, maybe better just remove
the upper limit and let user space to deal with that.

bye,

-- 

piergiorgio
