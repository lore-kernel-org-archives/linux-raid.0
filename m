From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: recovery starts from 0 after reboot - normal?
Date: Mon, 27 Aug 2007 15:39:42 +0200
Message-ID: <46D2D41E.4060506@wpkg.org>
References: <46CEBEED.1060209@wpkg.org> <Pine.LNX.4.64.0708240721280.18608@p34.internal.lan> <46CEC231.1070407@wpkg.org> <46CEC51B.10105@wpkg.org> <Pine.LNX.4.64.0708240748140.18608@p34.internal.lan> <46CEC805.6010009@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46CEC805.6010009@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tomasz Chmielewski schrieb:
> Justin Piszcz schrieb:
> 
>>> According to the fine manual, BITMAP CHANGES belong to the grow mode.
>>> So, let's try to do what the manual says - try to add a bitmap to the 
>>> active array:
>>>
>>>
>>> # mdadm --grow /dev/md0 --bitmap=internal
>>> mdadm: failed to set internal bitmap.
>>>
>>> # dmesg
>>> md: couldn't update array info. -16
>>>
>>>
>>> So, either I don't understand the manual, or there are more caveats 
>>> in it.
> 
> (...)
> 
>> Check: http://lkml.org/lkml/2007/6/17/235
> 
> It's an external bitmap; I'd prefer an internal one, as my root 
> filesystem is on a flash-IDE disk.
> 
> However, let's try the external bitmap:
> 
> # mdadm --grow /dev/md0 --bitmap=/bitmapfile
> mdadm: Cannot set bitmap file for /dev/md0: Device or resource busy
> 
> 
> So, it also fails. Perhaps because the array still rebuilds?

It looks it only works when the array is in a clean state (or, not 
rebuilding anymore).

Just for reference:

# mdadm --grow --bitmap=/bitmapfile /dev/md0
# dmesg -c
md0: bitmap file is out of date (0 < 43130) -- forcing full recovery
md0: bitmap file is out of date, doing full recovery
md0: bitmap initialized from disk: read 24/24 pages, set 763103 bits, 
status: 0
created bitmap (373 pages) for device md0

# mdadm --grow /dev/md0 --bitmap=internal
mdadm: /dev/md0 already has a bitmap (/bitmapfile)

# mdadm --grow /dev/md0 --bitmap=none

# mdadm --grow /dev/md0 --bitmap=internal
# dmesg -c
md0: bitmap file is out of date (0 < 43130) -- forcing full recovery
md0: bitmap file is out of date, doing full recovery
md0: bitmap initialized from disk: read 12/12 pages, set 381552 bits, 
status: 0
created bitmap (187 pages) for device md0


What are pages/bits in bitmap? It seems to differ, whether internal or 
external is used.

-- 
Tomasz Chmielewski
http://wpkg.org
