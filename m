From: "Majed B." <majedb@gmail.com>
Subject: Re: IDE/RAID/AHCI setting in BIOS influcencing mdraid?
Date: Wed, 11 Nov 2009 06:05:05 +0300
Message-ID: <70ed7c3e0911101905m5f0bfbdbi5ae8a00576330abf@mail.gmail.com>
References: <4AF9F415.9050809@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF9F415.9050809@ribosome.natur.cuni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello,

I won't be able to answer all your questions, but I can help with some:

1) Each mode in the BIOS makes the devices behave differently. AHCI
always improves performance for disks. My laptop was on IDE and its
max throughput was 11 MB/s. When enabling AHCI, I got 30-35 MB/s out
of the poor disk (5400 rpm).

1 & 2) Intel storage matrix is fake RAID and its driver is horrible &
slow. Avoid it like the plague!
You'd be better off with software RAID or a hardware controller.

3) As far as I know, whenevr you create an array (in any way --
software or hardware), array information is written to the disks, so
when you switch from software RAID to hardware RAID, you may lose your
array information, depending on where the information is written
(beginning of the disk or at the end of it) -- if you have a
filesystem already in place, that may be lost too.
The above is also correct if you tried to create a new software RAID
array but with a different superblock version (0.9 vs 1.x), since
array information is written differently.

A quote from the mdadm manual:
"1, 1.0, 1.1, 1.2: Use the new version-1 format superblock.  This has
few restrictions.  The different sub-versions store the superblock at
different locations on the device, either at the end (for 1.0), at the
start (for 1.1) or 4K from the start (for 1.2)."

On Wed, Nov 11, 2009 at 2:15 AM, Martin MOKREJ=C5=A0
<mmokrejs@ribosome.natur.cuni.cz> wrote:
> Hi,
> =C2=A0after poking around the internet I cannot answer myself several=
 questions.
> Please somebody feel free to update the http://linux-raid.osdl.org/ p=
ages
> and the mdadm manpage to explain the differences. ;-)
>
> =C2=A01. Does the BIOS values, especially AHCI vs. RAID force for exa=
mple the
> ICH9R chip into different mode seen by linux kernel? Looks like that =
=2E..
> I have two machines and see there is a difference reported. Could tha=
t
> cause machine instability if the disks would be configured through md=
adm
> to be in RAID? Some kind of conflict?
>
> =C2=A0I see "impl RAID mode" vs. "SATA mode" in dmesg outputs on my m=
achines:
> host1: ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f=
 impl RAID mode
> host2: ahci 0000:02:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 =
impl SATA mode
>
>
> =C2=A02. Selecting RAID mode in BIOS writes some Intel Storage Matrix=
 label
> somewhere into the disk, right? I think I read in mdadm manpage or si=
milar about
> "imsm" superblock format or something like that ... supported by mdra=
id. I cannot
> find it anymore. Does it mean that one could force mdadm to create th=
e superblock
> recognized by the ICH9R BIOS and in theory MS Win drivers from Intel?
>
>
> =C2=A03. I have now 0.90 superblocks on two raid1 disc partitions /de=
v/sd[a-b]1.
> What happens if I go to BIOS of ICH9R and "remove the drives from the=
 raid1" array?
> Does that clear the "imsm?" superblock? Will that kill the 0.90 mdadm=
 superblock
> and destroy my linux mdraid?
>
>
> =C2=A04. There is hardly a documentation available comparing and expl=
aining
> the difference between dmraid and mdraid. My understanding is that dm=
raid
> is used in linux/win dual-boot machines and is older implementation. =
Does
> use of the "imsm" superblock format under mdadm give the same possibi=
lity?
> BTW, arguably the best documentation is in lkml archives around here =
=2E..:-)
>
> From: Neil Brown (neilb@cse.unsw.edu.au)
> Date: Tue Nov 19 2002 - 23:09:18 EST
> Subject: RFC - new raid superblock layout for md driver
>
> The thread is at http://lkml.indiana.edu/hypermail/linux/kernel/0211.=
2/1108.html
>
>
> =C2=A0 5. There is --zero-superblock option to mdadm(1) but the manpa=
ge does not bother
> to state how can one create one. Googling around I found that actuall=
y --create
> does not kill the current data if one supplies mdadm with the list of=
 devices.
> I would have to Google again to give you the link, sorry. ;-) This on=
e is at least
> somehow similar, probably the first where I saw a trick with the devi=
cename "missing".
> Something new to me. ;-)
> http://ubuntu-ky.ubuntuforums.org/showthread.php?p=3D8286434
>
>
> =C2=A0 6. mdadm -D /dev/mdX shows: =C2=A0 "Persistence : Superblock i=
s persistent".
> =C2=A0What I did not create the array with persistent block? How to c=
reate one
> additionally? I think the answer is in the previous point nr. 5. ;-)
> Yes, would be nice if somebody placed into the manpage (your Wiki) a =
kernel
> command-line (for those who screwed their superblocks or want to stay=
 on a safe side
> if they manage so ...) example like this one from http://en.gentoo-wi=
ki.com/wiki/Software_RAID_Install:
>
> Title gentoo-2.6.24-r3
> root (hd0,0)
> kernel /gentoo.2624r3 root=3D/dev/md5 md=3D5,/dev/sda5,/dev/sdb5
>
>
> Thank you for any clarifications.
> Martin
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
