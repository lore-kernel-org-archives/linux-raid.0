From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 sector size
Date: Sun, 6 Feb 2011 14:49:45 -0200
Message-ID: <AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

the problem (benchmark) i don't know if it's a cpu intensive use
that's blocking some i/o (try to reduce IOPS on md raid1), or a
problem at read logic (check if disk is ok)

[root@myhost block]# dd if=3D/dev/sda of=3D/dev/zero bs=3D8196
^C80106+0 registros de entrada
80105+0 registros de sa=EDda
656540580 bytes (657 MB) copiados, 5,38142 s, 122 MB/s

[root@myhost block]# dd if=3D/dev/md0 of=3D/dev/zero bs=3D8196
^C52851+0 registros de entrada
52850+0 registros de sa=EDda
433158600 bytes (433 MB) copiados, 10,4623 s, 41,4 MB/s


on iostat -d 1 -k
i see that just sda is running (i'm using the normal unpatched kernel
2.6.37), cpu is: using htop (i coudn't select and copy, maybe sum>100%
but it's a mean value)

using md0:
CPU:	1.3%	sy 67.3	ni:	0	si 36%		wa: 0%

using  sda:
CPU:	1.3%	sy 33.6	ni:	0	si 8,4%		wa: 50%

maybe cpu don't have time to wait i/o (sda showed wa: 50%)
anyone could help me if i'm undestanding it right?
the best block size for my harddisk is 8196

md0 is in sync

2011/2/6 Roberto Spadim <roberto@spadim.com.br>:
> hi guys, there's a way to increase sector size?
> instead of 512bytes use 4096bytes?
>
> check:
> md0: 512bytes
> sda: 4096bytes
> sdb: 4096bytes
>
> i want a 512bytes at md0
> why? i'm trying to reduce IOPS (more bytes to read =3D less io / seco=
nd)
> and maybe increase read rate
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
