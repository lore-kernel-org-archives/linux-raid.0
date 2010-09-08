From: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Subject: =?iso-8859-1?B?UmU6IDMtd2F5IG1pcnJvcnM=?=
Date: Wed, 08 Sep 2010 06:16:16 +0000
Message-ID: <20100908061616.31334.qmail@s217.sureserver.com>
Reply-To: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>  -------Original Message-------
>  From: Neil Brown <neilb@suse.de>
>  To: Michael Sallaway <michael@sallaway.com>
>  Cc: linux-raid@vger.kernel.org
>  Subject: Re: 3-way mirrors
>  Sent: 08 Sep '10 06:02
> =20
>  Hmm.... Drive B shouldn't be ejected from the array for a read error=
=2E=A0=A0md
>  should calculate the data for both A and B from the other devices an=
d then
>  write that to A and B.
>  If the write fails, only then should it kick B from the array.=A0=A0=
Is that what
>  is happening?
> =20
>  i.e. do you see messages like:
>  =A0=A0 read error corrected
>  =A0=A0 read error not correctable
>  =A0=A0 read error NOT corrected
> =20
>  in the kernel logs??


The logs for the relevant section are below, at the bottom -- it's a "r=
ead error not correctable". So I'm guessing it's also failing a write, =
although I can't see the ATA error handling mentioning any writes -- it=
 all looks like reads??


>  If the write is failing, then you want my bad-block-log patches - on=
ly they
>  aren't really finished yet and certainly aren't tested very well.=A0=
=A0I really
>  should get back to those.

Interesting -- I'm not familiar with them, where would I find these pat=
ches? And what would they do -- just allow the bad blocks (even on writ=
es), and keep the drive in the array? That's all I'm really after, in t=
his case, I think.

Thanks!
Michael



Syslog from the failure of the first drive:

Sep  7 09:31:24 lechuck kernel: [51912.039892] ata13.00: exception Emas=
k 0x0 SAct 0x1ff SErr 0x0 action 0x0
Sep  7 09:31:24 lechuck kernel: [51912.048227] ata13.00: irq_stat 0x400=
00008
Sep  7 09:31:24 lechuck kernel: [51912.056685] ata13.00: failed command=
: READ FPDMA QUEUED
Sep  7 09:31:24 lechuck kernel: [51912.065055] ata13.00: cmd 60/d8:08:0=
0:20:d9/00:00:5d:00:00/40 tag 1 ncq 110592 in
Sep  7 09:31:24 lechuck kernel: [51912.065061]          res 51/40:35:a3=
:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
Sep  7 09:31:25 lechuck kernel: [51912.098113] ata13.00: status: { DRDY=
 ERR }
Sep  7 09:31:25 lechuck kernel: [51912.106705] ata13.00: error: { UNC }
Sep  7 09:31:25 lechuck kernel: [51912.128027] ata13.00: configured for=
 UDMA/133
Sep  7 09:31:25 lechuck kernel: [51912.128054] ata13: EH complete
Sep  7 09:31:28 lechuck kernel: [51915.216232] ata13.00: exception Emas=
k 0x0 SAct 0x1ff SErr 0x0 action 0x0
Sep  7 09:31:28 lechuck kernel: [51915.224757] ata13.00: irq_stat 0x400=
00008
Sep  7 09:31:28 lechuck kernel: [51915.233283] ata13.00: failed command=
: READ FPDMA QUEUED
Sep  7 09:31:28 lechuck kernel: [51915.241660] ata13.00: cmd 60/d8:38:0=
0:20:d9/00:00:5d:00:00/40 tag 7 ncq 110592 in
Sep  7 09:31:28 lechuck kernel: [51915.241662]          res 41/40:35:a3=
:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
Sep  7 09:31:28 lechuck kernel: [51915.275603] ata13.00: status: { DRDY=
 ERR }
Sep  7 09:31:28 lechuck kernel: [51915.284267] ata13.00: error: { UNC }
Sep  7 09:31:28 lechuck kernel: [51915.305722] ata13.00: configured for=
 UDMA/133
