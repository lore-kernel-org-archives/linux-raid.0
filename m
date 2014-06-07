From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: writing zeros to bad sector results in persistent read error
Date: Fri, 6 Jun 2014 20:26:44 -0500
Message-ID: <CAAMCDedUdgbxWQ7fqrPTeR24UA11Yig3GRRuMkKXUpXy+DyU8w@mail.gmail.com>
References: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B7EA34DA-1064-45B1-B0C0-B7C423C7EB47@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hdparm --write-sector <sectornum>

is the only thing I was ever able to force a rewrite and/or relocate.

That worked on both seagate and wd disks to make the offline test go
past that point (at least until the next bad sector).

I did note that bad sectors appear to come in groups.

On Fri, Jun 6, 2014 at 7:11 PM, Chris Murphy <lists@colorremedies.com> wrote:
> This is a bit off topic as it doesn't involved md raid. But bad sectors are common sources of md raid problems, so I figured I'd post this here.
>
> Summary: Hitachi/HGST Travelstar 5K750. smartctl will not complete an extended offline test, it stops 60% remaining reporting the LBA of the first error. Whether I use dd to read that LBA, or write zeros to it, or to a 1MB block surrounding it, I always get back a read error. Not a write error. I can't get rid of this bad sector. I have used the ATA secure erase command via hdparm and get the same results. Very weird, I'd expect a write error to occur.
>
>
>
> ### This is the entry from smartctl:
> Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed: read failure       60%      1206         430197584
>
> ### Link to the full smartctl -x output
> https://docs.google.com/file/d/0B_2Asp8DGjJ9VmdIZVo4UzdGaEE/edit
>
>
> ###  This is the command I used to try to write zeros over it, and the result:
> # dd if=/dev/zero of=/dev/sda seek=430197584 count=1
> dd: writing to '/dev/sda': Input/output error
> 1+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 3.6149 s, 0.0 kB/s
>
> ### And this is the kernel message that appears as a result:
>
> [15110.142071] ata1.00: exception Emask 0x0 SAct 0x20000 SErr 0x0 action 0x0
> [15110.142079] ata1.00: irq_stat 0x40000008
> [15110.142084] ata1.00: failed command: READ FPDMA QUEUED
> [15110.142092] ata1.00: cmd 60/08:88:50:4b:a4/00:00:19:00:00/40 tag 17 ncq 4096 in
>          res 51/40:08:50:4b:a4/00:00:19:00:00/40 Emask 0x409 (media error) <F>
> [15110.142096] ata1.00: status: { DRDY ERR }
> [15110.142099] ata1.00: error: { UNC }
> [15110.144802] ata1.00: configured for UDMA/133
> [15110.144826] sd 0:0:0:0: [sda] Unhandled sense code
> [15110.144830] sd 0:0:0:0: [sda]
> [15110.144832] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
> [15110.144835] sd 0:0:0:0: [sda]
> [15110.144837] Sense Key : Medium Error [current] [descriptor]
> [15110.144841] Descriptor sense data with sense descriptors (in hex):
> [15110.144843]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
> [15110.144854]         19 a4 4b 50
> [15110.144860] sd 0:0:0:0: [sda]
> [15110.144863] Add. Sense: Unrecovered read error - auto reallocate failed
> [15110.144865] sd 0:0:0:0: [sda] CDB:
> [15110.144867] Read(10): 28 00 19 a4 4b 50 00 00 08 00
> [15110.144892] end_request: I/O error, dev sda, sector 430197584
> [15110.144934] ata1: EH complete
>
> ### This is the complete dmesg
> https://docs.google.com/file/d/0B_2Asp8DGjJ9c3hfelQyTnNoMU0/edit
>
> At first I thought it was because I'm writing one 512 byte logical sector, but this drive has 4096 physical sectors. OK so I write out 8 logical sectors instead, still get a read error. If I do this, to put the bad sector in the middle of a 1MB write:
>
> # dd if=/dev/zero of=/dev/sda seek=430196560 count=2048
> dd: writing to '/dev/sda': Input/output error
> 1025+0 records in
> 1024+0 records out
>
> It stops right at LBA 430197584, again with a read error. So even though the drive SMART health assessment is "pass" and there are no other SMART values below threshold indicating "works as designed" this drive has effectively failed because any write operation to this LBA results in unrecoverable failure.
>
> Anyway I find this confusing and unexpected.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
