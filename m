From: Roman Mamedov <rm@romanrm.ru>
Subject: md RAID1 passes I/O errors to the filesystem despite having alive
 mirrors?
Date: Fri, 15 Mar 2013 04:10:54 +0600
Message-ID: <20130315041054.79eb5dcc@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=uq0LD7tBpDiMa2KGRLZgnv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=uq0LD7tBpDiMa2KGRLZgnv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Should it really be this way?

What happened was:
- a device (sdg1) was added as a write-mostly member to a degraded two-memb=
er RAID1 (md3) and started recovering;
- then it had some I/O errors;
- the filesystem on top of md3 got hit by those errors (see lines by "btrfs=
" below);
- this is despite still having perfectly working and readable mirror sdf1 i=
n the array (!!!);
- shouldn't the reads have been quietly satisfied my md3 from sdf1, instead=
 of just passing the buck^W error
  due to unreadable sdg1 to the higher (filesystem) layer?

Complete dmesg follows:


[  136.796501] md: bind<sdg1>
[  136.819689] RAID1 conf printout:
[  136.819698]  --- wd:1 rd:2
[  136.819704]  disk 0, wo:0, o:1, dev:sdf1
[  136.819709]  disk 1, wo:1, o:1, dev:sdg1
[  136.820156] md: recovery of RAID array md3
[  136.820161] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  136.820165] md: using maximum available idle IO bandwidth (but not more =
than 200000 KB/sec) for recovery.
[  136.820173] md: using 128k window, over a total of 58579264k.
[  136.873333] device label home devid 1 transid 474974 /dev/md3
[  392.463297] CE: hpet increased min_delta_ns to 20113 nsec
[  770.931150] ata11.00: exception Emask 0x0 SAct 0x3f SErr 0x0 action 0x6
[  770.931200] ata11.00: edma_err_cause=3D00000084 pp_flags=3D00000003, dev=
 error, EDMA self-disable
[  770.931246] ata11.00: failed command: READ FPDMA QUEUED
[  770.931294] ata11.00: cmd 60/08:00:48:d3:24/00:00:00:00:00/40 tag 0 ncq =
4096 in
[  770.931294]          res 41/40:34:60:cf:24/40:00:00:00:00/40 Emask 0x9 (=
media error)
[  770.931346] ata11.00: status: { DRDY ERR }
[  770.931382] ata11.00: error: { UNC }
[  770.931419] ata11.00: failed command: READ FPDMA QUEUED
[  770.931465] ata11.00: cmd 60/18:08:20:d3:24/00:00:00:00:00/40 tag 1 ncq =
12288 in
[  770.931465]          res 41/40:00:2c:d3:24/00:00:00:00:00/40 Emask 0x409=
 (media error) <F>
