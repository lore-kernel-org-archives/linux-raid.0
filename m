From: "Majed B." <majedb@gmail.com>
Subject: Re: Spurious HD convictions
Date: Mon, 14 Dec 2009 23:06:31 +0300
Message-ID: <70ed7c3e0912141206p65005aeegf663183c946dec7b@mail.gmail.com>
References: <200912122144.53709.lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200912122144.53709.lrhorer@satx.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: "lrhorer@satx.rr.com" <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Leslie,

I was wondering if you were able to stop the weird behavior with your d=
isks.

On Sun, Dec 13, 2009 at 6:44 AM, lrhorer@satx.rr.com
<lrhorer@satx.rr.com> wrote:
> Hmm. =C2=A0I don't see how it could be either the PS or the PMs, sinc=
e the drives
> were moved to a new enclosure when the problem started happening, yet=
 the
> problem persists. =C2=A0The new chassis has all new PMs and of course=
 a new PS,
> and the problem is happening across multiple PMs. =C2=A0In addition, =
if NCQ is the
> problem, why has it just started happening? =C2=A0This system has bee=
n up and
> running for the better part of a year. =C2=A0Regardless, I have disab=
led NCQ by
> executing `echo 1 > /sys/block/sd[a-g]/device/queue_depth`, and I am
> attempting a repair action again. =C2=A0We'll see how it goes.
>
>> Hi Leslie,
>>
>> According to some of the links here:
>> http://www.google.com/search?hl=3Den&q=3Dfailed+to+read+SCR+1+(Emask=
%3D0x40)
>>
>> It seem to be either the Power Supply Unit (PSU) or the Port Multipl=
ier
>> (PM).
>>
>> A quick workaround seem to be disabling NCQ on all affected devices.
>>
>> On Sun, Dec 13, 2009 at 5:02 AM, lrhorer@satx.rr.com
>> <lrhorer@satx.rr.com> wrote:
>> >
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0What's happening here? =C2=A0Suddenly, =
my backup server is suffering
>> apparently
>> > spurious hard drive convictions. =C2=A0The server is running RAID5=
 on 7 disks
>> > under md. =C2=A0It has been running well for months, but suddenly =
it has
>> started
>> > kicking drives from the array when under moderately heavy read or =
write
>> > loads. =C2=A0The thing is, it isn't convicting any particular driv=
e
>> repeatedly,
>> > and the drives are not showing any errors under SMART. =C2=A0This =
is a PM
>> system,
>> > and I have tried changing the drive adapters, changing the PMs, ch=
anging
>> > cables, moving the drives around, and moving them out of the CPU
>> enclosure to
>> > a new external chassis. =C2=A0The convictions are not occurring on=
 any one
>> > channel, over any one particular PM, or over any particular cable.
>> =C2=A0Since
>> > this started happening, I have been unable to get all the way thro=
ugh a
>> > resync before the array dumps at least one of the drives. =C2=A0He=
re is a
>> sample
>> > from the kernel log during one of the convictions:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
