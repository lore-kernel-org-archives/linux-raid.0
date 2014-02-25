From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 12:28:12 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1402251224390.747@uplift.swm.pp.se>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se> <530AA09B.3090708@fnarfbargle.com> <530AA460.602@eyal.emu.id.au> <530AAA55.2080508@fnarfbargle.com> <530ABF21.7030200@eyal.emu.id.au> <BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>
 <530BADF2.3090907@eyal.emu.id.au> <20140225141650.56b8dac4@notabene.brown> <530C4D18.4090403@eyal.emu.id.au> <20140225193501.080a8e61@notabene.brown> <530C79AD.2020400@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530C79AD.2020400@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 25 Feb 2014, Eyal Lebedinsky wrote:

> Final thought: if this sector is in an important header, when it *does* 
> need to be read (and fail), how bad a reaction should I expect?

I have two thoughts here:

Check data offset when doing mdadm -E. There you will see how much unused 
data is allocated between the superblock and start of the actual array 
data contents. This might be where your pending block is.

Regarding re-write. I have had happen to me that one drive that had bad 
blocks that "check" didn't find errors on, when I rebooted that drive had 
read errors on the superblock, was not assembled into the array, and 
instead md started rebuilding to a spare since the array was degraded. So 
my wonder is, when issuing "check" or "repair", does md actually check if 
the superblocks are readable? If not, perhaps it should? Should it check 
the contents of the superblocks are consistent with the data that the 
kernel has in its data structures?

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
