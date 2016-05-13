From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: recovering failed and unrecognizable RAID5 during mdadm --grow
 without backup
Date: Fri, 13 May 2016 16:39:23 +0200
Message-ID: <20160513143923.GA23787@EIS.leimen.priv>
References: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
 <5734D23D.6030400@turmel.org>
 <f06998d6-8e1e-c8ea-a22c-1307935092c3@misalpina.net>
 <5734E637.6030307@turmel.org>
 <7cf56631-7909-6a92-f0b2-05dd02722ee8@misalpina.net>
 <5735DF05.8080706@turmel.org>
 <5735E07F.2030802@turmel.org>
 <3b4ae5f5-af19-744b-cab3-aad317ea3a82@misalpina.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3b4ae5f5-af19-744b-cab3-aad317ea3a82@misalpina.net>
Sender: linux-raid-owner@vger.kernel.org
To: Claudiu Rad-Lohanel <jazzman@misalpina.net>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 13, 2016 at 05:26:02PM +0300, Claudiu Rad-Lohanel wrote:
> 1. i can't find any documentation anywhere about the --revert-reshape 
> option. how should the command look like? is it available in v3.3.2?

IIRC it's --assemble --update=revert-reshape and it's not mentioned 
in the man page...
 
> 2. is it safe?

Theoretically...
You could do this with overlays.

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

That's what I'd also recommend when running fsck... 
all of these things write on your disks without providing an undo function.

Regards
Andreas Klauer
