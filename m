From: "Wei Yongquan" <weiyqlq@gmail.com>
Subject: Re: linear : divide error: 0000
Date: Mon, 3 Nov 2008 20:37:51 +0800
Message-ID: <1346d4690811030437t259c4f60rac29acd746c2acff@mail.gmail.com>
References: <1346d4690811020803p47f62b3ak9868832969040759@mail.gmail.com>
	 <20081103103221.GJ17966@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081103103221.GJ17966@skl-net.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> This sector_div() is in linear_conf() while the call trace indicates
> the bug happens in mddev_put(). I'll have a deeper look later today.
>
> Is this a recent regression?

Sorry, I don't know.  2.6.24.4 has the some problem.

the code linear.c :

158              min_spacing = conf->array_sectors / 2;
159              sector_div(min_spacing, PAGE_SIZE/sizeof(struct dev_info *));

if the array size is less then 1024K and the system is 32 based,
min_spacing will be ZERO.

174               if (sz >= min_spacing && sz < conf->hash_spacing)
175                              conf->hash_spacing = sz;

when min_spacing is ZERO then the hash_spacing is ZERO, too.

199               base = conf->hash_spacing >> conf->preshift;
200               round = sector_div(sz, base);

here is base is ZERO, and case didive error.

raid of less then 1M size is really unusual, just refusing the request is OK.

Correct me if I have something wrong.  Thanks a lot.
