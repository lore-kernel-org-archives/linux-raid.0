From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Wed, 18 Sep 2013 09:00:55 -0700
Message-ID: <CAK2H+ef3ZytVbLPcOjbgSmZqFu8KNPFk3diWB1UkGXEyzfqNvA@mail.gmail.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
	<CACJz6QtVzR1bED939ZkesyXMWjv-2DmxZSrGH_enKX5dCuNEJw@mail.gmail.com>
	<CAH3kUhHin5PfjDCNFjD8eypNML=0YrkQp14DrCADc2StcODdaw@mail.gmail.com>
	<CACJz6QvCKLaGE-VxN9arJDb1WYuz0L8yS9FGSNfAnR-vyVA+EA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACJz6QvCKLaGE-VxN9arJDb1WYuz0L8yS9FGSNfAnR-vyVA+EA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 18, 2013 at 8:39 AM, Drew <drew.kay@gmail.com> wrote:
> Forwarded as only I got the reply.
>
> ---------- Forwarded message ----------
> From: Roberto Spadim <roberto@spadim.com.br>
> Date: Wed, Sep 18, 2013 at 7:41 AM
> Subject: Re: Best configuration for bcache/md cache or other cache using ssd
> To: Drew <drew.kay@gmail.com>
>
>
> Sorry guys, this time i don't have a full knowledge about the
> workload, but from what he told me, he want fast writes with hdd but i
> could check if small ssd devices could help
> After install linux with raid1 i will install apache mariadb and php
> at this machine, in other words it's a database and web server load,
> but i don't know what size of app and database will run yet
>
> Btw, ssd with bcache or dm cache could help hdd (this must be
> enterprise level) writes, right?
> Any idea what the best method to test what kernel drive could give
> superior performace? I'm thinking about install the bcache, and after
> make a backup and install dm cache and check what's better, any other
> idea?
>
> Em 18/09/2013 11:00, "Drew" <drew.kay@gmail.com> escreveu:
>
>> > HDD will be a SATA 7200rpm with 2TB, SSD will be ~ 160GB or less (must
>> > be cheap and enterprise level)
>> >
>> > he wants a RAID1 level over HDD and a cache (bcache/or md cache layer
>> > of kernel 3.9) over this md device (raid1)
>>
>> What is the client's workload? What is he trying to do with this machine?
>>
>> At first glance (without any information) the requirements don't make
>> sense. Placing a SSD based cache in front of a pair of slow 7200RPM
>> SATA's sounds like he's trying to get SSD performance at SATA prices.
>> It could work but if he's hammering the disks enough to need SSD
>> performance, those SATA's just won't keep up.


As the OP doesn't have a workload I throw one out as I've been
considering doing something similar for a few months.

I work at home on a Gentoo Linux box. (i980x, 24GB, five 500GB RE3
drives configured as a 1.4GB RAID6.) Mostly I work in Windows writing
software for trading, and then also trading. When trading I have a
moderate amount of real-time data arriving and being processed by 3
Windows VMs. 2 VMs are Virtualbox Win7 machines, the 3rd is a VMWare
XP machine. RAID6 was chosen as I have a lot of DVD video stored here
as a backup and wanted extra physical security. I sometimes play video
on the machine, but mostly 1TB of the RAID is just storage. The VMs
account for maybe 200GB of disk space.

My 'issue' with the machine is there are a lot of lags in (I think)
the RAID6 subsystem when the machine gets loaded up with a lot of
things going on in the VMs. It gets a _lot_ worse if maybe I'm ripping
a DVD in Gentoo.

I was considering using dm-cache with either a single SSD of a two SSD
RAID1. Will it help? MY worry looking in the dm-cache forums are a
number of people complaining that using dm-cache led to their disk
subsystem being corrupted.

This is likely not enough info for a quantitative answer. I'm willing
to collect some data if pointed toward tools that don't require a PhD
to run them.

Cheers,
Mark
