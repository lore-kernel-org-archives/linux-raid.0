From: Neil Brown <neilb@suse.de>
Subject: Re: Kernel 2.6.17 and RAID5 Grow Problem (critical section backup)
Date: Sat, 8 Jul 2006 08:00:55 +1000
Message-ID: <17582.55703.209583.446356@cse.unsw.edu.au>
References: <Pine.LNX.4.64.0607070830450.2648@p34.internal.lan>
	<Pine.LNX.4.64.0607070845280.2648@p34.internal.lan>
	<Pine.LNX.4.64.0607070849140.3010@p34.internal.lan>
	<Pine.LNX.4.64.0607071037190.5153@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Friday July 7
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday July 7, jpiszcz@lucidpixels.com wrote:
> >> 
> >> Jul  7 08:44:59 p34 kernel: [4295845.933000] raid5: reshape: not enough 
> >> stripes.  Needed 512
> >> Jul  7 08:44:59 p34 kernel: [4295845.962000] md: couldn't update array 
> >> info. -28
> >> 
> >> So the RAID5 reshape only works if you use a 128kb or smaller chunk size?
> >> 
> 
> Neil,
> 
> Any comments?
> 

Yes.   This is something I need to fix in the next mdadm.
You need to tell md/raid5 to increase the size of the stripe cache
before the grow can proceed.  You can do this with

  echo 600 > /sys/block/md3/md/stripe_cache_size

Then the --grow should work.  The next mdadm will do this for you.

NeilBrown

