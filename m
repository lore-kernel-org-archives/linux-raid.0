From: Drew <drew.kay@gmail.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Wed, 18 Sep 2013 06:59:48 -0700
Message-ID: <CACJz6QtVzR1bED939ZkesyXMWjv-2DmxZSrGH_enKX5dCuNEJw@mail.gmail.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> HDD will be a SATA 7200rpm with 2TB, SSD will be ~ 160GB or less (must
> be cheap and enterprise level)
>
> he wants a RAID1 level over HDD and a cache (bcache/or md cache layer
> of kernel 3.9) over this md device (raid1)

What is the client's workload? What is he trying to do with this machine?

At first glance (without any information) the requirements don't make
sense. Placing a SSD based cache in front of a pair of slow 7200RPM
SATA's sounds like he's trying to get SSD performance at SATA prices.
It could work but if he's hammering the disks enough to need SSD
performance, those SATA's just won't keep up.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
