From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: starting an array on Linux, advise needed
Date: Fri, 16 Jan 2004 21:04:42 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401170204.i0H24mi16143@dns1.watkins-home.com>
References: <200401170048.i0H0mO218903@bzs.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401170048.i0H0mO218903@bzs.org>
To: michael@insulin-pumpers.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

raidtab? 
Your sad devotion to that ancient software has not helped you conjure up the
superblocks.

Read:
	man mdadm

I have this line in my mdadm.conf:
	DEVICE /dev/sd[abcdefghijklmnopqrstuvwxyz][12]
It handles the first 2 partitions of the first 26 SCSI disks!
I only have 17 disks, most only have 1 partition, some have 2.


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael
Sent: Friday, January 16, 2004 7:48 PM
To: linux-raid@vger.kernel.org
Subject: Re: starting an array on Linux, advise needed

> Guy wrote:
> > I found this old message, it may help.
> > ======================================
> > http://www.corpit.ru/mjt/mdctl.c - a very small utility similar to
raidtools
> 
> Note it will not work correctly in the situation described.
> Or at least it may not work.  For the same reason as original
> code does not work: "renamed" devices in 2.4 vs 2.6.

<snip>

I've been following this thread for a while and have now become a bit 
confused. What are the implications for an autostart array marked 
'FD' in 2.6 ?? Will it start correctly? hmmm.... I think I missed 
something in the discussion..... How does one specify the raidtab 
under this circumstance if the device names are not stable.

Michael
Michael@Insulin-Pumpers.org
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