[  770.931514] ata11.00: status: { DRDY ERR }
[  770.931550] ata11.00: error: { UNC }
[  770.931587] ata11.00: failed command: READ FPDMA QUEUED
[  770.931632] ata11.00: cmd 60/10:10:c8:23:25/00:00:00:00:00/40 tag 2 ncq =
8192 in
[  770.931632]          res 41/40:34:60:cf:24/40:00:00:00:00/40 Emask 0x9 (=
media error)
[  770.931687] ata11.00: status: { DRDY ERR }
[  770.931725] ata11.00: error: { UNC }
[  770.931765] ata11.00: failed command: READ FPDMA QUEUED
[  770.931812] ata11.00: cmd 60/10:18:e0:23:25/00:00:00:00:00/40 tag 3 ncq =
8192 in
[  770.931812]          res 41/40:34:60:cf:24/40:00:00:00:00/40 Emask 0x9 (=
media error)
[  770.931871] ata11.00: status: { DRDY ERR }
[  770.931910] ata11.00: error: { UNC }
[  770.931949] ata11.00: failed command: READ FPDMA QUEUED
[  770.931996] ata11.00: cmd 60/10:20:58:71:2d/00:00:00:00:00/40 tag 4 ncq =
8192 in
[  770.931996]          res 41/40:34:60:cf:24/40:00:00:00:00/40 Emask 0x9 (=
media error)
[  770.932056] ata11.00: status: { DRDY ERR }
[  770.932094] ata11.00: error: { UNC }
[  770.932133] ata11.00: failed command: READ FPDMA QUEUED
[  770.932180] ata11.00: cmd 60/20:28:00:5a:0c/00:00:00:00:00/40 tag 5 ncq =
16384 in
[  770.932180]          res 41/40:34:60:cf:24/40:00:00:00:00/40 Emask 0x9 (=
media error)
[  770.932240] ata11.00: status: { DRDY ERR }
[  770.932278] ata11.00: error: { UNC }
[  770.932325] ata11: hard resetting link
[  771.405792] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  771.437732] ata11.00: configured for UDMA/133
[  771.437770] sd 10:0:0:0: [sdg] Unhandled sense code
[  771.437776] sd 10:0:0:0: [sdg] =20
[  771.437781] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[  771.437786] sd 10:0:0:0: [sdg] =20
[  771.437790] Sense Key : Medium Error [current] [descriptor]
[  771.437797] Descriptor sense data with sense descriptors (in hex):
[  771.437800]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[  771.437818]         00 24 cf 60=20
[  771.437827] sd 10:0:0:0: [sdg] =20
[  771.437833] Add. Sense: Unrecovered read error - auto reallocate failed
[  771.437838] sd 10:0:0:0: [sdg] CDB:=20
[  771.437841] Read(10): 28 00 00 24 d3 48 00 00 08 00
[  771.437857] end_request: I/O error, dev sdg, sector 2413384
[  771.437908] btrfs: bdev /dev/md3 errs: wr 0, rd 1, flush 0, corrupt 0, g=
en 0
[  771.437994] sd 10:0:0:0: [sdg] Unhandled sense code
[  771.437999] sd 10:0:0:0: [sdg] =20
[  771.438002] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[  771.438007] sd 10:0:0:0: [sdg] =20
[  771.438010] Sense Key : Medium Error [current] [descriptor]
[  771.438015] Descriptor sense data with sense descriptors (in hex):
[  771.438018]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[  771.438035]         00 24 d3 2c=20
[  771.438043] sd 10:0:0:0: [sdg] =20
[  771.438048] Add. Sense: Unrecovered read error - auto reallocate failed
[  771.438052] sd 10:0:0:0: [sdg] CDB:=20
[  771.438055] Read(10): 28 00 00 24 d3 20 00 00 18 00
[  771.438070] end_request: I/O error, dev sdg, sector 2413356
[  771.438111] btrfs: bdev /dev/md3 errs: wr 0, rd 2, flush 0, corrupt 0, g=
en 0
[  771.438165] btrfs: bdev /dev/md3 errs: wr 0, rd 3, flush 0, corrupt 0, g=
en 0
[  771.438219] sd 10:0:0:0: [sdg] Unhandled sense code
[  771.438224] sd 10:0:0:0: [sdg] =20
[  771.438228] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[  771.438232] sd 10:0:0:0: [sdg] =20
[  771.438235] Sense Key : Medium Error [current] [descriptor]
[  771.438239] Descriptor sense data with sense descriptors (in hex):
[  771.438242]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[  771.438259]         00 24 cf 60=20
[  771.438267] sd 10:0:0:0: [sdg] =20
[  771.438272] Add. Sense: Unrecovered read error - auto reallocate failed
[  771.438276] sd 10:0:0:0: [sdg] CDB:=20
[  771.438279] Read(10): 28 00 00 25 23 c8 00 00 10 00
[  771.438293] end_request: I/O error, dev sdg, sector 2433992
[  771.438334] btrfs: bdev /dev/md3 errs: wr 0, rd 4, flush 0, corrupt 0, g=
en 0
[  771.438386] btrfs: bdev /dev/md3 errs: wr 0, rd 5, flush 0, corrupt 0, g=
en 0
[  771.438440] sd 10:0:0:0: [sdg] Unhandled sense code
[  771.438445] sd 10:0:0:0: [sdg] =20
[  771.438448] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[  771.438453] sd 10:0:0:0: [sdg] =20
[  771.438455] Sense Key : Medium Error [current] [descriptor]
[  771.438460] Descriptor sense data with sense descriptors (in hex):
[  771.438463]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[  771.438479]         00 24 cf 60=20
[  771.438487] sd 10:0:0:0: [sdg] =20
[  771.438492] Add. Sense: Unrecovered read error - auto reallocate failed
[  771.438496] sd 10:0:0:0: [sdg] CDB:=20
[  771.438499] Read(10): 28 00 00 25 23 e0 00 00 10 00
[  771.438513] end_request: I/O error, dev sdg, sector 2434016
[  771.438554] btrfs: bdev /dev/md3 errs: wr 0, rd 6, flush 0, corrupt 0, g=
en 0
[  771.438606] btrfs: bdev /dev/md3 errs: wr 0, rd 7, flush 0, corrupt 0, g=
en 0
[  771.438659] sd 10:0:0:0: [sdg] Unhandled sense code
[  771.438663] sd 10:0:0:0: [sdg] =20
[  771.438667] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[  771.438671] sd 10:0:0:0: [sdg] =20
[  771.438674] Sense Key : Medium Error [current] [descriptor]
[  771.438679] Descriptor sense data with sense descriptors (in hex):
[  771.438681]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[  771.438698]         00 24 cf 60=20
[  771.438706] sd 10:0:0:0: [sdg] =20
[  771.438710] Add. Sense: Unrecovered read error - auto reallocate failed
[  771.438715] sd 10:0:0:0: [sdg] CDB:=20
[  771.438718] Read(10): 28 00 00 2d 71 58 00 00 10 00
[  771.438732] end_request: I/O error, dev sdg, sector 2978136
[  771.438772] btrfs: bdev /dev/md3 errs: wr 0, rd 8, flush 0, corrupt 0, g=
en 0
[  771.438830] sd 10:0:0:0: [sdg] Unhandled sense code
[  771.438835] sd 10:0:0:0: [sdg] =20
[  771.438838] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[  771.438843] sd 10:0:0:0: [sdg] =20
[  771.438846] Sense Key : Medium Error [current] [descriptor]
[  771.438851] Descriptor sense data with sense descriptors (in hex):
[  771.438854]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[  771.438871]         00 24 cf 60=20
[  771.438879] sd 10:0:0:0: [sdg] =20
[  771.438883] Add. Sense: Unrecovered read error - auto reallocate failed
[  771.438887] sd 10:0:0:0: [sdg] CDB:=20
[  771.438890] Read(10): 28 00 00 0c 5a 00 00 00 20 00
[  771.438904] end_request: I/O error, dev sdg, sector 809472
[  771.438945] btrfs: bdev /dev/md3 errs: wr 0, rd 9, flush 0, corrupt 0, g=
en 0
[  771.439011] ata11: EH complete
[  771.439035] btrfs no csum found for inode 31016 start 5668864
[  771.479594] btrfs csum failed ino 31016 off 5668864 csum 2731683453 priv=
ate 0
[ 1077.625955] ata11.00: exception Emask 0x0 SAct 0x7 SErr 0x0 action 0x6
[ 1077.626008] ata11.00: edma_err_cause=3D00000084 pp_flags=3D00000003, dev=
 error, EDMA self-disable
