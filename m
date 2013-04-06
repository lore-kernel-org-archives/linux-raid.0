From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Help, array corrupted after clean shutdown.
Date: Sat, 6 Apr 2013 13:58:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304061354170.23668@uplift.swm.pp.se>
References: <5160060B.8020603@schinagl.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5160060B.8020603@schinagl.nl>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 6 Apr 2013, Oliver Schinagl wrote:

> All that said when I did the assemble with the 'guessed' 3 correct drives. 
> Did of course increase the events count. sdc1 of course didn't partake in 
> this. Assuming that it is in sync with the rest, what is the worst that can 
> happen? And does the --read-only flag protect against it?

> /dev/sdc1:
>    Update Time : Sat Mar 16 20:20:47 2013
>       Checksum : a7686a57 - correct
>         Events : 180132

As you probably already know, using sdc1 will mean you'll be playing with 
part of the array that is out of date by 3 weeks (this update time 
indicates that sdc1 fell out on Mar 16).

So I would definitely stay away from sdc1. It seems you have made a lot of 
changes lately (your create time is in 2010 and on Mar 16 2013 you were up 
to 180k events, and then now three weeks later the rest of the drives are 
at 513k events, that seems like a of writes has been done to the array the 
past tree weeks?).

So sdc1 is definitely not in sync according to this information. Using it 
is risky, but as a last resort, sure.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
