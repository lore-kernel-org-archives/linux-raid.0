From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: why a bitmap file never changes?
Date: Fri, 31 Aug 2007 12:32:32 +0200
Message-ID: <46D7EE40.3050800@wpkg.org>
References: <46D53228.4000400@wpkg.org> <46D5371A.6020001@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46D5371A.6020001@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tomasz Chmielewski schrieb:
> Tomasz Chmielewski schrieb:
> 
>> The date of the file is the date of creation of this array, and as I 
>> look inside, it's basically almost empty. When looking in a hex 
>> editor, zeroes (+bitm etc.)at the beginning, and than FF to the end.
>>
>>
>> Is it normal?
> 
> Here is some more info about the bitmap itself - it's 100% dirty, what 
> does it mean?
> 
> # mdadm -X /root/backup-bitmap
>         Filename : /root/backup-bitmap
>            Magic : 6d746962
>          Version : 4
>             UUID : 00000000.00000000.00000000.00000000
>           Events : 0
>   Events Cleared : 0
>            State : OK
>        Chunksize : 1 MB
>           Daemon : 5s flush period
>       Write Mode : Allow write behind, max 256
>        Sync Size : 658800640 (628.28 GiB 674.61 GB)
>           Bitmap : 643360 bits (chunks), 643360 dirty (100.0%)

After the drives synchronized, the bitmap file was no longer 100% dirty.

So, I guess it gets 100% dirty when there is a substantial activity 
going on? Like resync, for example.


-- 
Tomasz Chmielewski
http://wpkg.org
