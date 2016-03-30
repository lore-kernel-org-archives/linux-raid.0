From: Shaohua Li <shlikernel@gmail.com>
Subject: Re: Unable to handle kernel NULL pointer dereference in super_written
Date: Wed, 30 Mar 2016 10:16:37 -0700
Message-ID: <56FC09F5.20609@gmail.com>
References: <678678296.35099303.1459240762496.JavaMail.zimbra@redhat.com>
 <538658018.35237734.1459254120634.JavaMail.zimbra@redhat.com>
 <20160329213731.GA2287@kernel.org> <56FB3B2A.9030405@suse.com>
Reply-To: shli@kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56FB3B2A.9030405@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>, Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes.Sorensen@redhat.com, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids



On 03/29/2016 07:34 PM, Guoqing Jiang wrote:
>
>
> On 03/30/2016 05:37 AM, Shaohua Li wrote:
>> On Tue, Mar 29, 2016 at 08:22:00AM -0400, Xiao Ni wrote:
>>> Hi all
>>>
>>> I encountered one NULL pointer dereference problem.
>>>
>>> The environment=EF=BC=9A
>>> latest linux-stable and mdadm codes
>>> aarch64 platform
>>> the md device is created with loop devices
>>>
>>> It's a test case to check date integrity. I added the test script a=
s=20
>>> the attachment.
>> Could you please try this patch:
>>
>>
>>  From b86d9e1724184c79ad1ea63901aec802492b861c Mon Sep 17 00:00:00 2=
001
>> Message-Id:=20
>> <b86d9e1724184c79ad1ea63901aec802492b861c.1459285706.git.shli@fb.com=
>
>> From: Shaohua Li <shli@fb.com>
>> Date: Tue, 29 Mar 2016 14:00:19 -0700
>> Subject: [PATCH] MD: add rdev reference for super write
>>
>> md_super_write() and corresponding md_super_wait() generally are cal=
led
>> with reconfig_mutex locked, which prevents disk disappears.
>
> Just for curious, I find several paths maybe also don't hold=20
> reconfig_mutex,
> take the followings as example.
>
> 1.  md_run -> md_update_sb -> md_super_write/md_super_wait
> 2.  rdev_size_store -> rdev_size_change -> md_super_write/md_super_wa=
it
we do mddev_lock/unlock calling these. The rdev_size_sotre is a bit=20
tricky. the lock is hold in rdev_attr_store

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
