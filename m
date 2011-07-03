From: John Obaterspok <john.obaterspok@gmail.com>
Subject: Re: Recommended sw raid setup
Date: Sun, 3 Jul 2011 21:14:53 +0200
Message-ID: <CAOscVdKw3UM_dDzac06AE0dwuyUb4GpL29XTWS_HKa1_o9seZQ@mail.gmail.com>
References: <BANLkTinbBu6zX-6s2NYH5BQvnaJZJYt_BA@mail.gmail.com>
	<BANLkTinghqiT4QbBb--X7Eh_RRWnRg_0RQ@mail.gmail.com>
	<CACJz6Qv=u0-66hwOEg5AeZ2rWuw2OE10ozUKEQGTbuGn0_fgGg@mail.gmail.com>
	<BANLkTing8Ei+najZAFXN_ib0LRmQfS8e9Q@mail.gmail.com>
	<iuq8re$kag$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iuq8re$kag$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: David Brown <david.brown@hesbynett.no>
List-Id: linux-raid.ids

Hi all,

Thanks for all good answers!

Today I got all my family data spread in hux-flux between medicenter,
laptops, external disks - no redundancy what so ever.
I would really like to have a backup solution too, but how do I backup
6 TB in a fasion that makes me do it more than the first 5 times?

=46irst I thought about using btrfs with snapshots on the RAID5 as a
substitute for backups, but that might not be worth it in the sense
that it doesn't give me much more safety?

--john

2011/7/3 David Brown <david.brown@hesbynett.no>:
> On 02/07/11 23:17, Simon Matthews wrote:
>>
>> I thought that I had read the TLER was not useful for mdraid, so tha=
t
>> enterprise drives were not really advised for mdraid. Am I wrong abo=
ut
>> this?
>>
>> Also, for the original question: for a home system, do you really ne=
ed
>> the uptime =A0that RAID provides? I suspect not -- in that case, put
>> your money into backups, not RAID.
>>
>
> If it's a choice of good backups /or/ raid, go for the backups every =
time.
> =A0But if you have the money and space for both, then do both. =A0Rai=
d is not
> just about uptime - it is also about avoiding the effort and inconven=
ience
> of rebuilding or reinstalling.
>
> mvh.,
>
> David
>
>
>> Simon
>>
>> On Sat, Jul 2, 2011 at 12:45 PM, Drew<drew.kay@gmail.com> =A0wrote:
>>>
>>> Hi John,
>>>
>>> Personally I think you'd be fine with consumer grade drives. Put th=
em
>>> in a RAID-5 array and you should be set.
>>>
>>> The high end consumer& =A0enterprise stuff w/ TLER and the like is =
only
>>> really needed if you put a lot of demand on the disks, running virt=
ual
>>> machines for example. A basic file server for home use won't stress
>>> the drives enough to need the more expensive ones.
>>>
>>>
>>> -Drew
>>>
>>> On 07/02/2011, John Obaterspok<john.obaterspok@gmail.com> =A0wrote:
>>>>
>>>> Hi,
>>>>
>>>> I've going to setup a _home_ file server to store all photos& =A0f=
amily
>>>> videos, work related material, DNLA streaming and more.
>>>>
>>>> The server will be set to suspend when not in use for an hour or s=
o.
>>>>
>>>> I've been thinking about buying 3 x 3 TB SATA disks and put these =
in
>>>> software RAID5 (except for a smaller boot partition on all three d=
isks
>>>> which will be RAID1).
>>>>
>>>> Any recommendation for what SATA drives to get? Should I get
>>>> enterprise drives that support TLER (or alike), or will the greene=
r
>>>> low cost drives be enough, is there something in between?
>>>>
>>>> Is it better to buy 4 low cost drives in RAID1 or 3 enterprise dri=
ves in
>>>> RAID5?
>>>>
>>>> Please help, I'm completely lost!
>>>>
>>>> --john
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>> --
>>> Sent from my mobile device
>>>
>>> Drew
>>>
>>> "Nothing in life is to be feared. It is only to be understood."
>>> --Marie Curie
>>>
>>> "This started out as a hobby and spun horribly out of control."
>>> -Unknown
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
