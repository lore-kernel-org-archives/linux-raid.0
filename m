From: Kanoa Withington <kanoa@cfht.hawaii.edu>
Subject: Re: High System Load
Date: Wed, 28 Jul 2004 13:23:49 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0407281322170.17864@umi.cfht.hawaii.edu>
References: <A506359028CAD21191C10008C75D895C0A06C865@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A506359028CAD21191C10008C75D895C0A06C865@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
To: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

There is a lot of activity after you first create a mirror but the CPU
load should not be that high. Maybe you don't have DMA turned on?
Check using "hdparm".

-Kanoa

On Wed, 28 Jul 2004, Huntress Gary B NPRI wrote:

> Hi,
>
> I'm creating my first software RAID array.  I'm on a 900 MHz system with 786MB of ram, running Fedora RC1.  I'm creating a RAID 1 array consisting only of two drives, split on two IDE channels.
>
> I used mdadm --create and everything is running fine so far, but my system load is well over 10.   Is this normal?   I suspect that this is just overhead while creating the array the first time.   Can I assume that when the array is actually put into use that the system loads will not be this high?  (I hope not!)
>
> Thanks,
>
> Gary H.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
