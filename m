From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: recovery starts from 0 after reboot - normal?
Date: Fri, 24 Aug 2007 07:40:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0708240739550.18608@p34.internal.lan>
References: <46CEBEED.1060209@wpkg.org> <Pine.LNX.4.64.0708240721280.18608@p34.internal.lan>
 <46CEC231.1070407@wpkg.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46CEC231.1070407@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Fri, 24 Aug 2007, Tomasz Chmielewski wrote:

> Justin Piszcz schrieb:
>> 
>> 
>> On Fri, 24 Aug 2007, Tomasz Chmielewski wrote:
>> 
>>> I built RAID-5 on a Debian Etch machine running 2.6.22.5 with this 
>>> command:
>>> 
>>> mdadm --create /dev/md0 --chunk=64 --level=raid5 --raid-devices=5 
>>> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>> 
>>> 
>>> After some time, it was synchronized just fine.
>>> 
>>> 
>>> I removed one drive, put it back again, readded the drive to the array.
>>> 
>>> It started rebuilding.
>>> However, if the rebuilding is not 100% done, and I reboot the machine, 
>>> rebuilding starts from 0.
>
> (...)
>
>> It should continue (at least that is what I have seen in the past), not 
>> sure if you need bitmaps or not (I dont use them).
>
> I had the same issue, with 4 drive RAID-10, on another Debian box.
>
> Perhaps, the bitmap is needed then? I guess by default, no internal bitmap is 
> added?
>
> # mdadm -X /dev/md0
>        Filename : /dev/md0
>           Magic : 00000000
> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
>         Version : 0
> mdadm: unknown bitmap version 0, either the bitmap file is corrupted or you 
> need to upgrade your tools
>
>
> The fine manual says:
>
>  BITMAP CHANGES
>  A write-intent bitmap can be added to, or removed from, an active
>  array. Either internal bitmaps, or bitmaps stored in a separate file
>  can be added.
>
>
> However, I'm not sure how to achieve it? How to add an internal bitmap to an 
> array without a bitmap?
>
>
> -- 
> Tomasz Chmielewski
> http://wpkg.org
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

That has been discussed on the mailing list before I believe.

        -e ,  --metadata=
               Declare the style of superblock (raid metadata) to be used.  The
               default is 0.90 for --create, and to guess for other operations.
               The default can be overridden by setting the metadata value  for
               the CREATE keyword in mdadm.conf.

Check the archives or ping Neil (especially) if you do not have a backup 
of your environment.

