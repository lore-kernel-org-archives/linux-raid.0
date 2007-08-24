From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: recovery starts from 0 after reboot - normal?
Date: Fri, 24 Aug 2007 13:59:01 +0200
Message-ID: <46CEC805.6010009@wpkg.org>
References: <46CEBEED.1060209@wpkg.org> <Pine.LNX.4.64.0708240721280.18608@p34.internal.lan> <46CEC231.1070407@wpkg.org> <46CEC51B.10105@wpkg.org> <Pine.LNX.4.64.0708240748140.18608@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0708240748140.18608@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Justin Piszcz schrieb:

>> According to the fine manual, BITMAP CHANGES belong to the grow mode.
>> So, let's try to do what the manual says - try to add a bitmap to the 
>> active array:
>>
>>
>> # mdadm --grow /dev/md0 --bitmap=internal
>> mdadm: failed to set internal bitmap.
>>
>> # dmesg
>> md: couldn't update array info. -16
>>
>>
>> So, either I don't understand the manual, or there are more caveats in 
>> it.

(...)

> Check: http://lkml.org/lkml/2007/6/17/235

It's an external bitmap; I'd prefer an internal one, as my root 
filesystem is on a flash-IDE disk.

However, let's try the external bitmap:

# mdadm --grow /dev/md0 --bitmap=/bitmapfile
mdadm: Cannot set bitmap file for /dev/md0: Device or resource busy


So, it also fails. Perhaps because the array still rebuilds?

A 95644 byte /bitmapfile was created.


I'll try again when the array is done with rebuilding. According to 
/proc/mdstat, it would be 6 more hours.


-- 
Tomasz Chmielewski
http://wpkg.org
