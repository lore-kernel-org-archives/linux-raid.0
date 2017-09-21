From: =?UTF-8?B?Vm9qdMSbY2ggS2xldGXEjWth?= <vojta.kletecka@gmail.com>
Subject: Re: Data recovery
Date: Thu, 21 Sep 2017 14:55:52 +0200
Message-ID: <CAEmSg09hzYijYix=gc_Nkbr1Ub4YuDGvP--MpEB8UjB=U71onA@mail.gmail.com>
References: <CAEmSg0_=5ni2mA1Q_A1DjZmvjG9u8tKXOQHmnmT33=12yJwYqA@mail.gmail.com>
 <59C309C7.9030300@youngman.org.uk> <796e5efe-04af-60c7-4ef0-f9962e456061@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <796e5efe-04af-60c7-4ef0-f9962e456061@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Requested command outputs are at the end of the mail and verbose
version of mdadm assembly yielded nothing new as I have already tried
--force and/or --run for assembling. For the sake of completeness I
also provide versions of mdadm and kernel.

Independently I have studied syslog a little bit. After rough
filtering of cluttering data
(cat /var/log/syslog.1 | grep -v
'gnome-session\|CRON\|UFW\|wpa_supplicant\|dnsmasq-dhcp\|Ring\|dring\|docke=
rd\|nm-dispatcher\|NetworkManager\|icecast2\|avahi-daemon\|rtkit-daemon\|dh=
client\|bluetoothd'
|grep "Sep 20" > syslog_preprocessed)
I have come up with ~7MB file of more or less relevant data which is
here: http://mysharegadget.com/911016387
First connection of disk was at 21:10:32, 7 minutes later raid finally
assembled but there are suspisious lines from ~9 minutes after the
first connection:

Sep 20 21:19:27 Titan kernel: [35921.641157] md: super_written gets error=
=3D-5
Sep 20 21:19:27 Titan kernel: [35921.701049] Buffer I/O error on dev
md127, logical block 732238832, async page read
Sep 20 21:19:27 Titan udisksd[3629]: Unable to resolve
/sys/devices/virtual/block/md127/md/dev-sdc1/block symlink

From now on there is plenty of errors like this (is it possible that
this caused desync in event count?):
Sep 20 21:19:27 Titan kernel: [35922.266406] md: super_written gets error=
=3D-5

Are these findings anyhow useful for solving the problem or at least
to determine what caused the error?

Anyway, thank you very much for helping me.

With kind regards,

Vojt=C4=9Bch Klete=C4=8Dka

----------------------
uname -a
Linux Titan 4.4.0-96-generic #119-Ubuntu SMP Tue Sep 12 14:59:54 UTC
2017 x86_64 x86_64 x86_64 GNU/Linux
----------------------
sudo mdadm --version
mdadm - v3.3 - 3rd September 2013
----------------------
sudo mdadm --assemble --force --verbose /dev/md127 /dev/sd[cde]1
mdadm: looking for devices for /dev/md127
mdadm: /dev/sdc1 is identified as a member of /dev/md127, slot 2.
mdadm: /dev/sdd1 is identified as a member of /dev/md127, slot 0.
mdadm: /dev/sde1 is identified as a member of /dev/md127, slot 1.
mdadm: added /dev/sde1 to /dev/md127 as 1
mdadm: added /dev/sdc1 to /dev/md127 as 2 (possibly out of date)
mdadm: added /dev/sdd1 to /dev/md127 as 0
mdadm: failed to RUN_ARRAY /dev/md127: Input/output error

(->As I said, this causes "not enough operational mirrors" error in dmesg)
----------------------
for x in /sys/block/sd[cde]/device/timeout ; do echo $x $(< $x) ; done
/sys/block/sdc/device/timeout 30
/sys/block/sdd/device/timeout 30
/sys/block/sde/device/timeout 30
----------------------
for x in /dev/sd[cde] ; do echo $x ; sudo smartctl -iA -l scterc $x ; done
/dev/sdc
[sudo] password for vojtech:
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-96-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

Read Device Identity failed: scsi error device will be ready soon

A mandatory SMART command failed: exiting. To continue, add one or
more '-T permissive' options.
/dev/sdd
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-96-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD20EZRZ-00Z5HB0
Serial Number:    WD-WCC4M6FP3T6Y
LU WWN Device Id: 5 0014ee 2b770e29c
Firmware Version: 80.00A80
User Capacity:    2 000 398 934 016 bytes [2,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Sep 21 14:13:51 2017 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   182   173   021    Pre-fail
Always       -       3875
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       113
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       179
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       105
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       41
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       1000
194 Temperature_Celsius     0x0022   115   098   000    Old_age
Always       -       32
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SCT Error Recovery Control command not supported

/dev/sde
smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-96-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WDC WD20EZRZ-00Z5HB0
Serial Number:    WD-WCC4M3ZF6D48
LU WWN Device Id: 5 0014ee 2623ff611
Firmware Version: 80.00A80
User Capacity:    2 000 398 934 016 bytes [2,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Sep 21 14:13:51 2017 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   187   175   021    Pre-fail
Always       -       3608
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       106
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       174
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       96
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       42
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       917
194 Temperature_Celsius     0x0022   113   096   000    Old_age
Always       -       34
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SCT Error Recovery Control command not supported

2017-09-21 14:10 GMT+02:00 Phil Turmel <philip@turmel.org>:
> On 09/20/2017 08:37 PM, Wols Lists wrote:
>> On 21/09/17 01:08, Vojt=C4=9Bch Klete=C4=8Dka wrote:
>
>> Thank $DEITY for that - do NOT use --create - at least don't use it if
>> you want to recover your data !!!
>
> Yes, do NOT use --create.
>
>>> Thank you for your time and any suggestions.
>>>
>> Get a SATA add in card if you don't have enough SATA ports, and get rid
>> of USB !!!
>
> After you reassemble one more time and finish backing up.
>
>> I'll let others chime in on how to get your array back - IF you put the
>> drives on SATA, I hope it's just a simple "--assemble --force" which
>> will result in everything sorting itself out, but we'll see. But don't
>> put USB drives into a raid array!
>
> Please run and report the output of the following commands:
>
> for x in /dev/sd[cde] ; do echo $x ; smartctl -iA -l scterc $x ; done
>
> for x in /sys/block/sd[cde]/device/timeout ; do echo $x $(< $x) ; done
>
> You may have problems that will interfere with rebuilding onto sdd1.
>
> After we see the above, you will be asked to do this:
>
> mdadm --assemble --force --verbose /dev/md127 /dev/sd[cde]1
>
> If this doesn't work (I'll be shocked), please post what it prints.
>
> Phil



--=20
Pokud tento mail obsahuje tautologii, pak z=C5=99ejm=C4=9B tautologii skute=
=C4=8Dn=C4=9B obsahuje.

Vojt=C4=9Bch Klete=C4=8Dka
