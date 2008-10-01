From: David Greaves <david@dgreaves.com>
Subject: Re: SATA errors?
Date: Wed, 01 Oct 2008 13:17:37 +0100
Message-ID: <48E36A61.4020903@dgreaves.com>
References: <48E34221.1000008@agenda.si> <20081001100833.3253724847@gemini.denx.de> <48E353D5.1060908@agenda.si> <A20315AE59B5C34585629E258D76A97C02180F8B@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C02180F8B@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Danilo Godec <danilo.godec@agenda.si>, Wolfgang Denk <wd@denx.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Lethe wrote:
> There is no cause of concern. The 0x25 command translates to
> READ_CAPACITY10.  (i.e., how many blocks does the disk hold).  This
> command is emulated because the disk doesn't natively speak SCSI
> commands, which is how your specific hardware/driver/controller
> combination configures such things.

and yet look at the timestamps...


> Oct  1 10:11:30 bigxen2 kernel: ata1: waiting for device to spin up (7
> secs)
> Oct  1 10:11:40 bigxen2 kernel: ata1: soft resetting port
> Oct  1 10:11:41 bigxen2 kernel: ata1: softreset failed (1st FIS failed)
> Oct  1 10:11:41 bigxen2 kernel: ata1: softreset failed, retrying in 5 secs
> Oct  1 10:11:46 bigxen2 kernel: ata1: hard resetting port
> Oct  1 10:11:47 bigxen2 kernel: ata1: SATA link up 3.0 Gbps (SStatus
> 123 SControl 300)
> Oct  1 10:11:47 bigxen2 kernel: ata1.00: configured for UDMA/133
> Oct  1 10:11:47 bigxen2 kernel: ata1: EH complete

That looks to me like 15-17 seconds of unresponsive disk; certainly the time
around the resets are times when the driver isn't allowing disk access.

I'd say there was cause for something; although I'd cc the linux-ide group for
real insight, not linux-raid :)

David - maybe the response from the 0x25 command should not result in a reset -
or maybe the 0x25 should not be issued if it causes a state that does require a
reset.

I get similar softreset/hardreset problems with some samsung drives on some
controllers. I've not got round to investigating it yet. Sorry.

David


-- 
"Don't worry, you'll be fine; I saw it work in a cartoon once..."
