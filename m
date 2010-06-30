From: CoolCold <coolthecold@gmail.com>
Subject: Re: Write-intent bitmap decreases or increase performance of RAID5?
Date: Wed, 30 Jun 2010 22:31:04 +0400
Message-ID: <AANLkTimjGpkivgvIkD210lBPX0MlsTKUIkVUgnQ-oqIq@mail.gmail.com>
References: <20100629201153.GA13018@localhost>
	<20100630111854.006ec4d0@natsu>
	<alpine.DEB.1.10.1006300729150.8623@uplift.swm.pp.se>
	<20100630115927.090751dd@natsu>
	<alpine.DEB.1.10.1006300857300.8623@uplift.swm.pp.se>
	<20100630142328.6451f910@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100630142328.6451f910@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Shaochun Wang <scwang@ios.ac.cn>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

flag: direct use direct I/O for data
can be useful too

On Wed, Jun 30, 2010 at 12:23 PM, Roman Mamedov <roman@rm.pp.ru> wrote:
> On Wed, 30 Jun 2010 08:58:28 +0200 (CEST)
> Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>
>> On Wed, 30 Jun 2010, Roman Mamedov wrote:
>>
>> > This is not necessary. See the dd man page about the conv=fdatasync switch.
>> > You can even test with just 256 MB this way, and still get an extremely
>> > accurate result.
>>
>> You're right, for writing this is ok. For read tests it's important to use
>> more than ram though, to avoid doing performance testing from block cache
>> instead of from the actual drives.
>
> Yeah, though there's also an alternative way of mitigating the effect of
> the cache when testing read speed, see http://linux-mm.org/Drop_Caches
>
> --
> With respect,
> Roman
>



-- 
Best regards,
[COOLCOLD-RIPN]
