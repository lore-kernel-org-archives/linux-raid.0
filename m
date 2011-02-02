From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID 5 - One drive dropped while replacing another
Date: Wed, 2 Feb 2011 14:29:35 +0000
Message-ID: <AANLkTikpT3yCLkoz-5QaQ0O6QDHAAMqcO9D0SnB-Pt0m@mail.gmail.com>
References: <AANLkTinXTYds442gPrs9a9vKtWTo4OcDHDEzvO0njvyv@mail.gmail.com>
	<AANLkTikSjLhoUM5f2ibqCUmo8XF-tsrhxZ7oieg08dtD@mail.gmail.com>
	<20110202043605.593f0c5c@natsu>
	<AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimJC_e8=BmGj7Th_LLc=wnoNj8tRovAgTR=mmQ7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com
Cc: Roman Mamedov <rm@romanrm.ru>, Bryan Wintermute <bryanwintermute@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2 February 2011 14:21,  <hansbkk@gmail.com> wrote:
> On Wed, Feb 2, 2011 at 6:36 AM, Roman Mamedov <rm@romanrm.ru> wrote:
>>
>>> I have a RAID5 setup with 15 drives.
>>
>> Looks like you got the problem you were so desperately asking for, w=
ith this
>> crazy setup. :(
>
> Please give some more details as to what's so crazy about this.
>
> I would think RAID6 would have made more sense, possibly with an
> additional spare if these are large drives (over a few hundred GB?)
>
> Or is there an upper limit as to the number of drives that's advisabl=
e
> for any array?
>
> If so, then what do people reckon a reasonable limit should be for a
> RAID6 made up of 2TB drives?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

With 15 drives, where only 1 can fail (RAID5) without data loss.. it's
a quite high risk that 2 (or more) drives will fail within a short
period of time. If you have less drives, this chance decreases. For
large amount of drives I recommend RAID10 personally (or RAID1+0,
whichever you prefer).

RAID6 + 1 hot spare is also nice, and cheaper. (for ~10 drives)

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
