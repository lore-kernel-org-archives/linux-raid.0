From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 18:58:29 -0600
Message-ID: <4D475AB5.10600@hardwarefreak.com>
References: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>	<AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com>	<20110131192858.GD27952@www2.open-std.org>	<4D4718E1.9040607@hardwarefreak.com>	<20110131203725.GB2283@www2.open-std.org>	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ
 @mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, =?UTF-8?B?S2VsZCBKw7hybiBTaW1vbnNlbg==?= <keld@keldix.com>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jon Nelson put forth on 1/31/2011 3:27 PM:
> Before this goes any further, why not just reference the excellent
> Wikipedia article (actually, excellent applies to both Wikipedia *and*
> the article):
> 
> http://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10
> 
> The only problem I have with the wikipedia article is the assertion
> that Linux MD RAID 10 is non-standard. It's as standard as anything
> else is in this world.

Unfortunately there is no organization, no standards body, that defines RAID
levels.  The use of the word "standard" in the article means "de facto"
standard.  All of the major and lesser expansion slot card and external RAID
controller vendors have been using the same RAID level terminology for two
decades.  In this case, some have used "RAID 10" while others have used "RAID
1+0" for the same algorithm.  Some used to use "RAID 10" and switched to using
"RAID 1+0" recently o avoid perceived confusion in the marketplace.  NONE of
them include a RAID "10" or "1+0" implementation that works with only 3 disks,
or even 2 disks.  In the hardware industry, RAID "10" or "1+0" always means a
stripe of mirrored pairs, 4 drives (devices) being the minimum required.  I
believe the "non standard" description is right on the money though because
Linux mdraid is the only software/hardware solution that offers these other
"layouts".

The reason I disdain these multiple layouts has nothing to do with their
technical merit, but the fact that it's almost impossible to discuss some things
because we don't know what the heck each other are talking about.  An OP may say
"RAID 10" on this list, but is actually referring to one of the layouts that
isn't the classic striped mirrors.  Such as when discussing how many drives can
fail and you're still up and running.  That is well defined for traditional RAID
10, but not so well, at least from my perspective, for these "non standard" RAID
10 layouts.

-- 
Stan

