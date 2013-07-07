From: Milan Broz <gmazyland@gmail.com>
Subject: Re: some general questions on RAID
Date: Sun, 07 Jul 2013 19:39:27 +0200
Message-ID: <51D9A7CF.6000700@gmail.com>
References: <1372962602.8716.56.camel@heisenberg.scientia.net> <51D5F22C.70007@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51D5F22C.70007@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Christoph Anton Mitterer <calestyo@scientia.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/05/2013 12:07 AM, Phil Turmel wrote:
> On 07/04/2013 02:30 PM, Christoph Anton Mitterer wrote:
> 
>> 1) I plan to use dmcrypt and LUKS and had the following stacking in
>> mind:
>> physical devices -> MD -> dmcrypt -> LVM (with multiple LVs) ->
>> filesystems
>>
>> Basically I use LVM for partitioning here ;-)
>>
>> Are there any issues with that order? E.g. I've heard rumours that
>> dmcrypt on top of MD performs much worse than vice versa...
> 
> Last time I checked, dmcrypt treated barriers as no-ops, so filesystems
> that rely on barriers for integrity can be scrambled.  As such, where I
> mix LVM and dmcrypt, I do it selectively on top of each LV.

Hi,

Barriers (later replaced by flush/fua) works on dmcrypt, this is the first
commit implementing it
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=647c7db14ef9cacc4ccb3683e206b61f0de6dc2b
(dm core ensures that there is no IO processing before it submits FLUSH/FUA to dmcrypt,
so the implementation is so simple here)

All features based on flush/FUA works over dmcrypt now.

> 
> I believe dmcrypt is single-threaded, too.

Since
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/md/dm-crypt.c?id=c029772125594e31eb1a5ad9e0913724ed9891f2

dmcrypt keeps IO running on the CPU core which submitted it.

So if you have multiple IOs submitted in parallel from *different* CPUs,
they are processed in parallel.

If you have MD over dmcrypt, this can cause problem that MD sumbits all IOs
with the same cpu context and dmcrypt cannot run it in parallel.

So with new kernel do not try put *multiple* dmcrypt mappings (per device or so)
below MD RAID - it will not improve performance, it will cause exact opposite
(everything will run on one core).

(Please note, this applies for kernel with patch above and later,
previously it was different. There were a lot of discussions about it,
some other patches which were never applied to mainline etc, see dmcrypt
and dm-devel list archive for more info...)

> If either or both of those issues have been corrected, I wouldn't expect
> the layering order to matter. 

Block layer (including transparent mappings like dmcrypt) can
reorder requests. It is FS responsibility to handle ordering (if it is
important) though flush requests.

Milan

