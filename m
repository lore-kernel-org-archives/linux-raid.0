From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: mdadm: ADD_NEW_DISK failed: Invalid argument
Date: Fri, 4 Feb 2011 00:45:20 +0000
Message-ID: <AANLkTi=aoyO6O9FgWNO0dosQNj2+g_tH7H=WMoAziE8f@mail.gmail.com>
References: <iifhb6$inv$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iifhb6$inv$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Forrest <jlforrest@berkeley.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4 February 2011 00:31, Jon Forrest <jlforrest@berkeley.edu> wrote:
> (I see that other people have had this problem
> but not in the same situation as me. Mine
> is probably as simple as you can get).
>
> I'm learning about how to manage software raid
> by using loopback devices on a RHEL6 system
> (2.6.32-71.14.1.el6.i686).
>
> I create two loopback devices thusly:
>
> # dd if=3D/dev/zero of=3Dfile0 bs=3D1k count=3D100
> 100+0 records in
> 100+0 records out
> 102400 bytes (102 kB) copied, 0.000689998 s, 148 MB/s
> # cp file0 file1
> # losetup /dev/loop0 file0
> # losetup /dev/loop1 file1
>
> I can create a RAID1 volume with no problems:
>
> # mdadm --create /dev/md0 --raid-device=3D2 --level=3D1 /dev/loop0 /d=
ev/loop1
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
>
> However, doing the same thing but creating a RAID0 volume
> fails thusly:
>
> # dd if=3D/dev/zero of=3Dfile2 bs=3D1k count=3D100
> 100+0 records in
> 100+0 records out
> 102400 bytes (102 kB) copied, 0.000699377 s, 146 MB/s
> # cp file2 file3
> # losetup /dev/loop2 file2
> # losetup /dev/loop3 file3
> # mdadm --create /dev/md1 --raid-device=3D2 --level=3D0 /dev/loop2 /d=
ev/loop3
> mdadm: Defaulting to version 1.2 metadata
> mdadm: ADD_NEW_DISK for /dev/loop2 failed: Invalid argument
>
> I don't understand what went wrong? Any ideas?
>
> Cordially,
> --
> Jon Forrest
> Research Computing Support
> College of Chemistry
> 173 Tan Hall
> University of California Berkeley
> Berkeley, CA
> 94720-1460
> 510-643-1032
> jlforrest@berkeley.edu
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

I just tried this on Ubuntu 10.10 and I got this:

sudo mdadm --create /dev/md0 --raid-device=3D2 --level=3D1 /dev/loop0 /=
dev/loop1
mdadm: /dev/loop0 is too small: 100K
mdadm: /dev/loop1 is too small: 100K
mdadm: create aborted


mdadm - v2.6.7.1 - 15th October 2008
2.6.35-26-generic

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
