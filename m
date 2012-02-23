From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Lenny to squeeze mdadm problem + e2label problem
Date: Thu, 23 Feb 2012 01:32:36 +0000
Message-ID: <4F459734.4050100@anonymous.org.uk>
References: <CAA8xrZdnBD+GTgk759aQigey0qVBQk-FsMj27_3ik8bjnTP_jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA8xrZdnBD+GTgk759aQigey0qVBQk-FsMj27_3ik8bjnTP_jw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Manuel Arostegui <manuel@tuenti.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/02/2012 11:44, Manuel Arostegui wrote:
> Hey all,
>
> Whilst trying to upgrade one box from Debian Lenny to Debian Squeeze =
I
> have run into some problems with mdadm and the RAID labeling.
>
> Kernel: 2.6.32-41
> mdadm version: v3.1.4
> Disks: 4
>
> RAID devices:
> /dev/md0 - boot - RAID1 - ext3
> /dev/md1 swap
> /dev/md2 - "/" - RAID1 - ext3
> /dev/md3 - "/var/lib/mysql" - RAID10 - xfs
>
> When doing the dist-upgrade and replacing the kernel + udev the syste=
m
> changes the RAID devices to md124, md125, md126 etc.
> As far as I have read, this makes sense - as mdadm is changing
> superblock and has to recalculate the whole RAID. This is big problem=
,
> if you have devices into /etc/fstab, like we do.

mdadm doesn't change superblocks in the manner you suggest - there isn'=
t=20
even an option yet to --update=3Dmetadata. I don't know Debian but it=20
sounds like the dist-upgrade must be doing something odd. Your device=20
names ought to be being preserved. Does doing a dist-upgrade involve a=20
reboot part-way through? It ought to have your mdadm.conf in its initrd=
,=20
or at the very least preserve your hostname, and maybe it doesn't.

The nearest I have seen is booting a system with a rescue CD when=20
existing arrays get auto-assembled with high numbers (from 127 down)=20
which can cause problems the next time you reboot back into the origina=
l=20
system (because the on-disc metadata now thinks the array prefers to be=
=20
e.g. md127 instead of md0). This is all to do with a missing mdadm.conf=
=20
and/or the hostname not matching the arrays' homehost.

[...]
> If we re-check the labels we can see all the devices got the same
> label (the one assigned to md0, md1 etc), so probably grub is trying
> to boot from single devices, and not from the md0 which is /boot

Grub always boots from single devices. This is why you have to use=20
metadata 0.90 or 1.0 with RAID-1 for /boot. Generally the BIOS and=20
therefore grub will boot from the first available drive, so if your=20
normal first drive dies, the second drive becomes the first and you can=
=20
still boot. Having said that, grub2 has real support for md RAID so you=
=20
can boot off any metadata and RAID level with it, as long as the BIOS=20
can read grub off the first drive.

> This is blkid's output:
>
> /dev/sdb1: LABEL=3D"boot" UUID=3D"6d15111c-d2d9-4636-b2a5-7954ddcbcae=
2"
> SEC_TYPE=3D"ext2" TYPE=3D"ext3"
[...]
> /dev/md0: LABEL=3D"boot" UUID=3D"6d15111c-d2d9-4636-b2a5-7954ddcbcae2=
"
> SEC_TYPE=3D"ext2" TYPE=3D"ext3"
[...]
>
> As we have to migrate loads of machines, using labels is the fastest
> and cleanest way to do it. Just create the labels and change
> /etc/fstab across all the machines and voil=E1. But we cannot get it
> running. Is there any workaround to work with labels and avoid all th=
e
> disks in the raid to get them as well?.

As you can see, it doesn't work. This will always happen with mdadm=20
metadata version 0.90 and 1.0 with RAID-1 and is the only way grub can=20
boot at all.

> Using UUID doesn't seem like a good idea, as they may change with
> future dist-upgrades, mdadm upgrades etc.

Using UUID won't work anyway, for the same reasons as using the label=20
doesn't work.

> Has someone had same/similar problem with mdadm?

It's not really a mdadm problem, I think you need to find a way to fix=20
whatever it is that's causing your arrays to be renamed/renumbered.

The only other thing that occurs to me is to check whether the upgrade=20
process gives you a symlink like /dev/md/d0 which points to /dev/md127=20
(and similarly for your original md1-3), and if it does, fix up your=20
Lenny systems to have those symlinks and use them in your fstab.

Sorry I can't give any more positive help.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
