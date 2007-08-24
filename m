From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: recovery starts from 0 after reboot - normal?
Date: Fri, 24 Aug 2007 07:22:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0708240721280.18608@p34.internal.lan>
References: <46CEBEED.1060209@wpkg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46CEBEED.1060209@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 24 Aug 2007, Tomasz Chmielewski wrote:

> I built RAID-5 on a Debian Etch machine running 2.6.22.5 with this command:
>
> mdadm --create /dev/md0 --chunk=64 --level=raid5 --raid-devices=5 /dev/sda1 
> /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>
>
> After some time, it was synchronized just fine.
>
>
> I removed one drive, put it back again, readded the drive to the array.
>
> It started rebuilding.
> However, if the rebuilding is not 100% done, and I reboot the machine, 
> rebuilding starts from 0.
>
> Is it normal?
>
>
> -- 
> Tomasz Chmielewski
> http://wpkg.org
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

It should continue (at least that is what I have seen in the past), not 
sure if you need bitmaps or not (I dont use them).

