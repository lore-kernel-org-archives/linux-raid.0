From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Sun, 08 Nov 2009 13:22:25 -0500
Message-ID: <4AF70C61.5030301@gmail.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D5FD.2010602@gmail.com> <4AF70791.9080007@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF70791.9080007@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Roger Heflin <rogerheflin@gmail.com>, robin@robinhill.me.uk, linux-raid list <linux-raid@vger.kernel.org>, nfbrown@novell.com
List-Id: linux-raid.ids

New data now, I got this from dmesg when it went down again. Hopefully
there is some significance to you guys.

> [14269.650381] sd 10:0:3:0: rejecting I/O to offline device
> [14269.650453] sd 10:0:3:0: rejecting I/O to offline device
> [14269.650524] sd 10:0:3:0: rejecting I/O to offline device
> [14269.650595] sd 10:0:3:0: rejecting I/O to offline device
> [14269.650672] sd 10:0:3:0: [sdh] Unhandled error code
> [14269.650675] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
> [14269.650680] end_request: I/O error, dev sdh, sector 1435085631
> [14269.650749] raid5:md0: read error not correctable (sector
1435085568 on sdh1).
> [14269.650753] raid5: Disk failure on sdh1, disabling device.
> [14269.650754] raid5: Operation continuing on 7 devices.
> [14269.650886] raid5:md0: read error not correctable (sector
1435085576 on sdh1).
> [14269.650890] raid5:md0: read error not correctable (sector
1435085584 on sdh1).
> [14269.650894] raid5:md0: read error not correctable (sector
1435085592 on sdh1).
> [14269.650898] raid5:md0: read error not correctable (sector
1435085600 on sdh1).
> [14269.650902] raid5:md0: read error not correctable (sector
1435085608 on sdh1).
> [14269.650905] raid5:md0: read error not correctable (sector
1435085616 on sdh1).
> [14269.650909] raid5:md0: read error not correctable (sector
1435085624 on sdh1).
> [14269.650913] raid5:md0: read error not correctable (sector
1435085632 on sdh1).
> [14269.650917] raid5:md0: read error not correctable (sector
1435085640 on sdh1).
> [14269.650943] sd 10:0:3:0: [sdh] Unhandled error code
> [14269.650946] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
> [14269.650950] end_request: I/O error, dev sdh, sector 1435085887
> [14269.651049] sd 10:0:3:0: [sdh] Unhandled error code
> [14269.651051] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
> [14269.651055] end_request: I/O error, dev sdh, sector 1435086143
> [14269.651151] sd 10:0:3:0: [sdh] Unhandled error code
> [14269.651153] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
> [14269.651157] end_request: I/O error, dev sdh, sector 1435086399
> [14269.651253] sd 10:0:3:0: [sdh] Unhandled error code
> [14269.651255] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
> [14269.651259] end_request: I/O error, dev sdh, sector 1435086655
> [14269.651358] sd 10:0:3:0: [sdh] Unhandled error code
> [14269.651361] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
> [14269.651364] end_request: I/O error, dev sdh, sector 1435086911
> [14269.651461] sd 10:0:3:0: [sdh] Unhandled error code
> [14269.651463] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
> [14269.651467] end_request: I/O error, dev sdh, sector 1435087167
> [14269.651565] sd 10:0:3:0: [sdh] Unhandled error code
> [14269.651568] sd 10:0:3:0: [sdh] Result: hostbyte=DID_NO_CONNECT
driverbyte=DRIVER_OK
> [14269.651571] end_request: I/O error, dev sdh, sector 1435087423
> [14269.670675] end_request: I/O error, dev sdf, sector 1953519935
> [14269.670739] md: super_written gets error=-5, uptodate=0
> [14269.670743] raid5: Disk failure on sdf1, disabling device.
> [14269.670745] raid5: Operation continuing on 6 devices.
> [14269.672525] end_request: I/O error, dev sdg, sector 1953519935
> [14269.672598] md: super_written gets error=-5, uptodate=0
> [14269.672603] raid5: Disk failure on sdg1, disabling device.
> [14269.672605] raid5: Operation continuing on 5 devices.
> [14269.674402] end_request: I/O error, dev sde, sector 1953519935
> [14269.674474] md: super_written gets error=-5, uptodate=0
> [14269.674478] raid5: Disk failure on sde1, disabling device.
> [14269.674480] raid5: Operation continuing on 4 devices.
> [14269.769991] sd 11:0:0:0: [sdi] Sense Key : Recovered Error
[current] [descriptor]
> [14269.769997] Descriptor sense data with sense descriptors (in hex):
> [14269.770000]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14269.770012]         00 4f 00 c2 00 50
> [14269.770018] sd 11:0:0:0: [sdi] Add. Sense: ATA pass through
information available
> [14269.800245] md: md0: recovery done.
> [14269.869990] sd 11:0:0:0: [sdi] Sense Key : Recovered Error
[current] [descriptor]
> [14269.869997] Descriptor sense data with sense descriptors (in hex):
> [14269.870008]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14269.870019]         00 4f 00 c2 00 50
> [14269.870025] sd 11:0:0:0: [sdi] Add. Sense: ATA pass through
information available
> [14269.905144] RAID5 conf printout:
> [14269.905148]  --- rd:9 wd:4
> [14269.905152]  disk 0, o:0, dev:sde1
> [14269.905155]  disk 1, o:0, dev:sdf1
> [14269.905157]  disk 2, o:0, dev:sdg1
> [14269.905160]  disk 3, o:0, dev:sdh1
> [14269.905162]  disk 4, o:1, dev:sdi1
> [14269.905165]  disk 5, o:1, dev:sdj1
> [14269.905167]  disk 6, o:1, dev:sdk1
> [14269.905169]  disk 7, o:1, dev:sdl1
> [14269.905172]  disk 8, o:1, dev:sdm1
> [14269.941265] RAID5 conf printout:
> [14269.941269]  --- rd:9 wd:4
> [14269.941273]  disk 0, o:0, dev:sde1
> [14269.941276]  disk 1, o:0, dev:sdf1
> [14269.941278]  disk 2, o:0, dev:sdg1
> [14269.941281]  disk 3, o:0, dev:sdh1
> [14269.941283]  disk 4, o:1, dev:sdi1
> [14269.941286]  disk 5, o:1, dev:sdj1
> [14269.941289]  disk 7, o:1, dev:sdl1
> [14269.941291]  disk 8, o:1, dev:sdm1
> [14269.941300] RAID5 conf printout:
> [14269.941302]  --- rd:9 wd:4
> [14269.941304]  disk 0, o:0, dev:sde1
> [14269.941307]  disk 1, o:0, dev:sdf1
> [14269.941309]  disk 2, o:0, dev:sdg1
> [14269.941311]  disk 3, o:0, dev:sdh1
> [14269.941314]  disk 4, o:1, dev:sdi1
> [14269.941316]  disk 5, o:1, dev:sdj1
> [14269.941318]  disk 7, o:1, dev:sdl1
> [14269.941321]  disk 8, o:1, dev:sdm1
> [14269.981260] RAID5 conf printout:
> [14269.981263]  --- rd:9 wd:4
> [14269.981265]  disk 0, o:0, dev:sde1
> [14269.981268]  disk 2, o:0, dev:sdg1
> [14269.981270]  disk 3, o:0, dev:sdh1
> [14269.981273]  disk 4, o:1, dev:sdi1
> [14269.981275]  disk 5, o:1, dev:sdj1
> [14269.981277]  disk 7, o:1, dev:sdl1
> [14269.981280]  disk 8, o:1, dev:sdm1
> [14269.981284] RAID5 conf printout:
> [14269.981286]  --- rd:9 wd:4
> [14269.981289]  disk 0, o:0, dev:sde1
> [14269.981291]  disk 2, o:0, dev:sdg1
> [14269.981293]  disk 3, o:0, dev:sdh1
> [14269.981296]  disk 4, o:1, dev:sdi1
> [14269.981298]  disk 5, o:1, dev:sdj1
> [14269.981300]  disk 7, o:1, dev:sdl1
> [14269.981302]  disk 8, o:1, dev:sdm1
> [14270.003316] sd 11:0:0:0: [sdi] Sense Key : Recovered Error
[current] [descriptor]
> [14270.003324] Descriptor sense data with sense descriptors (in hex):
> [14270.003327]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.003338]         00 4f 00 c2 00 50
> [14270.003344] sd 11:0:0:0: [sdi] Add. Sense: ATA pass through
information available
> [14270.021260] RAID5 conf printout:
> [14270.021263]  --- rd:9 wd:4
> [14270.021266]  disk 0, o:0, dev:sde1
> [14270.021269]  disk 3, o:0, dev:sdh1
> [14270.021271]  disk 4, o:1, dev:sdi1
> [14270.021274]  disk 5, o:1, dev:sdj1
> [14270.021276]  disk 7, o:1, dev:sdl1
> [14270.021278]  disk 8, o:1, dev:sdm1
> [14270.021283] RAID5 conf printout:
> [14270.021285]  --- rd:9 wd:4
> [14270.021287]  disk 0, o:0, dev:sde1
> [14270.021289]  disk 3, o:0, dev:sdh1
> [14270.021292]  disk 4, o:1, dev:sdi1
> [14270.021294]  disk 5, o:1, dev:sdj1
> [14270.021296]  disk 7, o:1, dev:sdl1
> [14270.021298]  disk 8, o:1, dev:sdm1
> [14270.061261] RAID5 conf printout:
> [14270.061264]  --- rd:9 wd:4
> [14270.061266]  disk 0, o:0, dev:sde1
> [14270.061269]  disk 4, o:1, dev:sdi1
> [14270.061272]  disk 5, o:1, dev:sdj1
> [14270.061274]  disk 7, o:1, dev:sdl1
> [14270.061276]  disk 8, o:1, dev:sdm1
> [14270.061281] RAID5 conf printout:
> [14270.061283]  --- rd:9 wd:4
> [14270.061285]  disk 0, o:0, dev:sde1
> [14270.061287]  disk 4, o:1, dev:sdi1
> [14270.061289]  disk 5, o:1, dev:sdj1
> [14270.061292]  disk 7, o:1, dev:sdl1
> [14270.061294]  disk 8, o:1, dev:sdm1
> [14270.061647] sd 11:0:0:0: [sdi] Sense Key : Recovered Error
[current] [descriptor]
> [14270.061653] Descriptor sense data with sense descriptors (in hex):
> [14270.061656]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.061667]         00 4f 00 c2 00 50
> [14270.061672] sd 11:0:0:0: [sdi] Add. Sense: ATA pass through
information available
> [14270.091263] RAID5 conf printout:
> [14270.091267]  --- rd:9 wd:4
> [14270.091271]  disk 4, o:1, dev:sdi1
> [14270.091274]  disk 5, o:1, dev:sdj1
> [14270.091276]  disk 7, o:1, dev:sdl1
> [14270.091279]  disk 8, o:1, dev:sdm1
> [14270.153319] sd 11:0:0:0: [sdi] Sense Key : Recovered Error
[current] [descriptor]
> [14270.153325] Descriptor sense data with sense descriptors (in hex):
> [14270.153328]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.153340]         00 4f 00 c2 00 50
> [14270.153346] sd 11:0:0:0: [sdi] Add. Sense: ATA pass through
information available
> [14270.211651] sd 11:0:0:0: [sdi] Sense Key : Recovered Error
[current] [descriptor]
> [14270.211657] Descriptor sense data with sense descriptors (in hex):
> [14270.211660]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.211671]         00 4f 00 c2 00 50
> [14270.211677] sd 11:0:0:0: [sdi] Add. Sense: ATA pass through
information available
> [14270.324057] sd 11:0:1:0: [sdj] Sense Key : Recovered Error
[current] [descriptor]
> [14270.324065] Descriptor sense data with sense descriptors (in hex):
> [14270.324067]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.324079]         00 4f 00 c2 00 50
> [14270.324085] sd 11:0:1:0: [sdj] Add. Sense: ATA pass through
information available
> [14270.382390] sd 11:0:1:0: [sdj] Sense Key : Recovered Error
[current] [descriptor]
> [14270.382396] Descriptor sense data with sense descriptors (in hex):
> [14270.382399]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.382410]         00 4f 00 c2 00 50
> [14270.382416] sd 11:0:1:0: [sdj] Add. Sense: ATA pass through
information available
> [14270.474060] sd 11:0:1:0: [sdj] Sense Key : Recovered Error
[current] [descriptor]
> [14270.474068] Descriptor sense data with sense descriptors (in hex):
> [14270.474071]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.474083]         00 4f 00 c2 00 50
> [14270.474089] sd 11:0:1:0: [sdj] Add. Sense: ATA pass through
information available
> [14270.532394] sd 11:0:1:0: [sdj] Sense Key : Recovered Error
[current] [descriptor]
> [14270.532401] Descriptor sense data with sense descriptors (in hex):
> [14270.532404]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.532415]         00 4f 00 c2 00 50
> [14270.532421] sd 11:0:1:0: [sdj] Add. Sense: ATA pass through
information available
> [14270.632394] sd 11:0:1:0: [sdj] Sense Key : Recovered Error
[current] [descriptor]
> [14270.632402] Descriptor sense data with sense descriptors (in hex):
> [14270.632405]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.632417]         00 4f 00 c2 00 50
> [14270.632423] sd 11:0:1:0: [sdj] Add. Sense: ATA pass through
information available
> [14270.690729] sd 11:0:1:0: [sdj] Sense Key : Recovered Error
[current] [descriptor]
> [14270.690736] Descriptor sense data with sense descriptors (in hex):
> [14270.690739]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.690751]         00 4f 00 c2 00 50
> [14270.690757] sd 11:0:1:0: [sdj] Add. Sense: ATA pass through
information available
> [14270.804065] sd 11:0:2:0: [sdk] Sense Key : Recovered Error
[current] [descriptor]
> [14270.804073] Descriptor sense data with sense descriptors (in hex):
> [14270.804076]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.804088]         00 4f 00 c2 00 50
> [14270.804094] sd 11:0:2:0: [sdk] Add. Sense: ATA pass through
information available
> [14270.862400] sd 11:0:2:0: [sdk] Sense Key : Recovered Error
[current] [descriptor]
> [14270.862406] Descriptor sense data with sense descriptors (in hex):
> [14270.862409]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.862420]         00 4f 00 c2 00 50
> [14270.862426] sd 11:0:2:0: [sdk] Add. Sense: ATA pass through
information available
> [14270.954070] sd 11:0:2:0: [sdk] Sense Key : Recovered Error
[current] [descriptor]
> [14270.954079] Descriptor sense data with sense descriptors (in hex):
> [14270.954081]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14270.954093]         00 4f 00 c2 00 50
> [14270.954099] sd 11:0:2:0: [sdk] Add. Sense: ATA pass through
information available
> [14271.012399] sd 11:0:2:0: [sdk] Sense Key : Recovered Error
[current] [descriptor]
> [14271.012406] Descriptor sense data with sense descriptors (in hex):
> [14271.012408]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.012420]         00 4f 00 c2 00 50
> [14271.012426] sd 11:0:2:0: [sdk] Add. Sense: ATA pass through
information available
> [14271.104072] sd 11:0:2:0: [sdk] Sense Key : Recovered Error
[current] [descriptor]
> [14271.104080] Descriptor sense data with sense descriptors (in hex):
> [14271.104083]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.104094]         00 4f 00 c2 00 50
> [14271.104100] sd 11:0:2:0: [sdk] Add. Sense: ATA pass through
information available
> [14271.162400] sd 11:0:2:0: [sdk] Sense Key : Recovered Error
[current] [descriptor]
> [14271.162407] Descriptor sense data with sense descriptors (in hex):
> [14271.162410]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.162422]         00 4f 00 c2 00 50
> [14271.162428] sd 11:0:2:0: [sdk] Add. Sense: ATA pass through
information available
> [14271.278147] sd 11:0:3:0: [sdl] Sense Key : Recovered Error
[current] [descriptor]
> [14271.278155] Descriptor sense data with sense descriptors (in hex):
> [14271.278157]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.278169]         00 4f 00 c2 00 50
> [14271.278175] sd 11:0:3:0: [sdl] Add. Sense: ATA pass through
information available
> [14271.336487] sd 11:0:3:0: [sdl] Sense Key : Recovered Error
[current] [descriptor]
> [14271.336495] Descriptor sense data with sense descriptors (in hex):
> [14271.336498]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.336509]         00 4f 00 c2 00 50
> [14271.336515] sd 11:0:3:0: [sdl] Add. Sense: ATA pass through
information available
> [14271.428148] sd 11:0:3:0: [sdl] Sense Key : Recovered Error
[current] [descriptor]
> [14271.428156] Descriptor sense data with sense descriptors (in hex):
> [14271.428158]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.428170]         00 4f 00 c2 00 50
> [14271.428176] sd 11:0:3:0: [sdl] Add. Sense: ATA pass through
information available
> [14271.486485] sd 11:0:3:0: [sdl] Sense Key : Recovered Error
[current] [descriptor]
> [14271.486493] Descriptor sense data with sense descriptors (in hex):
> [14271.486496]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.486508]         00 4f 00 c2 00 50
> [14271.486514] sd 11:0:3:0: [sdl] Add. Sense: ATA pass through
information available
> [14271.586482] sd 11:0:3:0: [sdl] Sense Key : Recovered Error
[current] [descriptor]
> [14271.586489] Descriptor sense data with sense descriptors (in hex):
> [14271.586492]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.586503]         00 4f 00 c2 00 50
> [14271.586509] sd 11:0:3:0: [sdl] Add. Sense: ATA pass through
information available
> [14271.644813] sd 11:0:3:0: [sdl] Sense Key : Recovered Error
[current] [descriptor]
> [14271.644819] Descriptor sense data with sense descriptors (in hex):
> [14271.644822]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.644833]         00 4f 00 c2 00 50
> [14271.644839] sd 11:0:3:0: [sdl] Add. Sense: ATA pass through
information available
> [14271.762812] sd 11:0:4:0: [sdm] Sense Key : Recovered Error
[current] [descriptor]
> [14271.762820] Descriptor sense data with sense descriptors (in hex):
> [14271.762823]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.762834]         00 4f 00 c2 00 50
> [14271.762841] sd 11:0:4:0: [sdm] Add. Sense: ATA pass through
information available
> [14271.821145] sd 11:0:4:0: [sdm] Sense Key : Recovered Error
[current] [descriptor]
> [14271.821152] Descriptor sense data with sense descriptors (in hex):
> [14271.821154]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.821166]         00 4f 00 c2 00 50
> [14271.821172] sd 11:0:4:0: [sdm] Add. Sense: ATA pass through
information available
> [14271.912816] sd 11:0:4:0: [sdm] Sense Key : Recovered Error
[current] [descriptor]
> [14271.912824] Descriptor sense data with sense descriptors (in hex):
> [14271.912827]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.912838]         00 4f 00 c2 00 50
> [14271.912844] sd 11:0:4:0: [sdm] Add. Sense: ATA pass through
information available
> [14271.971152] sd 11:0:4:0: [sdm] Sense Key : Recovered Error
[current] [descriptor]
> [14271.971161] Descriptor sense data with sense descriptors (in hex):
> [14271.971163]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14271.971175]         00 4f 00 c2 00 50
> [14271.971181] sd 11:0:4:0: [sdm] Add. Sense: ATA pass through
information available
> [14272.071150] sd 11:0:4:0: [sdm] Sense Key : Recovered Error
[current] [descriptor]
> [14272.071157] Descriptor sense data with sense descriptors (in hex):
> [14272.071160]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14272.071172]         00 4f 00 c2 00 50
> [14272.071178] sd 11:0:4:0: [sdm] Add. Sense: ATA pass through
information available
> [14272.129485] sd 11:0:4:0: [sdm] Sense Key : Recovered Error
[current] [descriptor]
> [14272.129494] Descriptor sense data with sense descriptors (in hex):
> [14272.129497]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
> [14272.129508]         00 4f 00 c2 00 50
> [14272.129514] sd 11:0:4:0: [sdm] Add. Sense: ATA pass through
information available
> [14365.066847] Aborting journal on device md0:8.
> [14365.066946] __ratelimit: 246 callbacks suppressed
> [14365.066949] Buffer I/O error on device md0, logical block 854622208
> [14365.067018] lost page write due to I/O error on md0
> [14365.067023] JBD2: I/O error detected when updating journal
superblock for md0:8.
> [14382.768622] EXT4-fs error (device md0): ext4_find_entry: reading
directory #6879966 offset 0
> [14382.820264] Buffer I/O error on device md0, logical block 0
> [14382.820332] lost page write due to I/O error on md0
> [14401.997859] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891861, block=27267765
> [14401.998043] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.041639] Buffer I/O error on device md0, logical block 0
> [14402.041708] lost page write due to I/O error on md0
> [14402.042025] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892055, block=27267777
> [14402.042189] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.042337] Buffer I/O error on device md0, logical block 0
> [14402.042404] lost page write due to I/O error on md0
> [14402.042615] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891691, block=27267754
> [14402.042780] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.042927] Buffer I/O error on device md0, logical block 0
> [14402.042994] lost page write due to I/O error on md0
> [14402.043204] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891589, block=27267748
> [14402.043369] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.043514] Buffer I/O error on device md0, logical block 0
> [14402.043581] lost page write due to I/O error on md0
> [14402.045186] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892719, block=27267818
> [14402.045351] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.045500] Buffer I/O error on device md0, logical block 0
> [14402.045569] lost page write due to I/O error on md0
> [14402.061829] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891914, block=27267768
> [14402.061983] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.062117] Buffer I/O error on device md0, logical block 0
> [14402.062175] lost page write due to I/O error on md0
> [14402.062495] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891136, block=27267719
> [14402.062651] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.062793] Buffer I/O error on device md0, logical block 0
> [14402.062859] lost page write due to I/O error on md0
> [14402.063053] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6893036, block=27267838
> [14402.063217] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.063357] Buffer I/O error on device md0, logical block 0
> [14402.063423] lost page write due to I/O error on md0
> [14402.063624] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892357, block=27267796
> [14402.063793] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.063935] Buffer I/O error on device md0, logical block 0
> [14402.064001] lost page write due to I/O error on md0
> [14402.064193] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891032, block=27267713
> [14402.064355] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.064496] Buffer I/O error on device md0, logical block 0
> [14402.064561] lost page write due to I/O error on md0
> [14402.064741] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891782, block=27267760
> [14402.064906] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.065232] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892332, block=27267794
> [14402.065395] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.065714] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892755, block=27267821
> [14402.065878] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.066197] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892235, block=27267788
> [14402.066362] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.066675] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892552, block=27267808
> [14402.066840] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.067156] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892123, block=27267781
> [14402.067321] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.067635] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892256, block=27267789
> [14402.067800] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.068114] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892532, block=27267807
> [14402.068278] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.068594] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892318, block=27267793
> [14402.068758] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.069069] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892845, block=27267826
> [14402.069233] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.069543] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892980, block=27267835
> [14402.069707] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.074971] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6890993, block=27267711
> [14402.075140] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.075540] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891750, block=27267758
> [14402.075686] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.076028] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891642, block=27267751
> [14402.076174] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.076543] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892605, block=27267811
> [14402.076689] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.077059] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892136, block=27267782
> [14402.077223] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.077567] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892717, block=27267818
> [14402.077732] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.078080] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6890999, block=27267711
> [14402.078243] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.078593] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892362, block=27267796
> [14402.080842] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.083259] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892867, block=27267828
> [14402.083423] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.083798] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891361, block=27267734
> [14402.083963] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.084315] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892012, block=27267774
> [14402.084480] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.084852] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891626, block=27267750
> [14402.085014] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.085365] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891320, block=27267731
> [14402.085530] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.085880] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891588, block=27267748
> [14402.086044] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.086390] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892584, block=27267810
> [14402.086556] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.086901] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6892891, block=27267829
> [14402.087066] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.087416] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891118, block=27267718
> [14402.087579] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.087930] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891559, block=27267746
> [14402.088094] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.088445] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6891212, block=27267724
> [14402.088609] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.091550] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6890993, block=27267711
> [14402.091718] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.106045] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6890999, block=27267711
> [14402.106212] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.141662] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889579, block=27267622
> [14402.141829] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.142185] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889980, block=27267647
> [14402.142350] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.142703] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889704, block=27267630
> [14402.142868] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.143318] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889340, block=27267607
> [14402.143483] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.143826] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889563, block=27267621
> [14402.143990] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.144341] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889220, block=27267600
> [14402.144506] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.144869] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889358, block=27267608
> [14402.145034] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.145379] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889530, block=27267619
> [14402.145542] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.145890] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889721, block=27267631
> [14402.146054] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.146398] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889621, block=27267625
> [14402.146562] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.146900] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889920, block=27267643
> [14402.147047] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.147390] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889508, block=27267618
> [14402.147536] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.147869] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889673, block=27267628
> [14402.148015] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.153911] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889220, block=27267600
> [14402.154075] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.155819] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889340, block=27267607
> [14402.155987] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.261374] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6876431, block=27266800
> [14402.261522] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.261981] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875468, block=27266740
> [14402.262128] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.262587] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6878644, block=27266939
> [14402.262753] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.263223] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875990, block=27266773
> [14402.263388] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.263741] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875325, block=27266731
> [14402.263908] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.264259] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875779, block=27266760
> [14402.264424] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.264808] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6879881, block=27267016
> [14402.264972] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.265325] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6878489, block=27266929
> [14402.265491] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.265842] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6878591, block=27266935
> [14402.266005] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.266357] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6876138, block=27266782
> [14402.266520] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.266876] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875310, block=27266730
> [14402.267042] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.267396] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6876274, block=27266791
> [14402.267560] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.267907] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875648, block=27266751
> [14402.268071] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.268422] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6876119, block=27266781
> [14402.268586] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.269056] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6877808, block=27266886
> [14402.269219] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.269573] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6878101, block=27266905
> [14402.269738] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.270088] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6877967, block=27266896
> [14402.270264] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.270614] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6877835, block=27266888
> [14402.270793] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.271146] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875370, block=27266734
> [14402.271323] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.271679] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6877955, block=27266896
> [14402.271854] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.272214] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6876218, block=27266787
> [14402.272391] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.272745] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875340, block=27266732
> [14402.272922] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.273281] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6878031, block=27266900
> [14402.273452] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.273919] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6874892, block=27266704
> [14402.274097] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.274454] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6878014, block=27266899
> [14402.274628] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.274987] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6876066, block=27266778
> [14402.275146] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.275488] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6879778, block=27267010
> [14402.275646] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.275996] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6878310, block=27266918
> [14402.276151] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.276624] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6877450, block=27266864
> [14402.276793] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.277148] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875397, block=27266736
> [14402.277315] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.277778] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6877004, block=27266836
> [14402.277943] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.278295] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875606, block=27266749
> [14402.280543] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.283306] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6874892, block=27266704
> [14402.283472] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.285354] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875310, block=27266730
> [14402.285519] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.302533] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6874640, block=27266688
> [14402.302698] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.304480] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6874640, block=27266688
> [14402.304629] EXT4-fs (md0): previous I/O error to superblock detected
> [14402.752437] EXT4-fs error (device md0): ext4_journal_start_sb:
Detected aborted journal
> [14402.752606] EXT4-fs (md0): Remounting filesystem read-only
> [14419.267133] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6874640, block=27266688
> [14419.297937] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6874892, block=27266704
> [14419.301517] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6875310, block=27266730
> [14419.332861] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889220, block=27267600
> [14419.335590] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6889340, block=27267607
> [14419.341744] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6890993, block=27267711
> [14419.343458] EXT4-fs error (device md0): __ext4_get_inode_loc:
unable to read inode block - inode=6890999, block=27267711


Richard Scobie wrote:
> Andrew Dunn wrote:
>
>> Do you think that the controller is dropping out? I know that I have 4
>> drives on one controller (AOC-USAS-L8i) and 5 drives on the other
>> controller (SAME make/model). but I think they are sequentially
>> connected... as in sd[efghi] should be on one device and sd[jklm] should
>> be on the other... any easy way to verify?
>
> If you are running smartd, cease doing so and do not use the smartctl
> command on drives attached to these controllers - use causes drives to
> be offlined.
>
> It appears the smartctl is broken with LSISAS 1068E based controllers.
>
> See:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=452389
>
> and
>
> http://marc.info/?l=linux-scsi&m=125673590221135&w=2
>
> Regards,
>
> Richard
>

-- 
Andrew Dunn
http://agdunn.net

