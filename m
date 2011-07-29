From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID 1 using SSD and 2 HDD
Date: Fri, 29 Jul 2011 12:51:29 -0300
Message-ID: <CABYL=TohTY1O1T-S0xoC+PMqX5PnTMt9-gi+3gU-t=HyMyvaqw@mail.gmail.com>
References: <4E25C9BA.1060401@dodtsair.com>
	<CABYL=TppzPDszVp3cr0DnuVDAg3Hjq2dvZyP0CYEz2x3H2ZjZQ@mail.gmail.com>
	<4E31AB58.3030206@redhat.com>
	<CABYL=To6GFBwsHi_2y6Rzgvr3LbP2Z9hUN8QjYP5Wf+vJtKsXw@mail.gmail.com>
	<4E32B5FE.6050001@redhat.com>
	<j0uhk8$k9a$1@dough.gmane.org>
	<4E32D219.503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E32D219.503@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

about ssd/hdd
ssd is better for unaligned reads/writes (.1ms access time)
the problem is...
we don't have a 'math model' to simulate and select the best disk to se=
nd read
it's a bit difficult, and maybe we won't have one since we have many
kind of devices (nbd, ssd, hd, ssd+hd, sd cards, etc)
i think the only good improvement is allow better unaligned read to
ssd, and aligned reads to hdd
i tested some benchmarks ago and a better tunned read balance
algorithm can only allow 1% less time to stop benchmark (speed)
maybe flashcache and bcache can give more 'speed' i didn't tested

2011/7/29 Doug Ledford <dledford@redhat.com>:
> On 07/29/2011 10:55 AM, David Brown wrote:
>>
>> One thing has occurred to me while reading this thread - it seems to=
 be
>> an assumption here that SSD's are faster than HD's. In one area - ac=
cess
>> times - SSD's are very much faster. But when transferring bulk data,
>> they are not necessarily faster.
>
> Not necessarily, no. =A0But, if you do like I did and pick your SSD c=
arefully,
> they are. =A0I specifically chose the one I did because it was SATA-I=
II with a
> 6MB/s link speed and it was rated for 400+MByte/s reads and 210MByte/=
s
> writes. =A0Here's the link:
>
> http://www.newegg.com/Product/Product.aspx?Item=3DN82E16820233154
>
> There are even faster ones out there now.
>
> But, I was worried about the drive wearing out under the frequent che=
ckouts,
> builds, etc. so hence the reason I have two hard drives backing it up=
=2E =A0When
> it does wear out, I'll put a new one in, add it to the array, wait fo=
r
> resync, all done.
>
>> Certainly a pair of good hard disks in
>> RAID10,far will stream reads and writes with a similar throughput to
>> many SSD's. An ideal situation is therefore that small reads will co=
me
>> from the SSD, but that bulk reads could come from any disk that is
>> currently idle. Enabling "write-behind" on the hard disks would stil=
l be
>> a big gain on the write latency.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
