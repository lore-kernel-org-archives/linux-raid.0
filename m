From: "Roger Lucas" <roger@planbit.co.uk>
Subject: RE: Odd (slow) RAID performance
Date: Thu, 30 Nov 2006 15:32:27 -0000
Message-ID: <20061130153240.1300912EDE@bluewhale.planbit.co.uk>
References: <456EF903.10502@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <456EF903.10502@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Bill Davidsen' <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > What drive configuration are you using (SCSI / ATA / SATA), what chipset
> is
> > providing the disk interface and what cpu are you running with?
> 3xSATA, Seagate 320 ST3320620AS, Intel 6600, ICH7 controller using the
> ata-piix driver, with drive cache set to write-back. It's not obvious to
> me why that matters, but if it helps you see the problem I''m glad to
> provide the info. I'm seeing ~50MB/s on the raw drive, and 3x that on
> plain stripes, so I'm assuming that either the RAID-5 code is not
> working well or I haven't set it up optimally.

If it had been ATA, and you had two drives as master+slave on the same
cable, then they would be fast individually but slow as a pair.

RAID-5 is higher overhead than RAID-0/RAID-1 so if your CPU was slow then
you would see some degradation from that too.

We have similar hardware here so I'll run some tests here and see what I
get...

