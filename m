From: "Marc" <linux-raid@liquid-nexus.net>
Subject: Re: Debian: how do I determine if RAID is working?
Date: Fri, 30 Apr 2004 16:25:11 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040430082512.M46074@liquid-nexus.net>
References: <JIEJLHEJOHJGIPFPDNJKEEHFDGAA.s@dondley.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <JIEJLHEJOHJGIPFPDNJKEEHFDGAA.s@dondley.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mdadm has a few options for examining the configuration/status of arrays. 

You can also 'cat /proc/mdstat' for a quick look at your raid array's 
status..

--


---------- Original Message -----------
From: "Steve Dondley" <s@dondley.com>
To: <linux-raid@vger.kernel.org>
Sent: Fri, 30 Apr 2004 01:47:58 -0400
Subject: Debian: how do I determine if RAID is working?

> According to dmesg, the driver that I configured into my kernel for 
> my 3ware 7000 series controller card gets installed at boot time 
> with no errors. That's nice, but aside from disconnecting one of the 
> hard drives, how can I verify my RAID configuration is working?
> 
> I'm running Debian (woody) kernel 2.4.18, raid 1 configuration on two
> ATA/IDE hard drives.
> 
> Thanks!
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

