From: Emilio Gargiulo <emilio.gargiulo@infinito.it>
Subject: Re: RAID1 root - troubles booting in degraded mode
Date: Wed, 30 Oct 2002 21:18:13 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210302118.13644.emilio.gargiulo@infinito.it>
References: <20021029230751.GP1472@sgabanaz.interim.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021029230751.GP1472@sgabanaz.interim.it>
To: Massimiliano Masserelli <negro@interim.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Massimiliano
Have you tryed to set partition id to 0xFD <raid autodetect>, and use a=
 boot=20
string as:
root=3D/dev/md1 ro devfs=3Dmount vga=3D791
I have the same configuration, and I have a grub bootloader on each rai=
d disk.

Emilio Gargiulo

Alle 00:07, mercoled=EC 30 ottobre 2002, Massimiliano Masserelli ha scr=
itto:
> Hi folks!
>
> I've taken a look at the ML archives, and found an old thread (06/200=
2)
> on this subject, but found no solution.
>
> I've a working setup with a two disks RAID1 root, which boots
> flawlessly. Troubles arise when simulating hw failure. RAID setup is =
as
> follows:
>
> raiddev                 /dev/md0
> raid-level              1
> nr-raid-disks           2
> nr-spare-disks          0
> chunk-size              4
>
> device                  /dev/hda1
> raid-disk               0
>
> device                  /dev/hdc1
> raid-disk               1
>
> If I disconnect /dev/hda before booting, the kernel tries to initiali=
ze
> the array, can't access /dev/hda1 (no wonder), marks it as faulty, th=
en
> refuses to initialize the array, dieing with a kernel panic, unable t=
o
> mount root.
>
> If I disconnect /dev/hdc before booting, the array gets started in
> degraded mode, and the startup goes on without a glitch.
>
> If I disconnect /dev/hda and move /dev/hdc to its place (so it's now
> /dev/hda), the array gets started in degraded mode and the startup go=
es
> on.
>
> Actually, this is already a workable solution (if the first disk dies=
, I
> just "promote" the second to hda and go looking for a replacement of =
the
> broken disk), but I think this is not _elegant_. 8)
>
> Could anyone help me shedding some light on the subject?
>
> Tnx in advance.

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
