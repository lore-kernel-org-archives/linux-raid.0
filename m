From: Mark Knecht <markknecht@gmail.com>
Subject: Re: metadata and / and grub-static
Date: Mon, 5 Apr 2010 07:15:29 -0700
Message-ID: <r2m5bdc1c8b1004050715q6db273f9o8d1c291a43ebd308@mail.gmail.com>
References: <u2u5bdc1c8b1004041902l9edc298dg6fb4774aaf8c22a6@mail.gmail.com>
	 <2D.29.28131.56A49BB4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2D.29.28131.56A49BB4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Apr 4, 2010 at 7:26 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
<SNIP>
>>
>> Answering self - putting / on RAID1 only seems to work using
>> --metadata=3D0.90. Tried it with higher versions and had no luck.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0One may most certainly run a RAID1 / or /b=
oot (or both) using other
> than 0.9 metadata. =C2=A0I'm running two servers with / on a 1.02 sup=
erblock and
> /boot on a 1.0 superblock, booting with grub 0.97.

Are you using an initrd? I could not make it work above 0.90 without
going that way which I didn't want to do.

>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0That said, if the restrictions of a 0.9 su=
perblock are not an issue
> for your system, then there is nothing particularly wrong with employ=
ing a
> 0.9 superblock.
>
>> Anyway, the system is running well now.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Unless the restrictions of a 0.9 superbloc=
k will cause problems for
> you in the future, that's the important thing.
>

I don't see that they will. I'm just building a home desktop/server
machine using 3-drive RAID1. I suspect you are doing more
sophisticated things than I.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
