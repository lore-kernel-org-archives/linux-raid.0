From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: mdadm: sending ioctl 800c0910 to a partition!
Date: Wed, 18 Apr 2012 12:34:59 +0800
Message-ID: <CA+res+TSnkTOjNcBhyA2e3h1mzePAsHaRqCWbKH_u3N3udzt5Q@mail.gmail.com>
References: <CAK2H+efFUYqX98KBSdJAu-wH5c+Aec2+1K40uQVostDgyh8PYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+efFUYqX98KBSdJAu-wH5c+Aec2+1K40uQVostDgyh8PYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I think you shouldn't concern this, just a annoy waining.

Jack

2012/4/18 Mark Knecht <markknecht@gmail.com>:
> Wondering if I should be concerned about these new messages?
>
> Everything seems to be working fine. Found a bug report at RedHat
> suggesting it's not an mdadm problem but thought maybe I should repor=
t
> it anyway.
>
> Thanks,
> Mark
>
> k2 ~ # uname -a
> Linux k2 3.2.12-gentoo #1 SMP PREEMPT Thu Apr 12 16:26:36 PDT 2012
> x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz GenuineIntel GNU/Linux
> k2 ~ #
>
> [ =C2=A0 =C2=A09.354769] scsi_verify_blk_ioctl: 368 callbacks suppres=
sed
> [ =C2=A0 =C2=A09.354773] mdadm: sending ioctl 1261 to a partition!
> [ =C2=A0 =C2=A09.354776] mdadm: sending ioctl 1261 to a partition!
> [ =C2=A0 =C2=A09.354918] mdadm: sending ioctl 800c0910 to a partition=
!
> [ =C2=A0 =C2=A09.354921] mdadm: sending ioctl 800c0910 to a partition=
!
> [ =C2=A0 =C2=A09.354939] mdadm: sending ioctl 800c0910 to a partition=
!
> [ =C2=A0 =C2=A09.354942] mdadm: sending ioctl 800c0910 to a partition=
!
> [ =C2=A0 =C2=A09.354988] mdadm: sending ioctl 800c0910 to a partition=
!
> [ =C2=A0 =C2=A09.354991] mdadm: sending ioctl 800c0910 to a partition=
!
> [ =C2=A0 =C2=A09.355004] mdadm: sending ioctl 800c0910 to a partition=
!
> [ =C2=A0 =C2=A09.355007] mdadm: sending ioctl 800c0910 to a partition=
!
> [ =C2=A0 =C2=A09.913580] EXT3-fs (md3): using internal journal
> [ =C2=A0 10.067489] kjournald starting. =C2=A0Commit interval 5 secon=
ds
> [ =C2=A0 10.092612] EXT3-fs (md127): using internal journal
> [ =C2=A0 10.092619] EXT3-fs (md127): mounted filesystem with writebac=
k data mode
> [ =C2=A0 11.724865] Adding 4200992k swap on /dev/sda2. =C2=A0Priority=
:-1
> extents:1 across:4200992k
> [ =C2=A0 11.731532] Adding 4200992k swap on /dev/sdb2. =C2=A0Priority=
:-2
> extents:1 across:4200992k
> [ =C2=A0 11.743473] Adding 4200992k swap on /dev/sdc2. =C2=A0Priority=
:-3
> extents:1 across:4200992k
>
>
> mark@k2 ~ $ cat /proc/mdstat
> Personalities : [raid0] [raid1]
> md127 : active raid1 sdc6[1] sdb6[0]
> =C2=A0 =C2=A0 =C2=A0327740905 blocks super 1.2 [2/2] [UU]
>
> md126 : active raid1 sdb5[0] sdc5[1]
> =C2=A0 =C2=A0 =C2=A031463203 blocks super 1.1 [2/2] [UU]
>
> md3 : active raid1 sdc3[1] sdb3[0]
> =C2=A0 =C2=A0 =C2=A041953664 blocks [2/2] [UU]
>
> unused devices: <none>
> mark@k2 ~ $
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
