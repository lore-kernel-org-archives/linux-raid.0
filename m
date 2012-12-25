From: Jaap Winius <jwinius@umrk.nl>
Subject: Re: Can this array be recovered?
Date: Tue, 25 Dec 2012 17:06:39 +0000 (UTC)
Message-ID: <kbcmeu$ste$3@ger.gmane.org>
References: <kbb975$nj1$1@ger.gmane.org> <50D9422F.9010403@turmel.org>
	<kbcgf7$ste$1@ger.gmane.org> <kbcibm$ste$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 Dec 2012 15:56:38 +0000, Jaap Winius wrote:

> # pvscan -u
>   Incorrect metadata area header checksum PV /dev/md2 with UUID
>   0iEU34-XNSd-vNpu-G3uW-2F1v-wEy9-Bw199N VG
> volgrp3         lvm2 [931.51 GiB / 11.51 GiB free]
>   PV /dev/md0 with UUID Lb3KzG-9tZM-5MbQ-1DUa-5ErW-DYf1-NqvMJW VG
> volgrp1         lvm2 [697.70 GiB / 5.44 GiB free]
>   PV /dev/md1 with UUID uWDdXr-8fRw-aJDG-SzdQ-
> yeIl-6dsv-28vJYs                    lvm2 [697.70 GiB]
>   Total: 3 [2.27 TiB] / in use: 2 [1.59 TiB] / in no VG: 1 [697.70 GiB]
> 
> That last UUID is still associated with a bunch of volgrp2 objects in my
> current LVM configuration (the old LVM volume on /dev/md1), even though
> pvscan currently doesn't recognize it as such.

All that was needed at this point involved some LVM recovery procedures. 
I did it like this:

# pvcreate --uuid uWDdXr-8fRw-aJDG-SzdQ-yeIl-6dsv-28vJYs --restorefile /
etc/lvm/archive/volgrp2_00007.vg /dev/md1
  Incorrect metadata area header checksum
  Incorrect metadata area header checksum
  Incorrect metadata area header checksum
  Incorrect metadata area header checksum
  Incorrect metadata area header checksum
  Physical volume "/dev/md1" successfully created

This restored my original LVM physical volume. However, the original 
volume group was missing. To fix that I created one with the same name on 
that same physical device:

# vgcreate -v volgrp2 /dev/md1
    Wiping cache of LVM-capable devices
    Wiping cache of LVM-capable devices
    Adding physical volume '/dev/md1' to volume group 'volgrp2'
    Archiving volume group "volgrp2" metadata (seqno 0).
    Creating volume group backup "/etc/lvm/backup/volgrp2" (seqno 1).
  Volume group "volgrp2" successfully created

Okay, but at this point the problem was that my logical volumes had yet 
to be restored

# vgcfgrestore -f /u21/backup/bitis/etc/2012-12-24@01:02:12/lvm/backup/
volgrp2 volgrp2
  Restored volume group volgrp2

This restored the volume group descriptor area from an older automatic  
backup file for this volume group. It worked: my old vicepb volume was 
back! Still, I couldn't mount it until I did this:

~# vgchange -ay
  3 logical volume(s) in volume group "volgrp3" now active
  1 logical volume(s) in volume group "volgrp2" now active
  6 logical volume(s) in volume group "volgrp1" now active

Finally, this allowed me to mount my volume and make all my data 
available once again. 

Thanks Phil!

Chritmas cheers,

Jaap