Sep  7 09:31:28 lechuck kernel: [51915.305746] ata13: EH complete
Sep  7 09:31:30 lechuck kernel: [51917.992164] ata13.00: exception Emas=
k 0x0 SAct 0x1ff SErr 0x0 action 0x0
Sep  7 09:31:30 lechuck kernel: [51918.000791] ata13.00: irq_stat 0x400=
00008
Sep  7 09:31:30 lechuck kernel: [51918.009631] ata13.00: failed command=
: READ FPDMA QUEUED
Sep  7 09:31:30 lechuck kernel: [51918.018303] ata13.00: cmd 60/d8:08:0=
0:20:d9/00:00:5d:00:00/40 tag 1 ncq 110592 in
Sep  7 09:31:30 lechuck kernel: [51918.018305]          res 41/40:35:a3=
:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
Sep  7 09:31:30 lechuck kernel: [51918.054117] ata13.00: status: { DRDY=
 ERR }
Sep  7 09:31:30 lechuck kernel: [51918.062808] ata13.00: error: { UNC }
Sep  7 09:31:30 lechuck kernel: [51918.084521] ata13.00: configured for=
 UDMA/133
Sep  7 09:31:30 lechuck kernel: [51918.084547] ata13: EH complete
Sep  7 09:31:33 lechuck kernel: [51920.956122] ata13.00: exception Emas=
k 0x0 SAct 0x1ff SErr 0x0 action 0x0
Sep  7 09:31:33 lechuck kernel: [51920.964858] ata13.00: irq_stat 0x400=
00008
Sep  7 09:31:33 lechuck kernel: [51920.973829] ata13.00: failed command=
: READ FPDMA QUEUED
Sep  7 09:31:33 lechuck kernel: [51920.982587] ata13.00: cmd 60/d8:38:0=
0:20:d9/00:00:5d:00:00/40 tag 7 ncq 110592 in
Sep  7 09:31:33 lechuck kernel: [51920.982589]          res 41/40:35:a3=
:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
Sep  7 09:31:33 lechuck kernel: [51921.017401] ata13.00: status: { DRDY=
 ERR }
Sep  7 09:31:33 lechuck kernel: [51921.026134] ata13.00: error: { UNC }
Sep  7 09:31:33 lechuck kernel: [51921.048656] ata13.00: configured for=
 UDMA/133
Sep  7 09:31:33 lechuck kernel: [51921.048680] ata13: EH complete
Sep  7 09:31:37 lechuck kernel: [51924.153414] ata13.00: exception Emas=
k 0x0 SAct 0x1ff SErr 0x0 action 0x0
Sep  7 09:31:37 lechuck kernel: [51924.162178] ata13.00: irq_stat 0x400=
00008
Sep  7 09:31:37 lechuck kernel: [51924.162182] ata13.00: failed command=
: READ FPDMA QUEUED
Sep  7 09:31:37 lechuck kernel: [51924.162189] ata13.00: cmd 60/d8:08:0=
0:20:d9/00:00:5d:00:00/40 tag 1 ncq 110592 in
Sep  7 09:31:37 lechuck kernel: [51924.162190]          res 41/40:35:a3=
:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
Sep  7 09:31:37 lechuck kernel: [51924.162193] ata13.00: status: { DRDY=
 ERR }
Sep  7 09:31:37 lechuck kernel: [51924.162195] ata13.00: error: { UNC }
Sep  7 09:31:37 lechuck kernel: [51924.175348] ata13.00: configured for=
 UDMA/133
Sep  7 09:31:37 lechuck kernel: [51924.175374] ata13: EH complete
Sep  7 09:31:39 lechuck kernel: [51927.005666] ata13.00: exception Emas=
k 0x0 SAct 0x1ff SErr 0x0 action 0x0
Sep  7 09:31:39 lechuck kernel: [51927.014384] ata13.00: irq_stat 0x400=
00008
Sep  7 09:31:39 lechuck kernel: [51927.023299] ata13.00: failed command=
: READ FPDMA QUEUED
Sep  7 09:31:39 lechuck kernel: [51927.031949] ata13.00: cmd 60/d8:38:0=
0:20:d9/00:00:5d:00:00/40 tag 7 ncq 110592 in
Sep  7 09:31:39 lechuck kernel: [51927.031951]          res 41/40:35:a3=
:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
Sep  7 09:31:39 lechuck kernel: [51927.066322] ata13.00: status: { DRDY=
 ERR }
Sep  7 09:31:39 lechuck kernel: [51927.074946] ata13.00: error: { UNC }
Sep  7 09:31:40 lechuck kernel: [51927.096349] ata13.00: configured for=
 UDMA/133
Sep  7 09:31:40 lechuck kernel: [51927.096393] sd 12:0:0:0: [sdm] Unhan=
dled sense code
Sep  7 09:31:40 lechuck kernel: [51927.096396] sd 12:0:0:0: [sdm] Resul=
t: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
Sep  7 09:31:40 lechuck kernel: [51927.096401] sd 12:0:0:0: [sdm] Sense=
 Key : Medium Error [current] [descriptor]
