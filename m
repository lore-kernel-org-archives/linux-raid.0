From: David Brown <david@westcontrol.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 04 Feb 2011 15:17:51 +0100
Message-ID: <iih1uj$dqi$1@dough.gmane.org>
References: <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com> <iigobc$n0n$2@dough.gmane.org> <20110204135343.GC4808@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204135343.GC4808@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/02/2011 14:53, Keld J=F8rn Simonsen wrote:
> On Fri, Feb 04, 2011 at 12:34:00PM +0100, David Brown wrote:
>> On 04/02/2011 09:27, Stan Hoeppner wrote:
>>> Keld J=F8rn Simonsen put forth on 2/4/2011 1:06 AM:
>>>
>>>> Well RAID1+0 is not the best combination available. I would argue =
that
>>>> raid10,f2 is significantly better in a number of areas.
>>>
>>> I'd guess Linux software RAID would be lucky to have 1% of RAID dep=
loyments
>>> worldwide--very lucky.  The other 99%+ are HBA RAID or SAN/NAS
>>> "appliances" most
>>> often using custom embedded RTOS with the RAID code written in asse=
mbler,
>>> especially in the case of the HBAs.  For everything not Linux mdrai=
d, RAID
>>> 10
>>> (aka 1+0) is king of the hill, and has been for 15 years+
>>>
>>
>> I wonder what sort of market penetration small cheap SAN/NAS
>> "appliances" have these days, aimed at the home markets and small
>> offices.  These are almost invariably Linux md raid devices, althoug=
h
>> the user views them as an black-box appliance.
>>
>> However, though they use md raid, they typically don't support RAID1=
0,
>> RAID1+0, RAID10,f2, or anything other than RAID0, RAID1 and RAID5.
>
> I wonder why this is so. (I cannot dispute what you are saying, as I =
have
> not got any experience with any small SAN/NAS devices).
>
> Anyway, Linux NAS/SAN devices should run a kernel that should be able=
 to
> run MD raid10 and RAID 1+0 - as this has been in the Linux kernel
> for more than 5 years.
>

I think it is just a matter of simplifying the interface for the=20
expected use of the target audience.  The typical customer of such NAS=20
appliances doesn't know enough about raid to understand the detailed=20
pros and cons of different types, and is unlikely to care about small=20
performance differences.  Thus they have the options of raid0 and JBD=20
for maximal space per $, raid1 for two disks with redundancy, and raid5=
=20
for more disks with redundancy.  They don't have hot spares, raid6,=20
mixing raid levels on different partitions, etc.  Keep it simple, and=20
people can use it.

Of course, you can always access these devices directly, or with ssh,=20
and re-arrange things as you want.  It's only the web-based user=20
interface that is limited.

> For c0mpanies that sell Linux NAS/SAN devices, I would have thought t=
hat
> they would have at least one engineer following this list.
> Maybe they will not disclose themselves, but are there some of you ou=
t
> here?
>
> And what kind of support of RAID types are available on your box?
>
> And maybe the more advanced stuff is available, but only in some CLI.
> The configuration web server could be without the more advanced oprio=
ns.
> But then: why not use options that kind of doubles the performance
> compared to competitors?
>
> Are the raid 1+0 and md raid10 options available via some ssh
> or other CLI access mechanisms? I know on routers, there are
> normally a CLI interface.
>
> Furthermore, Linux has a good penetration in the server market.
> And I think most people would run servers with raids, if they do
> something serious. So Linux RAID should be more than 1 %, at least
> in the server market.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
