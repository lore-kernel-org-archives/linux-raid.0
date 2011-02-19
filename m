From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sat, 19 Feb 2011 23:26:53 +0000
Message-ID: <AANLkTimzrc+JphJp-MeuFTo6CWFunto4N_zPLCoj8pkd@mail.gmail.com>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>
	<4D5FE3D6.8070006@anonymous.org.uk>
	<4D5FF386.6070003@turmel.org>
	<AANLkTinw8hSks5kopU9ju1cNCQu11kUgPzRbC8L2h_ed@mail.gmail.com>
	<4D60429E.1090501@turmel.org>
	<AANLkTi=k7BwKbkK+TL_CevezhcRyUszHpOBZY2Dt5TiQ@mail.gmail.com>
	<4D6046D5.4020005@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6046D5.4020005@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>, Simon Mcnair <simonmcnair@gmail.com>
List-Id: linux-raid.ids

On 19 February 2011 22:40, Phil Turmel <philip@turmel.org> wrote:
> On 02/19/2011 05:30 PM, Mathias Bur=C3=A9n wrote:
>> On 19 February 2011 22:22, Phil Turmel <philip@turmel.org> wrote:
>>> On 02/19/2011 03:09 PM, Mathias Bur=C3=A9n wrote:
>>>> The script works for me:
>>>>
>>>> =C2=A0$ sudo ./lsdrv.sh
>>>> Password:
>>>> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>>>> =C2=A0 SATA controller: nVidia Corporation MCP79 AHCI Controller (=
rev b1)
>>>> =C2=A0 =C2=A0 host0: /dev/sda ATA Corsair CSSD-F60 {SN: 1032650558=
0009990027}
>>>> =C2=A0 =C2=A0 host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA10=
22443}
>>>> =C2=A0 =C2=A0 host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ201=
52590}
>>>> =C2=A0 =C2=A0 host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ201=
88479}
>>>> =C2=A0 =C2=A0 host4: [Empty]
>>>> =C2=A0 =C2=A0 host5: [Empty]
>>>> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>>>> =C2=A0 SCSI storage controller: HighPoint Technologies, Inc. Rocke=
tRAID
>>>> 230x 4 Port SATA-II Controller (rev 02)
>>>> =C2=A0 =C2=A0 host6: [Empty]
>>>> =C2=A0 =C2=A0 host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800=
964 }
>>>> =C2=A0 =C2=A0 host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA10=
00331}
>>>> =C2=A0 =C2=A0 host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800=
850 }
>>>>
>>>> So ata3 is the same as host3 then? How come no errors are logged o=
n the drive:
>>>
>>> No, generally not. =C2=A0ATA numbering starts from #1. =C2=A0Host n=
umbering starts from #0, but includes non-ATA SCSI devices.
>>>
>>> I've attached a version of the script that shows the LUN in additio=
n to the host number, and includes John's adjustment. =C2=A0It might be=
 useful to people with port multipliers, and controllers that show all =
