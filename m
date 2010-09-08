From: Neil Brown <neilb@suse.de>
Subject: Re: 3-way mirrors
Date: Wed, 8 Sep 2010 16:40:38 +1000
Message-ID: <20100908164038.3067cc6f@notabene>
References: <20100908061616.31334.qmail@s217.sureserver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100908061616.31334.qmail@s217.sureserver.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Sallaway <michael@sallaway.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 08 Sep 2010 06:16:16 +0000
"Michael Sallaway" <michael@sallaway.com> wrote:

>=20
> >  -------Original Message-------
> >  From: Neil Brown <neilb@suse.de>
> >  To: Michael Sallaway <michael@sallaway.com>
> >  Cc: linux-raid@vger.kernel.org
> >  Subject: Re: 3-way mirrors
> >  Sent: 08 Sep '10 06:02
> > =20
> >  Hmm.... Drive B shouldn't be ejected from the array for a read err=
or.=C2=A0=C2=A0md
> >  should calculate the data for both A and B from the other devices =
and then
> >  write that to A and B.
> >  If the write fails, only then should it kick B from the array.=C2=A0=
=C2=A0Is that what
> >  is happening?
> > =20
> >  i.e. do you see messages like:
> >  =C2=A0=C2=A0 read error corrected
> >  =C2=A0=C2=A0 read error not correctable
> >  =C2=A0=C2=A0 read error NOT corrected
> > =20
> >  in the kernel logs??
>=20
>=20
> The logs for the relevant section are below, at the bottom -- it's a =
"read error not correctable". So I'm guessing it's also failing a write=
, although I can't see the ATA error handling mentioning any writes -- =
it all looks like reads??

Yes, it is just reads.
It looks like you have an ancient kernel - older than April 2010 :-)
A patch went in to 2.6.35 and I think some 2.6.34.y which fixed a bug t=
hat
causes md to drop devices in a degraded RAID6 when it could have fixed =
the
read error.  Commit 7b0bb5368a719

So a newer kernel might fix your problem for you.

>=20
>=20
> >  If the write is failing, then you want my bad-block-log patches - =
only they
> >  aren't really finished yet and certainly aren't tested very well.=C2=
=A0=C2=A0I really
> >  should get back to those.
>=20
> Interesting -- I'm not familiar with them, where would I find these p=
atches? And what would they do -- just allow the bad blocks (even on wr=
ites), and keep the drive in the array? That's all I'm really after, in=
 this case, I think.

I posted them to the list for review a few months ago and haven't got b=
ack to
them.

http://www.spinics.net/lists/raid/msg28813.html

I wouldn't recommend using them until they've seen more review and test=
ing.

NeilBrown



>=20
> Thanks!
> Michael
>=20
>=20
>=20
> Syslog from the failure of the first drive:
>=20
> Sep  7 09:31:24 lechuck kernel: [51912.039892] ata13.00: exception Em=
ask 0x0 SAct 0x1ff SErr 0x0 action 0x0
> Sep  7 09:31:24 lechuck kernel: [51912.048227] ata13.00: irq_stat 0x4=
0000008
> Sep  7 09:31:24 lechuck kernel: [51912.056685] ata13.00: failed comma=
nd: READ FPDMA QUEUED
> Sep  7 09:31:24 lechuck kernel: [51912.065055] ata13.00: cmd 60/d8:08=
:00:20:d9/00:00:5d:00:00/40 tag 1 ncq 110592 in
> Sep  7 09:31:24 lechuck kernel: [51912.065061]          res 51/40:35:=
a3:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
> Sep  7 09:31:25 lechuck kernel: [51912.098113] ata13.00: status: { DR=
DY ERR }
> Sep  7 09:31:25 lechuck kernel: [51912.106705] ata13.00: error: { UNC=
 }
