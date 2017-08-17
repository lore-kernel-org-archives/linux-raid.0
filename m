From: Benjammin2068 <benjammin2068@gmail.com>
Subject: Re: Sanity Check: RAID1 with 4 members + Spare
Date: Wed, 16 Aug 2017 23:58:00 -0500
Message-ID: <2fbd1a2f-419a-9ad1-6321-8f758f05385e@gmail.com>
References: <108d7193-d41a-9390-5fc3-10eac37cd39c@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <108d7193-d41a-9390-5fc3-10eac37cd39c@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 08/16/2017 11:52 PM, Benjammin2068 wrote:
> Hey all,
>
>
>   I'm looking to make a 16TB raid1 from (4) 8TB members + 8TB Spare.
>
> when I put in:
>
>  mdadm --create /dev/md/RecordingRAID --level=mirror --name=RecordingRAID --raid-devices=4 /dev/sda1 /dev/sdd1 /dev/sde1 /dev/sdl1 --spare-devices=1 /dev/sdn1
>
>
>  I end up with an 8TB RAID.... not what I'm looking for...
>
> Should I be doing something different?
>
> Thanks,
>
>
>  -Ben
>
>
> p.s. (https://raid.wiki.kernel.org/index.php/RAID_setup doesn't show a good example of this. only 2+1)
>

Ha.. RAID10.

Ok - I need more sleep. NEVERMIND.

:P

 -Ben
