From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Fri, 2 Jan 2009 12:46:08 -0800 (PST)
Message-ID: <923368.11110.qm@web30803.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan> <17665.11566.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021319330.26159@p34.internal.lan> <746863.34803.qm@web30803.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021355370.3485@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

Well, it looks like (maybe) you could be right about the backplane.  Shortly after replying to you, md2 went off and threw two drives.  So this is too much of a coincidence. Or I have having a really bad time with a bunch of disks!

I had 3 5in3 backplanes from a previous incarnation of the server around, so I moved all the disks from the new system into the old bacplanes, and hooked up power and cables etc...  They are now all online in the new backplanes.  

Md1 looks like it's still in the same state can't assemble from 5 drives.

Md2 when it came up said it couldn't assemble from 3 drives.  (It was working fine when I booted it in old backplane).  I told it to assemble using the --force option, and it adjust two drives events and so now complains that it can't assemble from 5 drives too.  

If I  were taking hits due to a bad backplane, could it be responsible for putting these arrys in such a bad state, even when i cleared the bad backplane?  

I'll probe around using the smart tools to see if I have a bad cable.  Meanwhile I have two new 8 port controllers on order to try and see if I have having more controller related grief.

Any ideas as to have to try reassmbling these guys?  I really don't want to try and do the create --assume-clean approach.  

Thx
mike





----- Original Message ----
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Mike Myers <mikesm559@yahoo.com>
Cc: linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
Sent: Friday, January 2, 2009 10:57:13 AM
Subject: Re: Need urgent help in fixing raid5 array



On Fri, 2 Jan 2009, Mike Myers wrote:

> Well, I can read from sdg1 just fine.  It seems to work ok, at least for a few GB of data.   I'll try this on some of the other disks, but it is possible for to pull the disks out of the backplane and run the SFF-8087 fanout cables direct to each drive and bypass the backplane completely.  It certainly would be easy to do this for the at least the sdo1 drive and see if I can get better results going direct to the disk.  I have moved the disks around the backplane a bit to deal with the issues of the controller failure, so I am pretty sure it's not just one bad slot or the like.
> 
> So you've seen a backplane fail in away that the disks come up fine at boot but have corrupted data transfers across them?  I wonder about the sata cables in that case as well.  I could hook up a pair of PMP's to my SI3132's and bypass the 8077 cables as well.

1. Try by-passing the backplane.
2. Bad cables will usually cause smart identifier UDMA_CRC_Error_Count to
   increase quite high, if it is 0 or close to it, the cable is unlikely the
   issue.
3. I have seem all kinds of weirdness with bad backplanes, drives dropping out
   of the array, drives producing I/O errors, etc.

Justin.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
