From: mark delfman <markdelfman@googlemail.com>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Wed, 14 Oct 2009 20:34:38 +0100
Message-ID: <66781b10910141234h5fbf5ac3k4adc347621dbc2a1@mail.gmail.com>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com>
	 <20091013013352.GA24869@infradead.org>
	 <66781b10910130406s4119985fg5db7679a2e9fd4f2@mail.gmail.com>
	 <20091013225241.GA32197@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091013225241.GA32197@infradead.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Chris... we tried the direct DD as requested and the problem is
still there...
1.3GBsec > 325MBsec  (even more dromatic)... hopefully this helps
narrow it down?


Write > MD
linux-poly:~ # dd if=3D/dev/zero of=3D/dev/md0 oflag=3Ddirect bs=3D1M c=
ount=3D20000
20000+0 records in
20000+0 records out
20971520000 bytes (21 GB) copied, 15.7671 s, 1.3 GB/s


Write > XFS > MD
linux-poly:~ # dd if=3D/dev/zero of=3D/mnt/md0/test oflag=3Ddirect bs=3D=
1M count=3D20000
20000+0 records in
20000+0 records out
20971520000 bytes (21 GB) copied, 64.616 s, 325 MB/s



On Tue, Oct 13, 2009 at 11:52 PM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> On Tue, Oct 13, 2009 at 12:06:24PM +0100, mark delfman wrote:
>> A little more information which I ?think? seems to point at MD.....
>>
>> Creating an EXT3 FS on an MD RAID also shows a circa 50% performance=
 drop.
>> We have tried a multitude of RAID options (raid6/0 various chunks et=
c).
>>
>> Using a hardware based raid XFS / EXT3 shows no performance drop
>> (although the hardware raid is significantly slower than MD in the
>> first place)
>>
>> We are happy to keep testing and offering anything that could be
>> useful, we are just a little stuck thinking of anything else to do..=
=2E.
>
> Can you test with conv=3Ddirect added to the dd command lines? =A0If =
that
> shows the problems too it's probably writeback-related. =A0If not the
> problems must be somewhere lower in the stack.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
