From: Per-Ola Stenborg <per-ola@stenborg.me>
Subject: Re: Multiple drive failure after stupid mistake. Help needed
Date: Sun, 19 Oct 2014 14:58:04 +0200
Message-ID: <5443B55C.7000208@stenborg.me>
References: <54438839.9080309@stenborg.me> <alpine.DEB.2.02.1410191253010.30853@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1410191253010.30853@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, thanks for your answer. (Tack!)

My debian mdadm is ver v3.1.4 - 31st August 2010
mdadm --assemble --force /dev/md0 /dev/sd[bcde]
outputs
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has no superblock - assembly aborted

I compiled the latest mdadm v3.3.2 - 21st August 2014
running
mdadm --assemble --force /dev/md0 /dev/sd[bcde]
outputs
mdadm: /dev/sdb is busy - skipping
mdadm: /dev/sdc is busy - skipping
mdadm: /dev/sdd is busy - skipping
mdadm: /dev/sde is busy - skipping

Strange. What does this mean? Is it flaged as in use in the kernel? The=
=20
devices are readable, I tried to read data with
dd if=3D/dev/sdb of=3Ddump bs=3D1024 count=3D1024
and it works, so the device is accressible.

dmesg shows nothing

/proc/mdstat
Personalities :
md0 : inactive sdd[2](S) sdb[0](S) sde[4](S) sdc[1](S)
       7814054240 blocks super 1.2


uname -a
Linux backuppc 2.6.32-5-686 #1 SMP Sat Jul 12 22:59:16 UTC 2014 i686=20
GNU/Linux
System is Debian squeeze-lts

Best regards
=B4
Per-Ola Stenborg

Mikael Abrahamsson skrev 2014-10-19 12:56:
> On Sun, 19 Oct 2014, Per-Ola Stenborg wrote:
>
>> *** PLEASE advice ***
>
> Please post dmesg output from when you do --assemble --force, and als=
o=20
> please post your mdadm and kernel versions.
>
> As a first step, compile mdadm from source and use that version, it=20
> often helps as distributions don't generally ship with the latest mda=
dm.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
