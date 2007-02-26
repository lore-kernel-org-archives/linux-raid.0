From: Neil Brown <neilb@suse.de>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Mon, 26 Feb 2007 15:36:04 +1100
Message-ID: <17890.25524.465403.130119@notabene.brown>
References: <45DF859B.2050108@eyal.emu.id.au>
	<Pine.LNX.4.64.0702231929380.31611@p34.internal.lan>
	<45DF8DE3.2050903@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Eyal Lebedinsky on Saturday February 24
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Saturday February 24, eyal@eyal.emu.id.au wrote:
> But is this not a good opportunity to repair the bad stripe for a very
> low cost (no complete resync required)?

In this case, 'md' knew nothing about an error.  The SCSI layer
detected something and thought it had fixed it itself.  Nothing for md
to do.

> 
> At time of error we actually know which disk failed and can re-write
> it, something we do not know at resync time, so I assume we always
> write to the parity disk.

md only knows of a 'problem' if the lower level driver reports one.
If it reports a problem for a write request, md will fail the device.
If it reports a problem for a read request, md will try to over-write
correct data on the failed block. 
But if the driver doesn't report the failure, there is nothing md can
do.

When performing a check/repair md looks for consistencies and fixes
the 'arbitrarily'.  For raid5/6, it just 'corrects' the parity.  For
raid1/10, it chooses one block and over-writes the other(s) with it.

Mapping these corrections back to blocks in files in the filesystem is
extremely non-trivial.

NeilBrown
