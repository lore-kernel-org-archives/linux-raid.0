From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 sector size
Date: Sun, 6 Feb 2011 23:21:49 -0200
Message-ID: <AANLkTikyOFRvhSc1ORC4HCnXRWZs_pQj1+ogpOiegzD3@mail.gmail.com>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
	<AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
	<4D4F20F3.5050709@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4F20F3.5050709@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=3D] it works heeh =3D]
but the problem is the same, speed is low on /dev/md0 than /dev/sda

2011/2/6 Stan Hoeppner <stan@hardwarefreak.com>:
> Roberto Spadim put forth on 2/6/2011 10:49 AM:
>
>> [root@myhost block]# dd if=3D/dev/sda of=3D/dev/zero bs=3D8196
>
>> [root@myhost block]# dd if=3D/dev/md0 of=3D/dev/zero bs=3D8196
>
> /dev/zero is a read source, not a write target. =A0I'm surprised this=
 doesn't bomb
> out. =A0Use /dev/null for output.
>
> --
> Stan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
