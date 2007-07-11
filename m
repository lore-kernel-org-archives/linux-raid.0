From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re:   Software based SATA RAID-5 expandable arrays?
Date: Wed, 11 Jul 2007 18:26:14 +0100 (BST)
Message-ID: <745823.56492.qm@web55802.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Korstad <dan@korstad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ahh... guess it's time to upgrade again.... My plan was to start off with 3 drives in a RAID5, and slowly grow it up to maybe 6 or 7 drives before converting it over to a RAID6, and then topping it out at 12 drives (all I can fit in the case).... The performace hit isn't going to bother me too much - it's mainly going to be for video for my media server for the house...

So.. Can I expand a RAID6 now, which is good.... But can I change from RAID5 to RAID6 whilst online?


Graham

----- Original Message ----
From: Daniel Korstad <dan@korstad.net>
To: gmitch64@yahoo.com
Cc: linux-raid@vger.kernel.org
Sent: Wednesday, 11 July, 2007 11:03:34 AM
Subject: RE: Software based SATA RAID-5 expandable arrays?


That was true up to kernel 2.6.21 and 2.6 mdadm where support for RAID 6 reshape arrived.

I have reshaped (added additional drives) to my RAID 6 twice now with no problems in the past few months.

You mentioned that as the only disadvantage.  There are other things to consider.  The overhead for parity of course.  You can't have a RAID 6 with only three drives unless you build it with a missing drive and run degraded.  Also (my opinion) it might not worth the overhead with only 4 drives, unless you plan to reshape (add drives) down the road.  When you have an array with several drives, than it is more advantages as the percentage of disk space lost to parity goes down [((2/N)*100) where N is the number of drives in the array] so your storage efficiency increases ((Number of Drives -2)/Number of Drives).  And with more drives the statistics of getting hit with a bit error after you lose a drive and you are trying to rebuild increases.

Also, there is a very slight performance drop for write speeds on RAID6 since you are calculating p and q parity. 

But for what I use my system for, family digital photos, file storage and media server I mostly read data and not bothered with slight performance hit in write.

I have been using RAID6 with 10 disk for over a year and it has saved me at least once.  

As far as converting the RAID6 to RAID5 or RAID4...  Never had a need to do this, but no probably not.

Dan.



----- Inline Message Follows -----
To: Daniel Korstad ; Michael 
Cc: linux-raid@vger.kernel.org
From: jahammonds prost
Subject: Re: Software based SATA RAID-5 expandable arrays?



> Why do I use RAID6?  For the extra redundancy 

I've been thinking about RAID6 too, having been bitten a couple of times.... the only disadvantage that I can see at the moment is that you can't convert and grow it... ie... I can't convert from a 4 drive RAID5 array to a 5 drive RAID6 one when I add an additional drive... I also don't think that you can grow a RAID6 array at the moment - I'd want to add additional drives over a few months as they come on sale.... Or am I wrong on both counts?


Graham
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


      ___________________________________________________________
Yahoo! Answers - Got a question? Someone out there knows the answer. Try it
now.
http://uk.answers.yahoo.com/ 
