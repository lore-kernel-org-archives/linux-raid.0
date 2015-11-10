From: Guillaume Paumier <guillaume.paumier@gmail.com>
Subject: Re: Offline array, events count mismatch
Date: Mon, 09 Nov 2015 19:05:31 -0800
Message-ID: <1970874.nKIz6W3yCk@carbon.lepommierdujardin.fr>
References: <1903758.3ih4aa4jR2@carbon.lepommierdujardin.fr> <56401471.2040605@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56401471.2040605@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Phil and the list,

Le dimanche 8 novembre 2015, 22:35:13 Phil Turmel a =E9crit :
>=20
> On 11/08/2015 09:49 PM, Guillaume Paumier wrote:
> >=20
> > If I understand the documentation [1] correctly, since the event co=
unt for
> > sdj is very close to the event count of sd[b,c,d,g,h,i], I should b=
e able
> > to re- assemble the array with these 7 disks using --force, leaving=
 sde
> > and sdf aside. Once the array is assembled, I should be able to re-=
add
> > sde and sdf, and they will be re-sync'd.
>=20
> Yes, that is the correct response.
>=20
> Your situation is common.  Please see the thread this weekend started=
 by
> Franscisco Parada.

Thank you for confirming, Phil, and for the additional pointer.

I've re-assembled the array with --force, which cleaned sdj, and then I=
 was=20
able to re-add the two other disks. The array started rebuilding and re=
covery=20
was past 10% when the array failed again.

