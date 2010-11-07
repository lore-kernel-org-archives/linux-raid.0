From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Determining which spindle is out of order
Date: Sun, 07 Nov 2010 12:53:21 +0000
Message-ID: <4CD6A141.5090601@anonymous.org.uk>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk> <4CD57C17.8020303@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD57C17.8020303@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/11/2010 16:02, Phil Turmel wrote:
> On 11/06/2010 11:46 AM, John Robinson wrote:
[...]
>> Now I need to find udevadm I guess. It must have been introduced since the udev version that comes with RHEL/CentOS 5, which is udev-095-14.21.el5_5.1. rpmfind.net suggests it's only been in since version 118 or so. Never mind :-)
>
> Heh.  Anyone know the equivalent command in earlier versions of udev?

I think it's `udevinfo` instead of `udevadm info` - the comment in the 
ChangeLog for udev-117 is "udevadm: merge all udev tools into a single 
binary". But it doesn't work terribly well:

[root@beast describe_scsi]# udevinfo -q all -p 
/devices/pci0000\:00/0000\:00\:1f.2/
no record for '/devices/pci0000:00/0000:00:1f.2/' in database

That's unfortunate. But it does know about that device if asked differently:

[root@beast describe_scsi]# udevinfo -a -p 
/devices/pci0000\:00/0000\:00\:1f.2/

Udevinfo starts with the device specified by the devpath and then
walks up the chain of parent devices. It prints for every device
found, all possible attributes in the udev rules key format.
A rule to match, can be composed by the attributes of the device
and the attributes from one single parent device.

   looking at device '/devices/pci0000:00/0000:00:1f.2':
     KERNEL=="0000:00:1f.2"
     SUBSYSTEM=="pci"
     SYSFS{broken_parity_status}=="0"
     SYSFS{enable}=="1"
 
SYSFS{modalias}=="pci:v00008086d00003A22sv00001043sd000082D4bc01sc06i01"
 
SYSFS{local_cpus}=="7fffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff,ffffffff"
     SYSFS{irq}=="251"
     SYSFS{class}=="0x010601"
     SYSFS{subsystem_device}=="0x82d4"
     SYSFS{subsystem_vendor}=="0x1043"
     SYSFS{device}=="0x3a22"
     SYSFS{vendor}=="0x8086"

   looking at parent device '/devices/pci0000:00':
     ID=="pci0000:00"
     BUS==""
     DRIVER==""

[root@beast describe_scsi]#

And that output is obviously not what the rest of your script wants. I 
can ask about individual drives though:

[root@beast describe_scsi]# udevinfo -q all -p /block/sda
P: /block/sda
N: sda
S: disk/by-id/scsi-SATA_Hitachi_HDS7210_JP2921HQ0J0PZA
S: disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0
E: ID_VENDOR=ATA
E: ID_MODEL=Hitachi_HDS72101
E: ID_REVISION=JP4O
E: ID_SERIAL=SATA_Hitachi_HDS7210_JP2921HQ0J0PZA
E: ID_TYPE=disk
E: ID_BUS=scsi
E: ID_PATH=pci-0000:00:1f.2-scsi-0:0:0:0
[root@beast describe_scsi]#

I suspect the udev version in EL5 just isn't going to give up the info 
you need, even if you did rewrite for the different sysfs paths :-(

Thanks for your efforts though!

Cheers,

John.
