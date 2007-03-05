From: Tejun Heo <teheo@suse.de>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Mon, 05 Mar 2007 13:00:47 +0900
Message-ID: <45EB95EF.9030702@suse.de>
References: <45DF859B.2050108@eyal.emu.id.au>	<Pine.LNX.4.64.0702231929380.31611@p34.internal.lan>	<45DF8DE3.2050903@eyal.emu.id.au> <17890.25524.465403.130119@notabene.brown> <45E297E5.50303@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45E297E5.50303@eyal.emu.id.au>
Sender: linux-ide-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: Neil Brown <neilb@suse.de>, linux-raid list <linux-raid@vger.kernel.org>, list linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Eyal Lebedinsky wrote:
> I CC'ed linux-ide to see if they think the reported error was really innocent:
> 
> Question: does this error report suggest that a disk could be corrupted?
> 
> This SATA disk is part of an md raid and no error was reported by md.
> 
> [937567.332751] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x4190002 action 0x2
> [937567.354094] ata3.00: cmd b0/d5:01:09:4f:c2/00:00:00:00:00/00 tag 0 cdb 0x0 data 512 in
> [937567.354096]          res 51/04:83:45:00:00/00:00:00:00:00/a0 Emask 0x10 (ATA bus error)

Command 0xb0 is SMART.  The device failed some subcommand of SMART, so,
no, it isn't related to data integrity, but your link is reporting
recovered data transmission error and PHY ready status changed and some
other conditions making libata EH mark the failure as ATA bus error.
Care to post full dmesg?

-- 
tejun
