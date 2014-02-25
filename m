From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: feature re-quest for "re-write"
Date: Tue, 25 Feb 2014 23:32:06 +1100
Message-ID: <530C8D46.3060306@eyal.emu.id.au>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se> <530AA09B.3090708@fnarfbargle.com> <530AA460.602@eyal.emu.id.au> <530AAA55.2080508@fnarfbargle.com> <530ABF21.7030200@eyal.emu.id.au> <BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl> <530BADF2.3090907@eyal.emu.id.au> <20140225141650.56b8dac4@notabene.brown> <530C4D18.4090403@eyal.emu.id.au> <20140225193501.080a8e61@notabene.brown> <530C79AD.2020400@eyal.emu.id.au> <alpine.DEB.2.02.1402251224390.747@uplift.swm.pp.se> <530C8723.9050009@eyal.emu.id.au> <alpine.DEB.2.02.1402251316070.747@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1402251316070.747@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I expect that zeroing (and then recreating the header) will surely write the whole area.
Or I can play really safe and write to the bad sector myself to force the reallocation
while the disk is out.

Eyal


On 02/25/14 23:17, Mikael Abrahamsson wrote:
> On Tue, 25 Feb 2014, Eyal Lebedinsky wrote:
>
>> Or just give up: fail and remove the disk, clear the superblock then add it and go through a full resync. This way feels safer as I do not touch the other members.
>
> I am not sure this will work either. I would expect that the empty data in "data offset" is never touched even when doing rebuild. Perhaps also something that should be done?
>

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
