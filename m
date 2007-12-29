From: dean gaudet <dean@arctic.org>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Sat, 29 Dec 2007 12:58:56 -0800 (PST)
Message-ID: <alpine.DEB.0.999999.0712291248490.5207@twinlark.arctic.org>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>  <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>  <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org> <e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 29 Dec 2007, Dan Williams wrote:

> On Dec 29, 2007 9:48 AM, dean gaudet <dean@arctic.org> wrote:
> > hmm bummer, i'm doing another test (rsync 3.5M inodes from another box) on
> > the same 64k chunk array and had raised the stripe_cache_size to 1024...
> > and got a hang.  this time i grabbed stripe_cache_active before bumping
> > the size again -- it was only 905 active.  as i recall the bug we were
> > debugging a year+ ago the active was at the size when it would hang.  so
> > this is probably something new.
> 
> I believe I am seeing the same issue and am trying to track down
> whether XFS is doing something unexpected, i.e. I have not been able
> to reproduce the problem with EXT3.  MD tries to increase throughput
> by letting some stripe work build up in batches.  It looks like every
> time your system has hung it has been in the 'inactive_blocked' state
> i.e. > 3/4 of stripes active.  This state should automatically
> clear...

cool, glad you can reproduce it :)

i have a bit more data... i'm seeing the same problem on debian's 
2.6.22-3-amd64 kernel, so it's not new in 2.6.24.

i'm doing some more isolation but just grabbing kernels i have precompiled 
so far -- a 2.6.19.7 kernel doesn't show the problem, and early 
indications are a 2.6.21.7 kernel also doesn't have the problem but i'm 
giving it longer to show its head.

i'll try a stock 2.6.22 next depending on how the 2.6.21 test goes, just 
so we get the debian patches out of the way.

i was tempted to blame async api because it's newish :)  but according to 
the dmesg output it doesn't appear the 2.6.22-3-amd64 kernel used async 
API, and it still hung, so async is probably not to blame.

anyhow the test case i'm using is the dma_thrasher script i attached... it 
takes about an hour to give me confidence there's no problems so this will 
take a while.

-dean
