From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: i made sh*t can anyone help!?
Date: Fri, 18 Mar 2011 13:49:03 +0000
Message-ID: <AANLkTimE-P5AgWsP69YKPVvONXbjmV6QswV_eXuoRo=k@mail.gmail.com>
References: <AANLkTinGkgSrfqTjYUKGXeR9yfuGws=o8bVhVnuDFMWx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinGkgSrfqTjYUKGXeR9yfuGws=o8bVhVnuDFMWx@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 18 March 2011 13:43, Roberto Spadim <roberto@spadim.com.br> wrote:
> hi guys i had a raid1 array, and i made shit, could i undo it? it hav=
e
> filesystem with files :(
>
> # mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 /dev/sdb mis=
sing
> mdadm: /dev/sdb appears to be part of a raid array:
> =C2=A0 =C2=A0level=3Draid1 devices=3D2 ctime=3DWed Mar 16 19:01:50 20=
11
> mdadm: Note: this array has metadata at the start and
> =C2=A0 =C2=A0may not be suitable as a boot device. =C2=A0If you plan =
to
> =C2=A0 =C2=A0store '/boot' on this device please ensure that
> =C2=A0 =C2=A0your boot-loader understands md/v1.x metadata, or use
> =C2=A0 =C2=A0--metadata=3D0.90
> Continue creating array?
> Continue creating array? (y/n) y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

You had a RAID1 array? Of which devices did it consists of? Looks like
you only destroyed one.

// M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