[ 1077.626060] ata11.00: failed command: READ FPDMA QUEUED
[ 1077.626110] ata11.00: cmd 60/08:00:48:9e:22/00:00:00:00:00/40 tag 0 ncq =
4096 in
[ 1077.626110]          res 41/40:00:49:9e:22/00:00:00:00:00/40 Emask 0x409=
 (media error) <F>
[ 1077.626172] ata11.00: status: { DRDY ERR }
[ 1077.626211] ata11.00: error: { UNC }
[ 1077.626251] ata11.00: failed command: READ FPDMA QUEUED
[ 1077.626298] ata11.00: cmd 60/20:08:80:a7:04/00:00:00:00:00/40 tag 1 ncq =
16384 in
[ 1077.626298]          res 41/40:14:78:e8:84/40:00:00:00:00/40 Emask 0x9 (=
media error)
[ 1077.626358] ata11.00: status: { DRDY ERR }
[ 1077.626396] ata11.00: error: { UNC }
[ 1077.626435] ata11.00: failed command: READ FPDMA QUEUED
[ 1077.626482] ata11.00: cmd 60/08:10:78:e8:84/00:00:00:00:00/40 tag 2 ncq =
4096 in
[ 1077.626482]          res 41/40:14:78:e8:84/40:00:00:00:00/40 Emask 0x9 (=
media error)
[ 1077.626541] ata11.00: status: { DRDY ERR }
[ 1077.626580] ata11.00: error: { UNC }
[ 1077.626625] ata11: hard resetting link
[ 1078.100560] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1078.132516] ata11.00: configured for UDMA/133
[ 1078.132552] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1078.132558] sd 10:0:0:0: [sdg] =20
[ 1078.132563] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1078.132568] sd 10:0:0:0: [sdg] =20
[ 1078.132571] Sense Key : Medium Error [current] [descriptor]
[ 1078.132578] Descriptor sense data with sense descriptors (in hex):
[ 1078.132581]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1078.132600]         00 22 9e 49=20
[ 1078.132609] sd 10:0:0:0: [sdg] =20
[ 1078.132615] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1078.132620] sd 10:0:0:0: [sdg] CDB:=20
[ 1078.132623] Read(10): 28 00 00 22 9e 48 00 00 08 00
[ 1078.132639] end_request: I/O error, dev sdg, sector 2268745
[ 1078.132690] btrfs: bdev /dev/md3 errs: wr 0, rd 10, flush 0, corrupt 0, =
gen 0
[ 1078.132763] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1078.132768] sd 10:0:0:0: [sdg] =20
[ 1078.132772] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1078.132776] sd 10:0:0:0: [sdg] =20
[ 1078.132779] Sense Key : Medium Error [current] [descriptor]
[ 1078.132784] Descriptor sense data with sense descriptors (in hex):
[ 1078.132787]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1078.132804]         00 84 e8 78=20
[ 1078.132813] sd 10:0:0:0: [sdg] =20
[ 1078.132817] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1078.132822] sd 10:0:0:0: [sdg] CDB:=20
[ 1078.132825] Read(10): 28 00 00 04 a7 80 00 00 20 00
[ 1078.132839] end_request: I/O error, dev sdg, sector 305024
[ 1078.132882] btrfs: bdev /dev/md3 errs: wr 0, rd 11, flush 0, corrupt 0, =
gen 0
[ 1078.132935] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1078.132940] sd 10:0:0:0: [sdg] =20
[ 1078.132943] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1078.132948] sd 10:0:0:0: [sdg] =20
[ 1078.132951] Sense Key : Medium Error [current] [descriptor]
[ 1078.132955] Descriptor sense data with sense descriptors (in hex):
[ 1078.132958]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1078.132975]         00 84 e8 78=20
[ 1078.132983] sd 10:0:0:0: [sdg] =20
[ 1078.132988] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1078.132992] sd 10:0:0:0: [sdg] CDB:=20
[ 1078.132995] Read(10): 28 00 00 84 e8 78 00 00 08 00
[ 1078.133009] end_request: I/O error, dev sdg, sector 8710264
[ 1078.133051] btrfs: bdev /dev/md3 errs: wr 0, rd 12, flush 0, corrupt 0, =
gen 0
[ 1078.133107] ata11: EH complete
[ 1078.133264] btrfs no csum found for inode 75312 start 679936
[ 1078.166233] btrfs csum failed ino 75312 off 679936 csum 922519264 privat=
e 0
[ 1170.907244] ata11.00: exception Emask 0x0 SAct 0x1df164 SErr 0x0 action =
0x6
[ 1170.907283] ata11.00: edma_err_cause=3D00000084 pp_flags=3D00000003, dev=
 error, EDMA self-disable
