From: "Wei Yongquan" <weiyqlq@gmail.com>
Subject: Re: linear : divide error: 0000
Date: Mon, 3 Nov 2008 22:53:22 +0800
Message-ID: <1346d4690811030653s566d17a7mc6c31fadb0f533d1@mail.gmail.com>
References: <1346d4690811020803p47f62b3ak9868832969040759@mail.gmail.com>
	 <20081103103221.GJ17966@skl-net.de>
	 <1346d4690811030437t259c4f60rac29acd746c2acff@mail.gmail.com>
	 <20081103141501.GK17966@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081103141501.GK17966@skl-net.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> the code linear.c :
>>
>> 158              min_spacing = conf->array_sectors / 2;
>> 159              sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));
>>
>> if the array size is less then 1024K and the system is 32 based,
>> min_spacing will be ZERO.
>
> nope, array_sectors in in 512 byte units. So the array size has to
> be smaller than 1024 _bytes_ for min_spacing to become zero.
Thanks.
er,  "array_sectors in in 512 byte units" means  when array_sectors =
2048, the array size is actually 2048 * 512 = 1024K. Is that right?
when min_spacing < 1024 at line 158, it becomes zero at line 159. is that right?
