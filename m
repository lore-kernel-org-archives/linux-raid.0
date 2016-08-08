From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Raid5 reshape stuck at 0% - SuSE leap 42.1
Date: Mon, 8 Aug 2016 13:40:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1608081339310.3593@uplift.swm.pp.se>
References: <57A69012.1010406@youngman.org.uk> <alpine.DEB.2.02.1608071154110.3593@uplift.swm.pp.se> <57A719CC.6080301@youngman.org.uk> <57A724ED.5070808@youngman.org.uk> <alpine.DEB.2.02.1608071630050.3593@uplift.swm.pp.se> <57A766DC.4000207@youngman.org.uk>
 <alpine.DEB.2.02.1608071923410.3593@uplift.swm.pp.se> <57A776AE.3050308@youngman.org.uk> <alpine.DEB.2.02.1608072002400.3593@uplift.swm.pp.se> <57A7869D.2090203@youngman.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57A7869D.2090203@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 7 Aug 2016, Wols Lists wrote:

> Note that I think this dmesg stuff overlaps with the last lot, namely 
> the start of this is the tail end of the array starting successfully 
> last time.

It helps if you supply output of /proc/mdstat before each operation, and 
also adding verbose output to mdadm command.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
