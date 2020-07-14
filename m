From: Junxiao Bi <junxiao.bi@oracle.com>
Subject: Re: [PATCH] md: fix deadlock causing by sysfs_notify
Date: Tue, 14 Jul 2020 09:29:41 -0700
Message-ID: <23a115e4-0d48-9186-c606-89d526649372@oracle.com>
References: <20200709233545.67954-1-junxiao.bi@oracle.com>
 <CAPhsuW7seCUnt3zt6A_fjTS2diB7qiTE+SZkM6Vh=G26hdwGtg@mail.gmail.com>
 <de97a2c1-fba0-5276-7748-f0155088ad0d@oracle.com>
 <CAPhsuW4GQK7hS4AOpJJ1mEE8gbFgo+n+XCQ2fvW94QnZhA6ivQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPhsuW4GQK7hS4AOpJJ1mEE8gbFgo+n+XCQ2fvW94QnZhA6ivQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Song Liu <song@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On 7/14/20 9:18 AM, Song Liu wrote:

> On Mon, Jul 13, 2020 at 11:41 PM Junxiao Bi <junxiao.bi@oracle.com> wrote:
>> On 7/13/20 11:17 PM, Song Liu wrote:
>>
>>> On Thu, Jul 9, 2020 at 4:36 PM Junxiao Bi <junxiao.bi@oracle.com> wrote:
>>>> The following deadlock was captured. The first process is holding 'kernfs_mutex'
>>>> and hung by io. The io was staging in 'r1conf.pending_bio_list' of raid1 device,
>>>> this pending bio list would be flushed by second process 'md127_raid1', but
>>>> it was hung by 'kernfs_mutex'. Using sysfs_notify_dirent_safe() to replace
>>>> sysfs_notify() can fix it. There were other sysfs_notify() invoked from io
>>>> path, removed all of them.
>>>>
>>> [...]
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
>>> Thanks for the patch. It looks good in general. One question though, do we
>>> need the same change the following line in md.c:level_store()?
>>>
>>>       sysfs_notify(&mddev->kobj, NULL, "level");
>> Thanks for the review. This one is not in io path, looks it's safe. I
>> can change it if you want to align it with others.
> This one is the only leftover. Let's also change it.

Sure, i will send a v2.

Thanks,

Junxiao.

>
> Thanks,
> Song
