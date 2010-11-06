From: Phil Turmel <philip@turmel.org>
Subject: Re: Determining which spindle is out of order
Date: Sat, 06 Nov 2010 12:02:31 -0400
Message-ID: <4CD57C17.8020303@turmel.org>
References: <30.2B.19545.E5C25DC4@cdptpa-omtalb.mail.rr.com> <4CD57048.4020107@turmel.org> <4CD57867.4010207@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD57867.4010207@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

[added linux-raid CC: back in]

On 11/06/2010 11:46 AM, John Robinson wrote:
> On 06/11/2010 15:12, Phil Turmel wrote:
> [...]
>> Thanks for the feedback.  The script only looks in sysfs for controllers
>> implementing the scsi_host interface.  So it won't pick up anything using
>> the legacy IDE interface.  If that's not the case on the first server, I'd
>> like to see lspci -vvv for the controller in question.
> 
> I get no output on my CentOS 5, kernel-xen-2.6.18-194.8.1.el5.centos.plus, much the same as the CentOS/RHEL kernel-xen-2.6.18-194.8.1.el5.
> 
> Here's my lspci -vvv for my storage/SCSI devices:

[snip /]

> [...]
>> find /sys/devices/ -name scsi_host |check_host
> 
> This may be the culprit, this find command finds nothing, but I think my devices still support the sysfs scsi_host interface:
> 
> [root@beast ~]# find /sys/devices/ -name scsi_host
> [root@beast ~]# find /sys/devices/ -name *scsi_host*
> /sys/devices/pci0000:00/0000:00:1f.2/host7/scsi_host:host7
> /sys/devices/pci0000:00/0000:00:1f.2/host6/scsi_host:host6
> /sys/devices/pci0000:00/0000:00:1f.2/host5/scsi_host:host5
> /sys/devices/pci0000:00/0000:00:1f.2/host4/scsi_host:host4
> /sys/devices/pci0000:00/0000:00:1f.2/host3/scsi_host:host3
> /sys/devices/pci0000:00/0000:00:1f.2/host2/scsi_host:host2
> /sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.1/host9/scsi_host:host9
> /sys/devices/pci0000:00/0000:00:1e.0/0000:05:01.0/host8/scsi_host:host8
> /sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host1/scsi_host:host1
> /sys/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/host0/scsi_host:host0
> [root@beast ~]#
> 
> When I change the script to use my find command, I get:
> 
> [root@beast ~]# ~john/projects/describe_scsi/describe_scsi
> /home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: command not found
> Controller device @ pci0000:00/0000:00:1f.2 []
>     host7: [Empty]
>     host6: [Empty]
>     host5: [Empty]
>     host4: [Empty]
>     host3: [Empty]
>     host2: [Empty]
> /home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: command not found
> Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.1 []
>     host9: [Empty]
> /home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: command not found
> Controller device @ pci0000:00/0000:00:1e.0/0000:05:01.0 []
>     host8: [Empty]
> /home/john/projects/describe_scsi/describe_scsi: line 8: udevadm: command not found
> Controller device @ pci0000:00/0000:00:1c.4/0000:03:00.0 []
>     host1: [Empty]
>     host0: [Empty]
> [root@beast ~]#

Indeed.  The sysfs layout changed since kernel 2.6.18.  I'm guessing the use of
CONFIG_SYSFS_DEPRECATED and/or CONFIG_SYSFS_DEPRECATED_V2 will interfere with my
script in current kernels.

I'll poke around in one of my VMs when I get a chance.

> Now I need to find udevadm I guess. It must have been introduced since the udev version that comes with RHEL/CentOS 5, which is udev-095-14.21.el5_5.1. rpmfind.net suggests it's only been in since version 118 or so. Never mind :-)

Heh.  Anyone know the equivalent command in earlier versions of udev?

> 
> Cheers,
> 
> John.
> 

Regards,

Phil
