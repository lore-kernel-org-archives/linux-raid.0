From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH v3] md linear: fix a race between linear_add() and
 linear_congested()
Date: Sun, 29 Jan 2017 14:39:11 +0800
Message-ID: <ecda9771-dc76-66e9-862a-e8b953d94a0b@suse.de>
References: <1485609109-23896-1-git-send-email-colyli@suse.de>
 <20170129014555.lgmk2ivste2xttxq@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170129014555.lgmk2ivste2xttxq@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Neil Brown <neilb@suse.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

On 2017/1/29 上午9:45, Shaohua Li wrote:
> On Sat, Jan 28, 2017 at 09:11:49PM +0800, colyli@suse.de wrote:
>> Recently I receive a bug report that on Linux v3.0 based kerenl, hot add
>> disk to a md linear device causes kernel crash at linear_congested(). From
>> the crash image analysis, I find in linear_congested(), mddev->raid_disks
>> contains value N, but conf->disks[] only has N-1 pointers available. Then
>> a NULL pointer deference crashes the kernel.
>>
>> There is a race between linear_add() and linear_congested(), RCU stuffs
>> used in these two functions cannot avoid the race. Since Linuv v4.0
>> RCU code is replaced by introducing mddev_suspend().  After checking the
>> upstream code, it seems linear_congested() is not called in
>> generic_make_request() code patch, so mddev_suspend() cannot provent it
>> from being called. The possible race still exists.
>>
>> Here I explain how the race still exists in current code.  For a machine
>> has many CPUs, on one CPU, linear_add() is called to add a hard disk to a
>> md linear device; at the same time on other CPU, linear_congested() is
>> called to detect whether this md linear device is congested before issuing
>> an I/O request onto it.
>>
>> Now I use a possible code execution time sequence to demo how the possible
>> race happens,
>>
>> seq    linear_add()                linear_congested()
>>  0                                 conf=mddev->private
>>  1   oldconf=mddev->private
>>  2   mddev->raid_disks++
>>  3                              for (i=0; i<mddev->raid_disks;i++)
>>  4                                bdev_get_queue(conf->disks[i].rdev->bdev)
>>  5   mddev->private=newconf
>>
>> In linear_add() mddev->raid_disks is increased in time seq 2, and on
>> another CPU in linear_congested() the for-loop iterates conf->disks[i] by
>> the increased mddev->raid_disks in time seq 3,4. But conf with one more
>> element (which is a pointer to struct dev_info type) to conf->disks[] is
>> not updated yet, accessing its structure member in time seq 4 will cause a
>> NULL pointer deference fault.
>>
>> To fix this race, there are 2 parts of modification in the patch,
>>  1) Add 'int raid_disks' in struct linear_conf, as a copy of
>>     mddev->raid_disks. It is initialized in linear_conf(), always being
>>     consistent with pointers number of 'struct dev_info disks[]'. When
>>     iterating conf->disks[] in linear_congested(), use conf->raid_disks to
>>     replace mddev->raid_disks in the for-loop, then NULL pointer deference
>>     will not happen again.
>>  2) RCU stuffs are back again, and use kfree_rcu() in linear_add() to
>>     free oldconf memory. Because oldconf may be referenced as mddev->private
>>     in linear_congested(), kfree_rcu() makes sure that its memory will not
>>     be released until no one uses it any more.
>> Also some code comments are added in this patch, to make this modification
>> to be easier understandable.
>>
>> This patch can be applied for kernels since v4.0 after commit:
>> 3be260cc18f8 ("md/linear: remove rcu protections in favour of
>> suspend/resume"). But this bug is reported on Linux v3.0 based kernel, for
>> people who maintain kernels before Linux v4.0, they need to do some back
>> back port to this patch.
>>
>> Changelog:
>>  - V3: add 'int raid_disks' in struct linear_conf, and use kfree_rcu() to
>>        replace rcu_call() in linear_add().
>>  - v2: add RCU stuffs by suggestion from Shaohua and Neil.
>>  - v1: initial effort.
>>
>> Signed-off-by: Coly Li <colyli@suse.de>
>> Cc: Shaohua Li <shli@fb.com>
>> Cc: Neil Brown <neilb@suse.com>
>> Cc: stable@vger.kernel.org
> Hi,
> 
> Happy new year! Applied, though I changed the format of comments. It should be:
> /*
>  * comments
>  */

I just use this comment format follow the existing comments in linear.c
file. OK I will follow the above format in future.

Thank you! And Happy New Year :-)

Coly
