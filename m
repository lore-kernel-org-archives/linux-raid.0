From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: raid resync speed
Date: Thu, 20 Mar 2014 18:46:48 +0100
Message-ID: <532B2988.5070600@itwm.fraunhofer.de>
References: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPrpM6wLpRhMqqsXQ8Baqz4axxj6cvoB2Z1HAOiNm7gPv1FT=w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Allison <jeff.allison@allygray.2y.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/20/2014 02:12 AM, Jeff Allison wrote:
> The gist of my question is what kind of resync speed should I expect?
>
> I have a HP N54L Microserver running centos 6.5.
>
> In this box I have a 3x2TB disk raid 5 array, which I am in the
> process of extending to a 4x2TB raid 5 array.
>
> I've added the new disk --> mdadm --add /dev/md0 /dev/sdb
>
> And grown the array --> mdadm --grow /dev/md0 --raid-devices=4
>
> Now the problem the resync speed is v slow, it refuses to rise above
> 5MB, in general it sits at 4M.

Per second?

>
> from looking at glances it would appear that writing to the new disk
> is the bottle neck, /dev/sdb is the new disk.
>
> Disk I/O In/s Out/s
> md0 0 0
> sda1 0 0
> sda2 0 1K
> sdb1 3.92M 0
> sdc1 24.2M 54.7M
> sdd1 11.2M 54.7M
> sde1 16.3M 54.7M

Could you please send output of 'iostat -xm 1'? Also, do you anything in 
'top' that takes 100% CPU?

Thanks,
Bernd


