From: Duncan Hill <dhill+linuxraid@cricalix.net>
Subject: IT 8212F drivers for kernel-2.6.x failure
Date: Sun, 11 Apr 2004 22:19:30 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200404112219.30612.dhill+linuxraid@cricalix.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Carsten Luedtke wrote:

> -----snip-----
> Dear Sir,
> 
> Please visit our web site for downloading the newest driver for kernel
> 2.6.x. 
> http://www.ite.com.tw/productInfo/Download.html#IT8212 ATA133 Controller
> 
> Best Regards,
> -----snip-----
> 
> You guys with this chipset onboard, please test these drivers and report
> problems to itesupport@ite.com.tw . 
> The drivers are available from the link above as source or binary
> drivers.

For me, this driver has some serious issues with a 2.6 kernel on an AMD64 box.  
I have sent a bug report to itesupport, once I got them to acknowledge that 
they actually wrote the driver (the first response was to talk to nvidia!), 
but I've heard nothing since.  Distro is Gentoo 2004.0 - had to shoehorn in 
the source code into the linux kernel tree, as it wouldn't build outside of 
the tree.

If anyone cares:
Mar 24 08:29:38  kernel: Found Controller: IT8212 UDMA/ATA133 RAID Controller
Mar 24 08:29:38  kernel: Device 0 is IDE
Mar 24 08:29:38  kernel: Channel[0] BM-DMA at 0xA400-0xA407
Mar 24 08:29:38  kernel: IssueIdentify: Resetting channel.
Mar 24 08:29:38  kernel: IssueIdentify (IDE): Disk[0] not ready. Status=0x20
Mar 24 08:29:38  kernel: Device 2 is not present
Mar 24 08:29:38  kernel: IssueIdentify: Resetting channel.
Mar 24 08:29:38  kernel: IssueIdentify (IDE): Disk[1] not ready. Status=0x30
Mar 24 08:29:38  kernel: Device 3 is not present
Mar 24 08:29:38  kernel: Channel[1] BM-DMA at 0xA408-0xA40F
Mar 24 08:29:38  kernel: scsi0 : ITE RAIDExpress133
Mar 24 08:29:38  kernel: Vendor: ITE       Model: IT8212F           Rev: 1.3
Mar 24 08:29:38  kernel: Type:   Direct-Access                      ANSI SCSI 
revision: 00
Mar 24 08:29:38  kernel: sda : sector size 0 reported, assuming 512.
Mar 24 08:29:38  kernel: SCSI device sda: 240121728 512-byte hdwr sectors 
(122942 MB)
Mar 24 08:29:38  kernel: sda: asking for cache data failed
Mar 24 08:29:38  kernel: sda: assuming drive cache: write through
Mar 24 08:29:38 s_dgram@highlander scsi.agent[6024]: how to add device type= 
at /devices/platform/host0/0:0:0:0 ??
Mar 24 08:30:00 s_dgram@highlander CRON[6042]: (root) CMD (test 
-x /usr/sbin/run-crons && /usr/sbin/run-crons )
Mar 24 08:30:08  
kernel: /dev/scsi/host0/bus0/target0/lun0:AtapiStartIo:Already have a 
request!
Mar 24 08:30:08  kernel: AtapiResetController enter
Mar 24 08:30:08  kernel: IT8212ResetAdapter: Reset channel 0
Mar 24 08:30:08  kernel: IT8212ResetAdapter Success!
Mar 24 08:30:08  kernel: AtapiResetController exit
Mar 24 08:30:08  kernel: AtapiResetController enter
Mar 24 08:30:08  kernel: IT8212ResetAdapter: Reset channel 0
Mar 24 08:30:08  kernel: IT8212ResetAdapter Success!
Mar 24 08:30:08  kernel: AtapiResetController exit
Mar 24 08:30:48  kernel: AtapiStartIo:Already have a request!
Mar 24 08:30:48  kernel: AtapiResetController enter
Mar 24 08:30:48  kernel: IT8212ResetAdapter: Reset channel 0
Mar 24 08:30:48  kernel: IT8212ResetAdapter Success!
Mar 24 08:30:48  kernel: AtapiResetController exit
Mar 24 08:30:48  kernel: AtapiResetController enter
Mar 24 08:30:48  kernel: IT8212ResetAdapter: Reset channel 0
Mar 24 08:30:48  kernel: IT8212ResetAdapter Success!
Mar 24 08:30:48  kernel: AtapiResetController exit
Mar 24 08:31:28  kernel: AtapiStartIo:Already have a request!
Mar 24 08:31:28  kernel: AtapiResetController enter
Mar 24 08:31:28  kernel: IT8212ResetAdapter: Reset channel 0
Mar 24 08:31:28  kernel: IT8212ResetAdapter Success!
Mar 24 08:31:28  kernel: AtapiResetController exit
Mar 24 08:31:28  kernel: AtapiResetController enter
Mar 24 08:31:28  kernel: IT8212ResetAdapter: Reset channel 0
Mar 24 08:31:28  kernel: IT8212ResetAdapter Success!
Mar 24 08:31:28  kernel: AtapiResetController exit

At this point the system locked into a loop of resets.  Had to use the power 
button :(
