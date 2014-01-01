From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: Looking for help how to migrate 2disk RAID1 to 3 disk RAID6
Date: Wed, 01 Jan 2014 14:02:00 +1300
Message-ID: <52C36908.2010701@insync.za.net>
References: <1388537511.5058.22.camel@oxygen.netxsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1388537511.5058.22.camel@oxygen.netxsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Adamski <k-list@adamski.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/01/2014 13:51, Krzysztof Adamski wrote:
> I have a system with two drives like this:
> / RAID1 on sda3 and sdb3
> /boot RAID1 on sda1 and sdb1
>
> I would like to migrate to
> / RAID6 on sdi3, sdj3 and sdh3
> /boot RAID1 on sdi1, sdj1 and sdh1
>
> The /boot already done.
> How would I do the migration to RAID6?
>
> The new drives i,j and h are larger then a and b, after the migration I
> will reshape the raid to use all the space on the new raid, unless it is
> possible to do it in one step.
>
> The reason I want RAID6 and not RAID1 with 3 drives is that later I may
> add more drives to the array.
>
> Currently I don't trust any RAID that has only one parity drive, it has
> to survive a failure of any two drives. So RAID6 or triple RAID1 are a
> minimum.
>
> Thanks in advance,
> K
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Hi,

RAID Level 6 requires a minimum of 4 drives to implement

Cheers,

Pieter
