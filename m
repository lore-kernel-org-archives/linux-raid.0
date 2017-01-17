From: Stan Hoeppner <stan@hardwarefreak.org>
Subject: Re: performance of raid5 on fast devices
Date: Mon, 16 Jan 2017 21:10:55 -0600
Message-ID: <65f0f922-fae0-0135-463d-86115cffbf33@hardwarefreak.org>
References: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jake Yao <jgyao1@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/16/2017 08:35 PM, Jake Yao wrote:
> I have a raid5 array on 4 NVMe drives, and the performance on the
> array is only marginally better than a single drive. Unlike a similar
> raid5 array on 4 SAS SSD or HDD,  the performance on array is 3x
> better than a single drive, which is expected.
>
> It looks like when the single kernel thread associated with the raid
> device running at 100%, the array performance hit its peak. This can
> happen easily for fast devices like NVMe.
The md raid personalities are limited to a single kernel write thread.  
Work is in progress to alleviate this bottleneck by using multiple write 
threads.  When it will hit mainline I don't know.

> This can reproduced by creating a raid5 with 4 ramdisks as well, and
> comparing performance on the array and one ramdisk. Sometimes the
> performance on the array is worse than a single ramdisk.
>
> The kernel version is 4.9.0-rc3 and mdadm is release 3.4, no write
> journal is configured.
>
> Is this a known issue?
>
> Please cc me on the email as I am not on the mail list.
>
> Thanks!


