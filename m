From: "Cal Leeming [Simplicity Media Ltd]"
	<cal.leeming@simplicitymedialtd.co.uk>
Subject: Re: RAID6 check found different events, how should I proceed?
Date: Sat, 6 Aug 2011 18:09:04 +0100
Message-ID: <CALvtuFTuuLFXpc53j4aMUsQOL2Y=ZKhbYkD-gkJ0ky8mdOYb2Q@mail.gmail.com>
References: <CADNH=7Eiqx0wCFypxqy-DSKWmr62L83MpP+V8XzjMEWJ3NE0yw@mail.gmail.com>
	<CADNH=7FBkx5HgWKiEzL_sNZvbjjTMbS23wOYXyrmPETCRbVwOw@mail.gmail.com>
	<CALvtuFTKBRtco1VFw9xv6x3qsLx+rdJg2wL8E9+1g3LQf=Xkuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALvtuFTKBRtco1VFw9xv6x3qsLx+rdJg2wL8E9+1g3LQf=Xkuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Can't offer any advice on this issue, but would be very interested to
hear the debrief once the situation is resolved.

On Sat, Aug 6, 2011 at 6:08 PM, Cal Leeming [Simplicity Media Ltd]
<cal.leeming@simplicitymedialtd.co.uk> wrote:
>
> Can't offer any advice on this issue, but would be very interested to=
 hear the debrief once the situation is resolved.
> On Sat, Aug 6, 2011 at 5:02 PM, Mathias Bur=E9n <mathias.buren@gmail.=
com> wrote:
>>
>> On 6 August 2011 14:23, Mathias Bur=E9n <mathias.buren@gmail.com> wr=
ote:
>> > My RAID6 is currently degraded with one HDD (panic mail on the lis=
t),
>> > and my weekly cron job kicked in doing the RAID6 check action. Thi=
s is
>> > the result:
>> >
>> > DEV =A0 =A0 EVENTS =A0REALL =A0 PEND =A0 =A0UNCORR =A0CRC =A0 =A0 =
RAW =A0 =A0 ZONE =A0 =A0END
>> > sdb1 =A0 =A06239487 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 2 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
>> > sdc1 =A0 =A06239487 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
>> > sdd1 =A0 =A06239487 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
>> > sde1 =A0 =A06239487 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
>> > sdf1 =A0 =A06239490 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 49 =A0 =A0 =A0=
 =A0 =A0 =A0 =A06
>> > sdg1 =A0 =A06239491 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 0
>> > sdh1 =A0 =A0(missing, on RMA trip)
>> >
>> (snip)
>> > * Should I run a repair?
>> > * Chould I run a check again, to see if the event count changes?
>> > * Is it likely I've 2 more bad harddrives that will die soon?
>> > * Is it wise to run another smartctl -t long on all devices?
>> >
>> > Thanks,
>> > Mathias
>> >
>>
>> A followup;
>>
>> I ran smartctl -t long on all devices, and they all passed, SMART is
>> fine. The number of events is also the same for all HDDs now:
>>
>> DEV =A0 =A0 EVENTS =A0REALL =A0 PEND =A0 =A0UNCORR =A0CRC =A0 =A0 RA=
W =A0 =A0 ZONE =A0 =A0END
>> sdb1 =A0 =A06244415 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 2 =A0 =
=A0 =A0 0 =A0 =A0 =A0 0
>> sdc1 =A0 =A06244415 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =
=A0 =A0 0 =A0 =A0 =A0 0
>> sdd1 =A0 =A06244415 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =
=A0 =A0 0 =A0 =A0 =A0 0
>> sde1 =A0 =A06244415 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =
=A0 =A0 0 =A0 =A0 =A0 0
>> sdf1 =A0 =A06244415 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =
=A0 =A0 49 =A0 =A0 =A06
>> sdg1 =A0 =A06244415 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =A0 =A0 0 =A0 =
=A0 =A0 0 =A0 =A0 =A0 0
>> sdh1
>>
>> This is without me running repair or anything like that.
>>
>> Mathias
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
