From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: OK, Now this is really weird
Date: Sat, 26 Feb 2011 11:35:11 +0000
Message-ID: <AANLkTim_cF9nnXMz2pJfewFqW68p1b0gKoKbtjRa6wqE@mail.gmail.com>
References: <20110226003611.tjp3cxisu880co88-xnmenx@webmail.spamcop.net>
	<C2.5D.05134.F02E86D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C2.5D.05134.F02E86D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Jeff Woods <jeff@jeffwoods.us>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26 February 2011 11:20, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>
>
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Jeff Woods
>> Sent: Saturday, February 26, 2011 1:36 AM
>> To: lrhorer@satx.rr.com
>> Cc: 'Linux RAID'
>> Subject: Re: OK, Now this is really weird
>>
>> Quoting Leslie Rhorer <lrhorer@satx.rr.com>:
>> > =C2=A0 =C2=A0 I have a pair of drives each of whose 3 partitions a=
re members of a
>> > set of 3 RAID arrays. =C2=A0One of the two drives had a flaky powe=
r
>> connection
>> > which I thought I had fixed, but I guess not, because the drive wa=
s
>> taken
>> > offline again on Tuesday. =C2=A0The significant issue, however, is=
 that both
>> > times the drive failed, mdadm behaved really oddly. =C2=A0The firs=
t time I
>> > thought it might just be some odd anomaly, but the second time it =
did
>> > precisely the same thing. =C2=A0Both times, when the drive was de-=
registered
>> by
>> > udev, the first two arrays properly responded to the failure, but =
the
>> third
>> > array did not. =C2=A0Here is the layout:
>>
>> [snip lots of technical details]
>>
>> > =C2=A0 =C2=A0 So what gives? =C2=A0/dev/sdk3 no longer even exists=
, so why hasn't it
>> > been failed and removed on /dev /md3 like it has on /dev/md1 and
>> /dev/md2?
>>
>> Is it possible there has been no I/O request for /dev/md3 since
>> /dev/sdk failed?
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Well, I thought about that. =C2=A0It's swa=
p space, so I suppose it's
> possible. =C2=A0I would have thought, however, that mdadm would fail =
a missing
> member whether there is any I/O or not.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

I thought so as well. But how will mdadm know is the device is faulty,
unless the device is generating errors? (which usually only happens on
read and/or write)

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
