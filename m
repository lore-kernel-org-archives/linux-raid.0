From: Joe Landman <joe.landman@gmail.com>
Subject: Re: Is this expected RAID10 performance?
Date: Sun, 09 Jun 2013 20:05:35 -0400
Message-ID: <51B5184F.9040707@gmail.com>
References: <CAO9HMNHVNQcU=FumFnLRd9b0msMr8fr0z6SmL82dksu+6CNXYA@mail.gmail.com> <51B47088.4000501@redhat.com> <CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAO9HMNHPeXiMmXYtPb29Y2xiOFpznzmP8nBSV09UFCnMrYkEgQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/09/2013 04:06 PM, Steve Bergman wrote:

> Google for "ZFS and zeroes" you surely noticed that many of the

s/ZFS/xfs/

[...]

> Saying that "you can lose data with any filesystem" is true... but
> evasive, and misses the point. One could say that speeding down the

Er ... no.

If you insist upon absolute "guarantees" in *any* file system, then 
mount it with a sync option, so writes don't return until they are 
committed to disk, turn off all write caching on the drive, and turn off 
any other write caching throughout the system.  And if you believe that 
this *guarantees* your data integrity, I'd suggest staying away from 
real estate sales people in Florida.

You have to understand what is *guaranteed* and what is not.  Where bugs 
can hit (yes, bugs in the stack can tank a file system).

You can get corruption *anywhere* along the pathway from CPU to disk. 
Anywhere.  Even with ECC memory, checksums, etc.  Have a good long 
gander at this 
http://www.snia.org/sites/default/files2/SDC2011/presentations/monday/WilliamMartin_Data_Integerity.pdf 
and other articles on T10 DIF.

Understand that file systems do not give you guarantees.

If you must provide a guaranteed non-data lost system, then you need to 
engineer a resilient system below the file system itself.  At the file 
system level, you need to use options which give you the highest 
probability of surviving a data loss event.  Understand that you *will* 
lose data irrespective of what file system you have on there.  Its the 
best practices that you may or may not choose to implement that matter 
here, in terms of how impactful this data loss will be.

If you don't know how to use XFS safely, thats fine.  Its a very good 
file system, I've personally used it since IRIX days (when I was at 
SGI).  Many very large organizations swear by it.  Few would run without 
it.  But if you prefer something else, fine.  Just understand you are 
going to lose data with the other file system as well.  Denying that 
this is possible is not a viable strategy to ameliorate the damage from 
the loss, and fundamentally, your focus should be on risk amelioration 
with respect to your choices, not arguing with the development team over 
your choices.

Now, please, back to your regularly scheduled IO RAID system ...
