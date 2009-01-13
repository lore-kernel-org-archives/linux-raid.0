From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Mon, 12 Jan 2009 21:38:21 -0800 (PST)
Message-ID: <627627.60301.qm@web30804.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan> <467705.96388.qm@web30807.mail.mud.yahoo.com> <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan> <344038.60917.qm@web30808.mail.mud.yahoo.com> <18786.34165.639790.37753@notabene.brown> <546794.45786.qm@web30802.mail.mud.yahoo.com> <879ae2ec7c5524fd9fa9841245772ab6.squirrel@neil.brown.name> <100979.40008.qm@web30803.mail.mud.yahoo.com> <780997576890f2ccd07a4486c2702e8d.squirrel@neil.brown.name> <524209.67755.qm@web30805.mail.mud.yahoo.com> <18787.59872.647206.934303@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

Ok, still more help needed.  I finally got enough time scheduled tonight to be able to try recreating the raid array as per our conversation before.  When doing the create as you outlined in your earlier post, mdadm -C says the first two disks are part of an existing raid array (I assume this is a normal "error" for this sort of situation and will be ignored in the end), but for each of the last 4 devices I speciffy on the command line, it says: mdadm: cannot open /dev/sdc1: Device or resource busy (and gives this error for each of the 4 devices).

The devices are online though.  I can do an mdadm --examine on them, dd from them, and do smartctl operations on them.  Why would md think they were busy?

Thx
Mike






----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>; linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
Sent: Tuesday, January 6, 2009 3:31:44 PM
Subject: Re: Need urgent help in fixing raid5 array

On Monday January 5, mikesm559@yahoo.com wrote:
> BTW, in the original email I sent that had the --examine info for
> each of these array members, three devices have the same device UUID
> and array slot, and two of them share an older event count, and one
> has a slightly newer event count.  Which of these should be the real
> array slot 0?  And I notice that one of the members in that email
> had a device UUID that I can't find anymore (I suspect it's the
> current sdf1 that thinks it's part of md2).  In that email, it had
> array slot 4, which is one of the missing devices in the current
> familt (that I assume --assemble would add as "3").  It also has
> 9663 hours on it, which makes it part of the original set of 4
> members for this raid5 array.  The drive in slot 5 only has 7630
> hours on it, so it should have been added later as part of a --grow
> operation. 
> 
> Does all that make sense?  If so, then sdb1, (which says it's slot
> 0), sdi1 (at 9671 hours) and also thinks it's slot 0, sdj1 (at 9194
> hours) which also says it's 0, and sdf1 (at 9663 hours) and used to
> apparently think it's slot 4 should be the original 4 drives of the
> array.  How can I figure out which is the real slot 0, and who is
> slot 1 and 2 if sdi1 and sdj1 all have the same event count and
> array slot id (0) and same device UUID? 

I had noticed the slot number was repeated.  I hadn't noticed the
device uuid was the same, though I guess that makes sense.  Somehow
the superblock for one device has been written to the other devices.
It is not really possible to be sure which is the original without
knowing how this happened, though I suspect that the one with the
higher event count is more likely to be the original.

Being a software guy, I tend to like to blame hardware, and I wonder
if your problematic backplane managed to send write requests to the
wrong drive somehow.  If it did, then my expectation of your success
just went down a few notches. :-(

The only option for you to try to find out which device is which is to
try various combinations and see what gives you access to the most
consistent data.

> 
> This is way harder work than should be need to fix a problem.  :-)
> But I am sure glad you gurus know how this stuff is supposed to
> work! 

I'm happy to help as much as I can... I just hope your hardware hasn't
done too much damage...

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
