From: Mark Knecht <markknecht@gmail.com>
Subject: Re: High mismatch count on root device - how to best handle?
Date: Sat, 30 Apr 2011 15:51:36 -0700
Message-ID: <BANLkTikBkaWsDicptHsX3dz=RW5_bL2Z7A@mail.gmail.com>
References: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>
	<BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com>
	<BANLkTinS9=v+qHAyewRu19HgGr4iriwjkw@mail.gmail.com>
	<4DB71F3E.3040003@turmel.org>
	<BANLkTinpDOuTDu7fhbXNYwtvToUaCM=cmQ@mail.gmail.com>
	<4DB8BEFE.3020009@turmel.org>
	<20110428053123.B031BD52709@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110428053123.B031BD52709@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 27, 2011 at 10:31 PM, Wolfgang Denk <wd@denx.de> wrote:
> Dear Phil Turmel,
>
> In message <4DB8BEFE.3020009@turmel.org> you wrote:
>>
>> Hmmm. =C2=A0Since its not swap, this would make me worry about the h=
ardware. =C2=A0Have you considered shuffling SATA port assignments to s=
ee if a pattern shows up? =C2=A0Also consider moving some of the drive =
power load to another PS.
>
> I do not think this is hardware related. =C2=A0I see this behaviour o=
n at
> least 5 different machines which show no other problems except for th=
e
> mismatch count in the RAID 1 partitins that hold the /boot partition.
>

That's interesting to me.

In my case /boot is on it's own partition and not mounted when I do
the test. There was however a RAID6 mounted at the time I was doing
the repair on the RAID1. I tried dismounting it but that didn't change
anything. Still got the same sort of error count.

>> > Still, if I haven't a clue which drive is causing the mismatch the=
n I
>> > cannot know which one to pull..
>>
>> This is really a file system problem, and effort are underway to sol=
ve it. =C2=A0Btrfs in particular, although it is still experimental. =C2=
=A0I'm looking forward to that status changing.
>
> It will probably take some time until grub can boot from a RAID1 arra=
y
> with btrfs on it...
>
> Best regards,
>
> Wolfgang Denk

Thanks for the info.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
