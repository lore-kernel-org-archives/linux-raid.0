From: "David Lethe" <david@santools.com>
Subject: Re: Performance question
Date: Sat, 17 Jan 2009 12:11:00 -0600
Message-ID: <2f8901c978ce$f6cb6bde$3d01a8c0@exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

All we know is that you use 2 disks and md.  This is like posting to a TCP/IP architecture group and saying you have a network connection and want performance advice.   Read up, supply full config info, run benchmarks, then ask specific questions.  GI=GO.
-----Original Message-----

From:  "Piergiorgio Sartor" <piergiorgio.sartor@nexgo.de>
Subj:  Performance question
Date:  Sat Jan 17, 2009 11:18 am
Size:  874 bytes
To:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

Hi all, 
 
I'll have to setup some machines with two HDs (each) 
in order to get some redundancy. 
 
Reading the MD features I noticed there are several 
possibilities to create a mirror. 
I was wondering which one offer the best perfomances 
and/or what are the compromises to accept between 
the different solutions. 
 
One possibility is a classic RAID-1 mirror. 
Another is a RAID-10 far. 
There would also be the RAID-10 near, but I guess 
this is equivalent to RAID-1. 
 
Any suggestion on which method offers higher "speed"? 
Or there are other possibilities with 2 HDs (keeping 
the redundancy, of course)? 
 
Thanks a lot in advance, 
 
bye, 
 
--  
 
piergiorgio 
-- 
To unsubscribe from this list: send the line "unsubscribe linux-raid" in 
the body of a message to majordomo@vger.kernel.org 
More majordomo info at  http://vger.kernel.org/majordomo-info.html 
 


