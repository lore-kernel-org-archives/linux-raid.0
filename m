From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: How safe is software RAID compared to how safe hardware RAID
Date: Wed, 19 Nov 2003 10:19:22 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0311190935440.10628@umi.cfht.hawaii.edu>
References: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <PPEOJEIEFLAONFNHJPOOAEICGOAA.jim@jimtreats.com>
To: James R Bamford <jim@jimtreats.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim,

It's a good question. I think most people will agree that having the
source code and the user support gives one a good feeling about Linux
software RAID. I would recommend it over hardware RAID for every
application except RAID 5.

The majority of the I/O errors I see on modern disks are read errors
rather than catastrophic disk failures. A software RAID 5 array goes
into degraded mode if it encounters a read error. Aside from the
immediate loss of redundancy, if there are any latent unreadable
blocks on the remaining disks, even an unreadable block which is not
in use by the file system, the array simply cannot be repaired. In a
very large array this is not uncommon. If the unreadable block was in
use by the file system, then there will be loss of data. Some hardware
controllers attempt to repair an unreadable block _before_ degrading
the array, an operation which in most cases is sucessfull.

This is a failure mode where I would consider a hardware controller to
be more reliable.

In a software RAID 1 array, each of the sub-volumes can be used just
like a normal partition+file system outside of the array and the whole
domain of software RAID, which is very nice for fault recovery. With a
hardware controller this usually cannot be done, the data on the disks
is useless without the controller.

This is a failure mode where I would consider a software array to be
more reliable.

-Kanoa

On Tue, 18 Nov 2003, James R Bamford wrote:

> Hi folks..
>
> hopefully everything will be working soon and i can get on with trying to
> get some backup scripts working :)
>
> I am going to stick with this software RAID for the near future if it
> carries on working correctly.. I was just wondering what peoples views were
> of software vs hardware raid... anything and everything really.. I'm not
> that up on all the technology... I know that 3ware have a good rep in
> hardware... I also imagine that for more exotic RAID configurations its
> obviously a help to not stress the CPU with the RAID tasks.. for me tho with
> simple mirroring the CPU costs are minimal.. the linux core is a sturdy base
> to build upon so is software raid in this way a perfectly acceptible
> reliable RAID solution..
>
> Just curious..
>
> Thanks for everyones help
>
> Jim
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
