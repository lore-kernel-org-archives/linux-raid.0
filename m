From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Repaired the sectors of a drive, how do I get the md to assemble
 and start degraded?
Date: Thu, 24 Apr 2014 19:27:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404241923510.19744@uplift.swm.pp.se>
References: <53592837.8020406@csun.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53592837.8020406@csun.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Wiegley <jeffw@csun.edu>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 24 Apr 2014, Jeff Wiegley wrote:

> How do I do this? how do I specify a command to take these 15 drives, 
> mark two of them failed and force the assembly and start of the 
> remaining 13 good drives (though one has probably been marked as failed 
> in the past?)

Try to use --assemble with all working drives (not the failed ones). If it 
doesn't work, add --force. Do not use --create --assume-clean unless you 
really really know what you're doing. If you go down that route, first 
make sure you do mdadm --examine on all devices so you know what the 
superblocks contained before you erase them (which is what --create will 
do).

Did you try to re-add the failed drives initially? If you had been using a 
bitmap, they might have come online and successfully added, and then you 
could have run md repair and avoided data loss altogether.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
