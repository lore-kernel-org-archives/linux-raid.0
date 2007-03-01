From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: swap on raid
Date: Fri, 02 Mar 2007 12:07:40 +1300
Message-ID: <45E75CBC.2050003@sauce.co.nz>
References: <20070301222739.GA4835@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070301222739.GA4835@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Hi,
> 
> I need to use a raid volume for swap, utilizing partitions from 4 
> physical drives I have available. From my experience I have three 
> options - raid5, raid10 with 2 offset chunks, and two raid 1 volumes 
> that are swapon-ed with equal priority. However I have a hard time 

Another option here would be a 4 disk RAID1, on the basis that it's 
giving you a simple, highly redundant setup.

If the performance requirement is such that you need the speed of RAID5, 
10 etc., then you probably need to be looking at adding RAM or otherwise 
avoiding swapping in the first place.

The fact that you mention you are using partitions on disks that 
possibly have other partions doing other things, means raw performance 
will be compromised anyway.

Regards,

Richard
