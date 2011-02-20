From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Possible HDD error, how do I find which HDD it is?
Date: Sun, 20 Feb 2011 03:44:33 +0000
Message-ID: <AANLkTimfDV7hvXRAiUs1mc2h72cZW11O0y0Lt7kngHV9@mail.gmail.com>
References: <AANLkTimV8-mciW_9z_=U_-uYLvKp7Rbh0V1N0mr7rh8v@mail.gmail.com>
	<4D5FE3D6.8070006@anonymous.org.uk>
	<4D5FF386.6070003@turmel.org>
	<AANLkTinw8hSks5kopU9ju1cNCQu11kUgPzRbC8L2h_ed@mail.gmail.com>
	<4D60429E.1090501@turmel.org>
	<AANLkTi=k7BwKbkK+TL_CevezhcRyUszHpOBZY2Dt5TiQ@mail.gmail.com>
	<4D6046D5.4020005@turmel.org>
	<4D608674.6090506@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D608674.6090506@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>, Simon Mcnair <simonmcnair@gmail.com>
List-Id: linux-raid.ids

On 20 February 2011 03:11, John Robinson <john.robinson@anonymous.org.u=
k> wrote:
> On 19/02/2011 22:40, Phil Turmel wrote:
>>
>> On 02/19/2011 05:30 PM, Mathias Bur=C3=A9n wrote:
>
> [...]
>>>
>>> This is the output of your latest script on my machine. The "0:0:0"
>>> is supposed to be the LUN, which would be ata[1, 2, 3..], no?
>>
>> No. =C2=A0You have to look in your dmesg to match the 'ata' initiali=
zation
>> reports with the corresponding 'scsi' initialization reports.
>>
>> dmesg |grep 'ata[0-9]\|scsi[0-9]'
>>
>> Unless I missed something in sysfs that would make it easy to report
>> it in the script?
>
> I don't know about easy, but there is a suggestion in the page Simon
> McNair linked to earlier in this thread:
> http://www.linux-archive.org/centos/316405-how-map-ata-numbers-dev-sd=
-numbers.html#post428370
>
> I suspect that at the very least you'd have to check the proc_name to
> see if it matched a driver which used libata before you could say the
> unique_id matched the kernel's ata:N though, which is why I say it mi=
ght not
> be easy (well beyond me at any rate)...
>
> Cheers,
>
> John.
>

Hi,

I think it's safe to assume that in my case, ata3 which showed errors
in dmesg is indeed /dev/sdc based on the following:


$ sudo bin/lsdrv-2.sh
Controller device @ pci0000:00/0000:00:0b.0 [ahci]
  SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
    host0 0:0:0 sda ATA Corsair CSSD-F60 {SN: 10326505580009990027}
    host1 0:0:0 sdb ATA WDC WD20EARS-00M {SN: WD-WCAZA1022443}
    host2 0:0:0 sdc ATA WDC WD20EARS-00M {SN: WD-WMAZ20152590}
    host3 0:0:0 sdd ATA WDC WD20EARS-00M {SN: WD-WMAZ20188479}
    host4 [Empty]
    host5 [Empty]
Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
  SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
230x 4 Port SATA-II Controller (rev 02)
    host6 [Empty]
    host7 0:0:0 sde ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800964 }
    host8 0:0:0 sdf ATA WDC WD20EARS-00M {SN: WD-WCAZA1000331}
    host9 0:0:0 sdg ATA SAMSUNG HD204UI {SN: S2HGJ1RZ800850 }

$ sudo lsscsi -d -v -l
[0:0:0:0]    disk    ATA      Corsair CSSD-F60 1.1   /dev/sda [8:0]
  state=3Drunning queue_depth=3D31 scsi_level=3D6 type=3D0 device_block=
ed=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/0:0:0:0
[/sys/devices/pci0000:00/0000:00:0b.0/host0/target0:0:0/0:0:0:0]
[1:0:0:0]    disk    ATA      WDC WD20EARS-00M 51.0  /dev/sdb [8:16]
  state=3Drunning queue_depth=3D31 scsi_level=3D6 type=3D0 device_block=
ed=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/1:0:0:0
[/sys/devices/pci0000:00/0000:00:0b.0/host1/target1:0:0/1:0:0:0]
[2:0:0:0]    disk    ATA      WDC WD20EARS-00M 50.0  /dev/sdc [8:32]
  state=3Drunning queue_depth=3D31 scsi_level=3D6 type=3D0 device_block=
ed=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/2:0:0:0
[/sys/devices/pci0000:00/0000:00:0b.0/host2/target2:0:0/2:0:0:0]
[3:0:0:0]    disk    ATA      WDC WD20EARS-00M 50.0  /dev/sdd [8:48]
  state=3Drunning queue_depth=3D31 scsi_level=3D6 type=3D0 device_block=
ed=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/3:0:0:0
[/sys/devices/pci0000:00/0000:00:0b.0/host3/target3:0:0/3:0:0:0]
[7:0:0:0]    disk    ATA      SAMSUNG HD204UI  1AQ1  /dev/sde [8:64]
  state=3Drunning queue_depth=3D31 scsi_level=3D6 type=3D0 device_block=
ed=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/7:0:0:0
[/sys/devices/pci0000:00/0000:00:16.0/0000:05:00.0/host7/target7:0:0/7:=
0:0:0]
[8:0:0:0]    disk    ATA      WDC WD20EARS-00M 51.0  /dev/sdf [8:80]
  state=3Drunning queue_depth=3D31 scsi_level=3D6 type=3D0 device_block=
ed=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/8:0:0:0
[/sys/devices/pci0000:00/0000:00:16.0/0000:05:00.0/host8/target8:0:0/8:=
0:0:0]
[9:0:0:0]    disk    ATA      SAMSUNG HD204UI  1AQ1  /dev/sdg [8:96]
  state=3Drunning queue_depth=3D31 scsi_level=3D6 type=3D0 device_block=
ed=3D0 timeout=3D30
  dir: /sys/bus/scsi/devices/9:0:0:0
[/sys/devices/pci0000:00/0000:00:16.0/0000:05:00.0/host9/target9:0:0/9:=
0:0:0]

$ for d in /sys/class/scsi_host/host*; do  echo "$d $(cat
$d/proc_name) $(cat $d/unique_id)"; done
/sys/class/scsi_host/host0 ahci 1
/sys/class/scsi_host/host1 ahci 2
/sys/class/scsi_host/host2 ahci 3
/sys/class/scsi_host/host3 ahci 4
/sys/class/scsi_host/host4 ahci 5
/sys/class/scsi_host/host5 ahci 6
/sys/class/scsi_host/host6 sata_mv 7
/sys/class/scsi_host/host7 sata_mv 8
/sys/class/scsi_host/host8 sata_mv 9
/sys/class/scsi_host/host9 sata_mv 10

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
