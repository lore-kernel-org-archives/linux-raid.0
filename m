From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Raid10 multi core scaling
Date: Tue, 26 Nov 2013 22:19:34 +1100
Message-ID: <529483C6.2080503@websitemanagers.com.au>
References: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131126105859.Horde.-ppIIPYRo99SlH7zGogGx_A@webmail.aeiou.pt>
Sender: linux-raid-owner@vger.kernel.org
To: Pedro Teixeira <finas@aeiou.pt>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 26/11/13 21:58, Pedro Teixeira wrote:
>    I created a Raid10 array with 16 sata 1TB disks and the array
> performance
> seems to be limited by the md0_raid10 taking 99% of one core and not
> scalling to other cores. I tried overclocing the cpu cores and this
> lead to
> a small increase in performance ( but md0_raid10 keeps eating 99% of one
> core ).
>
>    I'm using:
>     - a phenom X6 at 3600mhz
>     - 16 seagate SSHDs ( sata3 7200RPM with 8GB ssd cache )
>     - 4x marvell 9230 sata3 controllers ( 4 ports each ) pcie 2.0 2x
> lanes.
>     - 8GB ram
>     - custom 3.12 kernel and mdadm compiled from latest source
>
>    what I did to test performance was to force a check on the array, and
> this
> leads to mdadm reporting a speed of about 990000K/sec. The hard disks
> report a 54% utilization. ( Overclocking the cpu by 200mhz increases the
> resync speed a bit and the hdd's utilizartion to about 58% )
>
>    If I do the same with a raid5 array instead of raid10, them resync
> speed
> will be almost double of raid10, the harddisk utilization reported
> will be
> 98-100% and I can see at least two cores being used.

AFAIK, the only way to make RAID10 use multiple cores is to actually
create 8 RAID1 arrays, and then combine those into a RAID0 linear or
RAID0 striped array. Each array will then create a new thread (total of
9 threads) which will then spread across all available cores.

There is ongoing work happening to improve this, but I don't think it is
available in any released kernel yet.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