> Sep  7 09:31:25 lechuck kernel: [51912.128027] ata13.00: configured f=
or UDMA/133
> Sep  7 09:31:25 lechuck kernel: [51912.128054] ata13: EH complete
> Sep  7 09:31:28 lechuck kernel: [51915.216232] ata13.00: exception Em=
ask 0x0 SAct 0x1ff SErr 0x0 action 0x0
> Sep  7 09:31:28 lechuck kernel: [51915.224757] ata13.00: irq_stat 0x4=
0000008
> Sep  7 09:31:28 lechuck kernel: [51915.233283] ata13.00: failed comma=
nd: READ FPDMA QUEUED
> Sep  7 09:31:28 lechuck kernel: [51915.241660] ata13.00: cmd 60/d8:38=
:00:20:d9/00:00:5d:00:00/40 tag 7 ncq 110592 in
> Sep  7 09:31:28 lechuck kernel: [51915.241662]          res 41/40:35:=
a3:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
> Sep  7 09:31:28 lechuck kernel: [51915.275603] ata13.00: status: { DR=
DY ERR }
> Sep  7 09:31:28 lechuck kernel: [51915.284267] ata13.00: error: { UNC=
 }
> Sep  7 09:31:28 lechuck kernel: [51915.305722] ata13.00: configured f=
or UDMA/133
> Sep  7 09:31:28 lechuck kernel: [51915.305746] ata13: EH complete
> Sep  7 09:31:30 lechuck kernel: [51917.992164] ata13.00: exception Em=
ask 0x0 SAct 0x1ff SErr 0x0 action 0x0
> Sep  7 09:31:30 lechuck kernel: [51918.000791] ata13.00: irq_stat 0x4=
0000008
> Sep  7 09:31:30 lechuck kernel: [51918.009631] ata13.00: failed comma=
nd: READ FPDMA QUEUED
> Sep  7 09:31:30 lechuck kernel: [51918.018303] ata13.00: cmd 60/d8:08=
:00:20:d9/00:00:5d:00:00/40 tag 1 ncq 110592 in
> Sep  7 09:31:30 lechuck kernel: [51918.018305]          res 41/40:35:=
a3:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
> Sep  7 09:31:30 lechuck kernel: [51918.054117] ata13.00: status: { DR=
DY ERR }
> Sep  7 09:31:30 lechuck kernel: [51918.062808] ata13.00: error: { UNC=
 }
> Sep  7 09:31:30 lechuck kernel: [51918.084521] ata13.00: configured f=
or UDMA/133
> Sep  7 09:31:30 lechuck kernel: [51918.084547] ata13: EH complete
> Sep  7 09:31:33 lechuck kernel: [51920.956122] ata13.00: exception Em=
ask 0x0 SAct 0x1ff SErr 0x0 action 0x0
> Sep  7 09:31:33 lechuck kernel: [51920.964858] ata13.00: irq_stat 0x4=
0000008
> Sep  7 09:31:33 lechuck kernel: [51920.973829] ata13.00: failed comma=
nd: READ FPDMA QUEUED
> Sep  7 09:31:33 lechuck kernel: [51920.982587] ata13.00: cmd 60/d8:38=
:00:20:d9/00:00:5d:00:00/40 tag 7 ncq 110592 in
> Sep  7 09:31:33 lechuck kernel: [51920.982589]          res 41/40:35:=
a3:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
> Sep  7 09:31:33 lechuck kernel: [51921.017401] ata13.00: status: { DR=
DY ERR }
> Sep  7 09:31:33 lechuck kernel: [51921.026134] ata13.00: error: { UNC=
 }
> Sep  7 09:31:33 lechuck kernel: [51921.048656] ata13.00: configured f=
or UDMA/133
> Sep  7 09:31:33 lechuck kernel: [51921.048680] ata13: EH complete
> Sep  7 09:31:37 lechuck kernel: [51924.153414] ata13.00: exception Em=
ask 0x0 SAct 0x1ff SErr 0x0 action 0x0
> Sep  7 09:31:37 lechuck kernel: [51924.162178] ata13.00: irq_stat 0x4=
0000008
> Sep  7 09:31:37 lechuck kernel: [51924.162182] ata13.00: failed comma=
nd: READ FPDMA QUEUED
> Sep  7 09:31:37 lechuck kernel: [51924.162189] ata13.00: cmd 60/d8:08=
:00:20:d9/00:00:5d:00:00/40 tag 1 ncq 110592 in
> Sep  7 09:31:37 lechuck kernel: [51924.162190]          res 41/40:35:=
a3:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
> Sep  7 09:31:37 lechuck kernel: [51924.162193] ata13.00: status: { DR=
DY ERR }
> Sep  7 09:31:37 lechuck kernel: [51924.162195] ata13.00: error: { UNC=
 }
