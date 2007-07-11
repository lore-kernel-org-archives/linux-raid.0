From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re:     Software based SATA RAID-5 expandable arrays?
Date: Wed, 11 Jul 2007 13:12:40 -0700 (PDT)
Message-ID: <353792.560.qm@web55811.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Korstad <dan@korstad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yeah... I kinda suspected that it would need to be a new drive being added - which is fine by me. I'm in the planning stages for building my next home server...

One way to do it (with what we have at the moment) would be to have enough drives setup for RAID5, and build an empty RAID6 array. Move the data over, then destroy the old array, and grow out the new one with the recovered disks.... Ick... but I that works.


Graham

----- Original Message ----
From: Daniel Korstad <dan@korstad.net>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Wednesday, 11 July, 2007 3:26:51 PM
Subject: RE: Software based SATA RAID-5 expandable arrays?


And if I were a betting man, I would guess you will need to add a physical drive to execute a RAID5 to RAID6 conversation for adding additional parity even if your current RAID5 is not full of data.

So if your case only holds 12 Drives, I would not grow your RAID5 to 12 drives and expect to be able to convert to RAID6 with the same 12 drives even if they are not full of data.

But that is just my guess on a feature that does not even exist yet...

Dan.

----- Original Message -----
From: linux-raid-owner@vger.kernel.org on behalf of Daniel Korstad 
Sent: Wed, 7/11/2007 2:14pm
To: jahammonds prost 
Cc: linux-raid@vger.kernel.org
Subject: RE: Software based SATA RAID-5 expandable arrays? 


Currently, no you can't.

However it is on the TODO list.
http://neil.brown.name/blog/20050727143147-003

Maybe by the end of the year, Neil hit his goal on the raid6 grow for kernel 2.6.21... But Neil states the raid 5 to raid 6 is more complex to implement...

Dan.

----- Original Message -----
From: jahammonds prost 
Sent: Wed, 7/11/2007 12:26pm
To: Daniel Korstad 
Cc: linux-raid@vger.kernel.org
Subject: Re: Software based SATA RAID-5 expandable arrays? 


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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


      ___________________________________________________________ 
Yahoo! Mail is the world's favourite email. Don't settle for less, sign up for
your free account today http://uk.rd.yahoo.com/evt=44106/*http://uk.docs.yahoo.com/mail/winter07.html 
