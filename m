From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Recommendations for supported 4-port SATA PCI card ?
Date: Fri, 31 Mar 2006 05:29:44 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0603310522500.7170@chaos.egr.duke.edu>
References: <Pine.LNX.4.44.0603302227150.18644-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0603302227150.18644-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 Mar 2006 at 10:38pm, Mark Hahn wrote

> before the 9550, I never found attractive in price/performance:
> expensive as hell and a lot slower than MD.  but the 9550 is really
> quite impressive...

I like the 3wares for their ability to do true hot swap in hardware RAID 
mode.  I have 2 older servers with 7500 cards in 'em that I recently tried 
to migrate to md (for speed, as you mentioned).  All my testing with 
'mdadm --fail' went just fine.  However, when a disk actually died and the 
3ware booted it, the server hung.  So I migrated 'em back to hardware 
RAID (but RAID10 instead of RAID5).

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
