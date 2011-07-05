From: NeilBrown <neilb@suse.de>
Subject: Re: possible bug in md
Date: Tue, 5 Jul 2011 10:24:19 +1000
Message-ID: <20110705102419.5f2b22fa@notabene.brown>
References: <4E11E9A6.2000606@cdf.toronto.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E11E9A6.2000606@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Iordan Iordanov <iordan@cdf.toronto.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 04 Jul 2011 12:26:14 -0400 Iordan Iordanov <iordan@cdf.toronto.edu>
wrote:

> Hi,
> 
> I was doing some testing with an Ubuntu 10.04 installation (Linux 
> 2.6.32, so my apologies if this has been noted and dealt with already), 
> and I noticed what I think may be a bug.
> 
> I had a system with RAID10, layout n2, where /dev/sda is one of the 
> devices, and the other is "missing". I wanted to add /dev/sdb to the 
> RAID10 array. Both drives are on their last legs (bad sectors and 
> stuff), and I was just doing a proof of concept for a guide I was 
> writing, so I didn't care.
> 
> Here are the relevant dmesg messages for the drives detected:
> ====================================================
> ata1.00: ATA-5: IC35L040AVER07-0, ER4OA44A, max UDMA/100
> ata1.00: 80418240 sectors, multi 16: LBA
> ata1.01: ATA-6: Maxtor 94610H6, BAC51KJ0, max UDMA/100
> ata1.01: 90045648 sectors, multi 16: LBA
> ====================================================
> 
> On the system, ata1.00 is an IBM drive (/dev/sda), and ata1.01 is a 
> Maxtor drive (/dev/sdb). I have RAID10 (/dev/md0) on ata1.00 (/dev/sda) 
> and one "missing" device. I added the Maxtor (ata1.01, /dev/sdb), and 
> during the sync, an error occurred on ata1.00, which is the first disk 
> of the RAID10 array (the IBM, /dev/sda). However, mdadm wrongly reports 
> that an error has occurred on the device I had just ADDED (the Maxtor):
> 
> ====================================================
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata1.00: BMDMA stat 0x65
> ata1.00: failed command: READ DMA
> ata1.00: cmd c8/00:00:00:e5:7b/00:00:00:00:00/e2 tag 0 dma 131072 in
>           res 51/40:39:c7:e5:7b/00:00:00:00:00/e2 Emask 0x9 (media error)
> ata1.00: status: { DRDY ERR }
> ata1.00: error: { UNC }
> ata1.00: configured for UDMA/100
> ata1.01: configured for UDMA/100
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> ata1.00: BMDMA stat 0x65
> ata1.00: failed command: READ DMA
> ata1.00: cmd c8/00:00:00:e5:7b/00:00:00:00:00/e2 tag 0 dma 131072 in
>           res 51/40:39:c7:e5:7b/00:00:00:00:00/e2 Emask 0x9 (media error)
> ata1.00: status: { DRDY ERR }
> ata1.00: error: { UNC }
> ata1.00: configured for UDMA/100
> ata1.01: configured for UDMA/100
> sd 0:0:0:0: [sda] Unhandled sense code
> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> sd 0:0:0:0: [sda] Sense Key : Medium Error [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
>          72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
>          02 7b e5 c7
> sd 0:0:0:0: [sda] Add. Sense: Unrecovered read error - auto reallocate 
> failed
> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 02 7b e5 00 00 01 00 00
> end_request: I/O error, dev sda, sector 41674183
> ata1: EH complete
> md: md0: recovery done.
> raid10: Disk failure on sdb, disabling device.
> raid10: Operation continuing on 1 devices.
> RAID10 conf printout:
>   --- wd:1 rd:2
>   disk 0, wo:0, o:1, dev:sda
>   disk 1, wo:1, o:0, dev:sdb
> RAID10 conf printout:
>   --- wd:1 rd:2
>   disk 0, wo:0, o:1, dev:sda
> ====================================================
> 
> The relevant lines are the ones that show the errors on ata1.00 (the 
> IBM), and then the line which reports disk failure on /dev/sdb (ata1.01):
> 
> raid10: Disk failure on sdb, disabling device.
> 
> Sincerely,
> Iordan Iordanov

Thanks for the report.

md/raid10 is behaving 'correctly' here though I agree that it is a bit
confusing.

When raid10 handles the error on sda it notes that sda is the only device so
removing from the array would not to anyone any good so it just passes the
read error up.
The recovery process then gets to handle the read response which it would
normally do by writing the data to the spare.  However as there is no data to
write it just pretends that the write attempt failed so the spare gets
removed from the array.
This is correct in that the spare should be removed from the array as there
is nothing else useful that can be done.  It is possibly not ideal in that
the spare gets marked as 'faulty' where it isn't really.
I should probably fix that.

But mostly it is doing the 'right' thing.

Thanks,
NeilBrown
