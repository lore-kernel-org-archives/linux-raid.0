From: NeilBrown <neilb@suse.de>
Subject: Re: read errors not corrected when doing check on RAID6
Date: Thu, 16 Jan 2014 09:59:00 +1100
Message-ID: <20140116095900.6861234c@notabene.brown>
References: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/23EV01uFHxVlLgDh9Nz0osY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/23EV01uFHxVlLgDh9Nz0osY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Jan 2014 07:41:14 +0100 (CET) Mikael Abrahamsson
<swmike@swm.pp.se> wrote:

>=20
> Hello.
>=20
> Running Debian with 3.11-0.bpo.2-amd64 with mdadm 3.2.5 (later upgraded t=
o=20
> 3.3 to do the replace function described).
>=20
> /dev/sds on the system had 9 pending sectors according to smartctl. I=20
> issued a check and got several read during the check. I started the check=
=20
> by taking what debian has in its crontab:
>=20
> /usr/share/mdadm/checkarray --cron --all --idle --quiet
>=20
> This resulted in this in dmesg (there are two arrays), I don't know why i=
t=20
> didn't do the RAID conf printout for md2.
>=20
> [  569.034227] RAID conf printout:
> [  569.034233]  --- level:6 rd:10 wd:10
> [  569.034236]  disk 0, o:1, dev:sdn
> [  569.034238]  disk 1, o:1, dev:sdh
> [  569.034241]  disk 2, o:1, dev:sdj
> [  569.034243]  disk 3, o:1, dev:sdd
> [  569.034245]  disk 4, o:1, dev:sds
> [  569.034248]  disk 5, o:1, dev:sdv
> [  569.034250]  disk 6, o:1, dev:sdb
> [  569.034252]  disk 7, o:1, dev:sdc
> [  569.034254]  disk 8, o:1, dev:sdf
> [  569.034257]  disk 9, o:1, dev:sde
> [  569.034292] md: data-check of RAID array md0
> [  569.034337] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  569.034384] md: using maximum available idle IO bandwidth (but not mor=
e than 200000 KB/sec) for data-check.
> [  569.034440] md: using 128k window, over a total of 1953512960k.
> [  569.520326] md: data-check of RAID array md2
> [  569.520379] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [  569.520427] md: using maximum available idle IO bandwidth (but not mor=
e than 200000 KB/sec) for data-check.
> [  569.520488] md: using 128k window, over a total of 2930265408k.
> [  662.413059] perf samples too long (2504 > 2500), lowering kernel.perf_=
event_max_sample_rate to 50000
> [  714.577123] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [  714.577187] ata13.01: failed command: READ DMA EXT
> [  714.577245] ata13.01: cmd 25/00:00:58:3a:7c/00:04:00:00:00/f0 tag 0 dm=
a 524288 in
> [  714.577245]          res 51/40:28:30:3c:7c/40:02:00:00:00/f0 Emask 0x9=
 (media error)
> [  714.577330] ata13.01: status: { DRDY ERR }
> [  714.577381] ata13.01: error: { UNC }
> [  714.796272] ata13.00: configured for UDMA/133
> [  714.804347] ata13.01: configured for UDMA/133
> [  714.804767] sd 13:0:1:0: [sds] Unhandled sense code
> [  714.804887] sd 13:0:1:0: [sds]
> [  714.804988] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [  714.805094] sd 13:0:1:0: [sds]
> [  714.805194] Sense Key : Medium Error [current] [descriptor]
> [  714.805491] Descriptor sense data with sense descriptors (in hex):
> [  714.805665]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [  714.806845]         00 7c 3c 30
> [  714.807257] sd 13:0:1:0: [sds]
> [  714.807357] Add. Sense: Unrecovered read error - auto reallocate failed
> [  714.807531] sd 13:0:1:0: [sds] CDB:
> [  714.807632] Read(10): 28 00 00 7c 3a 58 00 04 00 00
> [  714.808494] end_request: I/O error, dev sds, sector 8141872
> [  714.808638] ata13: EH complete
>=20
> There were even more errors (not included), but md didn't seem to correct=
=20
> them. After the check, the number of pending sectors on /dev/sds was stil=
l=20
> 9.
>=20
> The reason to upgrade fmor kernel 3.2 to 3.11 was to gain the use of the=
=20
> replace function. I then issued:
>=20
> mdadm /dev/md0 --replace /dev/sds
>=20
> dmesg:
>=20
> [74791.213852] RAID conf printout:
> [74791.213858]  --- level:6 rd:10 wd:10
> [74791.213861]  disk 0, o:1, dev:sdn
> [74791.213864]  disk 1, o:1, dev:sdh
> [74791.213866]  disk 2, o:1, dev:sdj
> [74791.213869]  disk 3, o:1, dev:sdd
> [74791.213871]  disk 4, o:1, dev:sds
> [74791.213874]  disk 5, o:1, dev:sdv
> [74791.213876]  disk 6, o:1, dev:sdb
> [74791.213879]  disk 7, o:1, dev:sdc
> [74791.213881]  disk 8, o:1, dev:sdf
> [74791.213884]  disk 9, o:1, dev:sde
> [74791.252331] md: recovery of RAID array md0
> [74791.252371] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [74791.252405] md: using maximum available idle IO bandwidth (but not mor=
e than 200000 KB/sec) for recovery.
> [74791.252466] md: using 128k window, over a total of 1953512960k.
> [74872.590157] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [74872.590193] ata13.01: failed command: READ DMA EXT
> [74872.590226] ata13.01: cmd 25/00:00:38:fd:7b/00:04:00:00:00/f0 tag 0 dm=
a 524288 in
> [74872.590226]          res 51/40:48:f0:fe:7b/40:02:00:00:00/f0 Emask 0x9=
 (media error)
