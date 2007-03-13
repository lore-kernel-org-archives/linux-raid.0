From: Mark Hahn <hahn@mcmaster.ca>
Subject: Re: sw raid0 read bottleneck
Date: Tue, 13 Mar 2007 17:29:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0703131711220.28796@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.64.0703131713280.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131248260.29504@p34.internal.lan>
 <Pine.LNX.4.64.0703131815050.18749@localhost.localdomain>
 <Pine.LNX.4.64.0703131914360.18749@localhost.localdomain>
 <17911.3814.749745.77134@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17911.3814.749745.77134@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Tomka Gergely <gergely@tomka.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 15 drives and 64K chunks gives 960K per stripe.
> The raid0 code should set the read-ahead to twice that: 1920K
> which I would have thought would be enough, but apparently not.

choosing the RA size should depend in some way on speed, shouldn't it?
after all, the goal is to have enough reads queued to avoid a "stall"
while un-read-ahead-ed sectors pass under the head.  for a typical
60 MB/s, 7200 rpm disk, a track is .5 MB.  the heuristic above only reads
ahead .12 MB...

regards, mark hahn.
