From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Thu, 14 Feb 2013 15:39:27 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302141536580.32644@uplift.swm.pp.se>
References: <20130214143149.282820@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130214143149.282820@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Feb 2013, Dragon wrote:

> while nobody is answering i suggest that there is no better way like 
> phil told, or my i wrong?

Have you looked throught the recent archives for all the other threads 
about people prematurely doing --create, and the factors that affect this? 
(data offset, order, superblock version etc)

Please if you have mdadm --examine from before you destroyed the 
original superblocks then that might help.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
