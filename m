From: Sven Hessenmueller <Sven.Hessenmueller@gmx.de>
Subject: trouble with software raid-1 on dm-multipath-devices
Date: Thu, 09 Jun 2005 12:19:34 +0200
Message-ID: <42A817B6.70709@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

hi list!

i want to build a software raid-1 on top of multipath-devices and maybe
need to stack an lvm on top of this (not sure yet).

some details of my trouble by doing so:

my host with 2 HBAs (emulex lp9802) is attached to 2 storage-arrays
(emc symmetrix on different locations) on a dual independet fabric (1
hba on each fabric).

i have 2 paths to each symmetrix - looks like this:


SYMMETRIX1:
 (0 0 0 10) sdb [ready ] (8:16)
 (1 0 0 10) sdr [ready ] (65:16)
SYMMETRIX2:
 (0 0 1 61) sdj [ready ] (8:144)
 (1 0 1 61) sdz [ready ] (65:144)

so i just build the multipath devices:

echo "0 17677440 multipath 2 round-robin 1 0 65:16 round-robin 1 0 
8:16"  | dmsetup create sym1_388

...make the nodes via dmsetup mknodes etc.

to this point all is fine.

but now i want to build a mirror between the syms and *grmbl*:

mdadm -C -l mirror -n 2 /dev/md0 /dev/mapper/sym1_dev388 
/dev/mapper/sym2_dev388

results in:

Jun  8 02:24:09 s01kr606 kernel: md: could not lock dm-7.
Jun  8 02:24:09 s01kr606 kernel: md: error, md_import_device() returned -16

is there any other possibility or any clue to get it working??

i'm using a sles9 with sp1. in the past (kernel 2.4, sles8 w sp3) i got 
the same construction working with md-only (md-multipathing, stacking a 
md-mirror on top and finally stacking an lvm on top of the mirror) but i 
like the multipath implemetation with dm much more...

thanks!

-sven

