From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Scrub?
Date: Fri, 6 Aug 2004 15:24:23 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153143@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Kanoa Withington <kanoa@cfht.hawaii.edu>
Cc: Derek Listmail Acct <listmail@oversimplified.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

We have two RAID cards of different heritage over here with differing
definitions. One defines scrub as a means of erasing any content and
ensuring all blocks have correct parity or redundancy information; the
other defines it solely for RAID-5 to rebuild all the parity blocks. The
action in the second case resolves itself as a result of reading the bad
block.

Just reading the entire array should correct the bad blocks, so reverse
the sense of the dd:

	dd if=/dev/md0 of=/dev/null bs=200b

to find and replace the bad blocks (making the assumption that md works
like the H/W RAID cards).

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Kanoa Withington [mailto:kanoa@cfht.hawaii.edu] 
Sent: Friday, August 06, 2004 3:03 PM
To: Salyzyn, Mark
Cc: Derek Listmail Acct; linux-raid@vger.kernel.org
Subject: RE: Scrub?

Eh, that would delete the contents of the array, including the
filesystem. Is that what you meant by "scrub"? I thought "scrubbing"
meant looking for unreadable blocks and pro-actively replacing them
from parity. The latter would be very useful for a software raid 5
array since there is currently no facility in software raid for doing
this on-the-fly. I imagine it would be possible to write such a
utility in user space. I, too, wonder if anyone out there has
something that works.

-Kanoa

On Fri, 6 Aug 2004, Salyzyn, Mark wrote:

> dd if=/dev/zero of=/dev/md0 bs=200b
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Derek Listmail
> Acct
> Sent: Friday, August 06, 2004 2:07 PM
> To: linux-raid@vger.kernel.org
> Subject: Scrub?
>
> Many of the hardware raid controllers I've used have the ability to
run
> a
> 'scrub' on an array.  Is there a way to do this on a linux software
raid
> 5
> array?
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
