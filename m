From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Sat, 31 Mar 2012 08:59:54 +0100
Message-ID: <CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: daobang wang <wangdb1981@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 March 2012 02:22, daobang wang <wangdb1981@gmail.com> wrote:
> Hi ALL,
>
> =C2=A0 =C2=A0How to adjust the xfs and raid parameters to improve the=
 total
> performance when RAID5 created by 8 disks works with xfs, and i write=
d
> a test program, which started 100 threads to write big files, 500MB
> per file, and delete it after writing finish. Thank you very much.
>
> Best Wishes,
> Daobang Wang.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml

Hi,

See http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesyste=
ms_for_.3Csomething.3E
=2E Also see http://hep.kbfi.ee/index.php/IT/KernelTuning . For example=
,
RAID5 with 8 harddrives and 64K stripe size:

mkfs.xfs -d su=3D64k,sw=3D7 -l version=3D2,su=3D64k /dev/md0

Consider mounting the filesystem with logbufs=3D8,logbsize=3D256k

Kind regards,
Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