> Sep  7 09:31:37 lechuck kernel: [51924.175348] ata13.00: configured f=
or UDMA/133
> Sep  7 09:31:37 lechuck kernel: [51924.175374] ata13: EH complete
> Sep  7 09:31:39 lechuck kernel: [51927.005666] ata13.00: exception Em=
ask 0x0 SAct 0x1ff SErr 0x0 action 0x0
> Sep  7 09:31:39 lechuck kernel: [51927.014384] ata13.00: irq_stat 0x4=
0000008
> Sep  7 09:31:39 lechuck kernel: [51927.023299] ata13.00: failed comma=
nd: READ FPDMA QUEUED
> Sep  7 09:31:39 lechuck kernel: [51927.031949] ata13.00: cmd 60/d8:38=
:00:20:d9/00:00:5d:00:00/40 tag 7 ncq 110592 in
> Sep  7 09:31:39 lechuck kernel: [51927.031951]          res 41/40:35:=
a3:20:d9/00:00:5d:00:00/40 Emask 0x409 (media error) <F>
> Sep  7 09:31:39 lechuck kernel: [51927.066322] ata13.00: status: { DR=
DY ERR }
> Sep  7 09:31:39 lechuck kernel: [51927.074946] ata13.00: error: { UNC=
 }
> Sep  7 09:31:40 lechuck kernel: [51927.096349] ata13.00: configured f=
or UDMA/133
> Sep  7 09:31:40 lechuck kernel: [51927.096393] sd 12:0:0:0: [sdm] Unh=
andled sense code
> Sep  7 09:31:40 lechuck kernel: [51927.096396] sd 12:0:0:0: [sdm] Res=
ult: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> Sep  7 09:31:40 lechuck kernel: [51927.096401] sd 12:0:0:0: [sdm] Sen=
se Key : Medium Error [current] [descriptor]
> Sep  7 09:31:40 lechuck kernel: [51927.096406] Descriptor sense data =
with sense descriptors (in hex):
> Sep  7 09:31:40 lechuck kernel: [51927.096409]         72 03 11 04 00=
 00 00 0c 00 0a 80 00 00 00 00 00
> Sep  7 09:31:40 lechuck kernel: [51927.096420]         5d d9 20 a3
> Sep  7 09:31:40 lechuck kernel: [51927.096425] sd 12:0:0:0: [sdm] Add=
=2E Sense: Unrecovered read error - auto reallocate failed
> Sep  7 09:31:40 lechuck kernel: [51927.096431] sd 12:0:0:0: [sdm] CDB=
: Read(10): 28 00 5d d9 20 00 00 00 d8 00
> Sep  7 09:31:40 lechuck kernel: [51927.096442] end_request: I/O error=
, dev sdm, sector 1574510755
> Sep  7 09:31:40 lechuck kernel: [51927.104975] raid5:md10: read error=
 not correctable (sector 1574510752 on sdm).
> Sep  7 09:31:40 lechuck kernel: [51927.104985] raid5: Disk failure on=
 sdm, disabling device.
> Sep  7 09:31:40 lechuck kernel: [51927.104989] raid5: Operation conti=
nuing on 10 devices.
> Sep  7 09:31:40 lechuck kernel: [51927.122210] raid5:md10: read error=
 not correctable (sector 1574510760 on sdm).
> Sep  7 09:31:40 lechuck kernel: [51927.122214] raid5:md10: read error=
 not correctable (sector 1574510768 on sdm).
