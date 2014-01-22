From: Marc MERLIN <marc@merlins.org>
Subject: Re: Very long raid5 init/rebuild times
Date: Wed, 22 Jan 2014 09:48:54 -0800
Message-ID: <20140122174854.GF26014@merlins.org>
References: <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52DF7976.6070808@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 22, 2014 at 01:55:34AM -0600, Stan Hoeppner wrote:
> >> Question #1:
> >> Is it better to dmcrypt the 5 drives and then make a raid5 on top, or the opposite
> >> (raid5 first, and then dmcrypt)
> 
> For maximum throughput and to avoid hitting a ceiling with one thread on
> one core, using one dmcrypt thread per physical device is a way to
> achieve this.
 
There is that, but at rebuild time, if dmcrypt is after raid5, the raid5
rebuild would happen without going through encryption, and hence would save
5 core's worth of encryption bandwidth, would it not (for 5 drives)

I agree that during non rebuild operation, I do get 5 cores of encryption
bandwidth insttead of 1, so if I'm willing to suck up the CPU from rebuild
time, it may be a good thing anyway.

> >> I used:
> >> cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/sd[mnopq]1
> 
> Changing the key size or the encryption method may decrease latency a
> bit, but likely not enough.

Ok, thanks.

> > I should have said that this is seemingly a stupid question since obviously
> > if you encrypt each drive separately, you're going through the encryption
> > layer 5 times during rebuilds instead of just once.
> 
> Each dmcrypt thread is handling 1/5th of the IOs.  The low init
> throughput isn't caused by using 5 threads.  One thread would likely do
> no better.

If crypt is on top of raid5, it seems (and that makes sense) that no
encryption is neded for the rebuild. However in my test I can confirm that
the rebuild time is exactly the same. I only get 19MB/s of rebuild bandwidth
and I think tha'ts because of the port multiplier.

> > However in my case, I'm not CPU-bound, so that didn't seem to be an issue
> > and I was more curious to know if the dmcrypt and dmraid5 layers stacked the
> > same regardless of which one was on top and which one at the bottom.
> 
> You are not CPU bound, nor hardware bandwidth bound.  You are latency
> bound, just like every dmcrypt user.  dmcrypt adds a non trivial amount
> of latency to every IO.  Latency with serial IO equals low throughput.

Are you sure that applies here in the rebuild time? I see no crypt thread
running.

> Experiment with these things to increase throughput.  If you're using
> the CFQ elevator switch to deadline.  Try smaller md chunk sizes, key
> lengths, different ciphers, etc.  Turn off automatic CPU frequency
> scaling.  I've read reports of encryption causing the frequency to drop
> instead of increase.

I'll check those too, they can't hurt.

> Once in production, if your application workloads do 1 or 2 above then
> you may see higher throughput than the 18MB/s you see with the init.  If
> your workloads are serial maybe not much more.
 
I expect to see more because the drives will move inside the array that is
directly connected to the SATA card without going through a PMP (with PMP
all the SATA IO is shared on a single SATA chip).

> Common sense says that encrypting 16TB of storage at the block level,
> using software libraries and optimized CPU instructions, is not a smart
> thing to do.  Not if one desires decent performance, and especially if
> one doesn't need all 16TB encrypted.

I encrypt everything now because I think it's good general hygiene, and I
don't want to think about where my drives and data end up 5 years later, or
worry if they get stolen.
Software encryption on linux has been close enough to wire speed for a
little while now, I encrypt my 500MB/s capable SSD on my laptop and barely
see slowdowns (except a bit of extra latency as you point out).

> If you in fact don't need all 16TB encrypted, and I'd argue very few do,
> especially John and Jane Doe, then tear this down, build a regular
> array, and maintain an encrypted directory or few.

Not bad advise in general.

> If you actually *need* to encrypt all 16TB at the block level, and
> require decent performance, you need to acquire a dedicated crypto
> board.  One board will cost more than your complete server.  The cost of
> such devices should be a strong clue as to who does and does not need to
> encrypt their entire storage.

I'm not actually convinced that the CPU is the bottleneck, and as pointed out 
if I put dmcrypt on top of raid5, the rebuild happens without any
encryption.
Or did I miss something?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
