From: Jed Davidow <jed@ultralame.com>
Subject: Re: md rotates RAID5 spare at boot
Date: Thu, 10 Jan 2008 16:38:08 -0800
Message-ID: <4786BA70.1070205@ultralame.com>
References: <47852984.5040707@ultralame.com>	<4786844D.4010104@tmr.com>	<478685DA.8070701@ultralame.com>	<18310.38343.339990.718263@notabene.brown>	<47869D2C.7020805@ultralame.com> <18310.46808.422657.207784@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18310.46808.422657.207784@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(Sorry- yes it looks like I posted an incorrect dmesg extract)

$egrep "sd|md|raid|scsi" /var/log/dmesg.0
[   36.112449] md: linear personality registered for level -1
[   36.117197] md: multipath personality registered for level -4
[   36.121795] md: raid0 personality registered for level 0
[   36.126950] md: raid1 personality registered for level 1
[   36.131424] raid5: automatically using best checksumming function: 
pIII_sse
[   36.150020] raid5: using function: pIII_sse (4564.000 MB/sec)
[   36.218015] raid6: int32x1    780 MB/s
[   36.285943] raid6: int32x2    902 MB/s
[   36.353961] raid6: int32x4    667 MB/s
[   36.421869] raid6: int32x8    528 MB/s
[   36.489811] raid6: mmxx1     1813 MB/s
[   36.557775] raid6: mmxx2     2123 MB/s
[   36.625763] raid6: sse1x1    1101 MB/s
[   36.693717] raid6: sse1x2    1898 MB/s
[   36.761688] raid6: sse2x1    2227 MB/s
[   36.829647] raid6: sse2x2    3178 MB/s
[   36.829695] raid6: using algorithm sse2x2 (3178 MB/s)
[   36.829744] md: raid6 personality registered for level 6
[   36.829793] md: raid5 personality registered for level 5
[   36.829842] md: raid4 personality registered for level 4
[   36.853475] md: raid10 personality registered for level 10
[   37.781513] scsi0 : sata_sil
[   37.781628] scsi1 : sata_sil
[   37.781724] scsi2 : sata_sil
[   37.781820] scsi3 : sata_sil
[   37.781922] ata1: SATA max UDMA/100 cmd 0xf88c0080 ctl 0xf88c008a 
bmdma 0xf88c0000 irq 20
[   37.781997] ata2: SATA max UDMA/100 cmd 0xf88c00c0 ctl 0xf88c00ca 
bmdma 0xf88c0008 irq 20
[   37.782069] ata3: SATA max UDMA/100 cmd 0xf88c0280 ctl 0xf88c028a 
bmdma 0xf88c0200 irq 20
[   37.782142] ata4: SATA max UDMA/100 cmd 0xf88c02c0 ctl 0xf88c02ca 
bmdma 0xf88c0208 irq 20
[   39.577812] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500JD-00H 
08.0 PQ: 0 ANSI: 5
[   39.578027] scsi 1:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   
BACE PQ: 0 ANSI: 5
[   39.578234] scsi 3:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   
BACE PQ: 0 ANSI: 5
[   39.632483] scsi4 : ata_piix
[   39.632591] scsi5 : ata_piix
[   39.632812] ata5: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 
bmdma 0x0001f000 irq 14
[   39.634522] ata6: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 
bmdma 0x0001f008 irq 15
[   39.634924] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors 
(250059 MB)
[   39.634995] sd 0:0:0:0: [sda] Write Protect is off
[   39.635048] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   39.635076] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   39.635218] sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors 
(250059 MB)
[   39.635292] sd 0:0:0:0: [sda] Write Protect is off
[   39.635350] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   39.635380] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   39.635462]  sda: sda1 sda2
[   39.650092] sd 0:0:0:0: [sda] Attached SCSI disk
[   39.650226] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors 
(251000 MB)
[   39.650296] sd 1:0:0:0: [sdb] Write Protect is off
[   39.650348] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   39.650379] sd 1:0:0:0: [sdb] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[   39.650505] sd 1:0:0:0: [sdb] 490234752 512-byte hardware sectors 
(251000 MB)
[   39.650573] sd 1:0:0:0: [sdb] Write Protect is off
[   39.650625] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   39.650657] sd 1:0:0:0: [sdb] Write cache: disabled, read cache: 
enabled, doesn't support DPO or FUA
[   39.650727]  sdb: sdb1 sdb2
[   39.667599] sd 1:0:0:0: [sdb] Attached SCSI disk
[   39.667719] sd 3:0:0:0: [sdc] 490234752 512-byte hardware sectors 
(251000 MB)
[   39.667788] sd 3:0:0:0: [sdc] Write Protect is off
[   39.667840] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   39.667871] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   39.667997] sd 3:0:0:0: [sdc] 490234752 512-byte hardware sectors 
(251000 MB)
[   39.668064] sd 3:0:0:0: [sdc] Write Protect is off
[   39.668116] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   39.668146] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   39.668213]  sdc: sdc1 sdc2
[   39.692703] sd 3:0:0:0: [sdc] Attached SCSI disk
[   39.699348] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   39.699570] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   39.699786] sd 3:0:0:0: Attached scsi generic sg2 type 0
[   39.834560] md: md0 stopped.
[   39.870361] md: bind<sdc1>
[   39.870527] md: md1 stopped.
[   39.910999] md: md0 stopped.
[   39.911064] md: unbind<sdc1>
[   39.911120] md: export_rdev(sdc1)
[   39.929760] md: bind<sda1>
[   39.929953] md: bind<sdc1>
[   39.930139] md: bind<sdb1>
[   39.930231] md: md1 stopped.
[   39.932468] md: bind<sdc2>
[   39.932674] md: bind<sda2>
[   39.932860] md: bind<sdb2>
[   40.411001] scsi 4:0:1:0: CD-ROM            LITE-ON  DVDRW SOHW-1213S 
TS09 PQ: 0 ANSI: 5
[   40.411152] scsi 4:0:1:0: Attached scsi generic sg3 type 5
[   40.411657] scsi6 : ata_piix
[   40.411766] scsi7 : ata_piix
[   40.411981] ata7: SATA max UDMA/133 cmd 0x0001d000 ctl 0x0001d402 
bmdma 0x0001e000 irq 18
[   40.412050] ata8: SATA max UDMA/133 cmd 0x0001d800 ctl 0x0001dc02 
bmdma 0x0001e008 irq 18
[   40.880062] scsi 6:0:0:0: Direct-Access     ATA      ST3120026AS      
3.05 PQ: 0 ANSI: 5
[   40.880217] sd 6:0:0:0: [sdd] 234441648 512-byte hardware sectors 
(120034 MB)
[   40.880288] sd 6:0:0:0: [sdd] Write Protect is off
[   40.880340] sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   40.880367] sd 6:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   40.880504] sd 6:0:0:0: [sdd] 234441648 512-byte hardware sectors 
(120034 MB)
[   40.880572] sd 6:0:0:0: [sdd] Write Protect is off
[   40.880623] sd 6:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   40.880651] sd 6:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   40.880718]  sdd: sdd1 sdd2 <<7>ieee1394: Host added: 
ID:BUS[0-00:1023]  GUID[001485000012704c]
[   40.908264]  sdd5 >
[   40.908479] sd 6:0:0:0: [sdd] Attached SCSI disk
[   40.908579] sd 6:0:0:0: Attached scsi generic sg4 type 0
[   40.908747] scsi 6:0:1:0: Direct-Access     ATA      Maxtor 7L250S0   
BACE PQ: 0 ANSI: 5
[   40.908899] sd 6:0:1:0: [sde] 490234752 512-byte hardware sectors 
(251000 MB)
[   40.908968] sd 6:0:1:0: [sde] Write Protect is off
[   40.909020] sd 6:0:1:0: [sde] Mode Sense: 00 3a 00 00
[   40.909050] sd 6:0:1:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   40.909174] sd 6:0:1:0: [sde] 490234752 512-byte hardware sectors 
(251000 MB)
[   40.909243] sd 6:0:1:0: [sde] Write Protect is off
[   40.909294] sd 6:0:1:0: [sde] Mode Sense: 00 3a 00 00
[   40.909324] sd 6:0:1:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   40.909391]  sde: sde1 sde2
[   40.930218] sd 6:0:1:0: [sde] Attached SCSI disk
[   40.930318] sd 6:0:1:0: Attached scsi generic sg5 type 0
[   40.930480] scsi 7:0:0:0: Direct-Access     ATA      WDC WD2500JD-00H 
08.0 PQ: 0 ANSI: 5
[   40.930621] sd 7:0:0:0: [sdf] 488397168 512-byte hardware sectors 
(250059 MB)
[   40.930689] sd 7:0:0:0: [sdf] Write Protect is off
[   40.930742] sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[   40.930769] sd 7:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   40.930894] sd 7:0:0:0: [sdf] 488397168 512-byte hardware sectors 
(250059 MB)
[   40.930963] sd 7:0:0:0: [sdf] Write Protect is off
[   40.931015] sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[   40.931044] sd 7:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   40.931111]  sdf: sdf1 sdf2
[   40.948846] sd 7:0:0:0: [sdf] Attached SCSI disk
[   40.948946] sd 7:0:0:0: Attached scsi generic sg6 type 0
[   40.949106] scsi 7:0:1:0: Direct-Access     ATA      WDC WD2500JS-00M 
02.0 PQ: 0 ANSI: 5
[   40.949248] sd 7:0:1:0: [sdg] 488397168 512-byte hardware sectors 
(250059 MB)
[   40.949317] sd 7:0:1:0: [sdg] Write Protect is off
[   40.949368] sd 7:0:1:0: [sdg] Mode Sense: 00 3a 00 00
[   40.949396] sd 7:0:1:0: [sdg] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   40.949519] sd 7:0:1:0: [sdg] 488397168 512-byte hardware sectors 
(250059 MB)
[   40.949588] sd 7:0:1:0: [sdg] Write Protect is off
[   40.949640] sd 7:0:1:0: [sdg] Mode Sense: 00 3a 00 00
[   40.949668] sd 7:0:1:0: [sdg] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[   40.949734]  sdg: sdg1 sdg2
[   40.969827] sd 7:0:1:0: [sdg] Attached SCSI disk
[   40.969926] sd 7:0:1:0: Attached scsi generic sg7 type 0
[   40.995542] sr0: scsi3-mmc drive: 12x/12x writer cd/rw xa/form2 cdda tray
[   40.995965] sr 4:0:1:0: Attached scsi CD-ROM sr0
[   41.206078] md: md0 stopped.
[   41.206137] md: unbind<sdb1>
[   41.206187] md: export_rdev(sdb1)
[   41.206253] md: unbind<sdc1>
[   41.206302] md: export_rdev(sdc1)
[   41.206360] md: unbind<sda1>
[   41.206408] md: export_rdev(sda1)
[   41.247389] md: bind<sdf1>
[   41.247584] md: bind<sdb1>
[   41.247787] md: bind<sda1>
[   41.247971] md: bind<sdc1>
[   41.248151] md: bind<sdg1>
[   41.248325] md: bind<sde1>
[   41.256718] raid5: device sde1 operational as raid disk 0
[   41.256771] raid5: device sdc1 operational as raid disk 4
[   41.256821] raid5: device sda1 operational as raid disk 3
[   41.256870] raid5: device sdb1 operational as raid disk 2
[   41.256919] raid5: device sdf1 operational as raid disk 1
[   41.257426] raid5: allocated 5245kB for md0
[   41.257476] raid5: raid level 5 set md0 active with 5 out of 5 
devices, algorithm 2
[   41.257631]  disk 0, o:1, dev:sde1
[   41.257677]  disk 1, o:1, dev:sdf1
[   41.257724]  disk 2, o:1, dev:sdb1
[   41.257771]  disk 3, o:1, dev:sda1
[   41.257817]  disk 4, o:1, dev:sdc1
[   41.257952] md: md1 stopped.
[   41.258009] md: unbind<sdb2>
[   41.258060] md: export_rdev(sdb2)
[   41.258128] md: unbind<sda2>
[   41.258179] md: export_rdev(sda2)
[   41.258248] md: unbind<sdc2>
[   41.258306] md: export_rdev(sdc2)
[   41.283067] md: bind<sdc2>
[   41.283297] md: bind<sda2>
[   41.285235] md: bind<sdb2>
[   41.306753] md: md1 stopped.
[   41.306818] md: unbind<sdb2>
[   41.306878] md: export_rdev(sdb2)
[   41.306956] md: unbind<sda2>
[   41.307007] md: export_rdev(sda2)
[   41.307075] md: unbind<sdc2>
[   41.307130] md: export_rdev(sdc2)
[   41.312250] md: bind<sdf2>
[   41.312476] md: bind<sdb2>
[   41.312711] md: bind<sdg2>
[   41.312922] md: bind<sdc2>
[   41.313138] md: bind<sda2>
[   41.313343] md: bind<sde2>
[   41.313452] md: md1: raid array is not clean -- starting background 
reconstruction
[   41.322189] raid5: device sde2 operational as raid disk 0
[   41.322243] raid5: device sdc2 operational as raid disk 4
[   41.322292] raid5: device sdg2 operational as raid disk 3
[   41.322342] raid5: device sdb2 operational as raid disk 2
[   41.322391] raid5: device sdf2 operational as raid disk 1
[   41.322823] raid5: allocated 5245kB for md1
[   41.322872] raid5: raid level 5 set md1 active with 5 out of 5 
devices, algorithm 2
[   41.323026]  disk 0, o:1, dev:sde2
[   41.323073]  disk 1, o:1, dev:sdf2
[   41.323119]  disk 2, o:1, dev:sdb2
[   41.323165]  disk 3, o:1, dev:sdg2
[   41.323212]  disk 4, o:1, dev:sdc2
[   41.323316] md: resync of RAID array md1
[   41.323364] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   41.323415] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for resync.
[   41.323492] md: using 128k window, over a total of 231978496 blocks.
[   50.321199] EXT3-fs: sdd1: orphan cleanup on readonly fs
[   50.321323] EXT3-fs: sdd1: 5 orphan inodes deleted
[   66.616890] Adding 3004112k swap on /dev/sdd5.  Priority:-1 extents:1 
across:3004112k
[   66.773498] EXT3 FS on sdd1, internal journal



Neil Brown wrote:
> On Thursday January 10, jed@ultralame.com wrote:
>   
>> distro: Ubuntu 7.10
>>
>> Two files show up...
>>
>> 85-mdadm.rules:
>> # This file causes block devices with Linux RAID (mdadm) signatures to
>> # automatically cause mdadm to be run.
>> # See udev(8) for syntax
>>
>> SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="linux_raid*", \
>>         RUN+="watershed /sbin/mdadm --assemble --scan --no-degraded"
>>     
> ....
>   
>> I see.  So udev is invoking the assemble command as soon as it detects 
>> the devices.  So is it possible that the spare is not the last drive to 
>> be detected and mdadm assembles too soon?
>>     
>
> The "--no-degraded' should stop it from assembling until all expected
> devices have been found.  It could assemble before the spare is found,
> but should not assemble before all the data devices have been found.
>
> The "dmesg" trace you included in your first mail doesn't actually
> show anything wrong - it never starts and incomplete array.
> Can you try again and get a trace where there definitely is a rebuild
> happening.
>
> And please don't drop linux-raid from the 'cc' list.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
