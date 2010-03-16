From: Tao Guo <glorioustao@gmail.com>
Subject: Re: async/X threads and rebuild slowdown
Date: Tue, 16 Mar 2010 21:24:43 +0800
Message-ID: <318b7ac71003160624m16aad423lddca62c31021b104@mail.gmail.com>
References: <hnnu9c$tsj$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hnnu9c$tsj$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jeremy@jeremysanders.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I also meet this problem in several of my machines. If I change back
to kernel 2.6.18, it is
OK, but in 2.6.32 kernel, the performance is really poor.

At last I found a solution, set CONFIG_MULTICORE_RAID456=3Dn when
compiling raid456 module,
then everything goes normal. My machines do have multicore cpu, so it
is weird :<
Maybe there is something wrong with the CONFIG_MULTICORE_RAID456 enable=
d code?

On Tue, Mar 16, 2010 at 8:41 PM, Jeremy Sanders
<jeremy@jeremysanders.net> wrote:
> Hi - It seems our MD raid rebuild speeds are very slow with the new F=
edora
> 2.6.32.9-70 kernel. We're only getting ~13MB/s:
>
> [root@xback2 ~]# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdb1[0] sdj1[10](S) sdk1[9] sdl1[8] sdi1[7] sdh1[6=
]
> sdg1[5] sdf1[4] sde1[3] sdd1[2] sdc1[1]
> =C2=A0 =C2=A0 =C2=A08788959360 blocks level 5, 32k chunk, algorithm 2=
 [10/10] [UUUUUUUUUU]
> =C2=A0 =C2=A0 =C2=A0[=3D=3D=3D=3D=3D>...............] =C2=A0resync =3D=
 29.3% (286397320/976551040)
> finish=3D897.2min speed=3D12819K/sec
>
> The maximum rebuild speed is at the default 200000K/s. The drives are
> connected to a 3ware 9650SE-16ML controller on PCI-Express.
>
> There seem to be hundreds of async/X threads, where X goes up to 129 =
at
> least. The md0_raid5 process is using at least 80% of the CPU on this=
 dual
> core Athlon 7750 system.
>
> Has anything changed recently in the kernel. I don't remember md0_rai=
d5
> being so processor inefficient, slow at rebuilding or creating hundre=
ds of
> kernel threads.
>
> Are these async/X threads documented anywhere?
>
> Thanks
>
> Jeremy
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
tao.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
