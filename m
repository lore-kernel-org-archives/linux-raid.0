From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: raid1 sector size
Date: Sun, 6 Feb 2011 13:03:59 -0500
Message-ID: <AANLkTi=jGzLZ6w6eijB6qD+LLNmjYE-NiceTuv7bw9v8@mail.gmail.com>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com> <AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Feb 6, 2011 at 11:49 AM, Roberto Spadim <roberto@spadim.com.br>=
 wrote:
> the problem (benchmark) i don't know if it's a cpu intensive use
> that's blocking some i/o (try to reduce IOPS on md raid1), or a
> problem at read logic (check if disk is ok)
>
> [root@myhost block]# dd if=3D/dev/sda of=3D/dev/zero bs=3D8196
> ^C80106+0 registros de entrada
> 80105+0 registros de sa=EDda
> 656540580 bytes (657 MB) copiados, 5,38142 s, 122 MB/s
>
> [root@myhost block]# dd if=3D/dev/md0 of=3D/dev/zero bs=3D8196
> ^C52851+0 registros de entrada
> 52850+0 registros de sa=EDda
> 433158600 bytes (433 MB) copiados, 10,4623 s, 41,4 MB/s
>

You could try with some computer friendly bs=3D value, like 8192.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
