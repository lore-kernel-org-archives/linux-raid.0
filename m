From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Failed RAID 6 array advice
Date: Wed, 2 Mar 2011 06:26:32 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1103020623090.7942@uplift.swm.pp.se>
References: <65522.87245.qm@web55807.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65522.87245.qm@web55807.mail.re3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 1 Mar 2011, jahammonds prost wrote:

> What's the correct process for adding the failed /dev/sde1 back into the 
> array so I can start it. I don't want to rush into this and make things 
> worse.

There are a lot of discussions about this in the archives, but basically I 
recommend the following:

Make sure you're running the latest mdadm, right now it's 3.1.4. Compile 
it yourself if you have to. After that you stop the array and use 
--assemble --force to get the array up and running again with the drives 
you know are good (make sure you don't use the drives that was offlined a 
long time ago).

> What's the correct process for replacing the 2 other drives?
> I am presuming that I need to --fail, then --remove then --add the drives (one
> at a time?), but I want to make sure.

Yes, when you have a working degraded array you just add them and a 
re-sync should happen and then everything should be ok if the resync 
succeeds.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