[ 1170.907321] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.907357] ata11.00: cmd 60/18:10:28:5a:b6/00:00:00:00:00/40 tag 2 ncq =
12288 in
[ 1170.907357]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.907400] ata11.00: status: { DRDY ERR }
[ 1170.907431] ata11.00: error: { UNC }
[ 1170.907462] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.907497] ata11.00: cmd 60/10:28:68:cf:4e/00:00:01:00:00/40 tag 5 ncq =
8192 in
[ 1170.907497]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.907539] ata11.00: status: { DRDY ERR }
[ 1170.907569] ata11.00: error: { UNC }
[ 1170.907600] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.907635] ata11.00: cmd 60/08:30:30:38:76/00:00:01:00:00/40 tag 6 ncq =
4096 in
[ 1170.907635]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.907676] ata11.00: status: { DRDY ERR }
[ 1170.907707] ata11.00: error: { UNC }
[ 1170.907738] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.907772] ata11.00: cmd 60/08:40:90:b5:84/00:00:01:00:00/40 tag 8 ncq =
4096 in
[ 1170.907772]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.907813] ata11.00: status: { DRDY ERR }
[ 1170.907844] ata11.00: error: { UNC }
[ 1170.907875] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.907910] ata11.00: cmd 60/08:60:50:8a:de/00:00:01:00:00/40 tag 12 ncq=
 4096 in
