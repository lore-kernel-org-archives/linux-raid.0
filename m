From: Massimiliano Masserelli <negro@interim.it>
Subject: RAID1 root - troubles booting in degraded mode
Date: Wed, 30 Oct 2002 00:07:51 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021029230751.GP1472@sgabanaz.interim.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi folks! 

I've taken a look at the ML archives, and found an old thread (06/2002) 
on this subject, but found no solution.

I've a working setup with a two disks RAID1 root, which boots
flawlessly. Troubles arise when simulating hw failure. RAID setup is as
follows:

raiddev                 /dev/md0
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
chunk-size              4

device                  /dev/hda1
raid-disk               0

device                  /dev/hdc1
raid-disk               1

If I disconnect /dev/hda before booting, the kernel tries to initialize
the array, can't access /dev/hda1 (no wonder), marks it as faulty, then
refuses to initialize the array, dieing with a kernel panic, unable to
mount root.

If I disconnect /dev/hdc before booting, the array gets started in
degraded mode, and the startup goes on without a glitch.

If I disconnect /dev/hda and move /dev/hdc to its place (so it's now
/dev/hda), the array gets started in degraded mode and the startup goes
on.

Actually, this is already a workable solution (if the first disk dies, I
just "promote" the second to hda and go looking for a replacement of the
broken disk), but I think this is not _elegant_. 8)

Could anyone help me shedding some light on the subject?

Tnx in advance.
-- 
Massimiliano Masserelli
-------------------------------------------------------------------------------
Mayor: "Uh... try to have her home by eleven."
	--Buffy the Vampire Slayer: Enemies
