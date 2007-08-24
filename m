From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: recovery starts from 0 after reboot - normal?
Date: Fri, 24 Aug 2007 13:34:09 +0200
Message-ID: <46CEC231.1070407@wpkg.org>
References: <46CEBEED.1060209@wpkg.org> <Pine.LNX.4.64.0708240721280.18608@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708240721280.18608@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz schrieb:
> 
> 
> On Fri, 24 Aug 2007, Tomasz Chmielewski wrote:
> 
>> I built RAID-5 on a Debian Etch machine running 2.6.22.5 with this 
>> command:
>>
>> mdadm --create /dev/md0 --chunk=64 --level=raid5 --raid-devices=5 
>> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
>>
>>
>> After some time, it was synchronized just fine.
>>
>>
>> I removed one drive, put it back again, readded the drive to the array.
>>
>> It started rebuilding.
>> However, if the rebuilding is not 100% done, and I reboot the machine, 
>> rebuilding starts from 0.

(...)

> It should continue (at least that is what I have seen in the past), not 
> sure if you need bitmaps or not (I dont use them).

I had the same issue, with 4 drive RAID-10, on another Debian box.

Perhaps, the bitmap is needed then? I guess by default, no internal 
bitmap is added?

# mdadm -X /dev/md0
         Filename : /dev/md0
            Magic : 00000000
mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
          Version : 0
mdadm: unknown bitmap version 0, either the bitmap file is corrupted or 
you need to upgrade your tools


The fine manual says:

   BITMAP CHANGES
   A write-intent bitmap can be added to, or removed from, an active
   array. Either internal bitmaps, or bitmaps stored in a separate file
   can be added.


However, I'm not sure how to achieve it? How to add an internal bitmap 
to an array without a bitmap?


-- 
Tomasz Chmielewski
http://wpkg.org
