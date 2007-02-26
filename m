From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Mon, 26 Feb 2007 19:18:45 +1100
Message-ID: <45E297E5.50303@eyal.emu.id.au>
References: <45DF859B.2050108@eyal.emu.id.au>	<Pine.LNX.4.64.0702231929380.31611@p34.internal.lan>	<45DF8DE3.2050903@eyal.emu.id.au> <17890.25524.465403.130119@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <17890.25524.465403.130119@notabene.brown>
Sender: linux-ide-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid list <linux-raid@vger.kernel.org>, list linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

I CC'ed linux-ide to see if they think the reported error was really innocent:

Question: does this error report suggest that a disk could be corrupted?

This SATA disk is part of an md raid and no error was reported by md.

[937567.332751] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x4190002 action 0x2
[937567.354094] ata3.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 512 in
[937567.354096]          res 51/04:83:45:00:00/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)
[937568.120783] ata3: soft resetting port
[937568.282450] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[937568.306693] ata3.00: configured for UDMA/100
[937568.319733] ata3: EH complete
[937568.361223] SCSI device sdc: 625142448 512-byte hdwr sectors (320073 MB)
[937568.397207] sdc: Write Protect is off
[937568.408620] sdc: Mode Sense: 00 3a 00 00
[937568.453522] SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA

Neil Brown wrote:
> On Saturday February 24, eyal@eyal.emu.id.au wrote:
> 
>>But is this not a good opportunity to repair the bad stripe for a very
>>low cost (no complete resync required)?
> 
> 
> In this case, 'md' knew nothing about an error.  The SCSI layer
> detected something and thought it had fixed it itself.  Nothing for md
> to do.

I expected this. So either the scsi layer incorrectly held back the error
report of the mismatch_cnt is due to something unrelated to the disk
i/o failure.

>>At time of error we actually know which disk failed and can re-write
>>it, something we do not know at resync time, so I assume we always
>>write to the parity disk.

Again, as I expected, resync cannot correct a problem, effectively
"blaming" the parity block. To know which block to correct one needs
a higher level parity code (can raid6 correct single bit/disk read
errors?).

> md only knows of a 'problem' if the lower level driver reports one.
> If it reports a problem for a write request, md will fail the device.
> If it reports a problem for a read request, md will try to over-write
> correct data on the failed block. 
> But if the driver doesn't report the failure, there is nothing md can
> do.
> 
> When performing a check/repair md looks for consistencies and fixes
> the 'arbitrarily'.  For raid5/6, it just 'corrects' the parity.  For
> raid1/10, it chooses one block and over-writes the other(s) with it.
> 
> Mapping these corrections back to blocks in files in the filesystem is
> extremely non-trivial.
> 
> NeilBrown

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au) <http://samba.org/eyal/>
	attach .zip as .dat
