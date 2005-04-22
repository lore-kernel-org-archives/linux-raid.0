From: David Greaves <david@dgreaves.com>
Subject: Re: Raid1 stalls during hotplug and Promise SATA TX4
Date: Fri, 22 Apr 2005 09:04:55 +0100
Message-ID: <4268B027.9070504@dgreaves.com>
References: <32973.10.0.0.2.1114128004.squirrel@resen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32973.10.0.0.2.1114128004.squirrel@resen.org>
Sender: linux-raid-owner@vger.kernel.org
To: skrald@amossen.dk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

not sure about this but it looks like the problem is occuring at a lower 
  level than md.

I'd take it over to ide-linux and/or hotplug.

ide-linux is at linux-ide@vger.kernel.org
I don't know about hotplug

It would help to tell them what kernel you're running too <grin>

HTH
David


skrald@amossen.dk wrote:
> AApr 22 00:58:16 server kernel: ata4: command timeout
> Apr 22 00:58:16 server kernel: ata4: status=0x51 { DriveReady SeekComplete
> Error }
> Apr 22 00:58:16 server kernel: ata4: called with no error (51)!
> Apr 22 00:58:16 server kernel: SCSI error : <4 0 0 0> return code = 0x8000002
> Apr 22 00:58:16 server kernel: sdc: Current: sense key=0x3
> Apr 22 00:58:16 server kernel:     ASC=0x11 ASCQ=0x4
> Apr 22 00:58:16 server kernel: end_request: I/O error, dev sdc, sector 4199
> Apr 22 00:58:16 server kernel: raid1: Disk failure on sdc1, disabling device.

so /dev/sdc is toast, not /dev/sdb


> Apr 22 00:58:16 server kernel: ^IOperation continuing on 1 devices
> Apr 22 00:58:16 server kernel: raid1: sdc1: rescheduling sector 4136
> Apr 22 01:14:32 server kernel: Disabling IRQ #10
> Apr 22 00:58:46 server kernel: ata2: command timeout
> Apr 22 00:58:46 server kernel: ATA: abnormal status 0xFF on port 0xCA81429C
> Apr 22 00:58:46 server kernel: ata2: status=0xff { Busy }
> Apr 22 00:58:46 server kernel: SCSI error : <2 0 0 0> return code = 0x8000002
> Apr 22 00:58:46 server kernel: sdb: Current: sense key=0xb
> Apr 22 00:58:46 server kernel:     ASC=0x47 ASCQ=0x0
> Apr 22 00:58:46 server kernel: end_request: I/O error, dev sdb, sector
> 38491583
> Apr 22 00:58:46 server kernel: md: write_disk_sb failed for device sdb1

oops, so is /dev/sdb

