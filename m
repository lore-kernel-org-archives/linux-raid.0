From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: Determining which spindle is out of order
Date: Sat, 06 Nov 2010 17:45:52 +0100
Message-ID: <4CD58640.2010606@computer.org>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD57C17.8020303@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/10 17:02, Phil Turmel wrote:
> Indeed.  The sysfs layout changed since kernel 2.6.18.  I'm guessing the use of
> CONFIG_SYSFS_DEPRECATED and/or CONFIG_SYSFS_DEPRECATED_V2 will interfere with my
> script in current kernels.

Nice.

Output on one of my machines is however not as expected:

Controller device @ pci0000:00/0000:00:1c.1/0000:02:00.0 [ahci]
   SATA controller: JMicron Technology Corp. JMB360 AHCI Controller (rev 02)
     host4: [Empty]
Controller device @ pci0000:00/0000:00:1f.2 [ata_piix]
   IDE interface: Intel Corporation 5 Series/3400 Series Chipset 4 port 
SATA IDE Controller (rev 06)
     host0: /dev/sda ATA WDC WD20EADS-00R {SN: WD-WCAVY4080404}
     host1: /dev/sdb ATA ST3500418AS {SN: 9VMK33L9}
     host1: /dev/sdc ATA ST3500418AS {SN: 9VMM6EY4}
Controller device @ pci0000:00/0000:00:1f.5 [ata_piix]
   IDE interface: Intel Corporation 5 Series/3400 Series Chipset 2 port 
SATA IDE Controller (rev 06)
     host2: [Empty]
     host3: [Empty]

This machine has seven SATA ports: one provided by the JMicron chip, the 
other six by the Intel H55 south bridge. Only three ports are currently 
used, but I had expected another [Empty] entry.

Here's what's in /sys/devices:

root@zotac:~# find /sys/devices/ -name scsi_host
/sys/devices/pci0000:00/0000:00:1c.1/0000:02:00.0/host4/scsi_host
/sys/devices/pci0000:00/0000:00:1f.2/host0/scsi_host
/sys/devices/pci0000:00/0000:00:1f.2/host1/scsi_host
/sys/devices/pci0000:00/0000:00:1f.5/host2/scsi_host
/sys/devices/pci0000:00/0000:00:1f.5/host3/scsi_host

Not sure what to make of that...

Jan
