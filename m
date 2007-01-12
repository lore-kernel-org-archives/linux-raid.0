From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Linux Software RAID 5 Performance Optimizations: 2.6.19.1: (211MB/s
 read & 195MB/s write)
Date: Fri, 12 Jan 2007 17:01:24 +0300
Message-ID: <45A794B4.5020608@tls.msk.ru>
References: <Pine.LNX.4.64.0701111832080.3673@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0701111832080.3673@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Using 4 raptor 150s:
> 
> Without the tweaks, I get 111MB/s write and 87MB/s read.
> With the tweaks, 195MB/s write and 211MB/s read.
> 
> Using kernel 2.6.19.1.
> 
> Without the tweaks and with the tweaks:
> 
> # Stripe tests:
> echo 8192 > /sys/block/md3/md/stripe_cache_size
> 
> # DD TESTS [WRITE]
> 
> DEFAULT: (512K)
> $ dd if=/dev/zero of=10gb.no.optimizations.out bs=1M count=10240
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 96.6988 seconds, 111 MB/s
[]
> 8192K READ AHEAD
> $ dd if=10gb.16384k.stripe.out of=/dev/null bs=1M
> 10240+0 records in
> 10240+0 records out
> 10737418240 bytes (11 GB) copied, 64.9454 seconds, 165 MB/s

What exactly are you measuring?  Linear read/write, like copying one
device to another (or to /dev/null), in large chunks?

I don't think it's an interesting test.  Hint: how many times a day
you plan to perform such a copy?

(By the way, for a copy of one block device to another, try using
O_DIRECT, with two dd processes doing the copy - one reading, and
another writing - this way, you'll get best results without huge
affect on other things running on the system.  Like this:

 dd if=/dev/onedev bs=1M iflag=direct |
 dd of=/dev/twodev bs=1M oflag=direct
)

/mjt
