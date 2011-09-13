From: Andriano <chief000@gmail.com>
Subject: RAID6 issues
Date: Tue, 13 Sep 2011 16:14:51 +1000
Message-ID: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Linux-RAID mailing list,

I have an issue with my RAID6 array.
Here goes a short description of the system:

opensuse 11.4
Linux 3.0.4-2-desktop #1 SMP PREEMPT Wed Aug 31 09:30:44 UTC 2011
(a432f18) x86_64 x86_64 x86_64 GNU/Linux
Gigabyte EP35C-DS3 motherboard with 8 SATA ports + SuperMicro
AOC-SASLP-MV8 based on Marvel 6480, firmware updated to 3.1.0.21
running mdadm 3.2.2, single array consists of 10 2T disks, 8 of them
connected to the HBA, 2 - motherboard ports

I had some issues with one of the onboard connected disks, so tried to
plug it to different ports, just to eliminate possibly faulty port.
After reboot, suddenly other drives got kicked out from the array.
Re-assembling them gives weird errors.

--- some output ---
[3:0:0:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdb
[5:0:0:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdc
[8:0:0:0]    disk    ATA      ST32000542AS     CC34  /dev/sdd
[8:0:1:0]    disk    ATA      ST32000542AS     CC34  /dev/sde
[8:0:2:0]    disk    ATA      ST32000542AS     CC34  /dev/sdf
[8:0:3:0]    disk    ATA      ST32000542AS     CC34  /dev/sdg
[8:0:4:0]    disk    ATA      ST32000542AS     CC34  /dev/sdh
[8:0:5:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdi
[8:0:6:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdj
[8:0:7:0]    disk    ATA      ST2000DL003-9VT1 CC32  /dev/sdk

#more /etc/mdadm.conf
DEVICE partitions
ARRAY /dev/md0 level=raid6 UUID=82ac7386:a854194d:81b795d1:76c9c9ff

#mdadm --assemble --force --scan /dev/md0
mdadm: failed to add /dev/sdc to /dev/md0: Invalid argument
mdadm: failed to add /dev/sdb to /dev/md0: Invalid argument
mdadm: failed to add /dev/sdh to /dev/md0: Invalid argument
mdadm: /dev/md0 assembled from 7 drives - not enough to start the array.

dmesg:
[ 8215.651860] md: sdc does not have a valid v1.2 superblock, not importing!
[ 8215.651865] md: md_import_device returned -22
[ 8215.652384] md: sdb does not have a valid v1.2 superblock, not importing!
[ 8215.652388] md: md_import_device returned -22
[ 8215.653177] md: sdh does not have a valid v1.2 superblock, not importing!
[ 8215.653182] md: md_import_device returned -22

mdadm -E /dev/sd[b..k] gives exactly the same Magic number and Array
UUID for every disk, all checksums are correct,
the only difference is -  Avail Dev Size : 3907028896 is the same for
9 disks, and 3907028864 for sdc

mdadm --assemble --force --update summaries /dev/sd.. - didn't improve anything


I would really appreciate if someone could point me to the right direction.

thanks

Andrew
