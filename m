From: "Majed B." <majedb@gmail.com>
Subject: Re: mdadm --wait doesn't (part II) [was: Re: question about bitmaps
	and dirty percentile]
Date: Wed, 9 Sep 2009 01:21:04 +0300
Message-ID: <70ed7c3e0909081521s3df83519r1a729c91b259f03d@mail.gmail.com>
References: <cccedfc60909081123n36363d83ne6f39fd323ea0f47@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60909081123n36363d83ne6f39fd323ea0f47@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The one in OpenSUSE's repositories is a development version, as far as =
I know.

Download the latest and compile it and see if it works out with you.

On Tue, Sep 8, 2009 at 9:23 PM, Jon
Nelson<jnelson-linux-raid@jamponi.net> wrote:
> Regarding an earlier issue, I've also found that mdadm (v3.0 - 2nd
> June 2009, openSUSE 11.1) doesn't wait if a recovery is in progress i=
f
> the recovery proceeds beyond 100% (due to a kernel bug).
>
> turnip:~ # mdadm --wait /dev/md1
> turnip:~ # echo $?
> 1
> turnip:~ # cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid10] [raid0] [raid1]
> md1 : active raid1 sdf[2](W) md2[0]
> =C2=A0 =C2=A0 =C2=A072612920 blocks super 1.1 [2/1] [U_]
> =C2=A0 =C2=A0 =C2=A0[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D>] =C2=A0recovery =3D125.7%
> (45641024/36306460) finish=3D5320721999329.4min speed=3D28890K/sec
> =C2=A0 =C2=A0 =C2=A0bitmap: 29/139 pages [116KB], 256KB chunk
>
> md2 : active raid1 nbd0[2](W) sde[0]
> =C2=A0 =C2=A0 =C2=A072612988 blocks super 1.1 [2/2] [UU]
> =C2=A0 =C2=A0 =C2=A0bitmap: 1/139 pages [4KB], 256KB chunk
>
> md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[1]
> =C2=A0 =C2=A0 =C2=A0613409536 blocks super 1.1 level 6, 64k chunk, al=
gorithm 2 [4/4] [UUUU]
>
> unused devices: <none>
> turnip:~ #
>
>
> --
> Jon
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
