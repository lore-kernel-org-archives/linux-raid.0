From: Sam Bingner <sam@bingner.com>
Subject: Re: array went wonky
Date: Sat, 13 Apr 2013 14:20:50 +0000
Message-ID: <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com>
Content-Language: en-US
Content-ID: <63234E1DA1C8394FAA6A195C578B0639@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gimpbully <gimpbully@gmail.com>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Apr 12, 2013, at 7:41 PM, Gimpbully <gimpbully@gmail.com> wrote:

> Good Evening Folks,
>     Alright, I have a 5 disk raid5, it's worked for years.  Today a disk went "click click" and I dropped the cold spare I had in and started a rebuild.  Everything was great until I checked around 35% rebuild and everything was in the toilet.  Here is the current -E info.  Any advise would be *amazingly* appreciated.  (I can't believe I didn't just put the spare in and just go RAID5...).
> 
> /dev/sda1:
>         Events : 25952
> this     4       8        1        4      active sync   /dev/sda1
>   0     0       8       33        0      active sync   /dev/sdc1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
> /dev/sdb1:
>         Events : 25944
> this     1       8       17        1      active sync   /dev/sdb1
>   0     0       8       33        0      active sync   /dev/sdc1
>   1     1       8       17        1      active sync   /dev/sdb1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
> /dev/sdc1:
>         Events : 25952
> this     0       8       33        0      active sync   /dev/sdc1
>   0     0       8       33        0      active sync   /dev/sdc1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
> /dev/sde1:
>         Events : 25952
> this     2       8       65        2      active sync   /dev/sde1
>   0     0       8       33        0      active sync   /dev/sdc1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
> /dev/sdf1:
>         Events : 25952
> this     5       8       81        5      spare   /dev/sdf1
>   0     0       8       33        0      active sync   /dev/sdc1
>   2     2       8       65        2      active sync   /dev/sde1
>   4     4       8        1        4      active sync   /dev/sda1
>   5     5       8       81        5      spare   /dev/sdf1
> 
> -- 
> 

I suspect that your sdb drive is also bad... you should try to copy it to a new drive.  I would suggest GNU ddrescue (don't forget to use the logfile feature).  At this point I would actually suggest making a copy of all the drives (except the spare)... 

After that you can try to recreate the array with the proper order (sdc1, sdb1, sde1, missing, sda1) and copy data off or add the spare in again depending on if you were able to recover all the data wih GNU ddrescue.

You should use the check function for arrays to find such errors, and of course it would be best if you have a backup - then you can just restore from that.

Sam