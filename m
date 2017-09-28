From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Resolved? ServeRAID-BR10i (LSI SAS1068E) strageness
Date: Thu, 28 Sep 2017 10:11:18 +0500
Message-ID: <20170928101118.7c6291e5@natsu>
References: <74846504-299c-1d75-d6e9-8fbe8b603f52@eyal.emu.id.au>
        <f1ba566f-9caf-358b-9815-57f7116750ae@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f1ba566f-9caf-358b-9815-57f7116750ae@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 28 Sep 2017 15:03:23 +1000
Eyal Lebedinsky <eyal@eyal.emu.id.au> wrote:

> > Sep 22 14:59:18 e7 kernel: mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 20, phy 0, sas_addr 0x70944e23a5c4b492
> > Sep 22 14:59:18 e7 kernel: scsi 6:0:0:0: Direct-Access     ATA      WDC WD4003FZEX-0 1A01 PQ: 0 ANSI: 5
> > Sep 22 14:59:18 e7 kernel: sd 6:0:0:0: Attached scsi generic sg2 type 0
> > Sep 22 14:59:18 e7 kernel: sd 6:0:0:0: [sdc] 4294967294 512-byte logical blocks: (2.20 TB/2.00 TiB)
> > Sep 22 14:59:18 e7 kernel: sd 6:0:0:0: [sdc] Write Protect is off
> > Sep 22 14:59:18 e7 kernel: sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> Re-reading the messages I now notice that the disks are identified as
> 	4294967294 512-byte logical blocks: (2.20 TB/2.00 TiB)
> which is wrong (these are 4TB disks, as shown below).
> 
> I guess this controller, being a SATA-II, is not suitable for disks larger that 2TB?

Great catch. These are not interdependent though, it's not 2TB incapable just
because of SATA2. There are SATA2 controllers supporting 2TB+ drives.

But come to think of it, I now remember the monumental article at [1]
warning about the 1068E, "does not support drives larger than 2TB."

[1]
http://blog.zorinaq.com/from-32-to-2-ports-ideal-satasas-controllers-for-zfs-linux-md-ra/

-- 
With respect,
Roman
