From: David R <david@unsolicited.net>
Subject: Re: [MD] Crash with 4.12+ kernel and high disk load -- bisected to
 4ad23a976413: MD: use per-cpu counter for writes_pending
Date: Tue, 08 Aug 2017 06:55:26 +0000
Message-ID: <20170808065526.Horde.9rrpLi3TCaOrBk9KfEU4ZFP@vinovium.com>
References: <ee7921d2-d3ff-2381-1f05-2c07b8001d08@unsolicited.net>
 <c2df7906-67b2-b33f-0e82-49e6ef53f5f1@unsolicited.net>
 <20170807112025.GA3094@light.dominikbrodowski.net>
 <20170808045103.xpi32xkjidjuxczq@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170808045103.xpi32xkjidjuxczq@kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>, NeilBrown <neilb@suse.com>, Shaohua Li <shli@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Quoting Shaohua Li <shli@kernel.org>:

> Spent some time to check this one, unfortunately I can't find how that patch
> makes rcu stall. the percpu part looks good to me too. Can you  
> double check if
> reverting 4ad23a976413aa57 makes the issue go away? When the rcu  
> stall happens,
> what the /sys/block/md/md0/array_state? please also attach /proc/mdstat. When
> you say the mdx_raid1 threads are in 'R' state, can you double check if the
> /proc/pid/stack always 0xffffffffff?
>
> Thanks,
> Shaohua

I confess to knowing absolutely nothing about the md code, so please  
don't be too hard on me. However
:-

static bool set_in_sync(struct mddev *mddev)
{
     WARN_ON_ONCE(!spin_is_locked(&mddev->lock));
     if (!mddev->in_sync) {
         mddev->sync_checkers++;
         spin_unlock(&mddev->lock);
         percpu_ref_switch_to_atomic_sync(&mddev->writes_pending);
         spin_lock(&mddev->lock);
         if (!mddev->in_sync &&
             percpu_ref_is_zero(&mddev->writes_pending)) {
             mddev->in_sync = 1;
             /*
              * Ensure ->in_sync is visible before we clear
              * ->sync_checkers.
              */
             smp_mb();
             set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
             sysfs_notify_dirent_safe(mddev->sysfs_state);
         }
         if (--mddev->sync_checkers == 0)
             percpu_ref_switch_to_percpu(&mddev->writes_pending);


The switch_to_percpu() takes place under mddev->lock however  
switch_to_atomic_sync() does not. A thread can be in the middle of (or  
about to execute) switch_to_atomic_sync() at the same time as another  
is calling switch_to_percpu(). This can't be correct surely?

Cheers
David
