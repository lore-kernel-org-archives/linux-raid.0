From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Debian: how do I determine if RAID is working?
Date: Fri, 30 Apr 2004 07:37:25 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404300736240.26077@chaos.egr.duke.edu>
References: <JIEJLHEJOHJGIPFPDNJKEEHFDGAA.s@dondley.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <JIEJLHEJOHJGIPFPDNJKEEHFDGAA.s@dondley.com>
To: Steve Dondley <s@dondley.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 30 Apr 2004 at 1:47am, Steve Dondley wrote

> According to dmesg, the driver that I configured into my kernel for my 3ware
> 7000 series controller card gets installed at boot time with no errors.
> That's nice, but aside from disconnecting one of the hard drives, how can I
> verify my RAID configuration is working?
> 
> I'm running Debian (woody) kernel 2.4.18, raid 1 configuration on two
> ATA/IDE hard drives.

Are you using software or hardware RAID?  If software, the commands were 
already posted.  If hardware, you can install either 3dm or the CLI 
utilities from 3ware to monitor the array.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
