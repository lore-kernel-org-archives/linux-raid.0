From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Sun, 08 Nov 2009 12:08:21 -0500
Message-ID: <4AF6FB05.9060508@gmail.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D786.6070505@gmail.com> <4AF6DC22.7010909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF6DC22.7010909@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

No multiplier, they are on a backpane though. 2 on one backpane, 3 on
another... but only 2 of the 3 dropped off that one.

I looked through dmesg some more, maybe you all might see something of
significance. I don't think this was around when it happened, but it
might shed light onto the issue. I will continue to sift through the log.

[   19.021969] scsi10 : ioc0: LSISAS1068E B3, FwRev=011a0000h, Ports=1,
MaxQ=478, IRQ=16
[   19.061176] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id
0, phy 0, sas_addr 0x1221000000000000
[   19.063708] scsi 10:0:0:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   19.065473] sd 10:0:0:0: Attached scsi generic sg4 type 0
[   19.067322] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id
1, phy 1, sas_addr 0x1221000001000000
[   19.068074] sd 10:0:0:0: [sde] 1953523055 512-byte logical blocks:
(1.00 TB/931 GiB)
[   19.070474] scsi 10:0:1:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   19.072797] sd 10:0:1:0: Attached scsi generic sg5 type 0
[   19.074994] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id
4, phy 4, sas_addr 0x1221000004000000
[   19.076025] sd 10:0:1:0: [sdf] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   19.078091] scsi 10:0:2:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   19.080417] sd 10:0:2:0: Attached scsi generic sg6 type 0
[   19.082589] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id
5, phy 5, sas_addr 0x1221000005000000
[   19.082966] sd 10:0:0:0: [sde] Write Protect is off
[   19.082970] sd 10:0:0:0: [sde] Mode Sense: 73 00 00 08
[   19.084186] sd 10:0:2:0: [sdg] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   19.086521] sd 10:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.087036] scsi 10:0:3:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   19.088389] sd 10:0:1:0: [sdf] Write Protect is off
[   19.088393] sd 10:0:1:0: [sdf] Mode Sense: 73 00 00 08
[   19.089642] sd 10:0:3:0: Attached scsi generic sg7 type 0
[   19.092400] mptsas 0000:02:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   19.092525] mptbase: ioc1: Initiating bringup
[   19.093974] sd 10:0:3:0: [sdh] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   19.095129] sd 10:0:1:0: [sdf] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.101887] sd 10:0:2:0: [sdg] Write Protect is off
[   19.101891] sd 10:0:2:0: [sdg] Mode Sense: 73 00 00 08
[   19.104250] sd 10:0:2:0: [sdg] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.107231] sd 10:0:3:0: [sdh] Write Protect is off
[   19.107236] sd 10:0:3:0: [sdh] Mode Sense: 73 00 00 08
[   19.109398]  sde:
[   19.111301] sd 10:0:3:0: [sdh] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   19.111659]  sdf:
[   19.118664]  sdg: sdf1
[   19.122127]  sde1
[   19.126192]  sdh: sdg1
[   19.137786] sd 10:0:1:0: [sdf] Attached SCSI disk
[   19.143743]  sdh1
[   19.146360] sd 10:0:0:0: [sde] Attached SCSI disk
[   19.148589] sd 10:0:2:0: [sdg] Attached SCSI disk
[   19.158613] sd 10:0:3:0: [sdh] Attached SCSI disk
[   20.780022] ioc1: LSISAS1068E B3: Capabilities={Initiator}
[   20.780035] mptsas 0000:02:00.0: setting latency timer to 64
[   30.971934] scsi11 : ioc1: LSISAS1068E B3, FwRev=011a0000h, Ports=1,
MaxQ=478, IRQ=16
[   31.012437] mptsas: ioc1: attaching sata device: fw_channel 0, fw_id
0, phy 0, sas_addr 0x1221000000000000
[   31.015009] scsi 11:0:0:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   31.016755] sd 11:0:0:0: Attached scsi generic sg8 type 0
[   31.018603] mptsas: ioc1: attaching sata device: fw_channel 0, fw_id
1, phy 1, sas_addr 0x1221000001000000
[   31.019358] sd 11:0:0:0: [sdi] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   31.021753] scsi 11:0:1:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   31.024075] sd 11:0:1:0: Attached scsi generic sg9 type 0
[   31.026273] mptsas: ioc1: attaching sata device: fw_channel 0, fw_id
4, phy 4, sas_addr 0x1221000004000000
[   31.027302] sd 11:0:1:0: [sdj] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   31.029693] scsi 11:0:2:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   31.032004] sd 11:0:2:0: Attached scsi generic sg10 type 0
[   31.032233] sd 11:0:0:0: [sdi] Write Protect is off
[   31.032235] sd 11:0:0:0: [sdi] Mode Sense: 73 00 00 08
[   31.034133] mptsas: ioc1: attaching sata device: fw_channel 0, fw_id
5, phy 5, sas_addr 0x1221000005000000
[   31.035571] sd 11:0:2:0: [sdk] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   31.037483] sd 11:0:0:0: [sdi] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   31.038793] scsi 11:0:3:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   31.041160] sd 11:0:3:0: Attached scsi generic sg11 type 0
[   31.043506] mptsas: ioc1: attaching sata device: fw_channel 0, fw_id
6, phy 6, sas_addr 0x1221000006000000
[   31.043884] sd 11:0:1:0: [sdj] Write Protect is off
[   31.043887] sd 11:0:1:0: [sdj] Mode Sense: 73 00 00 08
[   31.046683] sd 11:0:3:0: [sdl] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   31.047038] sd 11:0:1:0: [sdj] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   31.050845] scsi 11:0:4:0: Direct-Access     ATA      WDC
WD1001FALS-0 0K05 PQ: 0 ANSI: 5
[   31.054206] sd 11:0:4:0: Attached scsi generic sg12 type 0
[   31.056125] sd 11:0:2:0: [sdk] Write Protect is off
[   31.056129] sd 11:0:2:0: [sdk] Mode Sense: 73 00 00 08
[   31.059805] sd 11:0:4:0: [sdm] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   31.061019] sd 11:0:2:0: [sdk] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   31.065705] sd 11:0:3:0: [sdl] Write Protect is off
[   31.065710] sd 11:0:3:0: [sdl] Mode Sense: 73 00 00 08
[   31.066991]  sdi:
[   31.069131]  sdj:
[   31.070087] sd 11:0:3:0: [sdl] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   31.073259] sd 11:0:4:0: [sdm] Write Protect is off
[   31.073262] sd 11:0:4:0: [sdm] Mode Sense: 73 00 00 08
[   31.074045]  sdj1
[   31.075719]  sdi1
[   31.077424] sd 11:0:4:0: [sdm] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   31.083141]  sdk:
[   31.090760]  sdl: sdk1
[   31.099798]  sdm: sdl1
[   31.115614]  sdm1
[   31.122247] sd 11:0:1:0: [sdj] Attached SCSI disk
[   31.124713] sd 11:0:0:0: [sdi] Attached SCSI disk
[   31.131908] sd 11:0:2:0: [sdk] Attached SCSI disk
[   31.141444] md: bind<sdj1>
[   31.143383] sd 11:0:3:0: [sdl] Attached SCSI disk
[   31.147407] md: bind<sdi1>
[   31.153910] sd 11:0:4:0: [sdm] Attached SCSI disk
[   31.159932] md: bind<sdl1>
[   31.176695] md: bind<sdm1>
[   31.265544] md: bind<sde1>
[   31.354001] md: bind<sdk1>
[   31.467249] md: bind<sdh1>
[   31.476153] md: bind<sdg1>
[   31.670444] md: bind<sdf1>
[   31.672643] md: kicking non-fresh sdk1 from array!
[   31.672652] md: unbind<sdk1>
[   31.711286] md: export_rdev(sdk1)
[   31.712356] raid5: device sdf1 operational as raid disk 1
[   31.712358] raid5: device sdg1 operational as raid disk 2
[   31.712360] raid5: device sdh1 operational as raid disk 3
[   31.712362] raid5: device sde1 operational as raid disk 0
[   31.712363] raid5: device sdm1 operational as raid disk 8
[   31.712365] raid5: device sdl1 operational as raid disk 7
[   31.712366] raid5: device sdi1 operational as raid disk 4
[   31.712368] raid5: device sdj1 operational as raid disk 5
[   31.712962] raid5: allocated 9540kB for md0
[   31.713094] raid5: raid level 6 set md0 active with 8 out of 9
devices, algorithm 2


Roger Heflin wrote:
> Andrew Dunn wrote:
>> [10:0:0:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sde
>> [10:0:1:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdf
>> [10:0:2:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdg
>> [10:0:3:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdh
>> [11:0:0:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdi
>> [11:0:1:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdj
>> [11:0:2:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdk
>> [11:0:3:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdl
>> [11:0:4:0]   disk    ATA      WDC WD1001FALS-0 0K05  /dev/sdm
>>
>> So 4 drives dropped out on the second controller. But why didnt sdm go
>> with them?
>>
>>
>
> It is possible that by the time it got to checking the last drive that
> the errors had cleared up, so sdm was ok with it checked.
>
>
> Is this on a port multiplier?
>
>

-- 
Andrew Dunn
http://agdunn.net

