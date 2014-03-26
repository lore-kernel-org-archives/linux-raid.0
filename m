From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Array created by mdadm 3.2 & 3.3 have different array size,
 why?
Date: Wed, 26 Mar 2014 19:38:24 +0100 (CET)
Message-ID: <alpine.DEB.2.02.1403261937480.747@uplift.swm.pp.se>
References: <tencent_66C345191B9B49B92956F243@qq.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <tencent_66C345191B9B49B92956F243@qq.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tide <lovetide@qq.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 26 Mar 2014, Tide wrote:

> The partition size of each disk in the two arrays are identical (all 
> partitions have 5860531087 logical sectors), so why the array size are 
> different? Is it caused by different mdadm version (I guess so) or 
> different array level or something else?

Do mdadm -E on one component device from each md volume. My first guess 
would be different data offset.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
