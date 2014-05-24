From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Seeking help fixing a failed array
Date: Sat, 24 May 2014 11:39:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1405241137470.29282@uplift.swm.pp.se>
References: <CAGcAkBKnp8J5zGuwgVv98zMrDLVPZWAi57rqpgLW6VByAcm94g@mail.gmail.com> <alpine.DEB.2.02.1405241129020.29282@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1405241129020.29282@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Marnitz Gray <marnitz@xdesigns.co.za>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 24 May 2014, Mikael Abrahamsson wrote:

> Your output seems to indicate that you have one drive with an event 
> count that is 6 events off the others. This most likely means it's safe 
> to use --assemble --force in order to make this get accepted.

Actually, it seems you have two drives with event counts that are off, one 
more than the other. Make sure you only add the drives with the highest 
event count, then add the last drive later so it gets sync:ed from the 
other drives. The event count isn't that much off (I believe it was 40 
events) even on the most differing one, so even with that your filesystem 
shouldn't be too much at risk.

Until you have everything under control I wouldn't write the filesystem 
read/write though, to avoid further problems...

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