Sep  7 09:31:40 lechuck kernel: [51927.096406] Descriptor sense data wi=
th sense descriptors (in hex):
Sep  7 09:31:40 lechuck kernel: [51927.096409]         72 03 11 04 00 0=
0 00 0c 00 0a 80 00 00 00 00 00
Sep  7 09:31:40 lechuck kernel: [51927.096420]         5d d9 20 a3
Sep  7 09:31:40 lechuck kernel: [51927.096425] sd 12:0:0:0: [sdm] Add. =
Sense: Unrecovered read error - auto reallocate failed
Sep  7 09:31:40 lechuck kernel: [51927.096431] sd 12:0:0:0: [sdm] CDB: =
Read(10): 28 00 5d d9 20 00 00 00 d8 00
Sep  7 09:31:40 lechuck kernel: [51927.096442] end_request: I/O error, =
dev sdm, sector 1574510755
Sep  7 09:31:40 lechuck kernel: [51927.104975] raid5:md10: read error n=
ot correctable (sector 1574510752 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.104985] raid5: Disk failure on s=
dm, disabling device.
Sep  7 09:31:40 lechuck kernel: [51927.104989] raid5: Operation continu=
ing on 10 devices.
Sep  7 09:31:40 lechuck kernel: [51927.122210] raid5:md10: read error n=
ot correctable (sector 1574510760 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122214] raid5:md10: read error n=
ot correctable (sector 1574510768 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122218] raid5:md10: read error n=
ot correctable (sector 1574510776 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122222] raid5:md10: read error n=
ot correctable (sector 1574510784 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122225] raid5:md10: read error n=
ot correctable (sector 1574510792 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122229] raid5:md10: read error n=
ot correctable (sector 1574510800 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122242] ata13: EH complete
Sep  7 09:31:40 lechuck kernel: [51927.142926] md: md10: recovery done.
Sep  7 09:31:40 lechuck mdadm[3840]: Fail event detected on md device /=
dev/md10, component device /dev/sdm
Sep  7 09:31:40 lechuck kernel: [51927.344026] RAID5 conf printout:
Sep  7 09:31:40 lechuck kernel: [51927.344031]  --- rd:12 wd:10
Sep  7 09:31:40 lechuck kernel: [51927.344034]  disk 0, o:1, dev:sdf
Sep  7 09:31:40 lechuck kernel: [51927.344037]  disk 1, o:1, dev:sdb
Sep  7 09:31:40 lechuck kernel: [51927.344039]  disk 2, o:1, dev:sda
Sep  7 09:31:40 lechuck kernel: [51927.344042]  disk 3, o:1, dev:sdc
Sep  7 09:31:40 lechuck kernel: [51927.344044]  disk 4, o:1, dev:sdj
Sep  7 09:31:40 lechuck kernel: [51927.344047]  disk 5, o:1, dev:sdi
Sep  7 09:31:40 lechuck kernel: [51927.344049]  disk 6, o:1, dev:sdp
Sep  7 09:31:40 lechuck kernel: [51927.344052]  disk 7, o:1, dev:sdn
Sep  7 09:31:40 lechuck kernel: [51927.344054]  disk 8, o:1, dev:sdo
Sep  7 09:31:40 lechuck kernel: [51927.344057]  disk 9, o:0, dev:sdm
Sep  7 09:31:40 lechuck kernel: [51927.344059]  disk 10, o:1, dev:sdk
Sep  7 09:31:40 lechuck kernel: [51927.344062]  disk 11, o:1, dev:sdl
Sep  7 09:31:40 lechuck kernel: [51927.344064] RAID5 conf printout:
Sep  7 09:31:40 lechuck kernel: [51927.344066]  --- rd:12 wd:10
Sep  7 09:31:40 lechuck kernel: [51927.344068]  disk 0, o:1, dev:sdf
Sep  7 09:31:40 lechuck kernel: [51927.344070]  disk 1, o:1, dev:sdb
Sep  7 09:31:40 lechuck kernel: [51927.344073]  disk 2, o:1, dev:sda
Sep  7 09:31:40 lechuck kernel: [51927.344075]  disk 3, o:1, dev:sdc
Sep  7 09:31:40 lechuck kernel: [51927.344077]  disk 4, o:1, dev:sdj
Sep  7 09:31:40 lechuck kernel: [51927.344080]  disk 5, o:1, dev:sdi
Sep  7 09:31:40 lechuck kernel: [51927.344082]  disk 6, o:1, dev:sdp
Sep  7 09:31:40 lechuck kernel: [51927.344084]  disk 7, o:1, dev:sdn
Sep  7 09:31:40 lechuck kernel: [51927.344087]  disk 8, o:1, dev:sdo
Sep  7 09:31:40 lechuck kernel: [51927.344089]  disk 9, o:0, dev:sdm
Sep  7 09:31:40 lechuck kernel: [51927.344091]  disk 10, o:1, dev:sdk
Sep  7 09:31:40 lechuck kernel: [51927.344093]  disk 11, o:1, dev:sdl
Sep  7 09:31:40 lechuck kernel: [51927.344095] RAID5 conf printout:
Sep  7 09:31:40 lechuck kernel: [51927.344097]  --- rd:12 wd:10
Sep  7 09:31:40 lechuck kernel: [51927.344100]  disk 0, o:1, dev:sdf
Sep  7 09:31:40 lechuck kernel: [51927.344102]  disk 1, o:1, dev:sdb
Sep  7 09:31:40 lechuck kernel: [51927.344104]  disk 2, o:1, dev:sda
Sep  7 09:31:40 lechuck kernel: [51927.344106]  disk 3, o:1, dev:sdc
Sep  7 09:31:40 lechuck kernel: [51927.344109]  disk 4, o:1, dev:sdj
Sep  7 09:31:40 lechuck kernel: [51927.344111]  disk 5, o:1, dev:sdi
Sep  7 09:31:40 lechuck kernel: [51927.344113]  disk 6, o:1, dev:sdp
Sep  7 09:31:40 lechuck kernel: [51927.344116]  disk 7, o:1, dev:sdn
Sep  7 09:31:40 lechuck kernel: [51927.344118]  disk 8, o:1, dev:sdo
Sep  7 09:31:40 lechuck kernel: [51927.344120]  disk 9, o:0, dev:sdm
Sep  7 09:31:40 lechuck kernel: [51927.344122]  disk 10, o:1, dev:sdk
Sep  7 09:31:40 lechuck kernel: [51927.344125]  disk 11, o:1, dev:sdl
Sep  7 09:31:40 lechuck kernel: [51927.400014] RAID5 conf printout:
Sep  7 09:31:40 lechuck kernel: [51927.400017]  --- rd:12 wd:10
Sep  7 09:31:40 lechuck kernel: [51927.400020]  disk 0, o:1, dev:sdf
Sep  7 09:31:40 lechuck kernel: [51927.400022]  disk 1, o:1, dev:sdb
Sep  7 09:31:40 lechuck kernel: [51927.400025]  disk 2, o:1, dev:sda
Sep  7 09:31:40 lechuck kernel: [51927.400027]  disk 3, o:1, dev:sdc
Sep  7 09:31:40 lechuck kernel: [51927.400029]  disk 4, o:1, dev:sdj
Sep  7 09:31:40 lechuck kernel: [51927.400032]  disk 5, o:1, dev:sdi
Sep  7 09:31:40 lechuck kernel: [51927.400034]  disk 6, o:1, dev:sdp
Sep  7 09:31:40 lechuck kernel: [51927.400036]  disk 7, o:1, dev:sdn
Sep  7 09:31:40 lechuck kernel: [51927.400039]  disk 8, o:1, dev:sdo
Sep  7 09:31:40 lechuck kernel: [51927.400041]  disk 10, o:1, dev:sdk
Sep  7 09:31:40 lechuck kernel: [51927.400043]  disk 11, o:1, dev:sdl
Sep  7 09:31:40 lechuck kernel: [51927.400138] md: recovery of RAID arr=
ay md10
Sep  7 09:31:40 lechuck kernel: [51927.400141] md: minimum _guaranteed_=
  speed: 1000 KB/sec/disk.
Sep  7 09:31:40 lechuck kernel: [51927.400145] md: using maximum availa=
ble idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Sep  7 09:31:40 lechuck kernel: [51927.400155] md: using 128k window, o=
ver a total of 1465138496 blocks.
Sep  7 09:31:40 lechuck kernel: [51927.400159] md: resuming recovery of=
 md10 from checkpoint.
Sep  7 09:31:40 lechuck mdadm[3840]: RebuildFinished event detected on =
md device /dev/md10, component device  mismatches found: 477544
Sep  7 09:31:40 lechuck mdadm[3840]: RebuildStarted event detected on m=
d device /dev/md10
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
