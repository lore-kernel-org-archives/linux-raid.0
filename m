From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: raid and sleeping bad sectors
Date: Tue, 29 Jun 2004 10:37:54 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406291027490.13281@twinlark.arctic.org>
References: <40E148EF.509@conterra.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40E148EF.509@conterra.de>
To: Dieter Stueken <stueken@conterra.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 29 Jun 2004, Dieter Stueken wrote:

> Question:
>
> Under which conditions a disk of a raid-5 system gets off line?
> Does it happen on ANY error, even if some read error happened?

yup -- md supports only "all good" or "all bad" as status for each disk --
no "partially good" status.

> Will double-fault read errors on different disks destroy my
> data?

a double fault will take your array offline but it's typically not a
catastrophic dataloss event.  you will have to do manual recovery --
you'll need to do the XOR to recreate at least one of the read errors, and
use mdadm to re-assemble the array.


> 1) I think a disk should be kept online as long as possible.
> This means, that a simple read error should not deactivate the disk
...
> 2) If I decide to replace a disk, it should be possible to add a new
> disk to the system before degrading it.
...
> 3) If a disks happened to produce a bad sector, you may try to rewrite it

i've been maintaining a wishlist, and those 3 are already on it:
<http://arctic.org/~dean/raid-wishlist.html>

-dean
