From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sat, 19 Feb 2011 20:09:43 +0000
Message-ID: <AANLkTinw8hSks5kopU9ju1cNCQu11kUgPzRbC8L2h_ed@mail.gmail.com>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>
	<4D5FE3D6.8070006@anonymous.org.uk>
	<4D5FF386.6070003@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5FF386.6070003@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19 February 2011 16:44, Phil Turmel <philip@turmel.org> wrote:
> On 02/19/2011 10:37 AM, John Robinson wrote:
>> On 19/02/2011 11:52, Mathias Bur=C3=A9n wrote:
>> [...]
>>> What I wonder is, how do I know what device is ata3? I do have 4
>>> devices of that model (WD20EARS). I've tried searching in /sys but
>>> there's nothing of value there (or I've missed it). If dmesg only
>>> showed the S/N...
>>> I posted the smartctl --all output of all devices here in case some=
one
>>> has time to take a look:
>>> http://stuff.dyndns.org/logs/smart-sd[a,b,c,d,e,f,g].log
>>
>> Try using Phil Turmel's excellent lsdrv script; I've attached the ve=
rsion I use on EL5, but I hacked it about to work on such an old distro=
 so I wouldn't swear it will work on more recent distros; Phil's origin=
al that does work on more recent distros can be found in the list archi=
ves around 6 November last year in the thread "Determining which spindl=
e is out of order".
>
> I've attached the latest version. =C2=A0It falls back to smartctl if =
it can't find the sginfo utility. =C2=A0It should work on both old and =
new sysfs layouts.
>
> Phil
>
>

Hi,

The script works for me:


 $ sudo ./lsdrv.sh
Password:
Controller device @ pci0000:00/0000:00:0b.0 [ahci]
  SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
    host0: /dev/sda ATA Corsair CSSD-F60 {SN: 10326505580009990027}
    host1: /dev/sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
    host2: /dev/sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
    host3: /dev/sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
    host4: [Empty]
    host5: [Empty]
Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
  SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
230x 4 Port SATA-II Controller (rev 02)
    host6: [Empty]
    host7: /dev/sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
    host8: /dev/sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
    host9: /dev/sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }

So ata3 is the same as host3 then? How come no errors are logged on the=
 drive:


ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   163   162   021    Pre-fail
Always       -       6808
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       53
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   093   093   000    Old_age
Always       -       5169
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       48
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       30
193 Load_Cycle_Count        0x0032   172   172   000    Old_age
Always       -       85965
194 Temperature_Celsius     0x0022   120   102   000    Old_age
Always       -       30
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
# 1  Extended offline    Completed without error       00%      4761   =
      -
# 2  Short offline       Completed without error       00%      2285   =
      -
# 3  Extended offline    Completed without error       00%      1514   =
      -

Cheers,
// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