> Sep  7 09:31:40 lechuck kernel: [51927.122218] raid5:md10: read error=
 not correctable (sector 1574510776 on sdm).
> Sep  7 09:31:40 lechuck kernel: [51927.122222] raid5:md10: read error=
 not correctable (sector 1574510784 on sdm).
> Sep  7 09:31:40 lechuck kernel: [51927.122225] raid5:md10: read error=
 not correctable (sector 1574510792 on sdm).
> Sep  7 09:31:40 lechuck kernel: [51927.122229] raid5:md10: read error=
 not correctable (sector 1574510800 on sdm).
> Sep  7 09:31:40 lechuck kernel: [51927.122242] ata13: EH complete
> Sep  7 09:31:40 lechuck kernel: [51927.142926] md: md10: recovery don=
e.
> Sep  7 09:31:40 lechuck mdadm[3840]: Fail event detected on md device=
 /dev/md10, component device /dev/sdm
> Sep  7 09:31:40 lechuck kernel: [51927.344026] RAID5 conf printout:
> Sep  7 09:31:40 lechuck kernel: [51927.344031]  --- rd:12 wd:10
> Sep  7 09:31:40 lechuck kernel: [51927.344034]  disk 0, o:1, dev:sdf
> Sep  7 09:31:40 lechuck kernel: [51927.344037]  disk 1, o:1, dev:sdb
> Sep  7 09:31:40 lechuck kernel: [51927.344039]  disk 2, o:1, dev:sda
> Sep  7 09:31:40 lechuck kernel: [51927.344042]  disk 3, o:1, dev:sdc
> Sep  7 09:31:40 lechuck kernel: [51927.344044]  disk 4, o:1, dev:sdj
> Sep  7 09:31:40 lechuck kernel: [51927.344047]  disk 5, o:1, dev:sdi
> Sep  7 09:31:40 lechuck kernel: [51927.344049]  disk 6, o:1, dev:sdp
> Sep  7 09:31:40 lechuck kernel: [51927.344052]  disk 7, o:1, dev:sdn
> Sep  7 09:31:40 lechuck kernel: [51927.344054]  disk 8, o:1, dev:sdo
> Sep  7 09:31:40 lechuck kernel: [51927.344057]  disk 9, o:0, dev:sdm
> Sep  7 09:31:40 lechuck kernel: [51927.344059]  disk 10, o:1, dev:sdk
> Sep  7 09:31:40 lechuck kernel: [51927.344062]  disk 11, o:1, dev:sdl
> Sep  7 09:31:40 lechuck kernel: [51927.344064] RAID5 conf printout:
> Sep  7 09:31:40 lechuck kernel: [51927.344066]  --- rd:12 wd:10
> Sep  7 09:31:40 lechuck kernel: [51927.344068]  disk 0, o:1, dev:sdf
> Sep  7 09:31:40 lechuck kernel: [51927.344070]  disk 1, o:1, dev:sdb
> Sep  7 09:31:40 lechuck kernel: [51927.344073]  disk 2, o:1, dev:sda
> Sep  7 09:31:40 lechuck kernel: [51927.344075]  disk 3, o:1, dev:sdc
> Sep  7 09:31:40 lechuck kernel: [51927.344077]  disk 4, o:1, dev:sdj
> Sep  7 09:31:40 lechuck kernel: [51927.344080]  disk 5, o:1, dev:sdi
> Sep  7 09:31:40 lechuck kernel: [51927.344082]  disk 6, o:1, dev:sdp
> Sep  7 09:31:40 lechuck kernel: [51927.344084]  disk 7, o:1, dev:sdn
> Sep  7 09:31:40 lechuck kernel: [51927.344087]  disk 8, o:1, dev:sdo
> Sep  7 09:31:40 lechuck kernel: [51927.344089]  disk 9, o:0, dev:sdm
> Sep  7 09:31:40 lechuck kernel: [51927.344091]  disk 10, o:1, dev:sdk
> Sep  7 09:31:40 lechuck kernel: [51927.344093]  disk 11, o:1, dev:sdl
> Sep  7 09:31:40 lechuck kernel: [51927.344095] RAID5 conf printout:
> Sep  7 09:31:40 lechuck kernel: [51927.344097]  --- rd:12 wd:10
> Sep  7 09:31:40 lechuck kernel: [51927.344100]  disk 0, o:1, dev:sdf
> Sep  7 09:31:40 lechuck kernel: [51927.344102]  disk 1, o:1, dev:sdb
> Sep  7 09:31:40 lechuck kernel: [51927.344104]  disk 2, o:1, dev:sda
> Sep  7 09:31:40 lechuck kernel: [51927.344106]  disk 3, o:1, dev:sdc
> Sep  7 09:31:40 lechuck kernel: [51927.344109]  disk 4, o:1, dev:sdj
> Sep  7 09:31:40 lechuck kernel: [51927.344111]  disk 5, o:1, dev:sdi
> Sep  7 09:31:40 lechuck kernel: [51927.344113]  disk 6, o:1, dev:sdp
> Sep  7 09:31:40 lechuck kernel: [51927.344116]  disk 7, o:1, dev:sdn
> Sep  7 09:31:40 lechuck kernel: [51927.344118]  disk 8, o:1, dev:sdo
> Sep  7 09:31:40 lechuck kernel: [51927.344120]  disk 9, o:0, dev:sdm
> Sep  7 09:31:40 lechuck kernel: [51927.344122]  disk 10, o:1, dev:sdk
> Sep  7 09:31:40 lechuck kernel: [51927.344125]  disk 11, o:1, dev:sdl
> Sep  7 09:31:40 lechuck kernel: [51927.400014] RAID5 conf printout:
> Sep  7 09:31:40 lechuck kernel: [51927.400017]  --- rd:12 wd:10
> Sep  7 09:31:40 lechuck kernel: [51927.400020]  disk 0, o:1, dev:sdf
> Sep  7 09:31:40 lechuck kernel: [51927.400022]  disk 1, o:1, dev:sdb
> Sep  7 09:31:40 lechuck kernel: [51927.400025]  disk 2, o:1, dev:sda
> Sep  7 09:31:40 lechuck kernel: [51927.400027]  disk 3, o:1, dev:sdc
> Sep  7 09:31:40 lechuck kernel: [51927.400029]  disk 4, o:1, dev:sdj
> Sep  7 09:31:40 lechuck kernel: [51927.400032]  disk 5, o:1, dev:sdi
> Sep  7 09:31:40 lechuck kernel: [51927.400034]  disk 6, o:1, dev:sdp
> Sep  7 09:31:40 lechuck kernel: [51927.400036]  disk 7, o:1, dev:sdn
> Sep  7 09:31:40 lechuck kernel: [51927.400039]  disk 8, o:1, dev:sdo
> Sep  7 09:31:40 lechuck kernel: [51927.400041]  disk 10, o:1, dev:sdk
> Sep  7 09:31:40 lechuck kernel: [51927.400043]  disk 11, o:1, dev:sdl
> Sep  7 09:31:40 lechuck kernel: [51927.400138] md: recovery of RAID a=
rray md10
> Sep  7 09:31:40 lechuck kernel: [51927.400141] md: minimum _guarantee=
d_  speed: 1000 KB/sec/disk.
> Sep  7 09:31:40 lechuck kernel: [51927.400145] md: using maximum avai=
lable idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
> Sep  7 09:31:40 lechuck kernel: [51927.400155] md: using 128k window,=
 over a total of 1465138496 blocks.
> Sep  7 09:31:40 lechuck kernel: [51927.400159] md: resuming recovery =
of md10 from checkpoint.
> Sep  7 09:31:40 lechuck mdadm[3840]: RebuildFinished event detected o=
n md device /dev/md10, component device  mismatches found: 477544
> Sep  7 09:31:40 lechuck mdadm[3840]: RebuildStarted event detected on=
 md device /dev/md10
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
