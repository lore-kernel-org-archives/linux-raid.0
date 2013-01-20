From: Wolfgang Denk <wd@denx.de>
Subject: Re: Suboptimal raid6 linear read speed
Date: Sun, 20 Jan 2013 10:04:26 +0100
Message-ID: <20130120090426.8EE1A200609@gemini.denx.de>
References: <20130115123301.GA11948@rabbit.us> <50F55046.7050605@turmel.org> <20130115125507.GA12184@rabbit.us> <50F614F7.20104@hardwarefreak.com> <20130116025857.GA31112@rabbit.us> <50F70DB7.6020104@hardwarefreak.com> <alpine.DEB.2.00.1301171648260.12098@uplift.swm.pp.se> <50F90857.3010305@hardwarefreak.com> <alpine.DEB.2.00.1301181015270.12098@uplift.swm.pp.se> <50F9D32F.7090606@hardwarefreak.com> <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Mikael Abrahamsson,

In message <alpine.DEB.2.00.1301190838440.12098@uplift.swm.pp.se> you wrote:
> 
> > If my math is correct, with a URE rate of 10E14, that's one URE for 
> > every ~12.5TB read.  So theoretically one would have to read the entire 
> > 2TB drive more than 6 times before hitting the first URE.  So it seems 
> > unlikely that one would hit a URE during a mirror rebuild with such a 
> > 2TB drive.
> 
> Unlikely yes, but it also means one in 6 rebuilds (statistically) will 
> fail with URE. I'm not willing to take that chance, thus I use RAID6.

Me too, as actually it will be probably more than one out of six
failing.  The URE rate as published in the drive's documentation is
only true under specific conditions.  These conditions may not be met
during extended periods of more or less continuous operation of the
drive, like during backups or RAID array rebuilds.

For example, years ago we had repeated cases of double errors taking
down RAID 5 arrays with Maxtor MaXLine Plus II 7Y250M0; the pattern
was always the same: a disk error during a backup run, followed by
another disk error during rebuild.  This specific drive type gets
extremely hot under continuous operaton, which greatly shifts the URE
rate to the worse.  

So even if the failure rate appears to be acceptable in theory, it may
bite you hard when you lose your data in reality.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Alliance: In international politics, the union  of  two  thieves  who
have  their hands so deeply inserted in each other's pocket that they
cannot separately plunder a third.                   - Ambrose Bierce