[ 1170.907910]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.907951] ata11.00: status: { DRDY ERR }
[ 1170.907982] ata11.00: error: { UNC }
[ 1170.908013] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.908047] ata11.00: cmd 60/08:68:d8:d6:de/00:00:01:00:00/40 tag 13 ncq=
 4096 in
[ 1170.908047]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.908089] ata11.00: status: { DRDY ERR }
[ 1170.908120] ata11.00: error: { UNC }
[ 1170.908151] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.908185] ata11.00: cmd 60/08:70:e0:94:0c/00:00:02:00:00/40 tag 14 ncq=
 4096 in
[ 1170.908185]          res 41/40:00:e5:94:0c/00:00:02:00:00/40 Emask 0x409=
 (media error) <F>
[ 1170.908227] ata11.00: status: { DRDY ERR }
[ 1170.908257] ata11.00: error: { UNC }
[ 1170.908288] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.908323] ata11.00: cmd 60/18:78:a8:4d:ff/00:00:02:00:00/40 tag 15 ncq=
 12288 in
[ 1170.908323]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.908364] ata11.00: status: { DRDY ERR }
[ 1170.908395] ata11.00: error: { UNC }
[ 1170.908426] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.908460] ata11.00: cmd 60/08:80:f8:c4:0e/00:00:03:00:00/40 tag 16 ncq=
 4096 in
[ 1170.908460]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.908501] ata11.00: status: { DRDY ERR }
[ 1170.908532] ata11.00: error: { UNC }
[ 1170.908563] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.908598] ata11.00: cmd 60/28:90:a8:57:1d/00:00:03:00:00/40 tag 18 ncq=
 20480 in
[ 1170.908598]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.908639] ata11.00: status: { DRDY ERR }
[ 1170.908670] ata11.00: error: { UNC }
[ 1170.908701] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.908735] ata11.00: cmd 60/08:98:b8:2a:23/00:00:03:00:00/40 tag 19 ncq=
 4096 in
[ 1170.908735]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.908777] ata11.00: status: { DRDY ERR }
[ 1170.908807] ata11.00: error: { UNC }
[ 1170.908838] ata11.00: failed command: READ FPDMA QUEUED
[ 1170.908873] ata11.00: cmd 60/08:a0:40:d6:27/00:00:03:00:00/40 tag 20 ncq=
 4096 in
