From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: managing raid on Linux
Date: Sat, 26 Apr 2008 15:39:09 -0400
Message-ID: <481384DD.9040801@tmr.com>
References: <247041911@web.de> <480F4EF6.1000103@tmr.com> <480F5BE6.7070908@nrel.colostate.edu> <A20315AE59B5C34585629E258D76A97C1964CC@34093-C3-EVS3.exchange.rackspace.com> <20080423184722.GA4889@rap.rap.dk> <A20315AE59B5C34585629E258D76A97C19652E@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C19652E@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>, Ty! Boyack <ty@nrel.colostate.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Lethe wrote:
> -----Original Message-----
> From: Keld J=F8rn Simonsen [mailto:keld@dkuug.dk]=20
> Sent: Wednesday, April 23, 2008 1:47 PM
> To: David Lethe
> Cc: Ty! Boyack; linux-raid@vger.kernel.org
> Subject: Re: managing raid on Linux
>
> On Wed, Apr 23, 2008 at 01:17:19PM -0500, David Lethe wrote:
>  =20
>>    Well, this is the norm. While some APIs are well done, the other
>> extreme is that vendor xyz farmed out the API/drivers to another
>> company, and the hardware vendor doesn't have the resources, knowled=
ge
>> or experience to provide the information necessary to bring a 3rd-pa=
rty
>> management tool to market.   I will certainly not reveal anything ab=
out
>> the companies that did farm out the software/firmware to 3rd parties=
,
>> and will not tell you if their names were mentioned in this post.
>> Suffice to say that this is a real problem with SOME controllers tha=
t
>> people reading this post have installed in their computers.
>>
>>   - The economics of developing support for a particular controller =
is a
>> severe constraint.  Consider the reasons above, and then add simple
>> equipment costs for development/testing, and then support.  I'm not
>> going to add support for product xyz unless I know it will be
>> profitable, and even a hundred end-user requests won't begin to pay =
for
>> such an effort.
>>
>>   - I for one certainly can't keep up with all the new things coming
>> out, so we choose our battles wisely based on the market opportunity=
,
>> longevity of the controller platform, safety/robustness of the API, =
and
>> development/ongoing support expense.
>>
>> So there are the reasons why the OP can't find anything that support=
s
>> everything he has.
>>    =20
>
> David, thanks for your explanation of the current situation for makin=
g
> an =FCbermanageri for HW RAID. The prospects seem dark indeed.=20
>
>  =20
If there were an ubermanager then products could compete on only price=20
and performance. Now they can compete on ease of use as well, and that'=
s=20
not all bad for the customer. Corporations try to skimp on system=20
management (usually) and often ease of use is the differerce between=20
mediocre management and totally incompetent.

> Are there then more future in doing it the SW RAID way, as the Linux
> Kernel stuff we are discussion here on this mailing list?
>
>  =20
The advantage is in the portability, you need not spend the top dollar=20
on hardware to get quite good results.

> Are there chances that this work om Linux RAID can match or be better
> on the issues of performance, raid personality flavours and managemen=
t,
> compared to the best of the HW RAID manufacturers?=20
>
>  =20
No, not the best. The reason is that Raid-N, where N>0, writes recovery=
=20
information, either mirrors or CRCs, or similar. Software raid must pas=
s=20
this as multiple writes, opening a chance for consistency problems, and=
=20
always taking more bus bandwidth. So better than the best dedicated=20
hardware it is not, and can't be. As good as the "very good" hardware=20
solutions, yes. More flexible to expanding with whatever hardware is=20
cost effective when you need it, SW raid wins every time.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
