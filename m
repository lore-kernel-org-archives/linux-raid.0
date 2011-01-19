From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: How to force rewrite of a smart detected bad block with raid5:
 checkarray?
Date: Wed, 19 Jan 2011 08:42:53 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1101190842170.13151@uplift.swm.pp.se>
References: <20110119070419.GC31606@merlins.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119070419.GC31606@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 18 Jan 2011, Marc MERLIN wrote:

> Does this actually do what I want? Try all the blocks on each drive and 
> if one block is unreadable, it forces a rewrite on the bad drive using 
> the n-1 other ones to recreate it?

You want to use the "repair" command. This has been discussed numerous 
times and discussions regarding it can be found in the archives.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