> [74872.590315] ata13.01: status: { DRDY ERR }
> [74872.590341] ata13.01: error: { UNC }
> [74872.820239] ata13.00: configured for UDMA/133
> [74872.828258] ata13.01: configured for UDMA/133
> [74872.828571] sd 13:0:1:0: [sds] Unhandled sense code
> [74872.828601] sd 13:0:1:0: [sds]
> [74872.828624] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [74872.828652] sd 13:0:1:0: [sds]
> [74872.828675] Sense Key : Medium Error [current] [descriptor]
> [74872.828710] Descriptor sense data with sense descriptors (in hex):
> [74872.828753]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [74872.828816]         00 7b fe f0
> [74872.828850] sd 13:0:1:0: [sds]
> [74872.828874] Add. Sense: Unrecovered read error - auto reallocate failed
> [74872.828904] sd 13:0:1:0: [sds] CDB:
> [74872.828928] Read(10): 28 00 00 7b fd 38 00 04 00 00
> [74872.828979] end_request: I/O error, dev sds, sector 8126192
> [74872.829055] ata13: EH complete
> [74877.699161] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [74877.699197] ata13.01: failed command: READ DMA
> [74877.699228] ata13.01: cmd c8/00:08:f0:fe:7b/00:00:00:00:00/f0 tag 0 dm=
a 4096 in
> [74877.699228]          res 51/40:08:f0:fe:7b/40:02:00:00:00/f0 Emask 0x9=
 (media error)
> [74877.699317] ata13.01: status: { DRDY ERR }
> [74877.699342] ata13.01: error: { UNC }
> [74877.928227] ata13.00: configured for UDMA/133
> [74877.936278] ata13.01: configured for UDMA/133
> [74877.936317] sd 13:0:1:0: [sds] Unhandled sense code
> [74877.936343] sd 13:0:1:0: [sds]
> [74877.936367] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [74877.936395] sd 13:0:1:0: [sds]
> [74877.936417] Sense Key : Medium Error [current] [descriptor]
> [74877.936450] Descriptor sense data with sense descriptors (in hex):
> [74877.936479]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [74877.936541]         00 7b fe f0
> [74877.936573] sd 13:0:1:0: [sds]
> [74877.936597] Add. Sense: Unrecovered read error - auto reallocate failed
> [74877.936628] sd 13:0:1:0: [sds] CDB:
> [74877.936651] Read(10): 28 00 00 7b fe f0 00 00 08 00
> [74877.936701] end_request: I/O error, dev sds, sector 8126192
> [74877.936730] end_request: I/O error, dev sds, sector 8126192
> [74877.936771] ata13: EH complete
> [74884.058379] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [74884.058416] ata13.01: failed command: READ DMA EXT
> [74884.058447] ata13.01: cmd 25/00:00:38:39:7c/00:04:00:00:00/f0 tag 0 dm=
a 524288 in
> [74884.058447]          res 51/40:08:30:3c:7c/40:01:00:00:00/f0 Emask 0x9=
 (media error)
> [74884.058535] ata13.01: status: { DRDY ERR }
> [74884.058561] ata13.01: error: { UNC }
> [74884.288226] ata13.00: configured for UDMA/133
> [74884.296277] ata13.01: configured for UDMA/133
> [74884.296570] sd 13:0:1:0: [sds] Unhandled sense code
> [74884.296598] sd 13:0:1:0: [sds]
> [74884.296622] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [74884.296650] sd 13:0:1:0: [sds]
> [74884.296673] Sense Key : Medium Error [current] [descriptor]
> [74884.296708] Descriptor sense data with sense descriptors (in hex):
> [74884.296739]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [74884.296805]         00 7c 3c 30
> [74884.296838] sd 13:0:1:0: [sds]
> [74884.296862] Add. Sense: Unrecovered read error - auto reallocate failed
> [74884.296892] sd 13:0:1:0: [sds] CDB:
> [74884.296916] Read(10): 28 00 00 7c 39 38 00 04 00 00
> [74884.296967] end_request: I/O error, dev sds, sector 8141872
> [74884.297020] ata13: EH complete
> [74889.334006] ata13.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [74889.334041] ata13.01: failed command: READ DMA
> [74889.334072] ata13.01: cmd c8/00:08:30:3c:7c/00:00:00:00:00/f0 tag 0 dm=
a 4096 in
> [74889.334072]          res 51/40:08:30:3c:7c/40:01:00:00:00/f0 Emask 0x9=
 (media error)
