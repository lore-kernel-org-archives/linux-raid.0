From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: Good news / bad news - The joys of RAID
Date: Fri, 26 Nov 2004 22:41:53 +0000
Message-ID: <41A7B131.3090506@robinbowes.com>
References: <04Nov26.172857est.30052@gpu.utcc.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <04Nov26.172857est.30052@gpu.utcc.utoronto.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Siebenmann <cks@utcc.utoronto.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Siebenmann wrote:
> You write:
> | Thinking about what happened, I would have expected that the bad
> | drive would just be removed from the array and spare activated and
> | re-syncing started automatically.
> 
>  This is what is supposed to happen; when the hardware winds are blowing
> in the right direction and the software recognizes everything, it even
> really does happen.

Chris,

I suspect that what happened is that the array was in the process of 
re-syncing when I powered off the box because it had frozen because of 
an ATA timeout error.

When I re-booted, the RAID1 root partition was dirty and wouldn't 
re-sync while the RAID 5 array was re-syncing.

Whatever, I got it back up and running by disconnecting the failed drive.

Cheers,

R.
-- 
http://robinbowes.com