It seems there was an "unrecoverable read error" on sdj, and now I'm ba=
ck with=20
an array where 2 of the disks are marked as spare (sde and sdf, because=
 their=20
rebuild didn't complete), and sdj is faulty with an event count mismatc=
h of 4,=20
like before:

/dev/sdb1:
         Events : 198704
/dev/sdc1:
         Events : 198704
/dev/sdd1:
         Events : 198704
/dev/sde1:
         Events : 198704
/dev/sdf1:
         Events : 198704
/dev/sdg1:
         Events : 198704
/dev/sdh1:
         Events : 198704
/dev/sdi1:
         Events : 198704
/dev/sdj1:
         Events : 198700

Below is the output of dmesg with more details on the read error.

Is there any way I can move past this? This error is preventing me from=
=20
rebuilding the array, and I'm assuming it would also prevent me from co=
pying=20
the data off the array without rebuilding, so I'm not sure how to proce=
ed. Any=20
guidance would be much appreciated.


[88233.712961] md: recovery of RAID array md0
[88233.712965] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[88233.712967] md: using maximum available idle IO bandwidth (but not m=
ore=20
than 200000 KB/sec) for recovery.
[88233.712978] md: using 128k window, over a total of 3907016448k.

[88953.752335] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x=
0
[88953.752345] ata9.01: BMDMA stat 0x64
[88953.752353] ata9.01: failed command: READ DMA EXT
[88953.752368] ata9.01: cmd 25/00:00:00:fc:e8/00:02:27:00:00/f0 tag 0 d=
ma=20
262144 in
         res 51/40:00:f8:fd:e8/40:00:27:00:00/10 Emask 0x9 (media error=
)                                                                      =
              =20
[88953.752375] ata9.01: status: { DRDY ERR }
[88953.752380] ata9.01: error: { UNC }
[88953.793877] ata9.00: configured for UDMA/33
[88953.799795] ata9.01: configured for UDMA/33
[88953.799855] sd 8:0:1:0: [sdj] Unhandled sense code
[88953.799858] sd 8:0:1:0: [sdj] =20
[88953.799860] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[88953.799862] sd 8:0:1:0: [sdj] =20
[88953.799864] Sense Key : Medium Error [current] [descriptor]
[88953.799867] Descriptor sense data with sense descriptors (in hex):
[88953.799868]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[88953.799875]         27 e8 fd f8=20
[88953.799879] sd 8:0:1:0: [sdj] =20
[88953.799882] Add. Sense: Unrecovered read error - auto reallocate fai=
led
[88953.799884] sd 8:0:1:0: [sdj] CDB:=20
[88953.799885] Read(16): 88 00 00 00 00 00 27 e8 fc 00 00 00 02 00 00 0=
0
[88953.799894] end_request: I/O error, dev sdj, sector 669580792
[88953.799898] md/raid:md0: read error not correctable (sector 66957874=
4 on=20
sdj1).
[88953.799924] ata9: EH complete

[89333.138473] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x=
0
[89333.138478] ata9.01: BMDMA stat 0x64
[89333.138482] ata9.01: failed command: READ DMA EXT
[89333.138488] ata9.01: cmd 25/00:00:58:6e:3b/00:02:35:00:00/f0 tag 0 d=
ma=20
262144 in
         res 51/40:00:c8:6f:3b/40:00:35:00:00/10 Emask 0x9 (media error=
)                                                                      =
              =20
[89333.138491] ata9.01: status: { DRDY ERR }
[89333.138493] ata9.01: error: { UNC }
[89333.147985] ata9.00: configured for UDMA/33
[89333.153966] ata9.01: configured for UDMA/33
[89333.154022] sd 8:0:1:0: [sdj] Unhandled sense code
[89333.154025] sd 8:0:1:0: [sdj] =20
[89333.154027] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[89333.154029] sd 8:0:1:0: [sdj] =20
[89333.154031] Sense Key : Medium Error [current] [descriptor]
[89333.154034] Descriptor sense data with sense descriptors (in hex):
[89333.154035]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[89333.154042]         35 3b 6f c8=20
[89333.154046] sd 8:0:1:0: [sdj] =20
[89333.154048] Add. Sense: Unrecovered read error - auto reallocate fai=
led
[89333.154050] sd 8:0:1:0: [sdj] CDB:=20
[89333.154052] Read(16): 88 00 00 00 00 00 35 3b 6e 58 00 00 02 00 00 0=
0
[89333.154061] end_request: I/O error, dev sdj, sector 893087688
[89333.154064] md/raid:md0: read error not correctable (sector 89308564=
0 on=20
sdj1).
[89333.154067] md/raid:md0: read error not correctable (sector 89308564=
8 on=20
sdj1).
[89333.154069] md/raid:md0: read error not correctable (sector 89308565=
6 on=20
sdj1).
[89333.154071] md/raid:md0: read error not correctable (sector 89308566=
4 on=20
sdj1).
[89333.154073] md/raid:md0: read error not correctable (sector 89308567=
2 on=20
sdj1).
[89333.154075] md/raid:md0: read error not correctable (sector 89308568=
0 on=20
sdj1).
[89333.154077] md/raid:md0: read error not correctable (sector 89308568=
8 on=20
sdj1).
[89333.154079] md/raid:md0: read error not correctable (sector 89308569=
6 on=20
sdj1).
[89333.154081] md/raid:md0: read error not correctable (sector 89308570=
4 on=20
sdj1).
[89333.154083] md/raid:md0: read error not correctable (sector 89308571=
2 on=20
sdj1).
[89333.154111] ata9: EH complete
[89338.097012] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x=
0
[89338.097016] ata9.01: BMDMA stat 0x64
[89338.097019] ata9.01: failed command: READ DMA EXT
[89338.097023] ata9.01: cmd 25/00:00:58:70:3b/00:02:35:00:00/f0 tag 0 d=
ma=20
262144 in
         res 51/40:00:60:70:3b/40:00:35:00:00/10 Emask 0x9 (media error=
)                                                                      =
              =20
[89338.097025] ata9.01: status: { DRDY ERR }
[89338.097026] ata9.01: error: { UNC }
[89338.125468] ata9.00: configured for UDMA/33
[89338.131458] ata9.01: configured for UDMA/33
[89338.131489] sd 8:0:1:0: [sdj] Unhandled sense code
[89338.131491] sd 8:0:1:0: [sdj] =20
[89338.131492] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[89338.131493] sd 8:0:1:0: [sdj] =20
[89338.131494] Sense Key : Medium Error [current] [descriptor]
[89338.131496] Descriptor sense data with sense descriptors (in hex):
[89338.131497]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[89338.131502]         35 3b 70 60=20
[89338.131504] sd 8:0:1:0: [sdj] =20
[89338.131506] Add. Sense: Unrecovered read error - auto reallocate fai=
led
[89338.131507] sd 8:0:1:0: [sdj] CDB:=20
[89338.131508] Read(16): 88 00 00 00 00 00 35 3b 70 58 00 00 02 00 00 0=
0
[89338.131513] end_request: I/O error, dev sdj, sector 893087840
[89338.131556] ata9: EH complete
[89342.103300] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x=
0
[89342.103310] ata9.01: BMDMA stat 0x64
[89342.103319] ata9.01: failed command: READ DMA EXT
[89342.103333] ata9.01: cmd 25/00:00:58:72:3b/00:02:35:00:00/f0 tag 0 d=
ma=20
262144 in
         res 51/40:00:58:72:3b/40:00:35:00:00/10 Emask 0x9 (media error=
)                                                                      =
              =20
[89342.103340] ata9.01: status: { DRDY ERR }
[89342.103344] ata9.01: error: { UNC }
[89342.224995] ata9.00: configured for UDMA/33
[89342.230983] ata9.01: configured for UDMA/33
[89342.231022] sd 8:0:1:0: [sdj] Unhandled sense code
[89342.231025] sd 8:0:1:0: [sdj] =20
[89342.231027] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[89342.231029] sd 8:0:1:0: [sdj] =20
[89342.231031] Sense Key : Medium Error [current] [descriptor]
[89342.231034] Descriptor sense data with sense descriptors (in hex):
[89342.231035]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[89342.231042]         35 3b 72 58=20
[89342.231046] sd 8:0:1:0: [sdj] =20
[89342.231049] Add. Sense: Unrecovered read error - auto reallocate fai=
led
[89342.231051] sd 8:0:1:0: [sdj] CDB:=20
[89342.231052] Read(16): 88 00 00 00 00 00 35 3b 72 58 00 00 02 00 00 0=
0
[89342.231061] end_request: I/O error, dev sdj, sector 893088344
[89342.231065] raid5_end_read_request: 71 callbacks suppressed
[89342.231067] md/raid:md0: read error not correctable (sector 89308629=
6 on=20
sdj1).
[89342.231070] md/raid:md0: read error not correctable (sector 89308630=
4 on=20
sdj1).
[89342.231072] md/raid:md0: read error not correctable (sector 89308631=
2 on=20
sdj1).
[89342.231074] md/raid:md0: read error not correctable (sector 89308632=
0 on=20
sdj1).
[89342.231076] md/raid:md0: read error not correctable (sector 89308632=
8 on=20
sdj1).
[89342.231078] md/raid:md0: read error not correctable (sector 89308633=
6 on=20
sdj1).
[89342.231080] md/raid:md0: read error not correctable (sector 89308634=
4 on=20
sdj1).
[89342.231081] md/raid:md0: read error not correctable (sector 89308635=
2 on=20
sdj1).
[89342.231083] md/raid:md0: read error not correctable (sector 89308636=
0 on=20
sdj1).
[89342.231085] md/raid:md0: read error not correctable (sector 89308636=
8 on=20
sdj1).
[89342.231149] ata9: EH complete
[89346.169717] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x=
0
[89346.169727] ata9.01: BMDMA stat 0x64
[89346.169736] ata9.01: failed command: READ DMA EXT
[89346.169750] ata9.01: cmd 25/00:00:58:74:3b/00:02:35:00:00/f0 tag 0 d=
ma=20
262144 in
         res 51/40:00:58:74:3b/40:00:35:00:00/10 Emask 0x9 (media error=
)                                                                      =
              =20
[89346.169758] ata9.01: status: { DRDY ERR }
[89346.169763] ata9.01: error: { UNC }
[89346.198239] ata9.00: configured for UDMA/33
[89346.204166] ata9.01: configured for UDMA/33
[89346.204232] sd 8:0:1:0: [sdj] Unhandled sense code
[89346.204239] sd 8:0:1:0: [sdj] =20
[89346.204243] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[89346.204248] sd 8:0:1:0: [sdj] =20
[89346.204251] Sense Key : Medium Error [current] [descriptor]
[89346.204258] Descriptor sense data with sense descriptors (in hex):
[89346.204261]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[89346.204278]         35 3b 74 58=20
[89346.204286] sd 8:0:1:0: [sdj] =20
[89346.204292] Add. Sense: Unrecovered read error - auto reallocate fai=
led
[89346.204296] sd 8:0:1:0: [sdj] CDB:=20
[89346.204299] Read(16): 88 00 00 00 00 00 35 3b 74 58 00 00 02 00 00 0=
0
[89346.204319] end_request: I/O error, dev sdj, sector 893088856
[89346.204419] ata9: EH complete
[89353.949976] ata9.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x=
0
[89353.949986] ata9.01: BMDMA stat 0x64
[89353.949994] ata9.01: failed command: READ DMA EXT
[89353.950008] ata9.01: cmd 25/00:90:c8:6f:3b/00:00:35:00:00/f0 tag 0 d=
ma=20
73728 in
         res 51/40:00:e0:6f:3b/40:00:35:00:00/10 Emask 0x9 (media error=
)                                                                      =
              =20
[89353.950016] ata9.01: status: { DRDY ERR }
[89353.950021] ata9.01: error: { UNC }
[89353.994545] ata9.00: configured for UDMA/33
[89354.000539] ata9.01: configured for UDMA/33
[89354.000597] sd 8:0:1:0: [sdj] Unhandled sense code
[89354.000603] sd 8:0:1:0: [sdj] =20
[89354.000608] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[89354.000612] sd 8:0:1:0: [sdj] =20
[89354.000616] Sense Key : Medium Error [current] [descriptor]
[89354.000623] Descriptor sense data with sense descriptors (in hex):
[89354.000626]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00=20
[89354.000643]         35 3b 6f e0=20
[89354.000651] sd 8:0:1:0: [sdj] =20
[89354.000657] Add. Sense: Unrecovered read error - auto reallocate fai=
led
[89354.000661] sd 8:0:1:0: [sdj] CDB:=20
[89354.000664] Read(16): 88 00 00 00 00 00 35 3b 6f c8 00 00 00 90 00 0=
0
[89354.000684] end_request: I/O error, dev sdj, sector 893087712
[89354.000692] raid5_end_read_request: 118 callbacks suppressed
[89354.000697] md/raid:md0: read error not correctable (sector 89308566=
4 on=20
sdj1).
[89354.000706] md/raid:md0: Disk failure on sdj1, disabling device.
md/raid:md0: Operation continuing on 6 devices.
[89354.000732] md/raid:md0: read error not correctable (sector 89308567=
2 on=20
sdj1).
[89354.000737] md/raid:md0: read error not correctable (sector 89308568=
0 on=20
sdj1).
[89354.000742] md/raid:md0: read error not correctable (sector 89308568=
8 on=20
sdj1).
[89354.000747] md/raid:md0: read error not correctable (sector 89308569=
6 on=20
sdj1).
[89354.000751] md/raid:md0: read error not correctable (sector 89308570=
4 on=20
sdj1).
[89354.000756] md/raid:md0: read error not correctable (sector 89308571=
2 on=20
sdj1).
[89354.000760] md/raid:md0: read error not correctable (sector 89308572=
0 on=20
sdj1).
[89354.000765] md/raid:md0: read error not correctable (sector 89308572=
8 on=20
sdj1).
[89354.000769] md/raid:md0: read error not correctable (sector 89308573=
6 on=20
sdj1).
[89354.000903] ata9: EH complete
[89354.109105] md: md0: recovery interrupted.
[89354.175670] RAID conf printout:
[89354.175675]  --- level:6 rd:9 wd:6
[89354.175677]  disk 0, o:1, dev:sdc1
[89354.175679]  disk 1, o:1, dev:sdd1
[89354.175680]  disk 2, o:1, dev:sdg1
[89354.175681]  disk 3, o:1, dev:sdh1
[89354.175682]  disk 4, o:1, dev:sdi1
[89354.175683]  disk 5, o:0, dev:sdj1
[89354.175684]  disk 6, o:1, dev:sdf1
[89354.175685]  disk 7, o:1, dev:sde1
[89354.175686]  disk 8, o:1, dev:sdb1
[89354.177220] RAID conf printout:
[89354.177221]  --- level:6 rd:9 wd:6
[89354.177222]  disk 0, o:1, dev:sdc1
[89354.177223]  disk 1, o:1, dev:sdd1
[89354.177224]  disk 2, o:1, dev:sdg1
[89354.177225]  disk 3, o:1, dev:sdh1
[89354.177226]  disk 4, o:1, dev:sdi1
[89354.177227]  disk 5, o:0, dev:sdj1
[89354.177227]  disk 7, o:1, dev:sde1
[89354.177228]  disk 8, o:1, dev:sdb1
[89354.177233] RAID conf printout:
[89354.177234]  --- level:6 rd:9 wd:6
[89354.177234]  disk 0, o:1, dev:sdc1
[89354.177235]  disk 1, o:1, dev:sdd1
[89354.177236]  disk 2, o:1, dev:sdg1
[89354.177237]  disk 3, o:1, dev:sdh1
[89354.177238]  disk 4, o:1, dev:sdi1
[89354.177239]  disk 5, o:0, dev:sdj1
[89354.177240]  disk 7, o:1, dev:sde1
[89354.177241]  disk 8, o:1, dev:sdb1
[89354.179575] RAID conf printout:
[89354.179576]  --- level:6 rd:9 wd:6
[89354.179577]  disk 0, o:1, dev:sdc1
[89354.179578]  disk 1, o:1, dev:sdd1
[89354.179579]  disk 2, o:1, dev:sdg1
[89354.179580]  disk 3, o:1, dev:sdh1
[89354.179581]  disk 4, o:1, dev:sdi1
[89354.179582]  disk 5, o:0, dev:sdj1
[89354.179583]  disk 8, o:1, dev:sdb1
[89354.179585] RAID conf printout:
[89354.179586]  --- level:6 rd:9 wd:6
[89354.179587]  disk 0, o:1, dev:sdc1
[89354.179588]  disk 1, o:1, dev:sdd1
[89354.179589]  disk 2, o:1, dev:sdg1
[89354.179589]  disk 3, o:1, dev:sdh1
[89354.179590]  disk 4, o:1, dev:sdi1
[89354.179591]  disk 5, o:0, dev:sdj1
[89354.179592]  disk 8, o:1, dev:sdb1
[89354.181443] RAID conf printout:
[89354.181444]  --- level:6 rd:9 wd:6
[89354.181445]  disk 0, o:1, dev:sdc1
[89354.181446]  disk 1, o:1, dev:sdd1
[89354.181447]  disk 2, o:1, dev:sdg1
[89354.181448]  disk 3, o:1, dev:sdh1
[89354.181449]  disk 4, o:1, dev:sdi1
[89354.181450]  disk 8, o:1, dev:sdb1

[90001.391680] md0: detected capacity change from 28005493899264 to 0
[90001.391697] md: md0 stopped.
[90001.391717] md: unbind<sdf1>
[90001.396688] md: export_rdev(sdf1)
[90001.396808] md: unbind<sde1>
[90001.403661] md: export_rdev(sde1)
[90001.403726] md: unbind<sdc1>
[90001.412707] md: export_rdev(sdc1)
[90001.412867] md: unbind<sdb1>
[90001.415711] md: export_rdev(sdb1)
[90001.415782] md: unbind<sdj1>
[90001.421708] md: export_rdev(sdj1)
[90001.421783] md: unbind<sdi1>
[90001.424752] md: export_rdev(sdi1)
[90001.424909] md: unbind<sdh1>
[90001.427741] md: export_rdev(sdh1)
[90001.427807] md: unbind<sdg1>
[90001.433745] md: export_rdev(sdg1)
[90001.433812] md: unbind<sdd1>
[90001.436732] md: export_rdev(sdd1)

> You should provide "smartctl -i -A -l scterc /dev/sdX" reports for yo=
ur
> drives.  If you can find an old syslog for when your two worst drives
> fell out, it might help.

Here's the output for the disk with the read error for now, in case it'=
s=20
useful.

# smartctl -i -A -l scterc /dev/sdj
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.16.7-29-desktop] (SUSE RP=
M)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     ST4000VN000-1H4168
Serial Number:    Z300NEB5
LU WWN Device Id: 5 000c50 063ed9f94
=46irmware Version: SC43
User Capacity:    4 000 787 030 016 bytes [4,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5900 rpm
=46orm Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall=
]
ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Nov  9 18:58:47 2015 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED =20
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   094   094   006    Pre-fail  Alway=
s      =20
-       28320486
  3 Spin_Up_Time            0x0003   092   092   000    Pre-fail  Alway=
