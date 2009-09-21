From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Mon, 21 Sep 2009 10:05:23 +0300
Message-ID: <70ed7c3e0909210005t6530dbf7k7f1d14059dcd012e@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<2267211f0909180912p745e4ea0idb5659cb54a6adce@mail.gmail.com>
	<6b696870909180923m35f29fa2l857b6f6402eb20be@mail.gmail.com>
	<2267211f0909181041o29d6f5eft1e260696c6ab9c57@mail.gmail.com>
	<6b696870909181317x777e3c5dsdcf0e7709f9c4979@mail.gmail.com>
	<2267211f0909181630r33fcdbe5hb0d158b9bf12924b@mail.gmail.com>
	<70ed7c3e0909181637g35b31926ref7e4a16beaab73c@mail.gmail.com>
	<1f0f1a960909181817s6ad0a3f3l386a478603e9fde8@mail.gmail.com>
	<AFD5FB84146A49B186DAB822C95DE16D@m5> <2267211f0909202140m54039f77rce262283eb4e371@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2267211f0909202140m54039f77rce262283eb4e371@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bostrom <tbostrom@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> I received the error : mdadm: superblock on /dev/sdc1 doesn't match
> others - assembly aborted.

I got that when using an older version of mdadm (2.6.7.1). According
to Neil, it's been fixed already so try using the latest version (3.0)
and do this:
mdadm -Af /dev/md0 /dev/sdf1 /dev/sdc1 /dev/sdb1 /dev/sdd1

(No need to specify a missing one).

I avoided creating another array. No matter what the situation is, it
would be the last thing I'd ever do, because I want to keep the
metadata as intact as possible to get the most info I can out of it to
fix the situation.
And my motherboard keeps changing names like crazy, so if I create a
new array, I may not be able to find the original disks' order again
(not easily).

On Mon, Sep 21, 2009 at 7:40 AM, Tim Bostrom <tbostrom@gmail.com> wrote=
:
> Well, thank god I copied everything off the array this weekend, but s=
trange:
>
> I had gotten the array up finally with the correct order and missing =
drive:
>
> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sdf1 /dev/sdc1 /dev/sdb1
> /dev/sdd1 missing
>
> ------------
> After copying everything off, I power-cycled my server and tried to
> bring the array back up again using:
>
> mdadm -A /dev/md0 /dev/sdf1 /dev/sdc1 /dev/sdb1 /dev/sdd1 missing
>
> I received the error : mdadm: superblock on /dev/sdc1 doesn't match
> others - assembly aborted.
>
> This is strange since I had this seemingly working and was able to
> copy all the data offline this weekend.
> Drives haven't changed order - I haven't unplugged anything or change=
d
> any cords.
>
> Another issue of the command that worked before on the array:
> mdadm -C /dev/md0 -l 5 -n 5 -c 256 /dev/sdf1 /dev/sdc1 /dev/sdb1
> /dev/sdd1 missing
>
> yields my old problem of not being able to mount.
> EXT3-fs: md0: couldn't mount because of unsupported optional features
> (3fd18e00).
> mount: wrong fs type, bad option, bad superblock on /dev/md0,
> =C2=A0 =C2=A0 =C2=A0 missing codepage or helper program, or other err=
or
> =C2=A0 =C2=A0 =C2=A0 In some cases useful info is found in syslog - t=
ry
> =C2=A0 =C2=A0 =C2=A0 dmesg | tail =C2=A0or so
--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
