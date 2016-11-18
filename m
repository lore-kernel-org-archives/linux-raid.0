From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] raid5-cache: update superblock at shutdown/reboot
Date: Thu, 17 Nov 2016 17:41:51 -0800
Message-ID: <20161118014151.d6f3garrxovzrz66@kernel.org>
References: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com>
 <87wpg2heg8.fsf@notabene.neil.brown.name>
 <20161117181353.z7mgiynosyb664oc@kernel.org>
 <8760nlhd18.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8760nlhd18.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

On Fri, Nov 18, 2016 at 11:01:07AM +1100, Neil Brown wrote:
> On Fri, Nov 18 2016, Shaohua Li wrote:
> 
> > On Thu, Nov 17, 2016 at 04:18:15PM +1100, Neil Brown wrote:
> >> On Thu, Nov 17 2016, Shaohua Li wrote:
> >> 
> >> > Currently raid5-cache update superblock in .quiesce. But since at
> >> > shutdown/reboot, .quiesce is called with reconfig mutex locked,
> >> > superblock isn't guaranteed to be called in reclaim thread (see
> >> > 8e018c21da3). This will make assemble do unnecessary journal recovery.
> >> > It doesn't corrupt data but is annoying.  This adds an extra hook to
> >> > guarantee journal is flushed to raid disks.  And since this hook is
> >> > called before superblock update, this will guarantee we have a uptodate
> >> > superblock in shutdown/reboot
> >> 
> >> Hi.
> >> I don't quite follow some of the reasoning here.
> >> In particular, the ->stop_writes() that you have implemented
> >> does almost exactly the same thing as r5l_quiesce(1).
> >> So why not simply call ->quiesce(mddev, 1) in __md_stop_writes()??
> >> You probably need to also call ->quiesce(mddev, 0) to keep things
> >> balanced.
> >
> > reboot (md_notify_reboot) doesn't call .quiesce, maybe we should do though. And
> > in stop, we hold reconfig_mutex before calling .quiesce. And with commit
> > 8e018c21da3, r5l_write_super_and_discard_space tries to hold the reconfig_mutex
> > before write super, which it can't hold, so superblock write is skipped. After
> > .quiesce we don't write superblock. To fix the shutdown case, we can add a
> > superblock write after .quiesce. But I think it's more generic to add a
> > ->stop_writes since it will work for the reboot case.
> 
> I hadn't quite processed that this was about md_notify_reboot().
> I would be very wary of optimizing this code.  It should certainly avoid
> data loss, but anything more doesn't belong here.
> During a clean shutdown the array should be stopped properly.
> md_notify_reboot() is only meant for minimizing damaged caused by a
> hasty "reboot -f -n".

yep, this isn't the priority. So do you still suggest we ignore the reboot case
and add the journal flush after .quiesce() is called in stop?

> A "clean" shutdown currently includes systemd/mdadm.shutdown (in the
> mdadm package) running "mdadm --wait-clean --scan".
> "mdadm --wait-clean" changes the "safe_mode_delay" so that the array
> will become "clean" more quickly.
> Possibly we should add something to that to trigger a flush of the
> journal, and to wait for the flush to complete.

I'm not sure how we can do this. But adding a different state in 'array_state'
indicating journal isn't clean makes sense.

Thanks,
Shaohua
