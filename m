From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: sw raid0 read bottleneck
Date: Wed, 14 Mar 2007 15:32:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703141524140.23527@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.64.0703131713280.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131248260.29504@p34.internal.lan>
 <Pine.LNX.4.64.0703131815050.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131914360.18749@localhost.localdomain>
 <17911.3814.749745.77134@notabene.brown> <Pine.LNX.4.64.0703131711220.28796@coffee.psychology.mcmaster.ca>
 <45F841CA.8040704@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45F841CA.8040704@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Tomka Gergely <gergely@tomka.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>> 15 drives and 64K chunks gives 960K per stripe.
>>> The raid0 code should set the read-ahead to twice that: 1920K
>>> which I would have thought would be enough, but apparently not.
>> 
>> choosing the RA size should depend in some way on speed, shouldn't it?
>> after all, the goal is to have enough reads queued to avoid a "stall"
>> while un-read-ahead-ed sectors pass under the head.  for a typical
>> 60 MB/s, 7200 rpm disk, a track is .5 MB.  the heuristic above only reads
>> ahead .12 MB... 
>
> While I'm sure you realize it, some reader won't, so I'll point out that a 
> cylinder is all the tracks which can be read without a seek, and cylinder 
> size is track size times number of data heads. If you want max speed you can 
> read that much off a drive at a time...

hmm.  I certainly agree with your terminology, but afaikt, disks only read
from a head at a time.  the last time I saw a vendor quoting head-switch
times, they were within a factor of two one-track seek times, which explains
why a same-family disk with more heads/surfaces shows only slight speedup.

regards, mark hahn.
