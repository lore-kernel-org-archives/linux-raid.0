From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Wed, 18 May 2005 08:08:46 -0700
Message-ID: <428B5A7E.2050509@h3c.com>
References: <Pine.LNX.4.44.0505180206580.1777-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0505180206580.1777-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


All colo facilities are required to have a complete power cut-off switch
for fire fighter safety. Its behind the UPS stacks, specifically so that
they know the racks aren't energized before they go in.

Apparently, the big red button that activates this cutoff is an easy
target for people to accidentally lean on or similar, so all power goes
down immediately.

http://www.google.com/search?q=data+corruption+colocation+power+cut+off+write+caching

As an example, the first result there is for wikipedia, which you've
probably heard of ;-)

LiveJournal (another huge site) was also bit by this.

Bottom line is, if you are in a colo, there must be a switch between all
power service and your machines, so you are susceptible

Posted back to linux-raid for general interest. Maybe everyone else
isn't interested, but I'm fascinated by gotchas. I'm sure at least a few
others...

-Mike

Mark Hahn wrote:
>>In particular, drives like to enable write-caching out of the box now,
>>which opens a window for data corruption that has bitten more than a few
>>high-profile sites as it causes the disk to break the fsync contract
> 
> 
> I'm curious for details on which sites and how they broke.
> I can't think of a scenario (except perhaps operating a server
> without UPS) were this would be a problem.  maybe servers 
> that are otherwise in such bad shape that they crash?
