From: Mark Knecht <markknecht@gmail.com>
Subject: Re: High mismatch count on root device - how to best handle?
Date: Sun, 1 May 2011 10:13:12 -0700
Message-ID: <BANLkTi=ssw38v24QQiAL=GyVrHs_jVwYzQ@mail.gmail.com>
References: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>
	<BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com>
	<BANLkTinS9=v+qHAyewRu19HgGr4iriwjkw@mail.gmail.com>
	<4DB71F3E.3040003@turmel.org>
	<BANLkTinpDOuTDu7fhbXNYwtvToUaCM=cmQ@mail.gmail.com>
	<4DB8BEFE.3020009@turmel.org>
	<20110428053123.B031BD52709@gemini.denx.de>
	<BANLkTikBkaWsDicptHsX3dz=RW5_bL2Z7A@mail.gmail.com>
	<4DBD7338.4060206@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DBD7338.4060206@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Wolfgang Denk <wd@denx.de>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, May 1, 2011 at 7:50 AM, Brad Campbell <lists2009@fnarfbargle.co=
m> wrote:
> On 01/05/11 06:51, Mark Knecht wrote:
>>
>> On Wed, Apr 27, 2011 at 10:31 PM, Wolfgang Denk<wd@denx.de> =C2=A0wr=
ote:
>>>
>>> Dear Phil Turmel,
>>>
>>> In message<4DB8BEFE.3020009@turmel.org> =C2=A0you wrote:
>>>>
>>>> Hmmm. =C2=A0Since its not swap, this would make me worry about the=
 hardware.
>>>> =C2=A0Have you considered shuffling SATA port assignments to see i=
f a pattern
>>>> shows up? =C2=A0Also consider moving some of the drive power load =
to another PS.
>>>
>>> I do not think this is hardware related. =C2=A0I see this behaviour=
 on at
>>> least 5 different machines which show no other problems except for =
the
>>> mismatch count in the RAID 1 partitins that hold the /boot partitio=
n.
>
> root@srv:/server# grep . /sys/block/md?/md/mismatch_cnt
> /sys/block/md0/md/mismatch_cnt:0
> /sys/block/md1/md/mismatch_cnt:128
> /sys/block/md2/md/mismatch_cnt:0
> /sys/block/md3/md/mismatch_cnt:41728
> /sys/block/md4/md/mismatch_cnt:896
> /sys/block/md5/md/mismatch_cnt:0
> /sys/block/md6/md/mismatch_cnt:4352
>
> root@srv:/server# cat /proc/mdstat | grep md[1346]
> md6 : active raid1 sdp6[0] sdo6[1]
> md4 : active raid1 sdp3[0] sdo3[1]
> md3 : active raid1 sdp2[0] sdo2[1]
> md1 : active raid1 sdp1[0] sdo1[1]
>
> root@srv:/server# cat /etc/fstab | grep md[1346]
> /dev/md1 =C2=A0 =C2=A0 =C2=A0 =C2=A0/ =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 ext4 errors=3Dremount-ro,commit=3D30,noatime
> 0 1
> /dev/md6 =C2=A0 =C2=A0 =C2=A0 =C2=A0/raid0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0ext4 =C2=A0 =C2=A0defaults,commit=3D30,noatime =C2=A0 =C2=A0 =C2=
=A00 1
> /dev/md4 =C2=A0 =C2=A0 =C2=A0 =C2=A0/home =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 ext4 =C2=A0 =C2=A0defaults,commit=3D30,noatime =C2=A0 =C2=A0 =C2=
=A00 1
> /dev/md3 =C2=A0 =C2=A0 =C2=A0 =C2=A0none =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0swap =C2=A0 =C2=A0sw
>
> I see them _all_ the time on RAID1's..
>
> When I configured this system _years_ ago, I did not know any better,=
 so
> it's a bit of a mish-mash.
>
> The machine also has a 10 drive RAID-6 and a 3 drive RAID-5. The only=
 time
> I've seen mismatches on those is when I used a SIL 3132 controller an=
d it
> trashed the RAID-6.
>
> Brad
>

Brad,
   Thanks very much for sharing the data and your experiences with
this. I'll simply ignore it on the RAID1's from now on.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
