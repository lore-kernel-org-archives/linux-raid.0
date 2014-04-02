From: David Lamparter <equinox@diac24.net>
Subject: [LVM/RAID BUG DATA DESTRUCTION] 3.12.14 raid1 initialisation +
 --write-mostly destroys LV
Date: Wed, 2 Apr 2014 14:03:21 +0200
Message-ID: <20140402120320.GJ113782@jupiter.n2.diac24.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-lvm@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

the following command sequence has very effectively destroyed my LV:
lvconvert --type raid1 -m 1 eidolon/root
lvchange --writemostly /dev/sda4:y --writebehind 32768 eidolon/root

The raid1 was still initialising (around 20%) when I executed the second
command, output from /sys/block/*/stat leads me to believe the sync direction
was inverted from the newly-added device to the existing one.

Kernel: 3.12.14, grsecurity + ZFS loaded
LVM user: 2.02.105 (Gentoo)

dmesg:

[950285.403239]  sdd: sdd1 sdd2 sdd3 sdd4
# lvconvert --type raid1 -m 1 eidolon/root
[950389.625421] device-mapper: raid: Superblocks created for new array
[950389.634143] md/raid1:mdX: not clean -- starting background reconstruction
[950389.641280] md/raid1:mdX: active with 2 out of 2 mirrors
[950389.646919] Choosing daemon_sleep default (5 sec)
[950389.651979] created bitmap (60 pages) for device mdX
[950389.751298] mdX: bitmap file is out of date, doing full recovery
[950389.868315] mdX: bitmap initialized from disk: read 4 pages, set 122880 of 122880 bits
[950389.942126] md: resync of RAID array mdX
[950389.946374] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[950389.952532] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[950389.962448] md: using 128k window, over a total of 62914560k.
# lvchange --writemostly /dev/sda4:y --writebehind 32768 eidolon/root
[950580.214563] md/raid1:mdX: not clean -- starting background reconstruction
[950580.221758] md/raid1:mdX: active with 2 out of 2 mirrors
[950580.227635] created bitmap (60 pages) for device mdX
[950580.487002] md: md_do_sync() got signal ... exiting
[950580.533464] md: checkpointing resync of mdX.
[950580.682165] mdX: bitmap initialized from disk: read 4 pages, set 98948 of 122880 bits
[950580.736789] dmeventd[159770]: segfault at 0 ip 0000034efba75200 sp 000003eb076024a8 error 4 in liblvm2cmd.so.2.02[34efba2e000+10b000]
[950580.773075] md: resync of RAID array mdX
[950580.777345] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[950580.783493] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
[950580.798701] md: using 128k window, over a total of 62914560k.
[950785.257000] ea_get: invalid extended attribute
[950785.261783] ffff880f533cc000: a7 0b 34 06 6a f2 b9 ef cf 4e 32 34 4d 52 49 2d  ..4.j....N24MRI-
[950785.271013] ffff880f533cc010: e9 3d f8 81 aa f9 c4 eb 02 7a 69 06 28 c1 76 55  .=.......zi.(.vU
[... more log messages of fs croaking ...]
[951414.308483] md: mdX: resync done.
[951414.389099] RAID1 conf printout:
[951414.389105]  --- wd:2 rd:2
[951414.389108]  disk 0, wo:0, o:1, dev:dm-4
[951414.389111]  disk 1, wo:0, o:1, dev:dm-6

Status after:

# pvs
  PV         VG      Fmt  Attr PSize   PFree  
  /dev/sda4  eidolon lvm2 a--  297.08g 207.08g
  /dev/sdd4  eidolon lvm2 a--  446.12g 386.12g
# vgs -a
  VG      #PV #LV #SN Attr   VSize   VFree  
  eidolon   2   2   0 wz--n- 743.21g 593.20g
# lvs -a
  LV              VG      Attr       LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
  root            eidolon rwi-aor--- 60.00g                               100.00
  [root_rimage_0] eidolon iwi-aor-w- 60.00g
  [root_rimage_1] eidolon iwi-aor--- 60.00g
  [root_rmeta_0]  eidolon ewi-aor---  4.00m
  [root_rmeta_1]  eidolon ewi-aor---  4.00m
  zfstest         eidolon -wi-ao---- 30.00g


Haven't rebooted the system yet, I assume it won't boot anymore.
(Unless this bug is some kind of RAM/cache corruption, then it might.)

If you need more information, I can still execute tools from RAM, check
out sysfs, etc.  I'll have to reboot in a few hours though.



-David
