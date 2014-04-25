From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Repaired the sectors of a drive, how do I get the md to assemble
 and start degraded?
Date: Fri, 25 Apr 2014 05:31:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404250526310.19744@uplift.swm.pp.se>
References: <53592837.8020406@csun.edu> <alpine.DEB.2.02.1404241923510.19744@uplift.swm.pp.se> <53597309.8070506@csun.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53597309.8070506@csun.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Wiegley <jeffw@csun.edu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 24 Apr 2014, Jeff Wiegley wrote:

> I don't want to simply re-add the failed drives as I believe
> they will start re-syncing won't they? I don't want their data
> lost and overwritten. I want the drive to be treated like it
> never failed in the first place.
>
> I might have some filesystem corruption but not as much as I
> will if the entire drive is resynced.
>
> I also cannot repair the two other dead drives. So I need this
> drive treated as is so that array can come up degraded. Then I
> can get what data I can off it before replacing all drives
> and probably starting fresh.

What do you mean by "repair"?

Well, anyway, if you --assemble --force with all parity drives gone, no 
resync will be done.

As long as you do not use --create, no "bad" information will be synced 
even if you use the previously failed drives. If their even count is way 
off, then --assemble --force might give you a lot more corruption.

But my original point was that if you have a RAID6 with bitmap and two 
drives are kicked out, but they are not dead, it's better to re-add them 
back in, let things re-sync. You then run a "repair" on the volume so you 
try to make sure that any UNC read errors are repaired by md.

Right now, you have no parity and any other UNC sectors will have to be 
written to in order for you to get your data.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
