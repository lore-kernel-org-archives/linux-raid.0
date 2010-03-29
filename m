From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Swap on /dev/md1 always lost after reboot
Date: Sun, 28 Mar 2010 23:33:53 -0700
Message-ID: <4877c76c1003282333j7250a117y4dcff2aa12f75e9b@mail.gmail.com>
References: <4BB00EBF.7070304@gmx.net> <4BB01158.6050109@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB01158.6050109@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Joachim Otahal <Jou@gmx.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 28, 2010 at 7:32 PM, Joachim Otahal <Jou@gmx.net> wrote:
> Joachim Otahal schrieb:
>>
>> free says: swap active, mdstat says:
>> md2 : active (auto-read-only) raid1 sda2[1] sdb2[0]
>> =A0 =A0 =A0979840 blocks [2/2] [UU]
>
> minor correction: the output right after creating the raid + issuing =
a
> mkswap is
> md2 : active raid1 sda2[1] sdb2[0]
> =A0 =A0 =A0979840 blocks [2/2] [UU]
> =A0 =A0 =A0[=3D=3D=3D=3D=3D=3D=3D>.............] =A0resync =3D 37.9% =
(372480/979840) finish=3D0.1min
> speed=3D93120K/sec
>
> and a few second later:
> md2 : active raid1 sda2[1] sdb2[0]
> =A0 =A0 =A0979840 blocks [2/2] [UU]
>
> mdadm.conf updated, but md2 still not there after reboot.
>
> Joachim
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Trigger the regeneration of your initrd/initramfs image.  It's
probably got an mdadm.conf that lacks your second device.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
