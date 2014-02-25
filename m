From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 01:05:35 -0600
Message-ID: <530C40BF.2070907@hardwarefreak.com>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>	<530AA09B.3090708@fnarfbargle.com>	<530AA460.602@eyal.emu.id.au>	<530AAA55.2080508@fnarfbargle.com>	<530ABF21.7030200@eyal.emu.id.au>	<BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>	<530BADF2.3090907@eyal.emu.id.au> <20140225141650.56b8dac4@notabene.brown> <530C3119.6030308@eyal.emu.id.au>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530C3119.6030308@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 2/24/2014 11:58 PM, Eyal Lebedinsky wrote:
...
> (*) I run a check action by setting sync_min/sync_max/sync_action
> to cover the bad sector. However, just to be sure, I allowed an overnight
> full check which also ran clean. The bad sector is still pending.

What is the expected behavior when the drive's spare sector pool has
been exhausted, and thus the sector cannot be remapped by the drive
firmware?

Unless md now keeps a spare sector pool of its own and remaps bad
sectors, the only way to fix this situation is to replace the drive.
And if indeed drive spare pool exhaustion is the cause of the sector not
being remapped, the drive needs to be replaced.

-- 
Stan
