From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] md linear: fix a race between linear_add() and
 linear_congested()
Date: Sat, 28 Jan 2017 01:45:46 +0800
Message-ID: <fe4e5004-3cf4-f3a7-7741-8aa3e4e4ccb5@suse.de>
References: <1485342943-9330-1-git-send-email-colyli@suse.de>
 <20170125180258.fil35zckwtebysqr@kernel.org>
 <8737g6vg7r.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737g6vg7r.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, stable@vger.kernel.org
List-Id: linux-raid.ids

On 2017/1/26 上午8:04, NeilBrown wrote:
> On Wed, Jan 25 2017, Shaohua Li wrote:
> 
>> On Wed, Jan 25, 2017 at 07:15:43PM +0800, colyli@suse.de wrote:
>>> Recently I receie a report that on Linux v3.0 based kerenl, hot
>>> add disk to a md linear device causes kernel crash at
>>> linear_congested(). From the crash image analysis, I find in
>>> linear_congested(), mddev->raid_disks contains value N, but
>>> conf->disks[] only has N-1 pointers available. Then a pointer
>>> deference to a NULL pointer crashes the kernel.
>>> 
>>> There is a race between linear_add() and linear_congested(),
>>> RCU stuffs used in these two functions cannot avoid the race.
>>> Since Linuv v4.0 RCU code is replaced by introducing
>>> mddev_suspend().  After checking the upstream code, it seems
>>> linear_congested() is not called in generic_make_request() code
>>> patch, so mddev_suspend() cannot provent it from being called.
>>> The possible race still exists.
>>> 
>>> Here I explain how the race still exists in current code.  For
>>> a machine has many CPUs, on one CPU, linear_add() is called to
>>> add a hard disk to a md linear device; at the same time on
>>> other CPU, linear_congested() is called to detect whether this
>>> md linear device is congested before issuing an I/O request
>>> onto it.
>>> 
>>> Now I use a possible code execution time sequence to demo how
>>> the possible race happens,
>>> 
>>> seq    linear_add()                linear_congested() 0
>>> conf=mddev->private 1   oldconf=mddev->private 2
>>> mddev->raid_disks++ 3                              for (i=0;
>>> i<mddev->raid_disks;i++) 4
>>> bdev_get_queue(conf->disks[i].rdev->bdev) 5
>>> mddev->private=newconf
>> 
>> Good catch, this makes a lot of sense. However, this looks like
>> an incomplete fix. step 0 will get the old conf, after step 5,
>> linear_add will free the old conf. So it's possible
>> linear_congested() will use the freed old conf. I think this is
>> more likely to happen. The easist fix maybe put rcu_lock in 
>> linear_congested and free the old conf in a rcu callback.
> 
> We used to use kfree_rcu() but removed it in
> 
> Commit: 3be260cc18f8 ("md/linear: remove rcu protections in favour
> of suspend/resume")
> 
> when we changed to suspend/resume the device.  That stops all IO,
> but doesn't stop the ->congested call.
> 
> So we probably should re-introduce kfree_rcu() to free oldconf. It
> might also be good to store a copy of raid_disks in linear_conf,
> like we do with r5conf, the ensure we never us inconsistent 
> ->raid_disks and ->disks[]

Hi Neil,

I just send out v2 patch which adds RCU stuffs back. I test it on my
small server, it survives.

Once thing I want to confirm here is the memory barrier in linear_add().

219         mddev_suspend(mddev);
220         oldconf = rcu_dereference(mddev->private);
221         rcu_assign_pointer(mddev->private, newconf);
222         smp_mb();
223         mddev->raid_disks++;
224         md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
225         set_capacity(mddev->gendisk, mddev->array_sectors);
226         mddev_resume(mddev);
227         revalidate_disk(mddev->gendisk);
228         call_rcu(&oldconf->rcu, free_conf);

At LINE 222, I add a smp_mb(), from Documentations/memory-barrier.txt,
my understand is here I need a smp_wmb() or smp_mb(). I see other
places all use smp_mb() so I choose the stronger one -- smp_mb().

But from Documentation/whatisRCU.txt, it says about
rcu_assign_pointer(): "This function returns he new value, and also
executes any memory-barrier instructions required for a given CPU
architecture." So it seems smp_mb() at LINE 222 is unnecessary.

In v2 patch, I keep smp_mb() although I think it is unnecessary. I
will remove it if you or Shaohua may confirm it is unncessary as I think.


Another question is, I try to look at the code about r5conf, but I
still have no idea how to store a copy of r5conf. Could you please to
give me more hint ?

Thanks.

Coly
