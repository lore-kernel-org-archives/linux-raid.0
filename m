From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: sw raid0 read bottleneck
Date: Wed, 14 Mar 2007 13:41:14 -0500
Message-ID: <45F841CA.8040704@tmr.com>
References: <Pine.LNX.4.64.0703131713280.18749@localhost.localdomain> <Pine.LNX.4.64.0703131248260.29504@p34.internal.lan> <Pine.LNX.4.64.0703131815050.18749@localhost.localdomain> <Pine.LNX.4.64.0703131914360.18749@localhost.localdomain> <17911.3814.749745.77134@notabene.brown> <Pine.LNX.4.64.0703131711220.28796@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703131711220.28796@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@mcmaster.ca>
Cc: Neil Brown <neilb@suse.de>, Tomka Gergely <gergely@tomka.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark Hahn wrote:
>> 15 drives and 64K chunks gives 960K per stripe.
>> The raid0 code should set the read-ahead to twice that: 1920K
>> which I would have thought would be enough, but apparently not.
>
> choosing the RA size should depend in some way on speed, shouldn't it?
> after all, the goal is to have enough reads queued to avoid a "stall"
> while un-read-ahead-ed sectors pass under the head.  for a typical
> 60 MB/s, 7200 rpm disk, a track is .5 MB.  the heuristic above only reads
> ahead .12 MB... 

While I'm sure you realize it, some reader won't, so I'll point out that 
a cylinder is all the tracks which can be read without a seek, and 
cylinder size is track size times number of data heads. If you want max 
speed you can read that much off a drive at a time...

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

