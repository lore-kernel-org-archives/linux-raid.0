From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Wed, 22 Jan 2014 17:17:55 -0600
Message-ID: <52E051A3.3050103@hardwarefreak.com>
References: <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140122174854.GF26014@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/22/2014 11:48 AM, Marc MERLIN wrote:
...
> If crypt is on top of raid5, it seems (and that makes sense) that no
> encryption is neded for the rebuild. However in my test I can confirm that
> the rebuild time is exactly the same. I only get 19MB/s of rebuild bandwidth
> and I think tha'ts because of the port multiplier.

Ok, now I think we're finally getting to the heart of this.  Given the
fact that you're doing full array encryption, and after reading your bio
on your website the other day, I think I've been giving you too much
credit.  So let's get back to md basics.  Have you performed any md
optimizations?  The default value of

/sys/block/mdX/md/stripe_cache_size

is 256.  This default is woefully inadequate for modern systems, and
will yield dreadfully low throughput.  To fix this execute

~$ echo 2048 > /sys/block/mdX/md/stripe_cache_size

To specifically address slow resync speed try

~$ echo 50000 > /proc/sys/dev/raid/speed_limit_min

And you also likely need to increase readahead from the default 128KB to
something like 1MB (in 512KiB units)

~$ blockdev --setra 2048 /dev/mdX

Since kernel 2.6.23 Linux does on demand readahead, so small random IO
won't trigger it.  Thus a large value here will not negatively impact
random IO.  See:  http://lwn.net/Articles/235181/

These changes should give you just a bit of a boost to resync
throughput, and streaming workloads in general.

Please test and post your results.  I don't think your problems have
anything to do with crypto.  However, after you get md running at peak
performance you then may start to see limitations in your crypto setup,
if you have chosen to switch to dmcrypt above md.

-- 
Stan
