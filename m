From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: recovery starts from 0 after reboot - normal?
Date: Fri, 24 Aug 2007 13:46:35 +0200
Message-ID: <46CEC51B.10105@wpkg.org>
References: <46CEBEED.1060209@wpkg.org> <Pine.LNX.4.64.0708240721280.18608@p34.internal.lan> <46CEC231.1070407@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46CEC231.1070407@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tomasz Chmielewski schrieb:

(...)

> Perhaps, the bitmap is needed then? I guess by default, no internal 
> bitmap is added?
> 
> # mdadm -X /dev/md0
>         Filename : /dev/md0
>            Magic : 00000000
> mdadm: invalid bitmap magic 0x0, the bitmap file appears to be corrupted
>          Version : 0
> mdadm: unknown bitmap version 0, either the bitmap file is corrupted or 
> you need to upgrade your tools
> 
> 
> The fine manual says:
> 
>   BITMAP CHANGES
>   A write-intent bitmap can be added to, or removed from, an active
>   array. Either internal bitmaps, or bitmaps stored in a separate file
>   can be added.
> 
> 
> However, I'm not sure how to achieve it? How to add an internal bitmap 
> to an array without a bitmap?

According to the fine manual, BITMAP CHANGES belong to the grow mode.
So, let's try to do what the manual says - try to add a bitmap to the 
active array:


# mdadm --grow /dev/md0 --bitmap=internal
mdadm: failed to set internal bitmap.

# dmesg
md: couldn't update array info. -16


So, either I don't understand the manual, or there are more caveats in it.


-- 
Tomasz Chmielewski
http://wpkg.org
