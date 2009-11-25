From: hank peng <pengxihan@gmail.com>
Subject: Re: Recovery didn't continue recovery after reboot
Date: Wed, 25 Nov 2009 17:30:11 +0800
Message-ID: <389deec70911250130p2c6bce77me8cdb9d73d9a102@mail.gmail.com>
References: <389deec70911242014r1a2f5c27k65a30f2d627b17c3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <389deec70911242014r1a2f5c27k65a30f2d627b17c3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/11/25 hank peng <pengxihan@gmail.com>:
> I created a RAID5 array which consisted of 3 disks.
> #mdadm -C /dev/md0 --metadata=3D1.1 --bitmap=3Dinternal -l5 -n3 /dev/=
sd{a,b,c}
> Before initial recovery was done, I reboot my system. After system is
> on, initial recovery didn't continue.
> #cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath]
> md0 : active raid5 sda[0] sdc[3] sdb[1]
> =C2=A0 =C2=A0 =C2=A0976772864 blocks super 1.1 level 5, 64k chunk, al=
gorithm 2 [3/3] [UUU]
>
> I removed '--bitmap' option and retest again, there was no problem an=
d
> recovery continued.
>
> Is there something wrong? Any help will be appreciated!
>
It seems that there is problem when both '--metadata=3D1.1' and
'--bitmap=3Dinternal' optinons are used. Anyone on this list have seen
this case?

> --
> The simplest is not all best but the best is surely the simplest!
>



--=20
The simplest is not all best but the best is surely the simplest!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