> [74889.334159] ata13.01: status: { DRDY ERR }
> [74889.334184] ata13.01: error: { UNC }
> [74889.564227] ata13.00: configured for UDMA/133
> [74889.572286] ata13.01: configured for UDMA/133
> [74889.572322] sd 13:0:1:0: [sds] Unhandled sense code
> [74889.572349] sd 13:0:1:0: [sds]
> [74889.572372] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
> [74889.572399] sd 13:0:1:0: [sds]
> [74889.572422] Sense Key : Medium Error [current] [descriptor]
> [74889.572455] Descriptor sense data with sense descriptors (in hex):
> [74889.572484]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [74889.572546]         00 7c 3c 30
> [74889.572579] sd 13:0:1:0: [sds]
> [74889.572603] Add. Sense: Unrecovered read error - auto reallocate failed
> [74889.572633] sd 13:0:1:0: [sds] CDB:
> [74889.572657] Read(10): 28 00 00 7c 3c 30 00 00 08 00
> [74889.572708] end_request: I/O error, dev sds, sector 8141872
> [74889.572737] end_request: I/O error, dev sds, sector 8141872
> [74889.572774] ata13: EH complete
> [74891.334029] md/raid:md0: read error corrected (8 sectors at 8126192 on=
 sds)
> [74891.353112] md/raid:md0: read error corrected (8 sectors at 8141872 on=
 sds)
>=20
> So here now in the replace function, md decided to correct the read error=
s=20
> on /dev/sds. Now the pending sectors are down to 7 on /dev/sds. There wer=
e=20
> some more errors which were also corrected, and now the pending count is=
=20
> down to 5. Recovery is still ongoing.
>=20
> So my question is, what did I do wrong the first time when doing the=20
> check? I expected it to correct the read errors on the drive then, but it=
=20
> seems it didn't. Should I have issued a "repair" instead?
>=20

Don't be too hasty in assuming you did something wrong.  When working with
computers, it is usually the computer that did something wrongly :-)

A 'check' certainly should correct read errors.  The code for handling read
errors makes no distinction between 'check' or 'repair' or regular IO.

When md/raid[56] gets a read error, the first thing it does is retry the re=
ad
with REQ_FLUSH (or in later kernels: REQ_NOMERGE) set.  This ensure that ea=
ch
1-page read goes down to the drive as a stand-alone request so we know with
more precision which sector had the error (usually multiple blocks are merg=
ed
so an error might mean "one block in a 128K region near here failed").
If this second read fails, then that required data is generated from
elsewhere and a write is scheduled.

My only guess is that in your case the second read succeeded when you were
doing a 'check', but it failed when you were doing a 'replace'.

To check this you can looked for "end_request: I/O error" in the kernel log=
s.
In the fragments you included there is just one error during the 'check', b=
ut
3 for each block during the 'replace'.  Given the timestamps, the 2nd and 3=
rd
are probably for the same request - some logging weirdness maybe.
Obviously you only provided fragments so we can't read too much into what we
see.  Looking at the complete logs could be more helpful.

NeilBrown

--Sig_/23EV01uFHxVlLgDh9Nz0osY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtcStDnsnt1WYoG5AQLiIQ//VvXFE8wXRehCcROTwgd3ZG/Zqug5lFCF
5FOIUV3HMgmbkfos7jN4wg0HrXYCO1Hl0WaDk9Fs4/IQDOspHOIq3LFRY25LIMcN
Zenxu/zQvk7lx1tgTblUEE0A3PMgelubt1BDR2cG1cQopbM3byg8Tn+MRRBqE1j/
pgy9kvqmTDQ3Efbdu/mtdHRxR4sqdvzTNKuLb+eL2NGvS+k0QRo59phA3pN+f7mG
Gh0dB97sDhBaHutSIs6pNB9mV3E4HXh56ylLNO2j7j/Ywvw+HMaNmqiOTWuEwaIQ
iyPyn+Kq12xKuR+wATcDo4626dbvTt9P0S4XoUlVuDSaSKveNuX1nvqcOlXebvSF
JOtgugFefFhQ+6IlPTiT1IgmGrEmzsnBhXCqRwmQf7G9rotKvb4+FD/z87g5KI7d
h7n0bIlmwZl8Y+zneFn69Tqy6FCZfOtVHEsqvo7j0yFjUnUap1pj92yEpU4IrKX5
nsrHoUPryZoG4inrYgOIyWK1uhY5Ftenghuf2pFUb0oHhO/6VKaJ/JkehFTh+/Uu
vHViL798NiCvFzFWtNh958MIgE7PRJZZQ/gjcGYE1vYwFVmJcMnR8zbMF7CYIhAZ
/+J7qMoOAOxOynUx6xGlEVo94htX/8aAcT/BY2qJZBSV+TVoI5OuH/oyyCnlcbTG
8nNS8Ht00yw=
=RyYA
-----END PGP SIGNATURE-----

--Sig_/23EV01uFHxVlLgDh9Nz0osY--
