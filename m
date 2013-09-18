From: Tommy Apel <tommyapeldk@gmail.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Wed, 18 Sep 2013 18:07:32 +0200
Message-ID: <CAGA4a+EnkWd6LXXj8WH_33Z_z=Gww39nE3FuJ4dVwjXG3r56kQ@mail.gmail.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
	<CACJz6QtVzR1bED939ZkesyXMWjv-2DmxZSrGH_enKX5dCuNEJw@mail.gmail.com>
	<CAH3kUhHin5PfjDCNFjD8eypNML=0YrkQp14DrCADc2StcODdaw@mail.gmail.com>
	<CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

dm cache is AFAIK still Experimental, the size of the ssd won't matter
too much in this case as you're only severing a 2TB backend and you'll
be able to use sequential writes to the backing store at 150MB/s or
so, once the writes are completed on the ssd they will be strained
together and flushed to permanent storage at full sequential speed for
the most time plus you'll have linux fs buffers as well so I'm not
really too sure how much the ssd will actually contribute to the setup
in total. The ssd caching will in most cases only benefit you if you
have a lot of small random write IO.

/Tommy


2013/9/18 Roberto Spadim <roberto@spadim.com.br>:
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
>>
>>
>> --
>> Drew
>>
>> "Nothing in life is to be feared. It is only to be understood."
>> --Marie Curie
>>
>> "This started out as a hobby and spun horribly out of control."
>> -Unknown
>
>
> --
> Roberto Spadim
> SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
