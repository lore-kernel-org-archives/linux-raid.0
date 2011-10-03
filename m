From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: How to stress test an RAID 6 array?
Date: Mon, 03 Oct 2011 22:35:28 +0200
Message-ID: <4E8A1C90.9050802@yazzy.org>
References: <4E89B81D.5000800@yazzy.org> <4E89C580.8050603@gmail.com>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E89C580.8050603@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/3/11 4:24 PM, Joe Landman wrote:
[...]

> nohup ./loop_check.pl 10 > out 2>&1 &
>
> which will execute the fio against sw_check.fio 10 times. Each
> sw_check.fio run will write and check 512GB of data (4 jobs, each
> writing and checking 128 GB data). Go ahead and change that if you want.
> We use a test just like this in our system checkout pipeline.
>
> This *will* stress all aspects of your units very hard. If you have an
> error in your paths, you will see crc errors in the output. If you have
> a marginal RAID system, this will probably kill it. Which is good, as
> you'd much rather it die on a hard test like this than in production.
>
> You can ramp up the intensity by increasing the number of jobs, or the
> size of the io, etc. We can (and do) crash machines with horrific loads
> generated from similar tests, just to see where the limits of the
> machines are at, and to help us tweak/tune our kernels for best
> stability under these horrific loads. The base test is used to convince
> us that the RAID is stable though.

I replaced SATA cables, updated the BIOS to the very last version,
ran/put hdparm -S0 /dev/sd[a-m] to /etc/rc.local and reset the BIOS to 
default settings.
It's running now and nothing broke so far.
Would it be enough to run one check with the sw_check.fio (I just 
changed the mount path) from your website to determine whether the RAID 
holds or not?



-- 

Marcin M. Jessa
