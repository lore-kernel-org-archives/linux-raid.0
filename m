From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID5
Date: Fri, 23 Apr 2010 13:57:13 -0700
Message-ID: <o2u4877c76c1004231357x649c5979ncd3e10ea8e6060d1@mail.gmail.com>
References: <s2q6b16fb4c1004182046x5464351m861ccaf9850f33df@mail.gmail.com>
	 <j2k4877c76c1004182121w3edcf996x2ee8ee0eca398985@mail.gmail.com>
	 <4BCEFE66.6010607@tmr.com>
	 <l2g4877c76c1004211243n6dfa55pfee322db20ba6f08@mail.gmail.com>
	 <4BD1AE0C.2040003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BD1AE0C.2040003@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Bill Davidsen <davidsen@tmr.com>, Kaushal Shriyan <kaushalshriyan@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 23, 2010 at 7:26 AM, Michael Tokarev <mjt@tls.msk.ru> wrote=
:
> Michael Evans wrote:
>> On Wed, Apr 21, 2010 at 6:32 AM, Bill Davidsen <davidsen@tmr.com> wr=
ote:
> []
>>> I have some recent experience with this gained the hard way, by loo=
king for
>>> a problem rather than curiousity. My experience with LVM on RAID is=
 that, at
>>> least for RAID-5, write performance sucks. I created two partitions=
 on each
>>> of three drives, and two raid-5 arrays using those partitions. Same=
 block
>>> size, same tuning for stripe-cache, etc. I dropped an ext4 on on ar=
ray, and
>>> LVM on the other, put ext4 on the LVM drive, and copied 500GB to ea=
ch. LVM
>>> had a 50% performance penalty, took twice as long. Repeated with fo=
ur drives
>>> (all I could spare) and found that the speed right on an array was =
roughly
>>> 3x slower with LVM.
>>>
>> This issues sounds very likely to be write barrier related. =A0Were =
you
>> using an external journal on a write-barrier honoring device?
>
> This is most likely due to read-modify-write cycle which is present o=
n
> lvm-on-raid[456] if the number of data drives is not a power of two.
> LVM requires the block size to be a power of two, so if you can't fit
> some number of LVM blocks on whole raid stripe size your write speed
> is expected to be ~3 times worse...
>
> Even creating partitions on such raid array is difficult.
>
> 'Hwell.
>
> Unfortunately very few people understand this.
>
> As of write barriers, it looks like either they already work
> (in 2.6.33) or will be (in 2.6.34) for whole raid5-lvm stack.
>
> /mjt
>

Even when write barriers are supported what will a typical transaction
look like?

Journal Flush
Data Flush
Journal Flush (maybe)

If the operations are small (which the journal ops should be) then
you're forced to wait for a read, and then make a write barrier after
it.

J.read(2 drives)
J.write(2 drives) -- Barrier
D.read(2 drives)
D.write(2 drives) -- Barrier
Then maybe
J.read(2 drives) (Hopefully cached, but could cross in to a new stripe.=
=2E.)
J.write(2 drives) -- Barrier

This is why an external journal on another device is a great idea.
Unfortunately what I really want is something like 512mb of battery
backed ram (at any vaguely modern speed) to split up as a journal
devices, but now everyone is selling SDDs which are broken for such
needs.  Any ram drive units still being sold seem to be more along
data-center grade sizes.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
