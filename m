From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Wed, 22 Jan 2014 01:55:34 -0600
Message-ID: <52DF7976.6070808@hardwarefreak.com>
References: <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140121163755.GG10140@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/21/2014 10:37 AM, Marc MERLIN wrote:
> On Mon, Jan 20, 2014 at 11:35:40PM -0800, Marc MERLIN wrote:
>> Howdy,
>>
>> I'm setting up a new array with 5 4TB drives for which I'll use dmcrypt.
>>
>> Question #1:
>> Is it better to dmcrypt the 5 drives and then make a raid5 on top, or the opposite
>> (raid5 first, and then dmcrypt)

For maximum throughput and to avoid hitting a ceiling with one thread on
one core, using one dmcrypt thread per physical device is a way to
achieve this.

>> I used:
>> cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64 /dev/sd[mnopq]1

Changing the key size or the encryption method may decrease latency a
bit, but likely not enough.

> I should have said that this is seemingly a stupid question since obviously
> if you encrypt each drive separately, you're going through the encryption
> layer 5 times during rebuilds instead of just once.

Each dmcrypt thread is handling 1/5th of the IOs.  The low init
throughput isn't caused by using 5 threads.  One thread would likely do
no better.

> However in my case, I'm not CPU-bound, so that didn't seem to be an issue
> and I was more curious to know if the dmcrypt and dmraid5 layers stacked the
> same regardless of which one was on top and which one at the bottom.

You are not CPU bound, nor hardware bandwidth bound.  You are latency
bound, just like every dmcrypt user.  dmcrypt adds a non trivial amount
of latency to every IO.  Latency with serial IO equals low throughput.

Experiment with these things to increase throughput.  If you're using
the CFQ elevator switch to deadline.  Try smaller md chunk sizes, key
lengths, different ciphers, etc.  Turn off automatic CPU frequency
scaling.  I've read reports of encryption causing the frequency to drop
instead of increase.

In general, to increase serial IO throughput on a high latency path one
must:

1.  Issue lots of IOs asynchronously
2.  And/or issue lots of IOs in parallel

Or both.  AFAIK both of these require code rewrites for md maintenance
operations.

Once in production, if your application workloads do 1 or 2 above then
you may see higher throughput than the 18MB/s you see with the init.  If
your workloads are serial maybe not much more.

Common sense says that encrypting 16TB of storage at the block level,
using software libraries and optimized CPU instructions, is not a smart
thing to do.  Not if one desires decent performance, and especially if
one doesn't need all 16TB encrypted.

If you in fact don't need all 16TB encrypted, and I'd argue very few do,
especially John and Jane Doe, then tear this down, build a regular
array, and maintain an encrypted directory or few.

If you actually *need* to encrypt all 16TB at the block level, and
require decent performance, you need to acquire a dedicated crypto
board.  One board will cost more than your complete server.  The cost of
such devices should be a strong clue as to who does and does not need to
encrypt their entire storage.

-- 
Stan


