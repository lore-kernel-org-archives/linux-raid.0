From: Vasiliy Tolstov <v.tolstov@selfip.ru>
Subject: Re: mdadm raid1 regression
Date: Mon, 22 Apr 2013 10:28:37 +0400
Message-ID: <CACaajQuq=rAvm-uJLyhv3ufP=R4WGeXef5o9Tdi3EvTuoX=YRw@mail.gmail.com>
References: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com>
 <20130422083549.7c1cff84@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130422083549.7c1cff84@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2013/4/22 NeilBrown <neilb@suse.de>:
>> Hello. I'm using linux 3.8.6 and mdadm 3.2.6 (from git).
>> I have many raid1 arrays that have data offset 2048 (metadata 1.2,
>> created with various mdadm versions but mostly 3.2.1 on linux 2.6.32).
>> If i create raid1 with never mdadm on 3.8.6 i have data offset 8192?? Why?
>
> More room for various useful things.
> In particular, if you one day want to convert this raid1 to a raid5, then
> having a bit of extra space at the front will mean you can avoid a 'backup
> file' and all the problems they cause (code for this isn't quite ready, but
> is getting there).
>

Very good news =)

>>
>> My problem:
>> Sometimes i'm doing mdadm --zero-superblock on both parts of array and
>> re-create it. On older systems i have no errors. On new (linux 3.8.6
>> and mdadm 3.2.6) i get corrupted ext3 fs and partition table. Why this
>> happening?
>
> Why are you doing that?

Our storage have two nodes each provides disk via srp to nodes. On
each node we create separate lvm (we not using clvm) and assemble md.
Sometimes we resize lvm and need to zero superblock, becouse sometimes
we can still have old mdadm data on lvm part (from previous user for
example). And then we add disk to raid we can get sometimes broken
data (invalid sync).

>
>> P.S. If i use mdadm 3.2.2 i get data offset 4096 that not breaks data,
>> but inconsistent with older versions.
>
> I suggest you use mdadm 3.2.2 then.

Yes, i'm already do that, but i think that lates mdadm version with
data-offset patches can solve my problems. Is that possible to correct
it behaviour and write in docs which data offset used in which version
of mdadm?

>
>> P.P.S. I'm try to specify --data-offset when create array but as i see
>> - its ignored and data offset still have 8192).
>
> I'll try to make sure that works correctly for the next release.
> Thanks for the report.
>
> NeilBrown

Thanks!

P.S. Very big thanks for all.


--
Vasiliy Tolstov,
e-mail: v.tolstov@selfip.ru
jabber: vase@selfip.ru
