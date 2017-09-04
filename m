From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: future of raid 6
Date: Mon, 4 Sep 2017 14:28:09 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709041425100.29378@uplift.swm.pp.se>
References: <2811558.CnJCJrJZ21@markus> <20170904095347.GA4187@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170904095347.GA4187@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Markus <M4rkusXXL@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Sep 2017, Andreas Klauer wrote:

> Genuine simultaneous drive failures are *very* rare.

No, the "drive failed and I now have URE on another drive" is not "*very 
rare*". Yes, it can be somewhat mitigated by frequent scrubbing.

That's why I run RAID6 and not RAID5. I have been hit by the above problem 
several times when running RAID5. I haven't yet had a data loss event 
(that I know of) because of this since I moved to RAID6.

I think "RAID6 with triple parity" would make sense for some deployment 
scenarios. It's not uncommon for people to have several RAID6 arrays and 
then have a hot spare in the chassis. This hot spare could instead 
actually do work by being triple redundancy in one array, instead of 
sitting there powered on but doing nothing.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
