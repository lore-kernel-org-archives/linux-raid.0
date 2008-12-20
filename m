From: "David Lethe" <david@santools.com>
Subject: RE: Read errors and SMART tests
Date: Fri, 19 Dec 2008 22:13:14 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C031B1B62@34093-C3-EVS3.exchange.rackspace.com>
References: <20081220013043.GM1749@cubit>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <20081220013043.GM1749@cubit>
Sender: linux-raid-owner@vger.kernel.org
To: Kevin Shanahan <kmshanah@disenchant.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Kevin Shanahan
> Sent: Friday, December 19, 2008 7:31 PM
> To: linux-raid@vger.kernel.org
> Subject: Read errors and SMART tests
> 
> Hi,
> 
> Just a quick question about SMART tests :-
> 
> I have a Samsung drive returning read errors, e.g.:
> 
> Dec 20 08:59:24 hermes kernel: ata4.00: exception Emask 0x0 SAct 0x1
> SErr 0x0 action 0x0
> Dec 20 08:59:24 hermes kernel: ata4.00: irq_stat 0x40000008
> Dec 20 08:59:24 hermes kernel: ata4.00: cmd
> 60/80:00:3f:0e:50/00:00:24:00:00/40 tag 0 ncq 65536 in
> Dec 20 08:59:24 hermes kernel:          res
> 41/40:00:61:0e:50/00:00:24:00:00/40 Emask 0x409 (media error) <F>
> Dec 20 08:59:24 hermes kernel: ata4.00: status: { DRDY ERR }
> Dec 20 08:59:24 hermes kernel: ata4.00: error: { UNC }
> Dec 20 08:59:24 hermes kernel: ata4.00: configured for UDMA/133
> Dec 20 08:59:24 hermes kernel: ata4: EH complete
> Dec 20 08:59:24 hermes kernel: sd 3:0:0:0: [sdd] 1953525168 512-byte
> hardware sectors (1000205 MB)
> Dec 20 08:59:24 hermes kernel: sd 3:0:0:0: [sdd] Write Protect is off
> Dec 20 08:59:24 hermes kernel: sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00
> 00
> Dec 20 08:59:24 hermes kernel: sd 3:0:0:0: [sdd] Write cache: enabled,
> read cache: enabled, doesn't support DPO or FUA
> 
> So, I ran the short (and long) selftest and it showed read
> failures. Then I put in a new drive to replace it and ran the short
> selftest again - this one is showing read errors also:
> 
> === START OF READ SMART DATA SECTION ===
> SMART Self-test log structure revision number 0
> Warning: ATA Specification requires self-test log structure revision
> number = 1
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Short offline       Completed: read failure       20%      2572
> 294961
> # 2  Short offline       Aborted by host               20%      2572
> -
> 
> I'm guessing this is just bad luck, i.e. drives from the same bad
> batch. Erm, so my question - Am I right in assuming that the SMART
> self test is not influenced in any way by bad cables, etc.? If the
> drive returns read errors on it's self-test the error is within the
> drive itself, right?
> 
> Thanks,
> Kevin.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This shows nothing more than you having a single bad block.  You have a
1TB drive, for crying
out loud, they can't all stay perfect ;)

This is no reason to assume the disk is bad, or that it has anything to
do with cabling.   When you wrote you have 
read "errors" .. does that mean you have dozens, hundreds of individual
unreadable blocks, or 
could you just have just this one bad block.

Why not use dd to do raw reads from /dev/sdd, send output to /dev/null,
and start at the next LBA, if dd
has another read error, it will tell you, then repeat process and go on.
I am assuming you aren't using
any software RAID1/5/6, so just fix the bad blocks by using dd to write
/dev/zero to the bad block(s).

When you write to the block the disk will either map a reserved block to
it, or just correct the ECC w/o remapping. It depends on root cause and
more details that you can't get without running some more sophisticated
software.

David


