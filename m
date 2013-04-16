From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Use RAID-6!
Date: Tue, 16 Apr 2013 19:09:30 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304161905150.23668@uplift.swm.pp.se>
References: <15345091.8.1366130671716.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15345091.8.1366130671716.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 16 Apr 2013, Roy Sigurd Karlsbakk wrote:

> Also, maybe this should be on an FAQ/RAID tutorial somewhere?

Question is, where should it be put so that people read it and actually 
understand it.

This article is from 2007:

<http://www.zdnet.com/blog/storage/why-raid-5-stops-working-in-2009/162>

I've had people argue with me that the above article is wrong, but I never 
udnerstood their logic. To me it makes perfect sense and I always go 
RAID6.

I also think the work having more than 2 parity drives was very promising. 
I'd rather have a 20 drive volume with 4 parity drives than to LVM 
together two 10 drive RAID6:es (apart from obvious performance penalties).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
