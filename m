From: Luca Berra <bluca@comedia.it>
Subject: Re: (no subject)
Date: Thu, 12 Sep 2002 07:48:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D802AB8.4000704@comedia.it>
References: <3D7F8B2E.14D49808@milleraa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Eddie Johnson wrote:
> I installed Suse Linux Professional 8 on a HP Netserver LC3 PII/450.  An
> AHA-2940 UW Scsi host adapter with a AIC-78XX Scsi Protocol Chip/50 pin
> high density scsi-2 control.  I have a raid (3 drives) off the host
No, you have an HP NetRaid Adapter (Aka AMI megaraid)
> adapter and a 80 gig scsi drive off the mother board. After launching
> yast2 the first raid has the following device: LD0 raid 5 34730R:
> device_name /dev/sda, vendor megaraid.  Disk two (80 gig drive) has LD1
> raid 0 70006R: device name /dev/sdb vendor the same as above.  There was
> no raidtab file so I created one with the following: >
.........
> If I read this correctly both are inactive when it should be stating
> that they are active.  At this point I am baffled any suggestions or
> possible directions would greatly be appreciated.

you don't need md, mkraid or such,
if you want to configure your hw raid just press Ctrl-M at boot
or start the server from the Navigator CD

L.


