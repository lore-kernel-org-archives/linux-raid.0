From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: Please help with a special RAID 1 setup
Date: Wed, 7 Jan 2004 09:48:12 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E5DA6395B8F9614EB7A784D628184B207E14CE@hdsmsx402.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Catalin BOIE <util@deuroconsult.ro>, Mircea Ciocan <mirceac@interplus.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Note that RAID-1 will only ever have a maximum of 2 active disks.
When you add the 3rd disk, it is added to the array as a spare, that's
why it doesn't rebuild.

Andy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Catalin BOIE
Sent: Wednesday, January 07, 2004 8:48 AM
To: Mircea Ciocan
Cc: linux-raid@vger.kernel.org
Subject: Re: Please help with a special RAID 1 setup


> >I think that you must replace:
> >	nr-raid-disks   2
> >with
> >	nr-raid-disks   3
> >Plus, the correspinding entry:
> >	device          /dev/sdb3
> >	raid-disk       2
> >
> >Else, the third drive isn't recognized as part of the md array.
> >Probably, you must restart the array (only first time).
> >You may want to use mdadm instead of raidtools.
> >
> >
> >
>
>     Modified config file, umounted and stoped raid, restarted raid,
> hotadded the disk, still the same results :(.
> Any other ideeas ??
>
>     Mircea

I think you must rebuid the /dec/md0 with mkraid --upgrade.
Warning! You may destroy all data, so backup first.

---
Catalin(ux) BOIE
catab@deuroconsult.ro
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
