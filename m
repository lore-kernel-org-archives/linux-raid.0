From: Keld Simonsen <keld@keldix.com>
Subject: Re: messed up changing chunk size
Date: Mon, 19 Jul 2010 21:02:46 +0200
Message-ID: <20100719190246.GA11519@rap.rap.dk>
References: <4C439D19.4070906@gmail.com>
 <20100719095351.4536a252@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100719095351.4536a252@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Konstantin Svist <fry.kun@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jul 19, 2010 at 09:53:51AM +0600, Roman Mamedov wrote:
> On Sun, 18 Jul 2010 17:32:25 -0700
> Konstantin Svist <fry.kun@gmail.com> wrote:
> 
> > I looked around and found that chunk size 
> > of 512 should work better.
> 
> Not true, at least with RAID5/6 a chunk size of 64K performs faster, see
> http://louwrentius.blogspot.com/2010/05/raid-level-and-chunk-size-benchmarks.html
> http://alephnull.com/benchmarks/sata2009/chunksize.html

Thanks for these benchmarks, I added them to our benchmarks page
on the wiki. 

It seems odd to me to use sata controllers on a 32-bit PCI bus,
this should limit performance to about 130 MB/s - which is also seen tin the graphs.
I think people would be better off using the on-board SATA controller, this would
give normally something like 4 SATA ports connected to the southbridge, which
normally is much faster than a 32-bit PCI bus, and also faster than many
PCI-E busses.  So I think using all the on-board SATA ports first, and the
using the SATA ports on a bus-connceted controller would give better
performance.

In the louwrentius page, I miss info on which layout of RAID10 that is used.
The 3 layouts (near, far, offset) has very different characteristics.

best regards
keld
