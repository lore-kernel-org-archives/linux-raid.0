From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 19:05:24 -0400
Message-ID: <4AE236B4.20103@tmr.com>
References: <818410.23525.qm@web38801.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <818410.23525.qm@web38801.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Warning: I can only be polite and diplomatic to a limited number of 
technically incompetent people each day. Today isn't your day.

adfas asd wrote:
> For those of you who don't follow the list closely, we have gone over this same old ground several times already.
>
> - Of course I know that RAID is not quite as good as backup. 
>   

That's like saying a bicycle is not as good as a frying pan. They are 
totally different things, used for different reasons. A raid array is a 
technique used to improve the performance or reliability of a single 
dynamic copy of data. A backup is an independent copy of the data at 
some point in time, and will continue to exist if the original is 
damaged or destroyed.

Note: a good backup will be off-site to prevent physical destruction. 
One of the few things I liked about running servers for at&t was that 
they actually had a "smoking hole recovery plan" requiring steps to 
recover if the data center was physically destroyed. The only other 
organization I have worked with who had that level of concern was a bank 
in Ireland during "the troubles." My general data will survive loss of 
my office and a two mile radius around it, my critical data will survive 
lose off the continental US. Okay, I may take this too seriously. ;-)
> - Of course I wish that backing up could save many terabytes of data for less than $10,000.  But that is not practical today.
>
>   
Hogwash! You can get an eSATA array tower with four bays from Newegg for 
<$200, 1TB drives for $85/ea on sale (mine are WD 'green' which run 
about 10C cooler than Seagate or Hitachi), and have 3TB RAID-5 for 
~$600, capable of being daisy chained. Choice of built-in or software 
raid. 2TB drives will add about $400, and with an independent copy of 
the filesystem on a box you have backup. For another $400 you can have a 
cheap 2nd system connected by Gbit network and be totally independent.

> Fact:  I have terabytes of data that I want to keep from losing.
> Fact:  Disk drives have never been cheaper.
> Fact:  It is most cost-effective to save terabytes of data on disk drives, if the proper regimen can be determined for safety.
>   

That means backup, sorry, stuff happens if you only have one copy.

> Fact:  After one month's use mdadm RAID has resulted in a failure which could have been catastrophic had I not determined that somehow JFS functionality was destroyed.
> Fact:  Now one of my  arrays has gone into degraded mode for mysterious reasons, and we are so busy arguing about backups that no one can advise on what to do about this.
>
>   
I advise you to go to backup. If you can afford to have "terabytes of 
data" you either live with losing it and just wonder when, or you go to 
real backup.
> --- On Fri, 10/23/09, Mattias Wadenstein <maswan@acc.umu.se> wrote:
>   

Not only don't you understand raid, you don't understand top-posting, 
either...

-- 
Bill Davidsen <davidsen@tmr.com>
  Unintended results are the well-earned reward for incompetence.

