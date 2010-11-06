From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Determining which spindle is out of order
Date: Sat, 6 Nov 2010 16:11:12 +0000
Message-ID: <AANLkTike4ufYxqax80Dp08GyOQf3qfuMRP6_gp4xwStr@mail.gmail.com>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com>
	<4CD57048.4020107@turmel.org>
	<4CD57867.4010207@anonymous.org.uk>
	<4CD57C17.8020303@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD57C17.8020303@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6 November 2010 16:02, Phil Turmel <philip@turmel.org> wrote:
> [added linux-raid CC: back in]
>
> On 11/06/2010 11:46 AM, John Robinson wrote:
>> On 06/11/2010 15:12, Phil Turmel wrote:
>> [...]
>>> Thanks for the feedback. =C2=A0The script only looks in sysfs for c=
ontrollers
>>> implementing the scsi_host interface. =C2=A0So it won't pick up any=
thing using
>>> the legacy IDE interface. =C2=A0If that's not the case on the first=
 server, I'd
>>> like to see lspci -vvv for the controller in question.
>>
>> I get no output on my CentOS 5, kernel-xen-2.6.18-194.8.1.el5.centos=
=2Eplus, much the same as the CentOS/RHEL kernel-xen-2.6.18-194.8.1.el5=
=2E
>>
>> Here's my lspci -vvv for my storage/SCSI devices:
>
> [snip /]
>
>> [...]
>>> find /sys/devices/ -name scsi_host |check_host
>>
>> This may be the culprit, this find command finds nothing, but I thin=
k my devices still support the sysfs scsi_host interface:
>>
>> [root@beast ~]# find /sys/devices/ -name scsi_host
>> [root@beast ~]# find /sys/devices/ -name *scsi_host*
>> /sys/devices/pci0000:00/0000:00:1f.2/host7/scsi_host:host7
>> /sys/devices/pci0000:00/0000:00:1f.2/host6/scsi_host:host6
>> /sys/devices/pci0000:00/0000:00:1f.2/host5/scsi_host:host5
>> /sys/devices/pci0000:00/0000:00:1f.2/host4/scsi_host:host4
>> /sys/devices/pci0000:00/0000:00:1f.2/host3/scsi_host:host3
>> /sys/devices/pci0000:00/0000:00:1f.2/host2/scsi_host:host2
>> /sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.1/host9/scsi_host:ho=
st9
>> /sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.0/host8/scsi_host:ho=
st8
>> /sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host1/scsi_host:ho=
st1
>> /sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host0/scsi_host:ho=
st0
>> [root@beast ~]#
>>
>> When I change the script to use my find command, I get:
>>
>> [root@beast ~]# ~john/projects/describe_scsi/describe_scsi
>> /home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: co=
mmand not found
>> Controller device @ pci0000:00/0000:00:1f.2 []
>> =C2=A0 =C2=A0 host7: [Empty]
>> =C2=A0 =C2=A0 host6: [Empty]
>> =C2=A0 =C2=A0 host5: [Empty]
>> =C2=A0 =C2=A0 host4: [Empty]
>> =C2=A0 =C2=A0 host3: [Empty]
>> =C2=A0 =C2=A0 host2: [Empty]
>> /home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: co=
mmand not found
>> Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.1 []
>> =C2=A0 =C2=A0 host9: [Empty]
>> /home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: co=
mmand not found
>> Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.0 []
>> =C2=A0 =C2=A0 host8: [Empty]
>> /home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: co=
mmand not found
>> Controller device @ pci0000:00/0000:00:1c.4/0000:03:00.0 []
>> =C2=A0 =C2=A0 host1: [Empty]
>> =C2=A0 =C2=A0 host0: [Empty]
>> [root@beast ~]#
>
> Indeed. =C2=A0The sysfs layout changed since kernel 2.6.18. =C2=A0I'm=
 guessing the use of
> CONFIG_SYSFS_DEPRECATED and/or CONFIG_SYSFS_DEPRECATED_V2 will interf=
ere with my
> script in current kernels.
>
> I'll poke around in one of my VMs when I get a chance.
>
>> Now I need to find udevadm I guess. It must have been introduced sin=
ce the udev version that comes with RHEL/CentOS 5, which is udev-095-14=
=2E21.el5_5.1. rpmfind.net suggests it's only been in since version 118=
 or so. Never mind :-)
>
> Heh. =C2=A0Anyone know the equivalent command in earlier versions of =
udev?
>
>>
>> Cheers,
>>
>> John.
>>
>
> Regards,
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Hi, just tested the script (nice!) and it seems to work fine on 2.6.36
(Archlinux) 64-bit:


[fackamato@ion bin]$ sudo ./drivescan.sh
Controller device @ pci0000:00/0000:00:0b.0 [ahci]
  SATA controller: nVidia Corporation MCP79 AHCI Controller (rev b1)
    host0: /dev/sda ATA Corsair CSSD-F60
    host1: /dev/sdb ATA WDC WD20EARS-00M
    host2: /dev/sdc ATA WDC WD20EARS-00M
    host3: /dev/sdd ATA WDC WD20EARS-00M
    host4: [Empty]
    host5: [Empty]
Controller device @ pci0000:00/0000:00:16.0/0000:05:00.0 [sata_mv]
  SCSI storage controller: HighPoint Technologies, Inc. RocketRAID
230x 4 Port SATA-II Controller (rev 02)
    host6: [Empty]
    host7: /dev/sde ATA SAMSUNG HD204UI
    host8: /dev/sdf ATA WDC WD20EARS-00M
    host9: /dev/sdg ATA SAMSUNG HD204UI
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
