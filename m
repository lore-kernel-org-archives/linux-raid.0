From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: RE: Scrub?
Date: Fri, 6 Aug 2004 09:02:30 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0408060856070.14130@umi.cfht.hawaii.edu>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153121@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01153121@otce2k03.adaptec.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Derek Listmail Acct <listmail@oversimplified.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
> Many of the hardware raid controllers I've used have the ability to run
> a
> 'scrub' on an array.  Is there a way to do this on a linux software raid
> 5
> array?
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
