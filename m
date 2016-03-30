From: Shaohua Li <shlikernel@gmail.com>
Subject: Re: Unable to handle kernel NULL pointer dereference in super_written
Date: Wed, 30 Mar 2016 10:27:19 -0700
Message-ID: <56FC0C77.7000006@gmail.com>
References: <678678296.35099303.1459240762496.JavaMail.zimbra@redhat.com>
 <538658018.35237734.1459254120634.JavaMail.zimbra@redhat.com>
 <20160329213731.GA2287@kernel.org>
 <2075551491.35783408.1459323893191.JavaMail.zimbra@redhat.com>
Reply-To: shli@kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2075551491.35783408.1459323893191.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids



On 03/30/2016 12:44 AM, Xiao Ni wrote:
>
> ----- Original Message -----
>> From: "Shaohua Li" <shli@kernel.org>
>> To: "Xiao Ni" <xni@redhat.com>
>> Cc: "linux-raid" <linux-raid@vger.kernel.org>, "Jes Sorensen" <Jes.S=
orensen@redhat.com>, "Neil Brown" <neilb@suse.de>
>> Sent: Wednesday, March 30, 2016 5:37:31 AM
>> Subject: Re: Unable to handle kernel NULL pointer dereference in sup=
er_written
>>
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
s the
>>> attachment.
>> Could you please try this patch:
> Thanks for the patch, I'm running test and will give the result. It n=
eed to run
> more than 300 iterations to reproduce this.
>
>>
>>  From b86d9e1724184c79ad1ea63901aec802492b861c Mon Sep 17 00:00:00 2=
001
>> Message-Id:
>> <b86d9e1724184c79ad1ea63901aec802492b861c.1459285706.git.shli@fb.com=
>
>> From: Shaohua Li <shli@fb.com>
>> Date: Tue, 29 Mar 2016 14:00:19 -0700
>> Subject: [PATCH] MD: add rdev reference for super write
>>
>> md_super_write() and corresponding md_super_wait() generally are cal=
led
>> with reconfig_mutex locked, which prevents disk disappears. There is=
 one
>> case this rule is broken. write_sb_page of bitmap.c doesn't hold the
>> mutex. next_active_rdev does increase rdev reference, but it decreas=
es
>> the reference too early (eg, before IO finish). disk can disappear a=
t
>> the window. We unconditionally increase rdev reference in
>> md_super_write() to avoid the race.
> In the path hot_remove_disk, the write_sb_page is protected by reconf=
ig_mutex.
> It shouldn't submit bio to the leg which is already set FAULTY. Could=
 you give
> an example to show how the buy happen?

Not sure if I understand your question correctly, but I try to answer.=20
When a disk is reported faulty with md_error we don't immediately remov=
e=20
the disk as there is risk for example some IO is running in the rdev. W=
e=20
increase rdev reference in every IO and decrease the reference after IO=
=20
finishes. You can find this in raid5.c for example. We only delete the=20
rdev after the reference is 0, please see remove_and_add_spares(). So=20
it's possible you will find disk with FAULTY set, but it's still in rde=
v=20
list.

Thanks,
Shaohua
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
