From: Milan Broz <gmazyland@gmail.com>
Subject: Re: some general questions on RAID
Date: Sun, 07 Jul 2013 20:50:11 +0200
Message-ID: <51D9B863.9010509@gmail.com>
References: <1372962602.8716.56.camel@heisenberg.scientia.net>  <51D5F22C.70007@turmel.org>  <51D9A7CF.6000700@gmail.com> <1373220112.5246.20.camel@fermat.scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1373220112.5246.20.camel@fermat.scientia.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/07/2013 08:01 PM, Christoph Anton Mitterer wrote:
> Hi Milan.
> 
> Thanks for your answers :)
> 
> On Sun, 2013-07-07 at 19:39 +0200, Milan Broz wrote:
>> dmcrypt keeps IO running on the CPU core which submitted it.
>>
>> So if you have multiple IOs submitted in parallel from *different* CPUs,
>> they are processed in parallel.
>>
>> If you have MD over dmcrypt, this can cause problem that MD sumbits all IOs
>> with the same cpu context and dmcrypt cannot run it in parallel.
> Interesting to know :)
> I will ask Arno over at the dm-crypt list to at this to the FAQ.

Yes, but for FAQ we need to cover even old kernels dmcrypt behavior.
(I had some document describing it somewhere.)

> 
> I'd guess there are no further black magical issues one should expect
> when mixing MD and/or dmcrypt with LVM (especially when contiguous
> allocation is used)... and even less expectable when using partitions
> (should be just offsetting)?!

The only problem is usually alignment - but all components now
supports automatic alignment setting using device topology so you should
not see this anymore. (For LUKS is it trivial, LVM is more complex
but should align to MD chunk/stripe properly as well.)


>> (Please note, this applies for kernel with patch above and later,
>> previously it was different. There were a lot of discussions about it,
>> some other patches which were never applied to mainline etc, see dmcrypt
>> and dm-devel list archive for more info...)
> IIRC, than these included discussions about paralleling IO sent from one
> CPU context, right?

I spent many hours testing this and it never convinced me that it is
generally better than existing mode.

> That's perhaps a bit off-topic now,... but given that stacking dmcrypt
> with MD seems to be done by many people I guess it's not totally
> off-topic, so...

Stacking dmcrypt over MD is very common and works well (usually)
even for high speed arrays (with AES-NI use).

(And if you connect some super-speed SSD or RAID array to old CPU
and encryption speed is bottleneck you can try to use faster cipher
"cryptsetup benchmark" should help.)


> Are there any plans for that (paralleling IO from one core)? Which
> should make it (at least performance wise) okay again do but dmcrypt
> below MD (not that I'd consider that much useful, personally).

TBH I have no idea, I no longer work for Red Hat (which maintains DM).
My response to these patches is still the same, see
http://permalink.gmane.org/gmane.linux.kernel/1464414

 
>> Block layer (including transparent mappings like dmcrypt) can
>> reorder requests. It is FS responsibility to handle ordering (if it is
>> important) though flush requests.
> Interesting... but I guess the main filesystems (ext*, xfs, btrfs, jfs)
> do just right with any combinations of MD/LVM/dmcrypt?

Yes.

Milan

