From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: It is possible to put write cache on ssd?
Date: Tue, 08 Jun 2010 14:24:55 +0930
Message-ID: <1275972895.4313.51.camel@sibyl.beware.dropbear.id.au>
References: <loom.20100604T102522-67@post.gmane.org>
	 <4C0D44FC.8020908@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C0D44FC.8020908@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Mario <mgiammarco@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2010-06-07 at 15:14 -0400, Bill Davidsen wrote:
> Mario wrote:
> > [...]
> > So I ask: if I add a fast (with little size) ssd to a linux server is there a
> > way for linux md raid to use it as a cache to have safer writes and faster raid?
> >
> > Thanks in advance for interest.
> >
> Actually playing with that now. I got an Intel SATA 40GB SSD, and I am 
> trying various combinations of things to put on it. One thing which I 
> hoped would benefit was to put a f/s journal on SSD and then use the 
> option to push all through the journal (data=journal) in hopes that it 
> would then free the RAM needed for cache and thus speed operation.
> 
> Since none of that has generated the performance I hoped, 

Interesting. If its the X25-V that you have, write performance is
nothing to write home about even compared to a single hard drive, let
alone a raid. By journaling data as well (as metadata), you just add
extra write overhead, possibly even a new bottleneck. 

What happens if you journal only the metadata? The hoped for advantage
would be to avoid seeks between the areas used for the journal and the
data.

The characteristics of these SSD devices seems to be that they get
faster as they get bigger (like the chips are effectively in a kind of
raid).

> I'm now 
> looking at a kernel patch to overflow the cache in RAM into the SSD, 
> stealing code from the mmap to make some address space on the SSD.

Again, I wonder if write performance is good enough for this to pay off.
How does that compare with just using the ssd for swap and possibly
tweaking some parameters to encourage the kernel to use swap more? This
would effectively free up more ram for buffers.

>  At 
> the moment that works poorly (ok, doesn't work) and I'm going to have to 
> rethink the way I do things and probably write a whole bunch of code to 
> do it. Not sure if I want to do that, it's unlikely to be a candidate 
> for mainline unless I put a ton of time into learning the corner cases.
> 
> I also played with mirroring and write mostly, etc. Does provide a 
> general solution, at least in my tests.

Do you mean "does NOT"?


-- 
Ian Dall <ian@beware.dropbear.id.au>

