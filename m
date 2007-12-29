From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: 2.6.24-rc6 reproducible raid5 hang
Date: Sat, 29 Dec 2007 13:47:37 -0700
Message-ID: <e9c3a7c20712291247u7d5f6b76gf44a1770f5cdc2cf@mail.gmail.com>
References: <alpine.DEB.0.999999.0712270845150.5207@twinlark.arctic.org>
	 <alpine.DEB.0.999999.0712270938160.5207@twinlark.arctic.org>
	 <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712290842530.21114@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Dec 29, 2007 9:48 AM, dean gaudet <dean@arctic.org> wrote:
> hmm bummer, i'm doing another test (rsync 3.5M inodes from another box) on
> the same 64k chunk array and had raised the stripe_cache_size to 1024...
> and got a hang.  this time i grabbed stripe_cache_active before bumping
> the size again -- it was only 905 active.  as i recall the bug we were
> debugging a year+ ago the active was at the size when it would hang.  so
> this is probably something new.

I believe I am seeing the same issue and am trying to track down
whether XFS is doing something unexpected, i.e. I have not been able
to reproduce the problem with EXT3.  MD tries to increase throughput
by letting some stripe work build up in batches.  It looks like every
time your system has hung it has been in the 'inactive_blocked' state
i.e. > 3/4 of stripes active.  This state should automatically
clear...

>
> anyhow raising it to 2048 got it unstuck, but i'm guessing i'll be able to
> hit that limit too if i try harder :)

Once you hang if 'stripe_cache_size' is increased such that
stripe_cache_active < 3/4 * stripe_cache_size things will start
flowing again.

>
> btw what units are stripe_cache_size/active in?  is the memory consumed
> equal to (chunk_size * raid_disks * stripe_cache_size) or (chunk_size *
> raid_disks * stripe_cache_active)?
>

memory_consumed = PAGE_SIZE * raid_disks * stripe_cache_size

>
> -dean
>

--
Dan
