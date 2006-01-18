From: Brad Campbell <brad@wasp.net.au>
Subject: Re: RAID 1 vs RAID 0
Date: Wed, 18 Jan 2006 12:40:28 +0400
Message-ID: <43CDFEFC.5070109@wasp.net.au>
References: <dqkie5$mf2$3@sea.gmane.org> <Pine.LNX.4.44.0601180228370.2456-100000@coffee.psychology.mcmaster.ca> <dqksi3$mf2$5@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dqksi3$mf2$5@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman wrote:
> 
> Still, it seems like it should be a solvable problem...if you order the 
> data differently on each disk; for example, in the two disk case, 
> putting odd and even numbered 'stripes' on different platters [or sides 
> of platters].
> 

The only problem there is determining the internal geometry of the disk, and knowing that each disk 
is probably different. How do you know which logical sector number correlates to which surface and 
where abouts on the surface? Just thinking about it makes my brain hurt.

Not like the good old days of the old stepper disks.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
