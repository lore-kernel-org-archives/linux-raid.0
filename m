From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 09:56:12 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1304170952280.23668@uplift.swm.pp.se>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <alpine.DEB.2.00.1304161905150.23668@uplift.swm.pp.se> <516DAE0E.5080209@hesbynett.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DAE0E.5080209@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 16 Apr 2013, David Brown wrote:

> you are going to have terrible RMW performance for small writes.  However, as

As I said, I don't have problem with lower performance. My workload is 
write once and few, read many. If the performance is approximately the 
approximately the same as a 10 drive RAID-6, but with double the storage, 
I'm fine.

> I am not sure there is much real-world need of triple parity raid for 
> normal arrays - even with better cpu scaling, it would still be a lot 
> slower than two raid6 arrays LVM'ed together.  I foresee it's main use 
> as a temporary measure during array maintenance.  For example, if you 
> have a raid6 and you want to swap out the drives for bigger ones, then 
> you could temporarily add an extra drive for a third parity using a 
> non-symmetrical layout.  Once this extra drive is synced, then you can 
> step through the other drives doing a replace-and-resync, knowing that 
> you still have the double parity safety. Then at the end of the process 
> you drop the third parity again.

Well, I run RAID6+spare. I'd rather run a triple parity drive unless the 
write performance penalty is huge.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
