From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: recommendations for stripe/chunk size
Date: Thu, 7 Feb 2008 01:31:16 +0100
Message-ID: <20080207003116.GA23341@rap.rap.dk>
References: <47AA08E7.5000801@tmr.com> <20080206202536.3316124D1D@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080206202536.3316124D1D@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 06, 2008 at 09:25:36PM +0100, Wolfgang Denk wrote:
> In message <47AA08E7.5000801@tmr.com> you wrote:
> >
> > > I actually  think the kernel should operate with block sizes
> > > like this and not wth 4 kiB blocks. It is the readahead and the elevator
> > > algorithms that save us from randomly reading 4 kb a time.
> > >
> > >   
> > Exactly, and nothing save a R-A-RW cycle if the write is a partial chunk.
> 
> Indeed kernel page size is an important factor in such optimizations.
> But you have to keep in mind that this is mostly efficient for (very)
> large strictly sequential I/O operations only -  actual  file  system
> traffic may be *very* different.
> 
> We implemented the option to select kernel page sizes of  4,  16,  64
> and  256  kB for some PowerPC systems (440SPe, to be precise). A nice
> graphics of the effect can be found here:
> 
> https://www.amcc.com/MyAMCC/retrieveDocument/PowerPC/440SPe/RAIDinLinux_PB_0529a.pdf

Yes, that is also what I would expect, for sequential reads.
Random writes of small data blocks, kind of what is done in bug data
bases, should show another picture as others also have described.

If you look at a single disk, would you get improved performance with
the asyncroneous IO?

I am a bit puzzled about my SATA-II performance: nominally I could get
300 MB/s on SATA-II, but I only get about 80 MB/s. Why is that?
I thought it was because of latency with syncroneous reads.
Ie, when a chunk is read, yo need to complete the IO operation, and then
issue an new one. In the meantime while the CPU is doing these
calculations, te disk has spun a little, and to get the next data chunk,
we need to wait for the disk to spin around to have the head positioned 
over the right data pace on the disk surface. Is that so? Or does the
controller take care of this, reading the rest of the not-yet-requested
track into a buffer, which then can be delivered next time. Modern disks
often have buffers of about 8 or 16 MB. I wonder why they don't have
bigger buffers.

Anyway, why does a SATA-II drive not deliver something like 300 MB/s?

best regards
keld
