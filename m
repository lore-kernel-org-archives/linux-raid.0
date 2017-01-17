From: Jake Yao <jgyao1@gmail.com>
Subject: Re: performance of raid5 on fast devices
Date: Tue, 17 Jan 2017 10:22:03 -0500
Message-ID: <CA+Dh763yW4nOYytkBqZbb9_QGJj_T+QKC__pCLzKQM7yA5M3PQ@mail.gmail.com>
References: <CA+Dh761_kVPEcRdFEAo72Wif_t-G7RpgyoKGetEFveyMpaYD1w@mail.gmail.com>
 <65f0f922-fae0-0135-463d-86115cffbf33@hardwarefreak.org> <f72f7be4-9b2d-6bf9-1b61-eb066ef35343@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f72f7be4-9b2d-6bf9-1b61-eb066ef35343@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>
Cc: Stan Hoeppner <stan@hardwarefreak.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks for the response.

It helps a little by increasing group_thread_cnt, but not to the
extend of 3x expected.  It looks like the single kernel thread is
still the bottleneck.

On Tue, Jan 17, 2017 at 12:04 AM, Coly Li <colyli@suse.de> wrote:
> On 2017/1/17 =E4=B8=8A=E5=8D=8811:10, Stan Hoeppner wrote:
>> On 01/16/2017 08:35 PM, Jake Yao wrote:
>>> I have a raid5 array on 4 NVMe drives, and the performance on the
>>> array is only marginally better than a single drive. Unlike a similar
>>> raid5 array on 4 SAS SSD or HDD,  the performance on array is 3x
>>> better than a single drive, which is expected.
>>>
>>> It looks like when the single kernel thread associated with the raid
>>> device running at 100%, the array performance hit its peak. This can
>>> happen easily for fast devices like NVMe.
>> The md raid personalities are limited to a single kernel write thread.
>> Work is in progress to alleviate this bottleneck by using multiple write
>> threads.  When it will hit mainline I don't know.
>
> If you want 8 writing threads, and your md raid5 device is /dev/md0, you
> may have a try with,
>         echo 8 > /sys/block/md0/md/group_thread_cnt
>
>>
>>> This can reproduced by creating a raid5 with 4 ramdisks as well, and
>>> comparing performance on the array and one ramdisk. Sometimes the
>>> performance on the array is worse than a single ramdisk.
>>>
>>> The kernel version is 4.9.0-rc3 and mdadm is release 3.4, no write
>>> journal is configured.
>>>
>>> Is this a known issue?
>
> It was, but you are on 4.9 kernel, group_thread_cnt should work for you.
>
> Coly
>
