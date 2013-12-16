From: Pieter De Wit <pieter@insync.za.net>
Subject: Re: two raid5 performance
Date: Mon, 16 Dec 2013 20:52:58 +1300
Message-ID: <52AEB15A.3050301@insync.za.net>
References: <386c52f5-dd36-4697-b76a-d24038bbded3@aliyun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <386c52f5-dd36-4697-b76a-d24038bbded3@aliyun.com>
Sender: linux-raid-owner@vger.kernel.org
To: lilofile <lilofile@aliyun.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16/12/2013 14:07, lilofile wrote:
> when I Create a raid5,dd  1M block size,the performance can reached to 1GB/s
> when I create another raid5,dd 1M block size ,the performance can reached to 1GB/s
> when I simultaneously dd the two different raid,the total performance only reached to 1.4GB/s,why can not reached to 2GB/s.
>
> the memory is 32GB,CPU is x5660,the stripe size is 4096
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
What is the disks involved in the array ? How are they connected ?
