From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: raid1 missing disk
Date: Fri, 13 Oct 2017 02:19:11 +1100
Message-ID: <0d28746f-1eb5-62aa-47a3-99989a42db64@websitemanagers.com.au>
References: <85523B4D-6691-44F1-A609-A5280224E352@jjd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <85523B4D-6691-44F1-A609-A5280224E352@jjd.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: James J Dempsey <jjd@jjd.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 13/10/17 01:58, James J Dempsey wrote:
> I have a simple problem with a 2-disk raid-1 configuration that I can’t find the solution for on the internet so I hope someone can help.
>
> One disk failed on my 2-disk raid-1 and I foolishly (physically) removed the disk before software removing it from the array.
>
> The current state is that the array is running degraded with 1 disk.  My goal is to add a new disk and return it to a non-degraded 2-disk array.
>
> I still have the failed disk, but I don’t really want to physically re-install it because the last time I tested that, the array started and showed the pre-failed data, not the current data.  My theory of this is that the computer switched it’s idea of which disk was /dev/sda and which was /dev/sdb as a result of the original removal.  So I’d like to just continue from this state without the confusion of adding that old disk physically back.
>
> Can I just use mdadm -a to add the new disk into this existing array?  How do I get rid of the missing ‘ghost’ drive?
>
> Thanks for any help you can provide.  I’ll include the output of mdstat and mdadm -D and mdadm.conf below.
>
> —Jim—
>
> $ cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sda1[0]
>        1953366016 blocks super 1.2 [2/1] [U_]
>        bitmap: 8/15 pages [32KB], 65536KB chunk
>
> unused devices: <none>
> $
Perfect...

mdadm --manage /dev/md0 --add /dev/sdb1
Wait for it to finish sync and you are all done (if only every broken 
raid issue was this easy ;)

Oh, make sure you have read and understood and fixed the timeout issue 
if using desktop drives.

Regards,
Adam
