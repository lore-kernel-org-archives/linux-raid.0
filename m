From: Mario Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: RAID1: recovery wrongly overrides resync
Date: Fri, 18 Feb 2005 23:37:42 +0100
Message-ID: <cv5qi1$9eb$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I'm running 7 3-mirror-RAID1s md0 to md6 in degraded mode, each of them
with 2 active mirrors hda2,hdc2 to hda9,hdc9.
I subsequently added hde2 to hde9 to the RAID1s and recovery took place:
first on md6, then on md0 to md5 (dunno why it got this sequence, but
I'm sure others do :)). While the recovery of md6/hde8 was still
running, I did a hard-reset to the system (pushed the reset button).
The system came up again and resync took place, first on md6 from
hda9 to hdc9/hde9, all other RAID1s have been in resync DELAYED.
After md6 resync was finished, md0 resync started from hda2 to
hdc2/hde2 and when this was finished, recovery took md5 and *recovery*
started from hda8 to hde8 *without* resync of hdc8. After md5 recovery
finished, md1 to md4 got resynched correctly. Only md5 was not
resynched but just recovered. Before recovery of md5 started, it
definitely was in resync DELAYED. After recovery it wasn't anymore,
but definitely nothing got written to hdc8! A reboot didn't solve the
issue, I had to manually remove and re-add hdc8 to the array to get it
in sync again.

I'm running 2.4.27 kernel built from Debian's kernel-source-2.4.27.

Is this a known issue and/or is it fixed in later kernels already?


regards,
   Mario
-- 
Ho ho ho! I am Santa Claus of Borg. Nice assimilation all together!