ports under a single host.
>>>
>>> Simon, I'm very curious what this latest script shows for the Super=
micro when one or more ports are empty, and whether those LUNs are cons=
istently assigned to specific ports.
>>>
>>> Phil
>>>
>>
>> $ sudo ./lsdrv-2.sh
>> Controller device @ pci0000:00/0000:00:0b.0 [ahci]
>> =C2=A0 SATA controller: nVidia Corporation MCP79 AHCI Controller (re=
v b1)
>> =C2=A0 =C2=A0 host0 0:0:0 sda ATA Corsair CSSD-F60 {SN: 103265055800=
09990027}
>> =C2=A0 =C2=A0 host1 0:0:0 sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022=
443}
>> =C2=A0 =C2=A0 host2 0:0:0 sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152=
590}
>> =C2=A0 =C2=A0 host3 0:0:0 sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188=
479}
>> =C2=A0 =C2=A0 host4 [Empty]
>> =C2=A0 =C2=A0 host5 [Empty]
>> Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
>> =C2=A0 SCSI storage controller: HighPoint Technologies, Inc. RocketR=
AID
>> 230x 4 Port SATA-II Controller (rev 02)
>> =C2=A0 =C2=A0 host6 [Empty]
>> =C2=A0 =C2=A0 host7 0:0:0 sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ80096=
4 }
>> =C2=A0 =C2=A0 host8 0:0:0 sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000=
331}
>> =C2=A0 =C2=A0 host9 0:0:0 sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ80085=
0 }
>>
>> This is the output of your latest script on my machine. The "0:0:0" =
is
>> supposed to be the LUN, which would be ata[1, 2, 3..], no?
>
> No. =C2=A0You have to look in your dmesg to match the 'ata' initializ=
ation reports with the corresponding 'scsi' initialization reports.
>
> dmesg |grep 'ata[0-9]\|scsi[0-9]'
>
> Unless I missed something in sysfs that would make it easy to report =
it in the script?
>
> Phil
>

$ dmesg |grep 'ata[0-9]\|scsi[0-9]'
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76100 irq 40
ata2: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76180 irq 40
ata3: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76200 irq 40
ata4: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76280 irq 40
ata5: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76300 irq 40
ata6: SATA max UDMA/133 abar m8192@0xfae76000 port 0xfae76380 irq 40
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: WDC WD20EARS-00MVWB0, 50.0AB50, max UDMA/133
ata3.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
ata2.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133
ata2.00: configured for UDMA/133
ata1.00: ATA-8: Corsair CSSD-F60GB2, 1.1, max UDMA/133
ata1.00: 117231408 sectors, multi 1: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD20EARS-00MVWB0, 50.0AB50, max UDMA/133
ata4.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata4.00: configured for UDMA/133
scsi6 : sata_mv
scsi7 : sata_mv
scsi8 : sata_mv
scsi9 : sata_mv
ata7: SATA max UDMA/133 mmio m1048576@0xfeb00000 port 0xfeb22000 irq 19
ata8: SATA max UDMA/133 mmio m1048576@0xfeb00000 port 0xfeb24000 irq 19
ata9: SATA max UDMA/133 mmio m1048576@0xfeb00000 port 0xfeb26000 irq 19
ata10: SATA max UDMA/133 mmio m1048576@0xfeb00000 port 0xfeb28000 irq 1=
9
ata7: SATA link down (SStatus 0 SControl 300)
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8.00: ATA-8: SAMSUNG HD204UI, 1AQ10003, max UDMA/133
ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata8.00: configured for UDMA/133
ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata9.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
ata9.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata9.00: configured for UDMA/133
ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata10.00: ATA-8: SAMSUNG HD204UI, 1AQ10003, max UDMA/133
ata10.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata10.00: configured for UDMA/133

Like you said before, ATA numbering starts from #1 & host numbering
starts from #0, if I only go by that the numbers match up. (the script
says host 4, 5 and 6 are empty, and according to ATA in dmesg ata 5, 6
& 7 are down.)

This would mean that the drive in question (ata3) is actually "host2
0:0:0 sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}". Yet it doesn't
show and SMART errors:


Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   165   163   021    Pre-fail
Always       -       6750
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       55
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   094   094   000    Old_age
Always       -       5070
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       49
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       31
193 Load_Cycle_Count        0x0032   180   180   000    Old_age
Always       -       60164
194 Temperature_Celsius     0x0022   114   099   000    Old_age
Always       -       36
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      4660   =
      -
# 2  Short offline       Completed without error       00%      2180   =
      -
# 3  Extended offline    Completed without error       00%      1408   =
      -

I'm beginning to wonder if there's a controller/firmware problem and
not actually a physical HDD problem that causes this error. I've only
seen it happen during consistency checks of the array (and only once
per check, near the 70% mark or so).

Nifty script btw. :-)

Thanks,
// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
