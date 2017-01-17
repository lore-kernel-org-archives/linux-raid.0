From: Jake Yao <jgyao1@gmail.com>
Subject: Re: performance of raid5 on fast devices
Date: Tue, 17 Jan 2017 10:28:35 -0500
Message-ID: <CA+Dh763Ttvnt9CSEUZ0QwPOLCaZq6VVXmj4OoheR7WTO6o4Pbw@mail.gmail.com>
References: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
 <20170117101043.78e80bdc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170117101043.78e80bdc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the response.

I am using fio for performance measurement.

The chunk size of raid5 array is 32K, and the block size in fio is set
to 96K(3x chunk size) which is also the optimal_io_size, ioengine is
set to libaio with direct IO.

Increasing stripe_cache_size does not help much, and it looks like the
write is limited by the single kernel thread as mentioned earlier.


On Tue, Jan 17, 2017 at 12:10 AM, Roman Mamedov <rm@romanrm.net> wrote:
> On Mon, 16 Jan 2017 21:35:21 -0500
> Jake Yao <jgyao1@gmail.com> wrote:
>
>> I have a raid5 array on 4 NVMe drives, and the performance on the
>> array is only marginally better than a single drive. Unlike a similar
>> raid5 array on 4 SAS SSD or HDD,  the performance on array is 3x
>> better than a single drive, which is expected.
>>
>> It looks like when the single kernel thread associated with the raid
>> device running at 100%, the array performance hit its peak. This can
>> happen easily for fast devices like NVMe.
>>
>> This can reproduced by creating a raid5 with 4 ramdisks as well, and
>> comparing performance on the array and one ramdisk. Sometimes the
>> performance on the array is worse than a single ramdisk.
>>
>> The kernel version is 4.9.0-rc3 and mdadm is release 3.4, no write
>> journal is configured.
>>
>> Is this a known issue?
>
> How do you measure the performance?
>
> Sure it may be CPU-bound in the end, but also why not try the usual
> optimization tricks, such as:
>
>   * increase your stripe_cache_size, it's not uncommon that this can speed up
>     linear writes by as much as several times;
>
>   * if you meant reads, you could look into read-ahead settings for the array;
>
>   * and in both cases, try experimenting with different stripe sizes (if you
>     were using 512K, try with 64K stripes).
>
> --
> With respect,
> Roman
