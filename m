From: Eamonn Hamilton <eamonn@snifter.org>
Subject: Re: differnet UUIDs and no of spares :(
Date: Wed, 14 Jan 2009 23:15:18 +0000
Message-ID: <1231974918.17710.20.camel@brandy.snifter.org>
References: <1231954002.17710.13.camel@brandy.snifter.org>
	 <496E6C37.9030608@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <496E6C37.9030608@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bill,

> 
> What can you tell us about how that happened? When (if ever) was it 
> running, how was it created, etc, etc.

It was running stably for a long time, with the raid5 being expanded
from 1TB to 2. It recently had two spare drives added to it, and again
was running fine, however  a new kernel on the box provoked some nasty
behaviour with the sata_nv driver.

This left the raid not starting at boot-up, as devmapper had claimed one
of the spares as it's own, so I started the array without that spare,
which provoked a re-sync for reasons I'm not clear on. Having cleared
the devmapper mapping on the other spare, it was added back in as a
spare to the array. 15 minutes into the resync, however, the biox fell
over, whether as a result of the array resync or something else I dont
know, there's nothing suspicious in the logs. Which brings us to where
we are today :(


> 
> You could probably try some things like trying to start it read-only 
> using --force, but don't do that yet, if you get it wrong you WILL be 
> likely to lose data.
> 

I was tempted to change the UUID on the nonstarting members, but the
number of spares being different gave me pause.



