From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: failed raid re-create changed dev size
Date: Tue, 11 Dec 2012 09:15:52 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212110912470.17599@uplift.swm.pp.se>
References: <1355182639.50c6722fe15b2@mail.inbox.lv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1355182639.50c6722fe15b2@mail.inbox.lv>
Sender: linux-raid-owner@vger.kernel.org
To: Andris Berzins <pkix@inbox.lv>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 11 Dec 2012, Andris Berzins wrote:

> I found on internet that this can be fixed if I re-create raid with the same configuration, but with dead drive set as 'missing'.

This is extremely dangerous. You would have been better off by first 
trying --assemble --force.

> However, I can not mount md1 and looks like it contains random data. The 
> order is correct. However, I noticed that new raid device size is 
> different from old one.

Your data offset is different, most likely you're not using the same mdadm 
version as was initially used to create the raid. Mdadm defaults have 
changed over time regarding chink size, data offset and others.

I don't know off the top of my head how to change the mdadm data offset 
unfortunately.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
