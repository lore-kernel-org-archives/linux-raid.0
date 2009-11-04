From: mark delfman <markdelfman@googlemail.com>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Wed, 4 Nov 2009 22:08:06 +0000
Message-ID: <66781b10911041408ia450d18h7046fa2e0a8e18f8@mail.gmail.com>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>
	 <19177.14609.138378.581065@notabene.brown>
	 <4AE94D95.4060303@shiftmail.org>
	 <66781b10910310351x7bb721c4mfba765fe9789cd7b@mail.gmail.com>
	 <19183.47226.529417.743975@notabene.brown>
	 <66781b10911030411y5bb32610lec72966f7cc09df@mail.gmail.com>
	 <66781b10911040915t11a7f0c2td6a9ed5672935efb@mail.gmail.com>
	 <4AF1D089.5080901@maine.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF1D089.5080901@maine.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Cousins <steve.cousins@maine.edu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes write cache is on the drives and the comparisons are all with the
same hardware... apples for apples and no pears ;)

Write is often faster (in my mind) simply because you can use a lot of
write cache (in system)... whilst reads reads you are limited to what
the drives can pull off.

I also guess that the FS's - mainly ext2 it seems is more effecient at
implementing a read cache than a raw device, hence the slight
performance increase.... but i just guessing to be honest




On Wed, Nov 4, 2009 at 7:05 PM, Steve Cousins <steve.cousins@maine.edu>=
 wrote:
> mark delfman wrote:
>>
>> Some FS comparisons attached in pdf
>>
>> not sure what to make of them as yet, but worth posting
>>
>
> I'm not sure either. Two things jump out.
>
> =A0 1. Why is raw RAID0 read performance slower than write performanc=
e
> =A0 2. Why is read performance with some file systems at or above raw=
 read
> performance?
>
> For number one, does this indicate that write caching is actually On =
on the
> drives?
>
> Are all tests truly apples-apples comparisons or were there other fac=
tors in
> there that aren't listed in the charts?
>
> I guess these issues might not have a lot to do with your main questi=
on but
> you might want to double-check the tests and numbers.
>
> Steve
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
