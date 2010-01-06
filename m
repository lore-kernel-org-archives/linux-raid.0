From: Michael Evans <mjevans1983@gmail.com>
Subject: Re:
Date: Wed, 6 Jan 2010 12:21:35 -0800
Message-ID: <4877c76c1001061221w582efcfdudc9a33c0f74a756a@mail.gmail.com>
References: <600349.38000.qm@web88207.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <600349.38000.qm@web88207.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lapohos Tibor <tibor.lapohos@rogers.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 6, 2010 at 6:19 AM, Lapohos Tibor <tibor.lapohos@rogers.com=
> wrote:
> Hello,
>
> I successfully set up an Intel Matrix Raid device with a RAID1 and a =
RAID0 volume, each having a couple of partitions, but then I could not =
install GRUB2 on the RAID1 volume, which I wanted to use to boot from a=
nd mount as root. It turned out that the "IMSM" metadata is not support=
ed in GRUB2 (v1.97.1) just yet, so I had to turn away from my original =
plan.
>
> To "imitate" the setup I originally wanded, I turned both of my drive=
s into AHCI controlled devices in the BIOS (instead of RAID), and I par=
titioned them to obtain /dev/sda[12] and /dev/sdb[12].
>
> Then I used /dev/sd[ab]1 to build a RAID1 set, and /dev/sd[ab]2 to cr=
eate a RAID0 set using mdadm v 3.0.3:
>
>> mdadm -C /dev/md0 -v -e 0 -l 1 -n 2 /dev/sda1 /dev/sdb1
>> mdadm -C /dev/md1 -v -e 0 -l 0 -n 2 /dev/sda2 /dev/sdb2
>
> I set the metadata type to 0.90 because I would like to boot from it =
and allow the kernel to auto-detect the RAID devices while it's booting=
, in order to can get away from using an intitrd (I am building my own =
distribution based on CLFS x86_64 multilib).
>
> I used cfdisk to partition both of the /dev/md[01] devices, and I obt=
ained /dev/md0p[123] and /dev/md1p[12]. The plan is to use /dev/md0p1 a=
s a RAID1 root partition, and have the system boot from /dev/md0. I for=
matted /dev/md0p1 as
>
>> mk2efs -t ext4 -L OS /dev/md0p1
>
> To this point, things went smoothly. mdadm -D... and mdadm -E... did =
report back working devices as intended. Then mounted /dev/md0p1 on a d=
irectory called /root/os, and I did
>
>> grub-install --root-directory=3D/root/os /dev/md0
>
> or
>
>> grub-install --root-directory=3D/root/os "md0"
>
> and I got a warning and an error message: "Your embedding area is unu=
sually small. =A0core.img won't fit in it." and "Embedding is not possi=
ble, but this is required when the root device is on a RAID array or LV=
M volume."
>
> What did I do wrong, and how do I fix it? Thanks ahead,
> Tibor
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Grub wants to embed (copy it's executable) in to the area between the
MBR style layout (sector 0 of a drive) and the first partition on that
drive (typically starts as early as sector 63).  Try starting the
first partition at something like a 1 or 2 mb offset from the start of
the drive.  That should likely be enough space.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
