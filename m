From: Catalin BOIE <util@deuroconsult.ro>
Subject: Re: Please help with a special RAID 1 setup
Date: Wed, 7 Jan 2004 15:47:35 +0200 (EET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0401071542170.16314@hosting.rdsbv.ro>
References: <3FFBDC7A.8020702@interplus.ro> <Pine.LNX.4.58.0401071413590.16314@hosting.rdsbv.ro>
 <3FFC0852.8060407@interplus.ro>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3FFC0852.8060407@interplus.ro>
To: Mircea Ciocan <mirceac@interplus.ro>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