[ 1170.908873]          res 41/40:a4:40:d6:27/40:00:03:00:00/40 Emask 0x9 (=
media error)
[ 1170.908914] ata11.00: status: { DRDY ERR }
[ 1170.908945] ata11.00: error: { UNC }
[ 1170.908979] ata11: hard resetting link
[ 1171.381909] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1171.398235] ata11.00: configured for UDMA/133
[ 1171.398279] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.398286] sd 10:0:0:0: [sdg] =20
[ 1171.398291] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.398296] sd 10:0:0:0: [sdg] =20
[ 1171.398299] Sense Key : Medium Error [current] [descriptor]
[ 1171.398306] Descriptor sense data with sense descriptors (in hex):
[ 1171.398309]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.398329]         03 27 d6 40=20
[ 1171.398338] sd 10:0:0:0: [sdg] =20
[ 1171.398344] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.398349] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.398352] Read(10): 28 00 00 b6 5a 28 00 00 18 00
[ 1171.398368] end_request: I/O error, dev sdg, sector 11950632
[ 1171.398419] btrfs: bdev /dev/md3 errs: wr 0, rd 13, flush 0, corrupt 0, =
gen 0
[ 1171.398480] btrfs: bdev /dev/md3 errs: wr 0, rd 14, flush 0, corrupt 0, =
gen 0
[ 1171.398552] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.398557] sd 10:0:0:0: [sdg] =20
[ 1171.398561] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.398566] sd 10:0:0:0: [sdg] =20
[ 1171.398569] Sense Key : Medium Error [current] [descriptor]
[ 1171.398574] Descriptor sense data with sense descriptors (in hex):
[ 1171.398577]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.398594]         03 27 d6 40=20
[ 1171.398603] sd 10:0:0:0: [sdg] =20
[ 1171.398607] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.398612] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.398614] Read(10): 28 00 01 4e cf 68 00 00 10 00
[ 1171.398629] end_request: I/O error, dev sdg, sector 21942120
[ 1171.398672] btrfs: bdev /dev/md3 errs: wr 0, rd 15, flush 0, corrupt 0, =
gen 0
[ 1171.398728] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.398733] sd 10:0:0:0: [sdg] =20
[ 1171.398736] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.398741] sd 10:0:0:0: [sdg] =20
[ 1171.398744] Sense Key : Medium Error [current] [descriptor]
[ 1171.398748] Descriptor sense data with sense descriptors (in hex):
[ 1171.398751]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.398769]         03 27 d6 40=20
[ 1171.398777] sd 10:0:0:0: [sdg] =20
[ 1171.398781] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.398786] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.398788] Read(10): 28 00 01 76 38 30 00 00 08 00
[ 1171.398803] end_request: I/O error, dev sdg, sector 24524848
[ 1171.398845] btrfs: bdev /dev/md3 errs: wr 0, rd 16, flush 0, corrupt 0, =
gen 0
[ 1171.398900] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.398904] sd 10:0:0:0: [sdg] =20
[ 1171.398908] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.398912] sd 10:0:0:0: [sdg] =20
[ 1171.398915] Sense Key : Medium Error [current] [descriptor]
[ 1171.398920] Descriptor sense data with sense descriptors (in hex):
[ 1171.398923]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.398940]         03 27 d6 40=20
[ 1171.398948] sd 10:0:0:0: [sdg] =20
[ 1171.398953] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.398957] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.398960] Read(10): 28 00 01 84 b5 90 00 00 08 00
[ 1171.398974] end_request: I/O error, dev sdg, sector 25474448
[ 1171.399016] btrfs: bdev /dev/md3 errs: wr 0, rd 17, flush 0, corrupt 0, =
gen 0
[ 1171.399070] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.399075] sd 10:0:0:0: [sdg] =20
[ 1171.399079] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.399083] sd 10:0:0:0: [sdg] =20
[ 1171.399086] Sense Key : Medium Error [current] [descriptor]
[ 1171.399091] Descriptor sense data with sense descriptors (in hex):
[ 1171.399093]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.399111]         03 27 d6 40=20
[ 1171.399119] sd 10:0:0:0: [sdg] =20
[ 1171.399123] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.399128] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.399131] Read(10): 28 00 01 de 8a 50 00 00 08 00
[ 1171.399145] end_request: I/O error, dev sdg, sector 31361616
[ 1171.399187] btrfs: bdev /dev/md3 errs: wr 0, rd 18, flush 0, corrupt 0, =
gen 0
[ 1171.399240] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.399245] sd 10:0:0:0: [sdg] =20
[ 1171.399248] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.399253] sd 10:0:0:0: [sdg] =20
[ 1171.399256] Sense Key : Medium Error [current] [descriptor]
[ 1171.399261] Descriptor sense data with sense descriptors (in hex):
[ 1171.399263]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.399281]         03 27 d6 40=20
[ 1171.399289] sd 10:0:0:0: [sdg] =20
[ 1171.399293] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.399298] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.399300] Read(10): 28 00 01 de d6 d8 00 00 08 00
[ 1171.399315] end_request: I/O error, dev sdg, sector 31381208
[ 1171.399356] btrfs: bdev /dev/md3 errs: wr 0, rd 19, flush 0, corrupt 0, =
gen 0
[ 1171.399410] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.399415] sd 10:0:0:0: [sdg] =20
[ 1171.399419] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.399423] sd 10:0:0:0: [sdg] =20
[ 1171.399426] Sense Key : Medium Error [current] [descriptor]
[ 1171.399431] Descriptor sense data with sense descriptors (in hex):
[ 1171.399433]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.399451]         02 0c 94 e5=20
[ 1171.399459] sd 10:0:0:0: [sdg] =20
[ 1171.399463] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.399468] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.399470] Read(10): 28 00 02 0c 94 e0 00 00 08 00
[ 1171.399484] end_request: I/O error, dev sdg, sector 34378981
[ 1171.399526] btrfs: bdev /dev/md3 errs: wr 0, rd 20, flush 0, corrupt 0, =
gen 0
[ 1171.399581] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.399586] sd 10:0:0:0: [sdg] =20
[ 1171.399589] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.399593] sd 10:0:0:0: [sdg] =20
[ 1171.399596] Sense Key : Medium Error [current] [descriptor]
[ 1171.399601] Descriptor sense data with sense descriptors (in hex):
[ 1171.399604]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.399621]         03 27 d6 40=20
[ 1171.399629] sd 10:0:0:0: [sdg] =20
[ 1171.399633] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.399638] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.399641] Read(10): 28 00 02 ff 4d a8 00 00 18 00
[ 1171.399655] end_request: I/O error, dev sdg, sector 50285992
[ 1171.399697] btrfs: bdev /dev/md3 errs: wr 0, rd 21, flush 0, corrupt 0, =
gen 0
[ 1171.399745] btrfs: bdev /dev/md3 errs: wr 0, rd 22, flush 0, corrupt 0, =
gen 0
[ 1171.399799] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.399804] sd 10:0:0:0: [sdg] =20
[ 1171.399808] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.399812] sd 10:0:0:0: [sdg] =20
[ 1171.399815] Sense Key : Medium Error [current] [descriptor]
[ 1171.399820] Descriptor sense data with sense descriptors (in hex):
[ 1171.399822]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.399840]         03 27 d6 40=20
[ 1171.399848] sd 10:0:0:0: [sdg] =20
[ 1171.399852] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.399857] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.399859] Read(10): 28 00 03 0e c4 f8 00 00 08 00
[ 1171.399873] end_request: I/O error, dev sdg, sector 51299576
[ 1171.399928] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.399933] sd 10:0:0:0: [sdg] =20
[ 1171.399936] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.399941] sd 10:0:0:0: [sdg] =20
[ 1171.399943] Sense Key : Medium Error [current] [descriptor]
[ 1171.399948] Descriptor sense data with sense descriptors (in hex):
[ 1171.399951]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.399968]         03 27 d6 40=20
[ 1171.399976] sd 10:0:0:0: [sdg] =20
[ 1171.399981] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.399985] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.399988] Read(10): 28 00 03 1d 57 a8 00 00 28 00
[ 1171.400002] end_request: I/O error, dev sdg, sector 52254632
[ 1171.400510] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.400515] sd 10:0:0:0: [sdg] =20
[ 1171.400518] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.400523] sd 10:0:0:0: [sdg] =20
[ 1171.400526] Sense Key : Medium Error [current] [descriptor]
[ 1171.400531] Descriptor sense data with sense descriptors (in hex):
[ 1171.400533]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.400551]         03 27 d6 40=20
[ 1171.400559] sd 10:0:0:0: [sdg] =20
[ 1171.400563] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.400568] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.400570] Read(10): 28 00 03 23 2a b8 00 00 08 00
[ 1171.400596] sd 10:0:0:0: [sdg] Unhandled sense code
[ 1171.400601] sd 10:0:0:0: [sdg] =20
[ 1171.400604] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[ 1171.400609] sd 10:0:0:0: [sdg] =20
[ 1171.400612] Sense Key : Medium Error [current] [descriptor]
[ 1171.400616] Descriptor sense data with sense descriptors (in hex):
[ 1171.400619]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[ 1171.400636]         03 27 d6 40=20
[ 1171.400644] sd 10:0:0:0: [sdg] =20
[ 1171.400648] Add. Sense: Unrecovered read error - auto reallocate failed
[ 1171.400653] sd 10:0:0:0: [sdg] CDB:=20
[ 1171.400655] Read(10): 28 00 03 27 d6 40 00 00 08 00
[ 1171.400688] ata11: EH complete
[ 1326.391405] md: md3: recovery done.
[ 1326.473189] RAID1 conf printout:
[ 1326.473199]  --- wd:2 rd:2
[ 1326.473206]  disk 0, wo:0, o:1, dev:sdf1
[ 1326.473212]  disk 1, wo:0, o:1, dev:sdg1

--=20
With respect,
Roman

--Sig_/=uq0LD7tBpDiMa2KGRLZgnv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFCSu4ACgkQTLKSvz+PZwhWnwCdGxGvMcAODXSeeXJhFp5D4gYX
n+QAn0S60D9CFnqn5e+wgIfKQH9+fcGX
=0JEj
-----END PGP SIGNATURE-----

--Sig_/=uq0LD7tBpDiMa2KGRLZgnv--
