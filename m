From: Mike Myers <mikesm559@yahoo.com>
Subject: Re: Need urgent help in fixing raid5 array
Date: Mon, 5 Jan 2009 22:24:12 -0800 (PST)
Message-ID: <524209.67755.qm@web30805.mail.mud.yahoo.com>
References: <451872.61166.qm@web30802.mail.mud.yahoo.com>    <alpine.DEB.1.10.0901011039110.9903@p34.internal.lan>    <467705.96388.qm@web30807.mail.mud.yahoo.com>    <alpine.DEB.1.10.0901011328380.17888@p34.internal.lan>    <344038.60917.qm@web30808.mail.mud.yahoo.com>    <18786.34165.639790.37753@notabene.brown>    <546794.45786.qm@web30802.mail.mud.yahoo.com>    <879ae2ec7c5524fd9fa9841245772ab6.squirrel@neil.brown.name>    <100979.40008.qm@web30803.mail.mud.yahoo.com> <780997576890f2ccd07a4486c2702e8d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, john lists <john4lists@gmail.com>
List-Id: linux-raid.ids

BTW, in the original email I sent that had the --examine info for each of these array members, three devices have the same device UUID and array slot, and two of them share an older event count, and one has a slightly newer event count.  Which of these should be the real array slot 0?  And I notice that one of the members in that email had a device UUID that I can't find anymore (I suspect it's the current sdf1 that thinks it's part of md2).  In that email, it had array slot 4, which is one of the missing devices in the current familt (that I assume --assemble would add as "3").  It also has 9663 hours on it, which makes it part of the original set of 4 members for this raid5 array.  The drive in slot 5 only has 7630 hours on it, so it should have been added later as part of a --grow opera
 tion.

Does all that make sense?  If so, then sdb1, (which says it's slot 0), sdi1 (at 9671 hours) and also thinks it's slot 0, sdj1 (at 9194 hours) which also says it's 0, and sdf1 (at 9663 hours) and used to apparently think it's slot 4 should be the original 4 drives of the array.  How can I figure out which is the real slot 0, and who is slot 1 and 2 if sdi1 and sdj1 all have the same event count and array slot id (0) and same device UUID?

This is way harder work than should be need to fix a problem.  :-)  But I am sure glad you gurus know how this stuff is supposed to work!

Thx
Mike




----- Original Message ----
From: NeilBrown <neilb@suse.de>
To: Mike Myers <mikesm559@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>; linux-raid@vger.kernel.org; john lists <john4lists@gmail.com>
Sent: Monday, January 5, 2009 8:00:43 PM
Subject: Re: Need urgent help in fixing raid5 array

On Tue, January 6, 2009 1:46 pm, Mike Myers wrote:
> BTW, don't I need to use the --assume-clean option in the create operation
> to have this work right?

No.  When you create a degraded raid5, it is always assumed to be clean,
because it doesn't make any sense for it to be dirty.
However it wouldn't hurt to use --assume-clean, but it won't make any
difference.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



      