s      =20
-       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Alway=
s      =20
-       73
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Alway=
s      =20
-       160
  7 Seek_Error_Rate         0x000f   069   060   030    Pre-fail  Alway=
s      =20
-       17212021570
  9 Power_On_Hours          0x0032   079   079   000    Old_age   Alway=
s      =20
-       19201
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Alway=
s      =20
-       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Alway=
s      =20
-       73
184 End-to-End_Error        0x0032   100   100   099    Old_age   Alway=
s      =20
-       0
187 Reported_Uncorrect      0x0032   055   055   000    Old_age   Alway=
s      =20
-       45
188 Command_Timeout         0x0032   100   100   000    Old_age   Alway=
s      =20
-       0
189 High_Fly_Writes         0x003a   001   001   000    Old_age   Alway=
s      =20
-       169
190 Airflow_Temperature_Cel 0x0022   065   057   045    Old_age   Alway=
s      =20
-       35 (Min/Max 30/37)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Alway=
s      =20
-       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Alway=
s      =20
-       28
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Alway=
s      =20
-       73
194 Temperature_Celsius     0x0022   035   043   000    Old_age   Alway=
s      =20
-       35 (0 18 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s      =20
-       48
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offli=
ne      -      =20
48
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Alway=
s      =20
-       0

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)


--=20
Guillaume Paumier
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
