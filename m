From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: mdadm raid1 regression
Date: Mon, 22 Apr 2013 11:38:37 +0200
Message-ID: <5175051D.8040800@profitbricks.com>
References: <CACaajQv+HhzStC-U1RGz4ZWdn0-w4X3MyMM9GTJPOFeyrxtP3w@mail.gmail.com> <20130422083549.7c1cff84@notabene.brown> <CACaajQuq=rAvm-uJLyhv3ufP=R4WGeXef5o9Tdi3EvTuoX=YRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACaajQuq=rAvm-uJLyhv3ufP=R4WGeXef5o9Tdi3EvTuoX=YRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: NeilBrown <neilb@suse.de>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 22.04.2013 08:28, Vasiliy Tolstov wrote:
>> Why are you doing that?
> 
> Our storage have two nodes each provides disk via srp to nodes. On
> each node we create separate lvm (we not using clvm) and assemble md.
> Sometimes we resize lvm and need to zero superblock, becouse sometimes
> we can still have old mdadm data on lvm part (from previous user for
> example). And then we add disk to raid we can get sometimes broken
> data (invalid sync).
> 
>>
>>> P.S. If i use mdadm 3.2.2 i get data offset 4096 that not breaks data,
>>> but inconsistent with older versions.
>>
>> I suggest you use mdadm 3.2.2 then.
> 
> Yes, i'm already do that, but i think that lates mdadm version with
> data-offset patches can solve my problems. Is that possible to correct
> it behaviour and write in docs which data offset used in which version
> of mdadm?
> 
>>
>>> P.P.S. I'm try to specify --data-offset when create array but as i see
>>> - its ignored and data offset still have 8192).
>>
>> I'll try to make sure that works correctly for the next release.
>> Thanks for the report.

So you use MD RAID-1 on the SRP initiator for replication?

So do we. We've just hacked mdadm to always use one LV extent (4 MiB)
for the "head room" with RAID-1 and don't allow reshape of RAID-1
anymore. This makes it very easy to calculate. We had to change mdadm
and the MD kernel code anyway to provide advanced replication features.

We've even got safe VM live migration with it and raw-to-md migration
letting the MD syncer do the job to sync the data from the raw device to
the MD devices. :-)
Replication of virtual storage doesn't really work without custom
hacking with MD. This use case is very hard to merge with mainline
behavior. But the required changes are relatively small.

Cheers,
Sebastian
