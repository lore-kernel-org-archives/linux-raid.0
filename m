From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software based SATA RAID-5 expandable arrays?
Date: Sat, 14 Jul 2007 11:49:10 -0400
Message-ID: <4698F076.7080507@tmr.com>
References: <920282231.1184166214119.JavaMail.root@gateway.korstad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <920282231.1184166214119.JavaMail.root@gateway.korstad.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Korstad <dan@korstad.net>
Cc: gmitch64@yahoo.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Daniel Korstad wrote:
>   
> That was true up to kernel 2.6.21 and 2.6 mdadm where support for RAID 6 reshape arrived.
>  
> I have reshaped (added additional drives) to my RAID 6 twice now with no problems in the past few months.
>  
> You mentioned that as the only disadvantage.  There are other things to consider.  The overhead for parity of course.  You can't have a RAID 6 with only three drives unless you build it with a missing drive and run degraded.  Also (my opinion) it might not worth the overhead with only 4 drives, unless you plan to reshape (add drives) down the road.  When you have an array with several drives, than it is more advantages as the percentage of disk space lost to parity goes down [((2/N)*100) where N is the number of drives in the array] so your storage efficiency increases ((Number of Drives -2)/Number of Drives).  And with more drives the statistics of getting hit with a bit error after you lose a drive and you are trying to rebuild increases.
>  
> Also, there is a very slight performance drop for write speeds on RAID6 since you are calculating p and q parity. 
>
>   
I would expect (and see) a fairly substantial drop in write performance. 
With RAID-5 only the parity needs to be read on a data change, and the 
old data chunk. Then several XORs are done and the new data and new 
parity written. With RAID-6, I believe that all the data in the stripe 
need be read for calculating the q parity.
> But for what I use my system for, family digital photos, file storage and media server I mostly read data and not bothered with slight performance hit in write.
>  
> I have been using RAID6 with 10 disk for over a year and it has saved me at least once.  
>  
> As far as converting the RAID6 to RAID5 or RAID4...  Never had a need to do this, but no probably not.
Agree, for many things the write performance is not an issue, while the 
reliability is. Backups are still desirable, of course.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

