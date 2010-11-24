From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: raid related kernel hang in 2.6.36
Date: Wed, 24 Nov 2010 14:19:54 +0000
Message-ID: <AANLkTinfbPDQhmKRVibUv+Rm50wDkGizeYLGXQqY_xOu@mail.gmail.com>
References: <4CED17A4.7050604@perabytes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CED17A4.7050604@perabytes.com>
Sender: linux-raid-owner@vger.kernel.org
To: Du Jun <dujun@perabytes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I suppose a few logs would be interesting. (dmesg, mdadm -E (hdds),
mdadm -D md10, zcat /proc/config.gz, mdadm version)

Regards,
// Mathias

2010/11/24 Du Jun <dujun@perabytes.com>:
> Hi,
> We just quick tested the raid stability under the vanilla 2.6.36 kern=
el
> and got an unstable result.
>
> first, we create a raid5 array using 16 sata disks:
>
> mdadm -C /dev/md10 -l 5 -n 16 /dev/sd[b-q]
>
> then use dd to stress the io:
>
> dd if=3D/dev/zero of=3D/dev/md10 bs=3D1M
>
> After a while, usually several minutes, the system hangs. It looks li=
ke
> some kind of kernel deadlock. ping to this machine could get timely
> response, however, any other process just hangs.
>
> It is easily reproducible and everytime the test result is a system h=
ang.
>
> Johnson
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
