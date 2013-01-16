From: Roman Mamedov <rm@romanrm.ru>
Subject: "redirecting sector nnnnn to other mirror?"
Date: Wed, 16 Jan 2013 15:24:50 +0600
Message-ID: <20130116152450.16034e02@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XzYASeIs71qUBGBqNP+Q9hb"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XzYASeIs71qUBGBqNP+Q9hb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

On kernel 3.6.11,

md3 : active raid1 sdf1[3] sdg4[2](W)
      58579264 blocks super 1.2 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 131072KB chunk

When sdf1 developed some I/O errors, mdadm shows it had to redirect the req=
uest to
"other" mirror, which according to it was... sdf1.

[65786.407900] md/raid1:md3: redirecting sector 2169824 to other mirror: sd=
f1

Maybe it's just that the message is worded in this way, but the above makes=
 me assume
that "other mirror: sdf1" means that sdf1 *is* the "other mirror".

What I feel would make more sense:

[65786.407900] md/raid1:md3: redirecting sector 2169824 of sdf1 to other mi=
rror: sdg4

Or maybe it is a genuine bug, and it did not try sdg4 (because it is marked=
 write-mostly)?

Complete log follows:


[65785.842760] ata8.00: exception Emask 0x0 SAct 0xffffff SErr 0x0 action 0=
x6 frozen
[65785.842784] ata8.00: failed command: READ FPDMA QUEUED
[65785.842806] ata8.00: cmd 60/88:00:d8:22:22/00:00:00:00:00/40 tag 0 ncq 6=
9632 in
[65785.842806]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.842828] ata8.00: status: { DRDY }
[65785.842838] ata8.00: failed command: READ FPDMA QUEUED
[65785.842856] ata8.00: cmd 60/88:08:d8:22:22/00:00:00:00:00/40 tag 1 ncq 6=
9632 in
[65785.842856]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.842883] ata8.00: status: { DRDY }
[65785.842895] ata8.00: failed command: READ FPDMA QUEUED
[65785.842914] ata8.00: cmd 60/08:10:38:3d:26/00:00:02:00:00/40 tag 2 ncq 4=
096 in
[65785.842914]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.842946] ata8.00: status: { DRDY }
[65785.842957] ata8.00: failed command: READ FPDMA QUEUED
[65785.842977] ata8.00: cmd 60/88:18:d8:22:22/00:00:00:00:00/40 tag 3 ncq 6=
9632 in
[65785.842977]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843007] ata8.00: status: { DRDY }
[65785.843020] ata8.00: failed command: READ FPDMA QUEUED
[65785.843038] ata8.00: cmd 60/80:20:60:23:22/00:00:00:00:00/40 tag 4 ncq 6=
5536 in
[65785.843038]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843067] ata8.00: status: { DRDY }
[65785.843079] ata8.00: failed command: READ FPDMA QUEUED
[65785.843098] ata8.00: cmd 60/90:28:e0:23:22/00:00:00:00:00/40 tag 5 ncq 7=
3728 in
[65785.843098]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843128] ata8.00: status: { DRDY }
[65785.843140] ata8.00: failed command: READ FPDMA QUEUED
[65785.843158] ata8.00: cmd 60/88:30:70:24:22/00:00:00:00:00/40 tag 6 ncq 6=
9632 in
[65785.843158]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843187] ata8.00: status: { DRDY }
[65785.843199] ata8.00: failed command: READ FPDMA QUEUED
[65785.843217] ata8.00: cmd 60/08:38:f8:24:22/01:00:00:00:00/40 tag 7 ncq 1=
35168 in
[65785.843217]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843253] ata8.00: status: { DRDY }
[65785.843264] ata8.00: failed command: READ FPDMA QUEUED
[65785.843282] ata8.00: cmd 60/78:40:00:26:22/00:00:00:00:00/40 tag 8 ncq 6=
1440 in
[65785.843282]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843312] ata8.00: status: { DRDY }
[65785.843323] ata8.00: failed command: READ FPDMA QUEUED
[65785.843342] ata8.00: cmd 60/18:48:78:26:22/01:00:00:00:00/40 tag 9 ncq 1=
43360 in
[65785.843342]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843371] ata8.00: status: { DRDY }
[65785.843382] ata8.00: failed command: READ FPDMA QUEUED
[65785.843401] ata8.00: cmd 60/70:50:90:27:22/00:00:00:00:00/40 tag 10 ncq =
57344 in
[65785.843401]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843430] ata8.00: status: { DRDY }
[65785.843442] ata8.00: failed command: READ FPDMA QUEUED
[65785.843460] ata8.00: cmd 60/88:58:00:28:22/00:00:00:00:00/40 tag 11 ncq =
69632 in
[65785.843460]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843490] ata8.00: status: { DRDY }
[65785.843501] ata8.00: failed command: READ FPDMA QUEUED
[65785.843520] ata8.00: cmd 60/98:60:88:28:22/00:00:00:00:00/40 tag 12 ncq =
77824 in
[65785.843520]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843550] ata8.00: status: { DRDY }
[65785.843561] ata8.00: failed command: READ FPDMA QUEUED
[65785.843579] ata8.00: cmd 60/88:68:20:29:22/00:00:00:00:00/40 tag 13 ncq =
69632 in
[65785.843579]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843609] ata8.00: status: { DRDY }
[65785.843620] ata8.00: failed command: READ FPDMA QUEUED
[65785.843639] ata8.00: cmd 60/88:70:a8:29:22/00:00:00:00:00/40 tag 14 ncq =
69632 in
[65785.843639]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.843668] ata8.00: status: { DRDY }
[65785.843679] ata8.00: failed command: READ FPDMA QUEUED
[65785.844145] ata8.00: cmd 60/88:78:30:2a:22/00:00:00:00:00/40 tag 15 ncq =
69632 in
[65785.844145]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844175] ata8.00: status: { DRDY }
[65785.844186] ata8.00: failed command: READ FPDMA QUEUED
[65785.844205] ata8.00: cmd 60/80:80:b8:2a:22/00:00:00:00:00/40 tag 16 ncq =
65536 in
[65785.844205]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844234] ata8.00: status: { DRDY }
[65785.844245] ata8.00: failed command: READ FPDMA QUEUED
[65785.844264] ata8.00: cmd 60/98:88:38:2b:22/00:00:00:00:00/40 tag 17 ncq =
77824 in
[65785.844264]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844294] ata8.00: status: { DRDY }
[65785.844305] ata8.00: failed command: READ FPDMA QUEUED
[65785.844324] ata8.00: cmd 60/78:90:d0:2b:22/00:00:00:00:00/40 tag 18 ncq =
61440 in
[65785.844324]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844353] ata8.00: status: { DRDY }
[65785.844364] ata8.00: failed command: READ FPDMA QUEUED
[65785.844383] ata8.00: cmd 60/70:98:48:2c:22/00:00:00:00:00/40 tag 19 ncq =
57344 in
[65785.844383]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844412] ata8.00: status: { DRDY }
[65785.844423] ata8.00: failed command: READ FPDMA QUEUED
[65785.844442] ata8.00: cmd 60/80:a0:b8:2c:22/00:00:00:00:00/40 tag 20 ncq =
65536 in
[65785.844442]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844472] ata8.00: status: { DRDY }
[65785.844483] ata8.00: failed command: READ FPDMA QUEUED
[65785.844502] ata8.00: cmd 60/70:a8:38:2d:22/00:00:00:00:00/40 tag 21 ncq =
57344 in
[65785.844502]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844531] ata8.00: status: { DRDY }
[65785.844542] ata8.00: failed command: READ FPDMA QUEUED
[65785.844561] ata8.00: cmd 60/78:b0:a8:2d:22/00:00:00:00:00/40 tag 22 ncq =
61440 in
[65785.844561]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844591] ata8.00: status: { DRDY }
[65785.844602] ata8.00: failed command: READ FPDMA QUEUED
[65785.844620] ata8.00: cmd 60/80:b8:20:2e:22/00:00:00:00:00/40 tag 23 ncq =
65536 in
[65785.844620]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65785.844651] ata8.00: status: { DRDY }
[65785.844665] ata8: hard resetting link
[65786.333593] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 370)
[65786.364453] ata8.00: configured for UDMA/133
[65786.364469] ata8.00: device reported invalid CHS sector 0
[65786.364477] ata8.00: device reported invalid CHS sector 0
[65786.364482] ata8.00: device reported invalid CHS sector 0
[65786.364486] ata8.00: device reported invalid CHS sector 0
[65786.364491] ata8.00: device reported invalid CHS sector 0
[65786.364495] ata8.00: device reported invalid CHS sector 0
[65786.364500] ata8.00: device reported invalid CHS sector 0
[65786.364505] ata8.00: device reported invalid CHS sector 0
[65786.364510] ata8.00: device reported invalid CHS sector 0
[65786.364514] ata8.00: device reported invalid CHS sector 0
[65786.364518] ata8.00: device reported invalid CHS sector 0
[65786.364523] ata8.00: device reported invalid CHS sector 0
[65786.364527] ata8.00: device reported invalid CHS sector 0
[65786.364532] ata8.00: device reported invalid CHS sector 0
[65786.364536] ata8.00: device reported invalid CHS sector 0
[65786.364541] ata8.00: device reported invalid CHS sector 0
[65786.364545] ata8.00: device reported invalid CHS sector 0
[65786.364549] ata8.00: device reported invalid CHS sector 0
[65786.364553] ata8.00: device reported invalid CHS sector 0
[65786.364558] ata8.00: device reported invalid CHS sector 0
[65786.364562] ata8.00: device reported invalid CHS sector 0
[65786.364566] ata8.00: device reported invalid CHS sector 0
[65786.364571] ata8.00: device reported invalid CHS sector 0
[65786.364575] ata8.00: device reported invalid CHS sector 0
[65786.364597] sd 7:0:0:0: [sdf] =20
[65786.364601] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.364607] sd 7:0:0:0: [sdf] =20
[65786.364610] Sense Key : Aborted Command [current] [descriptor]
[65786.364617] Descriptor sense data with sense descriptors (in hex):
[65786.364620]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.364639]         00 00 00 00=20
[65786.364648] sd 7:0:0:0: [sdf] =20
[65786.364652] Add. Sense: No additional sense information
[65786.364657] sd 7:0:0:0: [sdf] CDB:=20
[65786.364660] Read(10): 28 00 00 22 22 d8 00 00 88 00
[65786.364677] end_request: I/O error, dev sdf, sector 2237144
[65786.364697] md/raid1:md3: sdf1: rescheduling sector 2169560
[65786.364736] sd 7:0:0:0: [sdf] =20
[65786.364739] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.364744] sd 7:0:0:0: [sdf] =20
[65786.364746] Sense Key : Aborted Command [current] [descriptor]
[65786.364751] Descriptor sense data with sense descriptors (in hex):
[65786.364754]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.364771]         00 00 00 00=20
[65786.364780] sd 7:0:0:0: [sdf] =20
[65786.364783] Add. Sense: No additional sense information
[65786.364788] sd 7:0:0:0: [sdf] CDB:=20
[65786.364790] Read(10): 28 00 00 22 22 d8 00 00 88 00
[65786.364804] end_request: I/O error, dev sdf, sector 2237144
[65786.364817] md/raid1:md3: sdf1: rescheduling sector 2169560
[65786.364836] sd 7:0:0:0: [sdf] =20
[65786.364839] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.364844] sd 7:0:0:0: [sdf] =20
[65786.364846] Sense Key : Aborted Command [current] [descriptor]
[65786.364851] Descriptor sense data with sense descriptors (in hex):
[65786.364853]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.364870]         00 00 00 00=20
[65786.364878] sd 7:0:0:0: [sdf] =20
[65786.364881] Add. Sense: No additional sense information
[65786.364886] sd 7:0:0:0: [sdf] CDB:=20
[65786.364888] Read(10): 28 00 02 26 3d 38 00 00 08 00
[65786.364902] end_request: I/O error, dev sdf, sector 36060472
[65786.364915] md/raid1:md3: sdf1: rescheduling sector 35992888
[65786.364935] sd 7:0:0:0: [sdf] =20
[65786.364938] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.364942] sd 7:0:0:0: [sdf] =20
[65786.364945] Sense Key : Aborted Command [current] [descriptor]
[65786.364949] Descriptor sense data with sense descriptors (in hex):
[65786.364952]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.364969]         00 00 00 00=20
[65786.364977] sd 7:0:0:0: [sdf] =20
[65786.364980] Add. Sense: No additional sense information
[65786.364984] sd 7:0:0:0: [sdf] CDB:=20
[65786.364986] Read(10): 28 00 00 22 22 d8 00 00 88 00
[65786.365000] end_request: I/O error, dev sdf, sector 2237144
[65786.365013] md/raid1:md3: sdf1: rescheduling sector 2169560
[65786.365032] sd 7:0:0:0: [sdf] =20
[65786.365035] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365039] sd 7:0:0:0: [sdf] =20
[65786.365042] Sense Key : Aborted Command [current] [descriptor]
[65786.365046] Descriptor sense data with sense descriptors (in hex):
[65786.365049]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365066]         00 00 00 00=20
[65786.365074] sd 7:0:0:0: [sdf] =20
[65786.365077] Add. Sense: No additional sense information
[65786.365081] sd 7:0:0:0: [sdf] CDB:=20
[65786.365084] Read(10): 28 00 00 22 23 60 00 00 80 00
[65786.365097] end_request: I/O error, dev sdf, sector 2237280
[65786.365110] md/raid1:md3: sdf1: rescheduling sector 2169696
[65786.365129] sd 7:0:0:0: [sdf] =20
[65786.365132] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365137] sd 7:0:0:0: [sdf] =20
[65786.365139] Sense Key : Aborted Command [current] [descriptor]
[65786.365144] Descriptor sense data with sense descriptors (in hex):
[65786.365146]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365163]         00 00 00 00=20
[65786.365171] sd 7:0:0:0: [sdf] =20
[65786.365174] Add. Sense: No additional sense information
[65786.365179] sd 7:0:0:0: [sdf] CDB:=20
[65786.365181] Read(10): 28 00 00 22 23 e0 00 00 90 00
[65786.365195] end_request: I/O error, dev sdf, sector 2237408
[65786.365207] md/raid1:md3: sdf1: rescheduling sector 2169824
[65786.365227] sd 7:0:0:0: [sdf] =20
[65786.365230] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365234] sd 7:0:0:0: [sdf] =20
[65786.365237] Sense Key : Aborted Command [current] [descriptor]
[65786.365241] Descriptor sense data with sense descriptors (in hex):
[65786.365244]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365261]         00 00 00 00=20
[65786.365269] sd 7:0:0:0: [sdf] =20
[65786.365272] Add. Sense: No additional sense information
[65786.365276] sd 7:0:0:0: [sdf] CDB:=20
[65786.365279] Read(10): 28 00 00 22 24 70 00 00 88 00
[65786.365292] end_request: I/O error, dev sdf, sector 2237552
[65786.365305] md/raid1:md3: sdf1: rescheduling sector 2169968
[65786.365325] sd 7:0:0:0: [sdf] =20
[65786.365328] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365333] sd 7:0:0:0: [sdf] =20
[65786.365335] Sense Key : Aborted Command [current] [descriptor]
[65786.365340] Descriptor sense data with sense descriptors (in hex):
[65786.365342]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365359]         00 00 00 00=20
[65786.365367] sd 7:0:0:0: [sdf] =20
[65786.365370] Add. Sense: No additional sense information
[65786.365375] sd 7:0:0:0: [sdf] CDB:=20
[65786.365377] Read(10): 28 00 00 22 24 f8 00 01 08 00
[65786.365390] end_request: I/O error, dev sdf, sector 2237688
[65786.365403] md/raid1:md3: sdf1: rescheduling sector 2170104
[65786.365448] md/raid1:md3: sdf1: rescheduling sector 2170240
[65786.365471] sd 7:0:0:0: [sdf] =20
[65786.365474] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365479] sd 7:0:0:0: [sdf] =20
[65786.365481] Sense Key : Aborted Command [current] [descriptor]
[65786.365486] Descriptor sense data with sense descriptors (in hex):
[65786.365488]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365646]         00 00 00 00=20
[65786.365656] sd 7:0:0:0: [sdf] =20
[65786.365659] Add. Sense: No additional sense information
[65786.365665] sd 7:0:0:0: [sdf] CDB:=20
[65786.365667] Read(10): 28 00 00 22 26 00 00 00 78 00
[65786.365682] end_request: I/O error, dev sdf, sector 2237952
[65786.365695] md/raid1:md3: sdf1: rescheduling sector 2170368
[65786.365716] sd 7:0:0:0: [sdf] =20
[65786.365719] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365724] sd 7:0:0:0: [sdf] =20
[65786.365726] Sense Key : Aborted Command [current] [descriptor]
[65786.365731] Descriptor sense data with sense descriptors (in hex):
[65786.365734]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365751]         00 00 00 00=20
[65786.365759] sd 7:0:0:0: [sdf] =20
[65786.365762] Add. Sense: No additional sense information
[65786.365770] sd 7:0:0:0: [sdf] CDB:=20
[65786.365773] Read(10): 28 00 00 22 26 78 00 01 18 00
[65786.365787] end_request: I/O error, dev sdf, sector 2238072
[65786.365809] sd 7:0:0:0: [sdf] =20
[65786.365812] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365816] sd 7:0:0:0: [sdf] =20
[65786.365819] Sense Key : Aborted Command [current] [descriptor]
[65786.365823] Descriptor sense data with sense descriptors (in hex):
[65786.365826]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365843]         00 00 00 00=20
[65786.365851] sd 7:0:0:0: [sdf] =20
[65786.365854] Add. Sense: No additional sense information
[65786.365859] sd 7:0:0:0: [sdf] CDB:=20
[65786.365861] Read(10): 28 00 00 22 27 90 00 00 70 00
[65786.365884] sd 7:0:0:0: [sdf] =20
[65786.365887] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365892] sd 7:0:0:0: [sdf] =20
[65786.365894] Sense Key : Aborted Command [current] [descriptor]
[65786.365899] Descriptor sense data with sense descriptors (in hex):
[65786.365901]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365918]         00 00 00 00=20
[65786.365926] sd 7:0:0:0: [sdf] =20
[65786.365929] Add. Sense: No additional sense information
[65786.365934] sd 7:0:0:0: [sdf] CDB:=20
[65786.365936] Read(10): 28 00 00 22 28 00 00 00 88 00
[65786.365959] sd 7:0:0:0: [sdf] =20
[65786.365962] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.365966] sd 7:0:0:0: [sdf] =20
[65786.365969] Sense Key : Aborted Command [current] [descriptor]
[65786.365973] Descriptor sense data with sense descriptors (in hex):
[65786.365976]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.365993]         00 00 00 00=20
[65786.366001] sd 7:0:0:0: [sdf] =20
[65786.366004] Add. Sense: No additional sense information
[65786.366009] sd 7:0:0:0: [sdf] CDB:=20
[65786.366011] Read(10): 28 00 00 22 28 88 00 00 98 00
[65786.366038] sd 7:0:0:0: [sdf] =20
[65786.366042] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366046] sd 7:0:0:0: [sdf] =20
[65786.366048] Sense Key : Aborted Command [current] [descriptor]
[65786.366053] Descriptor sense data with sense descriptors (in hex):
[65786.366056]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366072]         00 00 00 00=20
[65786.366081] sd 7:0:0:0: [sdf] =20
[65786.366083] Add. Sense: No additional sense information
[65786.366088] sd 7:0:0:0: [sdf] CDB:=20
[65786.366091] Read(10): 28 00 00 22 29 20 00 00 88 00
[65786.366113] sd 7:0:0:0: [sdf] =20
[65786.366116] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366120] sd 7:0:0:0: [sdf] =20
[65786.366122] Sense Key : Aborted Command [current] [descriptor]
[65786.366127] Descriptor sense data with sense descriptors (in hex):
[65786.366130]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366146]         00 00 00 00=20
[65786.366185] sd 7:0:0:0: [sdf] =20
[65786.366198] Add. Sense: No additional sense information
[65786.366218] sd 7:0:0:0: [sdf] CDB:=20
[65786.366230] Read(10): 28 00 00 22 29 a8 00 00 88 00
[65786.366326] sd 7:0:0:0: [sdf] =20
[65786.366329] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366334] sd 7:0:0:0: [sdf] =20
[65786.366336] Sense Key : Aborted Command [current] [descriptor]
[65786.366341] Descriptor sense data with sense descriptors (in hex):
[65786.366343]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366360]         00 00 00 00=20
[65786.366368] sd 7:0:0:0: [sdf] =20
[65786.366371] Add. Sense: No additional sense information
[65786.366376] sd 7:0:0:0: [sdf] CDB:=20
[65786.366378] Read(10): 28 00 00 22 2a 30 00 00 88 00
[65786.366400] sd 7:0:0:0: [sdf] =20
[65786.366403] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366408] sd 7:0:0:0: [sdf] =20
[65786.366410] Sense Key : Aborted Command [current] [descriptor]
[65786.366415] Descriptor sense data with sense descriptors (in hex):
[65786.366417]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366434]         00 00 00 00=20
[65786.366443] sd 7:0:0:0: [sdf] =20
[65786.366445] Add. Sense: No additional sense information
[65786.366450] sd 7:0:0:0: [sdf] CDB:=20
[65786.366452] Read(10): 28 00 00 22 2a b8 00 00 80 00
[65786.366474] sd 7:0:0:0: [sdf] =20
[65786.366477] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366481] sd 7:0:0:0: [sdf] =20
[65786.366484] Sense Key : Aborted Command [current] [descriptor]
[65786.366488] Descriptor sense data with sense descriptors (in hex):
[65786.366491]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366508]         00 00 00 00=20
[65786.366516] sd 7:0:0:0: [sdf] =20
[65786.366519] Add. Sense: No additional sense information
[65786.366524] sd 7:0:0:0: [sdf] CDB:=20
[65786.366526] Read(10): 28 00 00 22 2b 38 00 00 98 00
[65786.366547] sd 7:0:0:0: [sdf] =20
[65786.366550] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366555] sd 7:0:0:0: [sdf] =20
[65786.366557] Sense Key : Aborted Command [current] [descriptor]
[65786.366562] Descriptor sense data with sense descriptors (in hex):
[65786.366564]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366581]         00 00 00 00=20
[65786.366589] sd 7:0:0:0: [sdf] =20
[65786.366592] Add. Sense: No additional sense information
[65786.366597] sd 7:0:0:0: [sdf] CDB:=20
[65786.366599] Read(10): 28 00 00 22 2b d0 00 00 78 00
[65786.366621] sd 7:0:0:0: [sdf] =20
[65786.366624] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366628] sd 7:0:0:0: [sdf] =20
[65786.366631] Sense Key : Aborted Command [current] [descriptor]
[65786.366635] Descriptor sense data with sense descriptors (in hex):
[65786.366638]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366655]         00 00 00 00=20
[65786.366663] sd 7:0:0:0: [sdf] =20
[65786.366666] Add. Sense: No additional sense information
[65786.366671] sd 7:0:0:0: [sdf] CDB:=20
[65786.366673] Read(10): 28 00 00 22 2c 48 00 00 70 00
[65786.366695] sd 7:0:0:0: [sdf] =20
[65786.366698] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366702] sd 7:0:0:0: [sdf] =20
[65786.366704] Sense Key : Aborted Command [current] [descriptor]
[65786.366709] Descriptor sense data with sense descriptors (in hex):
[65786.366712]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366728]         00 00 00 00=20
[65786.366737] sd 7:0:0:0: [sdf] =20
[65786.366740] Add. Sense: No additional sense information
[65786.366744] sd 7:0:0:0: [sdf] CDB:=20
[65786.366747] Read(10): 28 00 00 22 2c b8 00 00 80 00
[65786.366792] sd 7:0:0:0: [sdf] =20
[65786.366805] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366818] sd 7:0:0:0: [sdf] =20
[65786.366829] Sense Key : Aborted Command [current] [descriptor]
[65786.366864] Descriptor sense data with sense descriptors (in hex):
[65786.366883]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.366936]         00 00 00 00=20
[65786.366945] sd 7:0:0:0: [sdf] =20
[65786.366948] Add. Sense: No additional sense information
[65786.366952] sd 7:0:0:0: [sdf] CDB:=20
[65786.366955] Read(10): 28 00 00 22 2d 38 00 00 70 00
[65786.366976] sd 7:0:0:0: [sdf] =20
[65786.366980] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.366984] sd 7:0:0:0: [sdf] =20
[65786.366986] Sense Key : Aborted Command [current] [descriptor]
[65786.366991] Descriptor sense data with sense descriptors (in hex):
[65786.366994]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.367010]         00 00 00 00=20
[65786.367019] sd 7:0:0:0: [sdf] =20
[65786.367021] Add. Sense: No additional sense information
[65786.367026] sd 7:0:0:0: [sdf] CDB:=20
[65786.367028] Read(10): 28 00 00 22 2d a8 00 00 78 00
[65786.367050] sd 7:0:0:0: [sdf] =20
[65786.367053] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65786.367058] sd 7:0:0:0: [sdf] =20
[65786.367060] Sense Key : Aborted Command [current] [descriptor]
[65786.367065] Descriptor sense data with sense descriptors (in hex):
[65786.367067]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65786.367084]         00 00 00 00=20
[65786.367092] sd 7:0:0:0: [sdf] =20
[65786.367095] Add. Sense: No additional sense information
[65786.367100] sd 7:0:0:0: [sdf] CDB:=20
[65786.367102] Read(10): 28 00 00 22 2e 20 00 00 80 00
[65786.367128] ata8: EH complete
[65786.399061] md/raid1:md3: redirecting sector 2169560 to other mirror: sd=
f1
[65786.401448] md/raid1:md3: redirecting sector 2169560 to other mirror: sd=
f1
[65786.402065] md/raid1:md3: redirecting sector 35992888 to other mirror: s=
df1
[65786.403795] md/raid1:md3: redirecting sector 2169560 to other mirror: sd=
f1
[65786.405894] md/raid1:md3: redirecting sector 2169696 to other mirror: sd=
f1
[65786.407900] md/raid1:md3: redirecting sector 2169824 to other mirror: sd=
f1
[65786.410303] md/raid1:md3: redirecting sector 2169968 to other mirror: sd=
f1
[65786.412234] md/raid1:md3: redirecting sector 2170104 to other mirror: sd=
f1
[65786.414888] md/raid1:md3: redirecting sector 2170240 to other mirror: sd=
f1
[65786.416719] md/raid1:md3: redirecting sector 2170368 to other mirror: sd=
f1
[65823.762631] ata8.00: exception Emask 0x0 SAct 0xfffffff SErr 0x0 action =
0x6 frozen
[65823.762645] ata8.00: failed command: READ FPDMA QUEUED
[65823.762654] ata8.00: cmd 60/68:00:88:53:22/00:00:00:00:00/40 tag 0 ncq 5=
3248 in
[65823.762654]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762667] ata8.00: status: { DRDY }
[65823.762672] ata8.00: failed command: READ FPDMA QUEUED
[65823.762678] ata8.00: cmd 60/08:08:70:dc:53/00:00:03:00:00/40 tag 1 ncq 4=
096 in
[65823.762678]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762691] ata8.00: status: { DRDY }
[65823.762696] ata8.00: failed command: READ FPDMA QUEUED
[65823.762702] ata8.00: cmd 60/68:10:88:53:22/00:00:00:00:00/40 tag 2 ncq 5=
3248 in
[65823.762702]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762716] ata8.00: status: { DRDY }
[65823.762721] ata8.00: failed command: READ FPDMA QUEUED
[65823.762728] ata8.00: cmd 60/68:18:88:53:22/00:00:00:00:00/40 tag 3 ncq 5=
3248 in
[65823.762728]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762740] ata8.00: status: { DRDY }
[65823.762745] ata8.00: failed command: READ FPDMA QUEUED
[65823.762751] ata8.00: cmd 60/68:20:88:53:22/00:00:00:00:00/40 tag 4 ncq 5=
3248 in
[65823.762751]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762764] ata8.00: status: { DRDY }
[65823.762768] ata8.00: failed command: READ FPDMA QUEUED
[65823.762775] ata8.00: cmd 60/68:28:88:53:22/00:00:00:00:00/40 tag 5 ncq 5=
3248 in
[65823.762775]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762788] ata8.00: status: { DRDY }
[65823.762792] ata8.00: failed command: READ FPDMA QUEUED
[65823.762799] ata8.00: cmd 60/68:30:88:53:22/00:00:00:00:00/40 tag 6 ncq 5=
3248 in
[65823.762799]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762811] ata8.00: status: { DRDY }
[65823.762816] ata8.00: failed command: READ FPDMA QUEUED
[65823.762822] ata8.00: cmd 60/78:38:f0:53:22/00:00:00:00:00/40 tag 7 ncq 6=
1440 in
[65823.762822]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762835] ata8.00: status: { DRDY }
[65823.762839] ata8.00: failed command: READ FPDMA QUEUED
[65823.762846] ata8.00: cmd 60/70:40:68:54:22/00:00:00:00:00/40 tag 8 ncq 5=
7344 in
[65823.762846]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762858] ata8.00: status: { DRDY }
[65823.762863] ata8.00: failed command: READ FPDMA QUEUED
[65823.762869] ata8.00: cmd 60/78:48:d8:54:22/00:00:00:00:00/40 tag 9 ncq 6=
1440 in
[65823.762869]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762882] ata8.00: status: { DRDY }
[65823.762886] ata8.00: failed command: READ FPDMA QUEUED
[65823.762893] ata8.00: cmd 60/88:50:50:55:22/00:00:00:00:00/40 tag 10 ncq =
69632 in
[65823.762893]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762906] ata8.00: status: { DRDY }
[65823.762910] ata8.00: failed command: READ FPDMA QUEUED
[65823.762917] ata8.00: cmd 60/78:58:d8:55:22/00:00:00:00:00/40 tag 11 ncq =
61440 in
[65823.762917]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762930] ata8.00: status: { DRDY }
[65823.762934] ata8.00: failed command: READ FPDMA QUEUED
[65823.762941] ata8.00: cmd 60/70:60:50:56:22/00:00:00:00:00/40 tag 12 ncq =
57344 in
[65823.762941]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762953] ata8.00: status: { DRDY }
[65823.762958] ata8.00: failed command: READ FPDMA QUEUED
[65823.762964] ata8.00: cmd 60/80:68:c0:56:22/00:00:00:00:00/40 tag 13 ncq =
65536 in
[65823.762964]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.762982] ata8.00: status: { DRDY }
[65823.762987] ata8.00: failed command: READ FPDMA QUEUED
[65823.762994] ata8.00: cmd 60/70:70:40:57:22/00:00:00:00:00/40 tag 14 ncq =
57344 in
[65823.762994]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763007] ata8.00: status: { DRDY }
[65823.763012] ata8.00: failed command: READ FPDMA QUEUED
[65823.763018] ata8.00: cmd 60/78:78:b0:57:22/00:00:00:00:00/40 tag 15 ncq =
61440 in
[65823.763018]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763465] ata8.00: status: { DRDY }
[65823.763469] ata8.00: failed command: READ FPDMA QUEUED
[65823.763476] ata8.00: cmd 60/78:80:28:58:22/00:00:00:00:00/40 tag 16 ncq =
61440 in
[65823.763476]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763488] ata8.00: status: { DRDY }
[65823.763493] ata8.00: failed command: READ FPDMA QUEUED
[65823.763499] ata8.00: cmd 60/80:88:a0:58:22/00:00:00:00:00/40 tag 17 ncq =
65536 in
[65823.763499]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763512] ata8.00: status: { DRDY }
[65823.763516] ata8.00: failed command: READ FPDMA QUEUED
[65823.763523] ata8.00: cmd 60/78:90:20:59:22/00:00:00:00:00/40 tag 18 ncq =
61440 in
[65823.763523]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763536] ata8.00: status: { DRDY }
[65823.763540] ata8.00: failed command: READ FPDMA QUEUED
[65823.763547] ata8.00: cmd 60/78:98:98:59:22/00:00:00:00:00/40 tag 19 ncq =
61440 in
[65823.763547]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763559] ata8.00: status: { DRDY }
[65823.763564] ata8.00: failed command: READ FPDMA QUEUED
[65823.763570] ata8.00: cmd 60/78:a0:10:5a:22/00:00:00:00:00/40 tag 20 ncq =
61440 in
[65823.763570]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763583] ata8.00: status: { DRDY }
[65823.763587] ata8.00: failed command: READ FPDMA QUEUED
[65823.763594] ata8.00: cmd 60/80:a8:88:5a:22/00:00:00:00:00/40 tag 21 ncq =
65536 in
[65823.763594]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763607] ata8.00: status: { DRDY }
[65823.763611] ata8.00: failed command: READ FPDMA QUEUED
[65823.763617] ata8.00: cmd 60/80:b0:08:5b:22/00:00:00:00:00/40 tag 22 ncq =
65536 in
[65823.763617]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763630] ata8.00: status: { DRDY }
[65823.763634] ata8.00: failed command: READ FPDMA QUEUED
[65823.763641] ata8.00: cmd 60/78:b8:88:5b:22/00:00:00:00:00/40 tag 23 ncq =
61440 in
[65823.763641]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763654] ata8.00: status: { DRDY }
[65823.763658] ata8.00: failed command: READ FPDMA QUEUED
[65823.763665] ata8.00: cmd 60/68:c0:00:5c:22/00:00:00:00:00/40 tag 24 ncq =
53248 in
[65823.763665]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763677] ata8.00: status: { DRDY }
[65823.763682] ata8.00: failed command: READ FPDMA QUEUED
[65823.763688] ata8.00: cmd 60/78:c8:68:5c:22/00:00:00:00:00/40 tag 25 ncq =
61440 in
[65823.763688]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763701] ata8.00: status: { DRDY }
[65823.763705] ata8.00: failed command: READ FPDMA QUEUED
[65823.763712] ata8.00: cmd 60/80:d0:e0:5c:22/00:00:00:00:00/40 tag 26 ncq =
65536 in
[65823.763712]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763725] ata8.00: status: { DRDY }
[65823.763729] ata8.00: failed command: READ FPDMA QUEUED
[65823.763736] ata8.00: cmd 60/80:d8:60:5d:22/00:00:00:00:00/40 tag 27 ncq =
65536 in
[65823.763736]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[65823.763748] ata8.00: status: { DRDY }
[65823.763754] ata8: hard resetting link
[65824.365172] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 370)
[65824.387281] ata8.00: configured for UDMA/133
[65824.387298] ata8.00: device reported invalid CHS sector 0
[65824.387304] ata8.00: device reported invalid CHS sector 0
[65824.387324] ata8.00: device reported invalid CHS sector 0
[65824.387527] ata8.00: device reported invalid CHS sector 0
[65824.387532] ata8.00: device reported invalid CHS sector 0
[65824.387537] ata8.00: device reported invalid CHS sector 0
[65824.387541] ata8.00: device reported invalid CHS sector 0
[65824.387546] ata8.00: device reported invalid CHS sector 0
[65824.387550] ata8.00: device reported invalid CHS sector 0
[65824.387554] ata8.00: device reported invalid CHS sector 0
[65824.387559] ata8.00: device reported invalid CHS sector 0
[65824.387564] ata8.00: device reported invalid CHS sector 0
[65824.387568] ata8.00: device reported invalid CHS sector 0
[65824.387572] ata8.00: device reported invalid CHS sector 0
[65824.387576] ata8.00: device reported invalid CHS sector 0
[65824.387581] ata8.00: device reported invalid CHS sector 0
[65824.387585] ata8.00: device reported invalid CHS sector 0
[65824.387589] ata8.00: device reported invalid CHS sector 0
[65824.387594] ata8.00: device reported invalid CHS sector 0
[65824.387598] ata8.00: device reported invalid CHS sector 0
[65824.387603] ata8.00: device reported invalid CHS sector 0
[65824.387608] ata8.00: device reported invalid CHS sector 0
[65824.387612] ata8.00: device reported invalid CHS sector 0
[65824.387616] ata8.00: device reported invalid CHS sector 0
[65824.387621] ata8.00: device reported invalid CHS sector 0
[65824.387625] ata8.00: device reported invalid CHS sector 0
[65824.387629] ata8.00: device reported invalid CHS sector 0
[65824.387633] ata8.00: device reported invalid CHS sector 0
[65824.387649] sd 7:0:0:0: [sdf] =20
[65824.387654] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.387659] sd 7:0:0:0: [sdf] =20
[65824.387662] Sense Key : Aborted Command [current] [descriptor]
[65824.387670] Descriptor sense data with sense descriptors (in hex):
[65824.387673]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.387692]         00 00 00 00=20
[65824.387701] sd 7:0:0:0: [sdf] =20
[65824.387705] Add. Sense: No additional sense information
[65824.387710] sd 7:0:0:0: [sdf] CDB:=20
[65824.387713] Read(10): 28 00 00 22 53 88 00 00 68 00
[65824.387729] blk_update_request: 14 callbacks suppressed
[65824.387733] end_request: I/O error, dev sdf, sector 2249608
[65824.387751] raid1_end_read_request: 16 callbacks suppressed
[65824.387757] md/raid1:md3: sdf1: rescheduling sector 2182024
[65824.387787] sd 7:0:0:0: [sdf] =20
[65824.387791] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.387795] sd 7:0:0:0: [sdf] =20
[65824.387798] Sense Key : Aborted Command [current] [descriptor]
[65824.387803] Descriptor sense data with sense descriptors (in hex):
[65824.387806]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.387823]         00 00 00 00=20
[65824.387831] sd 7:0:0:0: [sdf] =20
[65824.387834] Add. Sense: No additional sense information
[65824.387839] sd 7:0:0:0: [sdf] CDB:=20
[65824.387841] Read(10): 28 00 03 53 dc 70 00 00 08 00
[65824.387856] end_request: I/O error, dev sdf, sector 55827568
[65824.387870] md/raid1:md3: sdf1: rescheduling sector 55759984
[65824.387890] sd 7:0:0:0: [sdf] =20
[65824.387893] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.387898] sd 7:0:0:0: [sdf] =20
[65824.387900] Sense Key : Aborted Command [current] [descriptor]
[65824.387905] Descriptor sense data with sense descriptors (in hex):
[65824.387907]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.387924]         00 00 00 00=20
[65824.387933] sd 7:0:0:0: [sdf] =20
[65824.387936] Add. Sense: No additional sense information
[65824.387940] sd 7:0:0:0: [sdf] CDB:=20
[65824.387943] Read(10): 28 00 00 22 53 88 00 00 68 00
[65824.387957] end_request: I/O error, dev sdf, sector 2249608
[65824.387970] md/raid1:md3: sdf1: rescheduling sector 2182024
[65824.387990] sd 7:0:0:0: [sdf] =20
[65824.387993] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.387997] sd 7:0:0:0: [sdf] =20
[65824.388000] Sense Key : Aborted Command [current] [descriptor]
[65824.388004] Descriptor sense data with sense descriptors (in hex):
[65824.388007]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388024]         00 00 00 00=20
[65824.388032] sd 7:0:0:0: [sdf] =20
[65824.388035] Add. Sense: No additional sense information
[65824.388040] sd 7:0:0:0: [sdf] CDB:=20
[65824.388042] Read(10): 28 00 00 22 53 88 00 00 68 00
[65824.388056] end_request: I/O error, dev sdf, sector 2249608
[65824.388069] md/raid1:md3: sdf1: rescheduling sector 2182024
[65824.388089] sd 7:0:0:0: [sdf] =20
[65824.388092] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388096] sd 7:0:0:0: [sdf] =20
[65824.388098] Sense Key : Aborted Command [current] [descriptor]
[65824.388103] Descriptor sense data with sense descriptors (in hex):
[65824.388106]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388122]         00 00 00 00=20
[65824.388138] sd 7:0:0:0: [sdf] =20
[65824.388141] Add. Sense: No additional sense information
[65824.388146] sd 7:0:0:0: [sdf] CDB:=20
[65824.388148] Read(10): 28 00 00 22 53 88 00 00 68 00
[65824.388162] end_request: I/O error, dev sdf, sector 2249608
[65824.388175] md/raid1:md3: sdf1: rescheduling sector 2182024
[65824.388196] sd 7:0:0:0: [sdf] =20
[65824.388199] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388203] sd 7:0:0:0: [sdf] =20
[65824.388205] Sense Key : Aborted Command [current] [descriptor]
[65824.388210] Descriptor sense data with sense descriptors (in hex):
[65824.388212]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388229]         00 00 00 00=20
[65824.388238] sd 7:0:0:0: [sdf] =20
[65824.388240] Add. Sense: No additional sense information
[65824.388245] sd 7:0:0:0: [sdf] CDB:=20
[65824.388247] Read(10): 28 00 00 22 53 88 00 00 68 00
[65824.388261] end_request: I/O error, dev sdf, sector 2249608
[65824.388274] md/raid1:md3: sdf1: rescheduling sector 2182024
[65824.388294] sd 7:0:0:0: [sdf] =20
[65824.388297] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388301] sd 7:0:0:0: [sdf] =20
[65824.388304] Sense Key : Aborted Command [current] [descriptor]
[65824.388308] Descriptor sense data with sense descriptors (in hex):
[65824.388311]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388328]         00 00 00 00=20
[65824.388336] sd 7:0:0:0: [sdf] =20
[65824.388339] Add. Sense: No additional sense information
[65824.388344] sd 7:0:0:0: [sdf] CDB:=20
[65824.388346] Read(10): 28 00 00 22 53 88 00 00 68 00
[65824.388360] end_request: I/O error, dev sdf, sector 2249608
[65824.388372] md/raid1:md3: sdf1: rescheduling sector 2182024
[65824.388391] sd 7:0:0:0: [sdf] =20
[65824.388394] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388399] sd 7:0:0:0: [sdf] =20
[65824.388401] Sense Key : Aborted Command [current] [descriptor]
[65824.388406] Descriptor sense data with sense descriptors (in hex):
[65824.388408]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388425]         00 00 00 00=20
[65824.388433] sd 7:0:0:0: [sdf] =20
[65824.388436] Add. Sense: No additional sense information
[65824.388441] sd 7:0:0:0: [sdf] CDB:=20
[65824.388443] Read(10): 28 00 00 22 53 f0 00 00 78 00
[65824.388457] end_request: I/O error, dev sdf, sector 2249712
[65824.388470] md/raid1:md3: sdf1: rescheduling sector 2182128
[65824.388490] sd 7:0:0:0: [sdf] =20
[65824.388493] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388497] sd 7:0:0:0: [sdf] =20
[65824.388499] Sense Key : Aborted Command [current] [descriptor]
[65824.388504] Descriptor sense data with sense descriptors (in hex):
[65824.388507]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388523]         00 00 00 00=20
[65824.388532] sd 7:0:0:0: [sdf] =20
[65824.388535] Add. Sense: No additional sense information
[65824.388539] sd 7:0:0:0: [sdf] CDB:=20
[65824.388542] Read(10): 28 00 00 22 54 68 00 00 70 00
[65824.388555] end_request: I/O error, dev sdf, sector 2249832
[65824.388568] md/raid1:md3: sdf1: rescheduling sector 2182248
[65824.388587] sd 7:0:0:0: [sdf] =20
[65824.388591] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388595] sd 7:0:0:0: [sdf] =20
[65824.388597] Sense Key : Aborted Command [current] [descriptor]
[65824.388602] Descriptor sense data with sense descriptors (in hex):
[65824.388605]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388621]         00 00 00 00=20
[65824.388630] sd 7:0:0:0: [sdf] =20
[65824.388633] Add. Sense: No additional sense information
[65824.388637] sd 7:0:0:0: [sdf] CDB:=20
[65824.388640] Read(10): 28 00 00 22 54 d8 00 00 78 00
[65824.388653] end_request: I/O error, dev sdf, sector 2249944
[65824.388666] md/raid1:md3: sdf1: rescheduling sector 2182360
[65824.388685] sd 7:0:0:0: [sdf] =20
[65824.388688] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388692] sd 7:0:0:0: [sdf] =20
[65824.388695] Sense Key : Aborted Command [current] [descriptor]
[65824.388699] Descriptor sense data with sense descriptors (in hex):
[65824.388702]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388719]         00 00 00 00=20
[65824.388727] sd 7:0:0:0: [sdf] =20
[65824.388730] Add. Sense: No additional sense information
[65824.388735] sd 7:0:0:0: [sdf] CDB:=20
[65824.388737] Read(10): 28 00 00 22 55 50 00 00 88 00
[65824.388759] sd 7:0:0:0: [sdf] =20
[65824.388763] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388767] sd 7:0:0:0: [sdf] =20
[65824.388769] Sense Key : Aborted Command [current] [descriptor]
[65824.388774] Descriptor sense data with sense descriptors (in hex):
[65824.388777]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388793]         00 00 00 00=20
[65824.388802] sd 7:0:0:0: [sdf] =20
[65824.388805] Add. Sense: No additional sense information
[65824.388809] sd 7:0:0:0: [sdf] CDB:=20
[65824.388812] Read(10): 28 00 00 22 55 d8 00 00 78 00
[65824.388833] sd 7:0:0:0: [sdf] =20
[65824.388836] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388840] sd 7:0:0:0: [sdf] =20
[65824.388843] Sense Key : Aborted Command [current] [descriptor]
[65824.388847] Descriptor sense data with sense descriptors (in hex):
[65824.388850]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388867]         00 00 00 00=20
[65824.388875] sd 7:0:0:0: [sdf] =20
[65824.388878] Add. Sense: No additional sense information
[65824.388883] sd 7:0:0:0: [sdf] CDB:=20
[65824.388885] Read(10): 28 00 00 22 56 50 00 00 70 00
[65824.388907] sd 7:0:0:0: [sdf] =20
[65824.388910] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388914] sd 7:0:0:0: [sdf] =20
[65824.388916] Sense Key : Aborted Command [current] [descriptor]
[65824.388921] Descriptor sense data with sense descriptors (in hex):
[65824.388924]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.388941]         00 00 00 00=20
[65824.388949] sd 7:0:0:0: [sdf] =20
[65824.388952] Add. Sense: No additional sense information
[65824.388956] sd 7:0:0:0: [sdf] CDB:=20
[65824.388959] Read(10): 28 00 00 22 56 c0 00 00 80 00
[65824.388980] sd 7:0:0:0: [sdf] =20
[65824.388983] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.388987] sd 7:0:0:0: [sdf] =20
[65824.388990] Sense Key : Aborted Command [current] [descriptor]
[65824.388994] Descriptor sense data with sense descriptors (in hex):
[65824.388997]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389014]         00 00 00 00=20
[65824.389050] sd 7:0:0:0: [sdf] =20
[65824.389053] Add. Sense: No additional sense information
[65824.389058] sd 7:0:0:0: [sdf] CDB:=20
[65824.389060] Read(10): 28 00 00 22 57 40 00 00 70 00
[65824.389085] sd 7:0:0:0: [sdf] =20
[65824.389088] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389093] sd 7:0:0:0: [sdf] =20
[65824.389095] Sense Key : Aborted Command [current] [descriptor]
[65824.389100] Descriptor sense data with sense descriptors (in hex):
[65824.389102]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389119]         00 00 00 00=20
[65824.389128] sd 7:0:0:0: [sdf] =20
[65824.389131] Add. Sense: No additional sense information
[65824.389135] sd 7:0:0:0: [sdf] CDB:=20
[65824.389138] Read(10): 28 00 00 22 57 b0 00 00 78 00
[65824.389160] sd 7:0:0:0: [sdf] =20
[65824.389163] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389167] sd 7:0:0:0: [sdf] =20
[65824.389170] Sense Key : Aborted Command [current] [descriptor]
[65824.389175] Descriptor sense data with sense descriptors (in hex):
[65824.389177]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389194]         00 00 00 00=20
[65824.389246] sd 7:0:0:0: [sdf] =20
[65824.389259] Add. Sense: No additional sense information
[65824.389278] sd 7:0:0:0: [sdf] CDB:=20
[65824.389291] Read(10): 28 00 00 22 58 28 00 00 78 00
[65824.389373] sd 7:0:0:0: [sdf] =20
[65824.389376] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389380] sd 7:0:0:0: [sdf] =20
[65824.389383] Sense Key : Aborted Command [current] [descriptor]
[65824.389388] Descriptor sense data with sense descriptors (in hex):
[65824.389390]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389407]         00 00 00 00=20
[65824.389415] sd 7:0:0:0: [sdf] =20
[65824.389418] Add. Sense: No additional sense information
[65824.389423] sd 7:0:0:0: [sdf] CDB:=20
[65824.389425] Read(10): 28 00 00 22 58 a0 00 00 80 00
[65824.389447] sd 7:0:0:0: [sdf] =20
[65824.389450] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389454] sd 7:0:0:0: [sdf] =20
[65824.389456] Sense Key : Aborted Command [current] [descriptor]
[65824.389461] Descriptor sense data with sense descriptors (in hex):
[65824.389464]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389480]         00 00 00 00=20
[65824.389489] sd 7:0:0:0: [sdf] =20
[65824.389492] Add. Sense: No additional sense information
[65824.389497] sd 7:0:0:0: [sdf] CDB:=20
[65824.389499] Read(10): 28 00 00 22 59 20 00 00 78 00
[65824.389521] sd 7:0:0:0: [sdf] =20
[65824.389524] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389528] sd 7:0:0:0: [sdf] =20
[65824.389531] Sense Key : Aborted Command [current] [descriptor]
[65824.389535] Descriptor sense data with sense descriptors (in hex):
[65824.389538]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389555]         00 00 00 00=20
[65824.389563] sd 7:0:0:0: [sdf] =20
[65824.389566] Add. Sense: No additional sense information
[65824.389571] sd 7:0:0:0: [sdf] CDB:=20
[65824.389573] Read(10): 28 00 00 22 59 98 00 00 78 00
[65824.389595] sd 7:0:0:0: [sdf] =20
[65824.389598] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389602] sd 7:0:0:0: [sdf] =20
[65824.389604] Sense Key : Aborted Command [current] [descriptor]
[65824.389609] Descriptor sense data with sense descriptors (in hex):
[65824.389611]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389628]         00 00 00 00=20
[65824.389637] sd 7:0:0:0: [sdf] =20
[65824.389640] Add. Sense: No additional sense information
[65824.389644] sd 7:0:0:0: [sdf] CDB:=20
[65824.389647] Read(10): 28 00 00 22 5a 10 00 00 78 00
[65824.389668] sd 7:0:0:0: [sdf] =20
[65824.389671] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389675] sd 7:0:0:0: [sdf] =20
[65824.389678] Sense Key : Aborted Command [current] [descriptor]
[65824.389683] Descriptor sense data with sense descriptors (in hex):
[65824.389685]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389702]         00 00 00 00=20
[65824.389710] sd 7:0:0:0: [sdf] =20
[65824.389713] Add. Sense: No additional sense information
[65824.389718] sd 7:0:0:0: [sdf] CDB:=20
[65824.389720] Read(10): 28 00 00 22 5a 88 00 00 80 00
[65824.389742] sd 7:0:0:0: [sdf] =20
[65824.389745] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389749] sd 7:0:0:0: [sdf] =20
[65824.389752] Sense Key : Aborted Command [current] [descriptor]
[65824.389756] Descriptor sense data with sense descriptors (in hex):
[65824.389759]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389776]         00 00 00 00=20
[65824.389784] sd 7:0:0:0: [sdf] =20
[65824.389787] Add. Sense: No additional sense information
[65824.389792] sd 7:0:0:0: [sdf] CDB:=20
[65824.389794] Read(10): 28 00 00 22 5b 08 00 00 80 00
[65824.389816] sd 7:0:0:0: [sdf] =20
[65824.389819] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389824] sd 7:0:0:0: [sdf] =20
[65824.389826] Sense Key : Aborted Command [current] [descriptor]
[65824.389831] Descriptor sense data with sense descriptors (in hex):
[65824.389833]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.389850]         00 00 00 00=20
[65824.389858] sd 7:0:0:0: [sdf] =20
[65824.389861] Add. Sense: No additional sense information
[65824.389866] sd 7:0:0:0: [sdf] CDB:=20
[65824.389868] Read(10): 28 00 00 22 5b 88 00 00 78 00
[65824.389930] sd 7:0:0:0: [sdf] =20
[65824.389943] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.389956] sd 7:0:0:0: [sdf] =20
[65824.389968] Sense Key : Aborted Command [current] [descriptor]
[65824.390004] Descriptor sense data with sense descriptors (in hex):
[65824.390022]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.390057]         00 00 00 00=20
[65824.390065] sd 7:0:0:0: [sdf] =20
[65824.390068] Add. Sense: No additional sense information
[65824.390073] sd 7:0:0:0: [sdf] CDB:=20
[65824.390075] Read(10): 28 00 00 22 5c 00 00 00 68 00
[65824.390097] sd 7:0:0:0: [sdf] =20
[65824.390100] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.390104] sd 7:0:0:0: [sdf] =20
[65824.390107] Sense Key : Aborted Command [current] [descriptor]
[65824.390111] Descriptor sense data with sense descriptors (in hex):
[65824.390114]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.390131]         00 00 00 00=20
[65824.390139] sd 7:0:0:0: [sdf] =20
[65824.390142] Add. Sense: No additional sense information
[65824.390147] sd 7:0:0:0: [sdf] CDB:=20
[65824.390149] Read(10): 28 00 00 22 5c 68 00 00 78 00
[65824.390171] sd 7:0:0:0: [sdf] =20
[65824.390174] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.390178] sd 7:0:0:0: [sdf] =20
[65824.390181] Sense Key : Aborted Command [current] [descriptor]
[65824.390185] Descriptor sense data with sense descriptors (in hex):
[65824.390188]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.390205]         00 00 00 00=20
[65824.390213] sd 7:0:0:0: [sdf] =20
[65824.390216] Add. Sense: No additional sense information
[65824.390221] sd 7:0:0:0: [sdf] CDB:=20
[65824.390223] Read(10): 28 00 00 22 5c e0 00 00 80 00
[65824.390244] sd 7:0:0:0: [sdf] =20
[65824.390247] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[65824.390251] sd 7:0:0:0: [sdf] =20
[65824.390254] Sense Key : Aborted Command [current] [descriptor]
[65824.390258] Descriptor sense data with sense descriptors (in hex):
[65824.390261]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[65824.390278]         00 00 00 00=20
[65824.390286] sd 7:0:0:0: [sdf] =20
[65824.390289] Add. Sense: No additional sense information
[65824.390294] sd 7:0:0:0: [sdf] CDB:=20
[65824.390296] Read(10): 28 00 00 22 5d 60 00 00 80 00
[65824.390318] ata8: EH complete
[65824.418363] handle_read_error: 16 callbacks suppressed
[65824.418373] md/raid1:md3: redirecting sector 2182024 to other mirror: sd=
f1
[65824.419035] md/raid1:md3: redirecting sector 55759984 to other mirror: s=
df1
[65824.420239] md/raid1:md3: redirecting sector 2182024 to other mirror: sd=
f1
[65824.421978] md/raid1:md3: redirecting sector 2182024 to other mirror: sd=
f1
[65824.423939] md/raid1:md3: redirecting sector 2182024 to other mirror: sd=
f1
[65824.425645] md/raid1:md3: redirecting sector 2182024 to other mirror: sd=
f1
[65824.427317] md/raid1:md3: redirecting sector 2182024 to other mirror: sd=
f1
[65824.429895] md/raid1:md3: redirecting sector 2182128 to other mirror: sd=
f1
[65824.431730] md/raid1:md3: redirecting sector 2182248 to other mirror: sd=
f1
[65824.433566] md/raid1:md3: redirecting sector 2182360 to other mirror: sd=
f1
[66044.234953] ata8.00: exception Emask 0x0 SAct 0x1 SErr 0x0 action 0x6 fr=
ozen
[66044.234979] ata8.00: failed command: READ FPDMA QUEUED
[66044.235002] ata8.00: cmd 60/20:00:b8:ad:68/00:00:00:00:00/40 tag 0 ncq 1=
6384 in
[66044.235002]          res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[66044.235034] ata8.00: status: { DRDY }
[66044.235049] ata8: hard resetting link
[66044.725759] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 370)
[66044.747422] ata8.00: configured for UDMA/133
[66044.747436] ata8.00: device reported invalid CHS sector 0
[66044.747459] sd 7:0:0:0: [sdf] =20
[66044.747463] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[66044.747469] sd 7:0:0:0: [sdf] =20
[66044.747472] Sense Key : Aborted Command [current] [descriptor]
[66044.747479] Descriptor sense data with sense descriptors (in hex):
[66044.747482]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[66044.747500]         00 00 00 00=20
[66044.747509] sd 7:0:0:0: [sdf] =20
[66044.747513] Add. Sense: No additional sense information
[66044.747519] sd 7:0:0:0: [sdf] CDB:=20
[66044.747521] Read(10): 28 00 00 68 ad b8 00 00 20 00
[66044.747537] blk_update_request: 18 callbacks suppressed
[66044.747541] end_request: I/O error, dev sdf, sector 6860216
[66044.747565] raid1_end_read_request: 18 callbacks suppressed
[66044.747570] md/raid1:md3: sdf1: rescheduling sector 6792632
[66044.747611] ata8: EH complete
[66044.778306] handle_read_error: 18 callbacks suppressed
[66044.778316] md/raid1:md3: redirecting sector 6792632 to other mirror: sd=
f1
[94090.661189] ata8.00: exception Emask 0x0 SAct 0x2 SErr 0x0 action 0x6 fr=
ozen
[94090.661199] ata8.00: failed command: READ FPDMA QUEUED
[94090.661207] ata8.00: cmd 60/08:08:c8:cf:13/00:00:06:00:00/40 tag 1 ncq 4=
096 in
[94090.661207]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (=
timeout)
[94090.661220] ata8.00: status: { DRDY }
[94090.661226] ata8: hard resetting link
[94091.152039] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 370)
[94091.174057] ata8.00: configured for UDMA/133
[94091.174071] ata8.00: device reported invalid CHS sector 0
[94091.174093] sd 7:0:0:0: [sdf] =20
[94091.174098] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[94091.174103] sd 7:0:0:0: [sdf] =20
[94091.174106] Sense Key : Aborted Command [current] [descriptor]
[94091.174113] Descriptor sense data with sense descriptors (in hex):
[94091.174116]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[94091.174134]         00 00 00 00=20
[94091.174143] sd 7:0:0:0: [sdf] =20
[94091.174147] Add. Sense: No additional sense information
[94091.174152] sd 7:0:0:0: [sdf] CDB:=20
[94091.174155] Read(10): 28 00 06 13 cf c8 00 00 08 00
[94091.174171] end_request: I/O error, dev sdf, sector 101961672
[94091.174192] md/raid1:md3: sdf1: rescheduling sector 101894088
[94091.174235] ata8: EH complete
[94091.224252] md/raid1:md3: redirecting sector 101894088 to other mirror: =
sdf1

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/XzYASeIs71qUBGBqNP+Q9hb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlD2ceIACgkQTLKSvz+PZwg8lwCfZwkwhWWkTMnUJ4qneOd0I/qh
mDMAni+68bxo51wTFg8I2ioTE2SuWnQL
=pRHX
-----END PGP SIGNATURE-----

--Sig_/XzYASeIs71qUBGBqNP+Q9hb--
