From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] md linear: fix a race between linear_add() and
 linear_congested()
Date: Sat, 28 Jan 2017 01:32:23 +0800
Message-ID: <8bb96eef-64d9-9a3a-646e-2b0a1d553f0f@suse.de>
References: <1485342943-9330-1-git-send-email-colyli@suse.de>
 <20170125180258.fil35zckwtebysqr@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170125180258.fil35zckwtebysqr@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

On 2017/1/26 上午2:02, Shaohua Li wrote:
> On Wed, Jan 25, 2017 at 07:15:43PM +0800, colyli@suse.de wrote:
>> Recently I receie a report that on Linux v3.0 based kerenl, hot add disk
>> to a md linear device causes kernel crash at linear_congested(). From the
>> crash image analysis, I find in linear_congested(), mddev->raid_disks
>> contains value N, but conf->disks[] only has N-1 pointers available. Then
>> a pointer deference to a NULL pointer crashes the kernel.
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
> 
> Good catch, this makes a lot of sense. However, this looks like an incomplete
> fix. step 0 will get the old conf, after step 5, linear_add will free the old
> conf. So it's possible linear_congested() will use the freed old conf. I think
> this is more likely to happen. The easist fix maybe put rcu_lock in
> linear_congested and free the old conf in a rcu callback.

Yes, RCU is still necessary here, I just compose and send out the second
version.

Thanks for pointing out this :-)

Coly
