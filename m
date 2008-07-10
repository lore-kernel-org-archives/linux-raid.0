From: CaT <cat@zip.com.au>
Subject: Re: Can't recover half of a raid1
Date: Fri, 11 Jul 2008 09:13:51 +1000
Message-ID: <20080710231351.GC2903@zip.com.au>
References: <alpine.LRH.1.10.0807100956020.4684@skippy.fini.net> <20080710142034.GB2903@zip.com.au> <alpine.LRH.1.10.0807101044320.4684@skippy.fini.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.10.0807101044320.4684@skippy.fini.net>
Sender: linux-raid-owner@vger.kernel.org
To: Christopher Hicks <chicks@chicks.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 10, 2008 at 10:45:23AM -0400, Christopher Hicks wrote:
> On Fri, 11 Jul 2008, CaT wrote:
> >On Thu, Jul 10, 2008 at 10:00:05AM -0400, Christopher Hicks wrote:
> >>We had a drive die in a RAID1 array.  I've tried to bring it back so we
> >...
> >>     Raid Level : raid0
> >
> >These two things seem to contradict...
> 
> Oh no.  I don't suppose there's any chance that mdadm is wrong about what 
> RAID level that chunk was at.

I don't know to be honest. There are two possibilities as far as I can
see:

1. it is a raid 1 array so you might try creating it as raid 1 with a
drive missing and seeing if there's a valid filesystem there. don't know
if this will destroy useful data though.
2. you only think you had a raid1 array, in which case you're probably
screwed as the data would be interleved between the two drives.

-- 
  "Police noticed some rustling sounds from Linn's bottom area
  and on closer inspection a roll of cash was found protruding
  from Linn's anus, the full amount of cash taken in the robbery."
    - http://www.smh.com.au/news/world/robber-hides-loot-up-his-booty/2008/05/09/1210131248617.html
