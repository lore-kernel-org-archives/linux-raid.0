From: Mike Hartman <mike@hartmanipulation.com>
Subject: Re: How to initialize "composite" RAID
Date: Fri, 10 Sep 2010 18:33:24 -0400
Message-ID: <AANLkTikinD8D4B_iagGBZ1gJRyeR5qQSwqs=MbZL--Qm@mail.gmail.com>
References: <AANLkTim9TnyTGMWnRr65SrmJDrLN=Maua_QnVLLDerwS@mail.gmail.com>
	<20100910222814.CB50615242D@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100910222814.CB50615242D@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Sep 10, 2010 at 6:28 PM, Wolfgang Denk <wd@denx.de> wrote:
> Dear Mike Hartman,
>
> In message <AANLkTim9TnyTGMWnRr65SrmJDrLN=3DMaua_QnVLLDerwS@mail.gmai=
l.com> you wrote:
>> This is unrelated to my other RAID thread, but I discovered this iss=
ue
>> when I was forced to hard restart due to the other one.
>>
>> My main raid (md0) is a RAID 5 composite that looks like this:
>>
>> - partition on hard drive A (1.5TB)
>> - partition on hard drive B (1.5TB)
>> - partition on hard drive C (1.5TB)
>> - partition on RAID 1 (md1) (1.5TB)
>
> I guess this is a typo and you mean RAID 0 ?
>
>> md1 is a RAID 0 used to combine two 750GB drives I already had so th=
at
>
> ...as used here?
>

Definitely, sorry about that.

>> Detecting md0. Can't start md0 because it's missing a component (md1=
)
>> and thus wouldn't be in a clean state.
>> Detecting md1. md1 started.
>> Then I use mdadm to stop md0 and restart it (mdadm --assemble md0),
>> which works fine at that point because md1 is up.
>
> Did you try changing your configurations uch that md0 is the RAID 0
> and md1 is the RAID 5 array?
>

That's the kind of simple solution I had in mind, I just have no idea
how to do it. The arrays are already created and I don't have enough
space to back up all the data elsewhere (I know - *cringe*). Is there
a way to do that swap "in place"?

I created everything by following the current directions in the Linux
RAID wiki and I didn't see anything there about specifying the device
name or anything like that.

> Best regards,
>
> Wolfgang Denk
>
> --
> DENX Software Engineering GmbH, =A0 =A0 MD: Wolfgang Denk & Detlev Zu=
ndel
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
> If today is the first day of the rest of your life, what the hell was
> yesterday?
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
