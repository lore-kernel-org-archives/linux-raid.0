From: Sean Puttergill <puttergi@yahoo.ca>
Subject: Re: Hot add not supported by version 1.x superblocks?
Date: Wed, 31 Jan 2007 12:16:08 -0800 (PST)
Message-ID: <250507.53532.qm@web34402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

False alarm.  My apologies.

There was a stale superblock on the disk I was trying to hot add as a spare.  Once I wiped the superblock it was successfully added to the array.
That being said, the error message issued wasn't exactly appropriate.


Regards,
Sean

----- Original Message ----
From: Sean Puttergill <puttergi@yahoo.ca>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
Sent: Wednesday, January 31, 2007 10:58:23 AM
Subject: Hot add not supported by version 1.x superblocks?

Hello Neil.

I have a RAID1 built using v1.2 superblocks.  I seem to not be able to hot add a spare drive to this array.
I get the error message:

"HOT_ADD may only be used with version-0 superblocks"

Does this really mean that hot add is not supported for arrays built with v1.x superblocks?
If so this seems like a big regression in functionality.  In this case, are there technical reasons why v1.x cannot support hot add?

I am using a stock 2.6.18 kernel with mdadm v2.5.4


Thanks,
Sean




__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
