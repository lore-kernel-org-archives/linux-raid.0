From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Fri, 2 Jan 2009 20:19:40 -0800 (PST)
Message-ID: <480194.8807.qm@web30808.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <alpine.DEB.1.10.0901020708210.3858@p34.internal.lan> <17665.11566.qm@web30804.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021319330.26159@p34.internal.lan> <746863.34803.qm@web30803.mail.mud.yahoo.com> <alpine.DEB.1.10.0901021355370.3485@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

Ok, good news and bad news.  I finally got all the disks connected and bypassed the backplane.  Md2 starts with 6 members in a degraded mode.  Md1 is still having the same problem.  In doing an examine on each member disk, I discovered that 8 disks had the superblock referencing md2's UUID.  The other thing is that only 6 had the UUID of md1, which is suppposed to have 7 members.  One of the two (sdf1) that has the superblock of md2 (but not active in the array) is also an Hitachi, which it shouldn't be (md2 is a seagate 7200.11 array). This appears to be the missing md1 disk.  I don't understand how it got the other raid array's info, but things are weird here.

That was the good news.  The bad news is that when I tried to assemble md1 with all the md1 members plus sdf1 (the disk that thinks its part of md2), I mistakenly used it as the target for for mdadm assemble command.  Ugh.

So I typed: mdadm /dev/sdf1 --assemble /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdi1 /dev/sdj1 --force

So now sdf1 instead of having the wrong superblock has no super block.  Am I completely hosed at this point?  I probably needed to figure out a way to get this disk a new superblock anyway, but but I suspect things are even harder to fix at this point.

Any ideas as to how to fix this?  Is there another superblock somewhere else on the disk that I can recover the proper info from?

Thanks,
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


      
