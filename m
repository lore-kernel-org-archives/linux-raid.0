From: Michael Robinton <michael@bizsystems.com>
Subject: (unknown)
Date: Tue, 29 Oct 2002 17:26:23 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0210291720140.7119-100000@pandora.is.bizsystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>I've taken a look at the ML archives, and found an old thread (06/2002)
>on this subject, but found no solution.
>
>I've a working setup with a two disks RAID1 root, which boots
>flawlessly. Troubles arise when simulating hw failure. RAID setup is as
>follows:
>
>raiddev                 /dev/md0
>raid-level              1
>nr-raid-disks           2
>nr-spare-disks          0
>chunk-size              4
>
>device                  /dev/hda1
>raid-disk               0
>
>device                  /dev/hdc1
>raid-disk               1

>If I disconnect /dev/hda before booting, the kernel tries to initialize
>the array, can't access /dev/hda1 (no wonder), marks it as faulty, then
>refuses to initialize the array, dieing with a kernel panic, unable to
>mount root.
>
>If I disconnect /dev/hdc before booting, the array gets started in
>degraded mode, and the startup goes on without a glitch.
>
>If I disconnect /dev/hda and move /dev/hdc to its place (so it's now
>/dev/hda), the array gets started in degraded mode and the startup goes
>on.
>
>Actually, this is already a workable solution (if the first disk dies, I
>just "promote" the second to hda and go looking for a replacement of the
>broken disk), but I think this is not _elegant_. 8)
>
>Could anyone help me shedding some light on the subject?
>
>Tnx in advance.
>--
>Massimiliano Masserelli

There is no standard for the behavior of the motherboard bios when the
first device 0x80 is not available at boot time. Some motherboards will
automove 0x81 -> 0x80, some can do it as a bios change, some you're stuck.

Most scsii controllers will do this and a few IDE controllers will as
well.

Generally for best flexibility, use an independent lilo file for each hard
disk and set the boot disk pointer individually for each drive to 0x80 or
0x81 as needed for your environment rather than using the "raid" feature
of lilo.

See the Boot-Root-Raid-LILO howto for examples. This doc is a bit out of
date, but the examples and setups are all applicable for the 2.4 series
kernels.

Michael

