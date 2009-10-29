From: "Majed B." <majedb@gmail.com>
Subject: Re: small mdadm issue under debian
Date: Thu, 29 Oct 2009 15:26:22 +0300
Message-ID: <70ed7c3e0910290526v93752bfv3b5acb1a3b3f4e52@mail.gmail.com>
References: <200910290124.59090.tfjellstrom@shaw.ca> <200910290130.18829.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200910290130.18829.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When using newer kernels, did you update initrd?

sudo update-initramfs -u -k all

Then reboot to a new kernel and see if it auto assembles.

On Thu, Oct 29, 2009 at 10:30 AM, Thomas Fjellstrom <tfjellstrom@shaw.c=
a> wrote:
> On Thu October 29 2009, Thomas Fjellstrom wrote:
>> I've been trying to get mdadm to auto assemble my raid array for a w=
hile
>> now, and as I'm trying to test which kernels give me back some
>> =C2=A0performance (testing 2.6.26 right now), I find that with this =
kernel,
>> =C2=A0its happily auto assembling my 1.1 versioned metadata array. 3=
=2E6.30 does
>> =C2=A0not, nor does .31 or .32 for that matter. Same version of mdad=
m, for
>> =C2=A0some reason, when the mdadm-raid init script is run, it fails =
to
>> =C2=A0assemble the raid array I've specified in mdadm.conf. And agai=
n, it
>> =C2=A0automagically works with 2.6.26.
>>
>> color me confused.
>>
>
> I totally forgot:
>
> root@natasha:/home/moose# mdadm --version
> mdadm - v3.0.3 - 22nd October 2009
>
> root@natasha:/home/moose# uname -a
> Linux natasha 2.6.26-2-amd64 #1 SMP Wed Aug 19 22:33:18 UTC 2009 x86_=
64
> GNU/Linux
>
> root@natasha:/home/moose# mdadm -D /dev/md0
> /dev/md0:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Version : 1.01
> =C2=A0Creation Time : Wed Oct 14 08:55:25 2009
> =C2=A0 =C2=A0 Raid Level : raid5
> =C2=A0 =C2=A0 Array Size : 3907049472 (3726.05 GiB 4000.82 GB)
> =C2=A0Used Dev Size : 976762368 (931.51 GiB 1000.20 GB)
> =C2=A0 Raid Devices : 5
> =C2=A0Total Devices : 5
> =C2=A0 =C2=A0Persistence : Superblock is persistent
>
> =C2=A0 =C2=A0Update Time : Thu Oct 29 01:28:10 2009
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0State : clean
> =C2=A0Active Devices : 5
> Working Devices : 5
> =C2=A0Failed Devices : 0
> =C2=A0Spare Devices : 0
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Layout : left-symmetric
> =C2=A0 =C2=A0 Chunk Size : 512K
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Name : natasha:0 =C2=A0(local to h=
ost natasha)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 UUID : 7d0e9847:ec3a4a46:32b60a80:=
06d0ee1c
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Events : 4952
>
> =C2=A0 =C2=A0Number =C2=A0 Major =C2=A0 Minor =C2=A0 RaidDevice State
> =C2=A0 =C2=A0 =C2=A0 0 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 64=
 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sde
> =C2=A0 =C2=A0 =C2=A0 1 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 80=
 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdf
> =C2=A0 =C2=A0 =C2=A0 2 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 32=
 =C2=A0 =C2=A0 =C2=A0 =C2=A02 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdc
> =C2=A0 =C2=A0 =C2=A0 3 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 48=
 =C2=A0 =C2=A0 =C2=A0 =C2=A03 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdd
> =C2=A0 =C2=A0 =C2=A0 5 =C2=A0 =C2=A0 =C2=A0 8 =C2=A0 =C2=A0 =C2=A0 96=
 =C2=A0 =C2=A0 =C2=A0 =C2=A04 =C2=A0 =C2=A0 =C2=A0active sync =C2=A0 /d=
ev/sdg
>
>
> And I'm running Debian Sid.
>
> --
> Thomas Fjellstrom
> tfjellstrom@shaw.ca
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
