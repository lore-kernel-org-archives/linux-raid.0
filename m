From: Shaohua Li <shli@kernel.org>
Subject: Re: Re: [patch]raid5: fix directio regression
Date: Wed, 8 Aug 2012 20:53:00 +0800
Message-ID: <CANejiEWC5ZKWT2L4DM-bfGi+v=TpkABruQqe5h0qG4oQg9sDhw@mail.gmail.com>
References: <20120807032240.GA22495@kernel.org>
	<201208071312593120932@gmail.com>
	<CANejiEUQcA6X75WG0xSgSv6NAQaBQnwpDD-5QaNVbqmo-oqLsA@mail.gmail.com>
	<201208071421033759628@gmail.com>
	<CANejiEVoOprAFoS6mCVYDJKh+nbGE0=7Xw_CpVS+Z9AcUoh6RQ@mail.gmail.com>
	<201208081321202343795@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208081321202343795@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

2012/8/8 Jianpeng Ma <majianpeng@gmail.com>:
> On 2012-08-08 10:58 Shaohua Li <shli@kernel.org> Wrote:
>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
>>> On 2012-08-07 13:32 Shaohua Li <shli@kernel.org> Wrote:
>>>>2012/8/7 Jianpeng Ma <majianpeng@gmail.com>:
>>>>> On 2012-08-07 11:22 Shaohua Li <shli@kernel.org> Wrote:
>>>>>>My directIO randomwrite 4k workload shows a 10~20% regression caused by commit
>>>>>>895e3c5c58a80bb. directIO usually is random IO and if request size isn't big
>>>>>>(which is the common case), delay handling of the stripe hasn't any advantages.
>>>>>>For big size request, delay can still reduce IO.
>>>>>>
>>>>>>Signed-off-by: Shaohua Li <shli@fusionio.com>
>>> [snip]
>>>>>>--
>>>>> May be used size to judge is not a good method.
>>>>> I firstly sended this patch, only want to control direct-write-block,not for reqular file.
>>>>> Because i think if someone used direct-write-block for raid5,he should know the feature of raid5 and he can control
>>>>> for write to full-write.
>>>>> But at that time, i did know how to differentiate between regular file and block-device.
>>>>> I thik we should do something to do this.
>>>>
>>>>I don't think it's possible user can control his write to be a
>>>>full-write even for
>>>>raw disk IO. Why regular file and block device io matters here?
>>>>
>>>>Thanks,
>>>>Shaohua
>>> Another problem is the size. How to judge the size is large or not?
>>> A syscall write is a dio and a dio may be split more bios.
>>> For my workload, i usualy write chunk-size.
>>> But your patch is judge by bio-size.
>>
>>I'd ignore workload which does sequential directIO, though
>>your workload is, but I bet no real workloads are. So I'd like
> Sorry,my explain maybe not corcrect. I write data once which size is almost chunks-size * devices,in order to full-write
> and as possible as to no pre-read operation.
>>only to consider big size random directio. I agree the size
>>judge is arbitrary. I can optimize it to be only consider stripe
>>which hits two or more disks in one bio, but not sure if it's
>>worthy doing. Not ware big size directio is common, and even
>>is, big size request IOPS is low, a bit delay maybe not a big
>>deal.
> If add a acc_time for 'striep_head' to control?
> When get_active_stripe() is ok, update acc_time.
> For some time, stripe_head did not access and it shold pre-read.

Do you want to add a timer for each stripe? This is even ugly.
How do you choose the expire time? A time works for harddisk
definitely will not work for a fast SSD.
