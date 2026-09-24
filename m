Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3535A424646
	for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271462; cv=none; b=TEIaCdBJ/WlppKAvZ3R7Zcvn8LcDJVSu18v7+YPWfNKxFeXPrn9qLMHgzbdJSwVQJR4vEfGPUVelQdQ0KjpfJzR0wewPs+lTqTLsNLk+QhfLKXK1XCzPAQbjWGqOPz8LtK0i6GLkHCkj6+8cmDPOjvz+qHPgm2CqLcJHkgQg4eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271462; c=relaxed/simple;
	bh=aj2d3OSao+UaqswEDrqL5bouRiG7jwSPZJvYY+D2k+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ujMgeWkSCyNd+O0hyZxJZRfwMWNCeV/T4rtWQioghyjv1SXbeX3NKsNkPclteAIdBZKJU47GjMwum0+4CHkN9KtGS7cbA5V/HbgBm/A3LxEk7uSw2Ka6ihkJUnEfHE/mZGxFCVX/L5vqAiUdmYy4pQkou+gk59d7mbXhAXEjupU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S1bRWFDj; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sqcIP5T1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S1bRWFDj";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sqcIP5T1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790271458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wHr1XZo3p6JDDieh2+NCQqs4GvsEpee7uL3Fjk8vbNI=;
	b=S1bRWFDjhGr2JWH+lIgx82C+bcFLu5Wopzv1sIzvaHIVwDk2qZ456Nb8A/64SB6NiN8qBE
	qOPvxr3QvlW37U+4ae7lQBf6aE7D6qmPIjCtretG3fT5rCXkhTR7QOzYFIWgSBLIOh1ZQY
	w+8/2yfIV/zzN57xldWwtXdNupO88/Y=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-pyWLdvuQNs2ERDX3ywKliA-1; Thu, 24 Sep 2026 13:37:37 -0400
X-MC-Unique: pyWLdvuQNs2ERDX3ywKliA-1
X-Mimecast-MFC-AGG-ID: pyWLdvuQNs2ERDX3ywKliA_1790271457
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a00c70d28so7640485a.0
        for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 10:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790271457; x=1790876257; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wHr1XZo3p6JDDieh2+NCQqs4GvsEpee7uL3Fjk8vbNI=;
        b=sqcIP5T1z/8kZR/sD0e2i2ucka+DawvOYKeYgMjhMjbDdwNN2JhxdETo7IUxq2Bxwc
         qd6QctOQz2dFwfiMCLB89Yj1IkfiGKSW7FK3/kfl2qVswC6HMYeorDMjGwUNLrBiFjPI
         /kStVcJIzzsGcO8RUKW55o/w6cpbTpTh+EWPjMenkLN2T5kB9sZarmed7zVqOXnRI/Tx
         wqc3+CKZI+spJ+5NT0DfVGo8a8XSZintYPviniUnJKQL87fRdun0E8c5mCjIefPPCT7P
         LaNmS/Mi+3V30nQj0lc1iyucg5xAS2ZzI95HprUI6uLrmYCaTyptZqMJCM6nYR4sMhFl
         /Iqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790271457; x=1790876257;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wHr1XZo3p6JDDieh2+NCQqs4GvsEpee7uL3Fjk8vbNI=;
        b=H3KUurtwoBZcoStOqhjfwiNT5TW+3+GXOhwVqg8uEICmp75giAYcBqm5nM+v+r0c4s
         ZABzH6yDhDpMM+FWxrboQkhzxrAeom5w2DWvicV2BulgZMlFgsAB7+rzkznOH8TjoSng
         F5Yxv7Y7LorSH8fwu7ylhdflTE4FBPhJcNEH6UvaubcHF7Y0BZ7XNsqpLvAHaSKIsrWE
         MYk/q4KUCmGIjAJ7ectDyWsEgei6HWRHNWPFqC/o/NareN6kwzmqf+OqBA903pLFHFWF
         rvCXl+tP0VB8gWrCd0aoylUmU3uYCYaV5x77HsjF3cxBSgNCDg96Z0HykmD6x1ph3PuK
         yGOA==
X-Gm-Message-State: AFuF++m/myQsx45qZZ0wloHYdTS8rCJ5cR9k46g5RfrjfUfSiPR5KdNl
	2vKTe25GWk/bPDs3Vr65FhC1n3i8ytwA3PY/pBcQfsL4a9a8sPXdf0N/xwwpydahIEMLOMwQydz
	ODWMaVtkN9X8T4D920nWXGE81jzrA/+hvbK/D6vR1zaaN5Bqa3xeHwA/Z8JaSPKN/0uCno/Q=
X-Gm-Gg: AYBFou3qVsdjI2rDonniceZEqn/pgmjXl39ZWSwjQzrN5etChEqBxIj5kv9gF6xZdb6
	t6yUWMvhpAYb6jTMlkqxvXeZlyMT8Y5BETuT0eVBM94OsB3A+gTUJgblV/T58mb0nqyGaVnuxDj
	hwijDZAuHE94s59y9UlD4MMdS9to0hzjS0Ya2CMyV2d4WlGWKnSDznvMZHDQzukuTSRufCv0TKg
	eSSGmojdcffyRETceHraqOV+kpvy3JTovwbMXxHthbePJmJbM+ED38TBeh1dh4s23s+2qbsZeal
	ZPyilsKrsWU3PUmYtLJ49Tm1igklQtHkimnX0hiMudH1EDDMlLCwA8akZ7xDy5Fjj9R56kTbHpt
	Tdy/yUKCbQ4d6wCCrJt4JFNW0k38475rkE8h5F0upAMrHgZU0j7h0d3/PyA==
X-Received: by 2002:a05:620a:c41:b0:939:ab43:77a1 with SMTP id af79cd13be357-93c3625d784mr367104585a.6.1790271456831;
        Thu, 24 Sep 2026 10:37:36 -0700 (PDT)
X-Received: by 2002:a05:620a:c41:b0:939:ab43:77a1 with SMTP id af79cd13be357-93c3625d784mr367098385a.6.1790271456062;
        Thu, 24 Sep 2026 10:37:36 -0700 (PDT)
Received: from vdo-obuilder-bjohnston.permabit.com (nat-pool-rdu-t.redhat.com. [66.187.233.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248cf620sm512451185a.43.2026.09.24.10.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 10:37:35 -0700 (PDT)
Date: Thu, 24 Sep 2026 13:37:25 -0400
From: Bruce Johnston <bjohnsto@redhat.com>
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 2/4] md: Handle pers->run failure in level_store
Message-ID: <arVf1YyRKFGFqRxV@vdo-obuilder-bjohnston.permabit.com>
References: <20260923112159.94175-1-chengzhihao1@huawei.com>
 <20260923112159.94175-3-chengzhihao1@huawei.com>
 <arQdkcalhtK5ySUz@vdo-obuilder-bjohnston.permabit.com>
 <8f71a698-d073-105e-ab19-2fc2a196faf0@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f71a698-d073-105e-ab19-2fc2a196faf0@huawei.com>

One of the things I have been looking at is how dm-raid does takeover.
As you might expect, it behaves much differently than how md.c does
takeover. In the case of dm-raid, it basically builds up a brand new
array from scratch that is read_only and frozen. This is all done in the
raid_ctr function in dm-raid.c. Then when you want to swap, you
basically suspend the old array, do the appropriate swap code and then
turn the new array to read write and unfreeze the threads.
pers->takeover is never called in this scenario as far as I can tell,
but pers->run is through a call to md_run, but because the threads are
frozen, no I/O happens until the swap is done.  

I'm not saying this is the correct model to follow here, but
it does possibly suggest we might be able to do something similar in
terms of sharing resources.  

I know this is not as easy problem to solve and any fix may require
extensive changes, but I feel like we should try to solve this now
before things become more complicated. 

On Thu, Sep 24, 2026 at 07:53:50PM +0800, Zhihao Cheng wrote:
> 在 2026/9/24 2:42, Bruce Johnston 写道:
> Hi Bruce,
> > Hi. I've been looking into takeover for a little while as well. I was
> > planning to write up something to post into the mailing list about it
> > but say your submission and figured I would mention it here. I believe
> > just handling a failure in pers->run is insufficient to fixing takeover
> > errors.
> > 
> > IMO the contract for level_store should be that if something fails, we
> > end up where we were before the function was called. So if we try to go
> > from 1->5 and something fails, we are back at a working valid level 1.
> Indeed, this is the most correct implementation for users, the level_store
> operation should be atomic, and my patch is just a simple workaround
> implementation.
> > 
> > The current level_store function roughly does the following:
> > 1. Suspend & Validate: Suspends the mddev device and performs initial
> >     validation checks.
> > 2. Takeover: Invokes pers->takeover().
> > 3. Swap Personality: Swaps the array to the new RAID personality.
> > 4. Free Old State: Frees the old personality configuration and internal
> >     information.
> > 5. Update sysfs fields from old to new
> > 6. Run Personality: Calls pers->run to initialize the new RAID
> >     personality.
> > 7. Resume Device: Resumes the mddev device.
> > 
> > By the time we get to run, we have swapped and free'd the old
> > personality.
> > 
> > The code in md_run around pers->run cleanup is reasonable because if
> > something fails, the array isn't started. You can't really do anything
> > after that. But in takeover, on a failed run, we're now in a state where
> > we have a half swapped personality. How do we recover from that? Are we
> > just going to stop the array?
> > 
> > There are also additional issues in level_store where the personality
> > functions like pers->takeover do things like remove unsupported flags
> > from the mddev based on the new personality but never repair them on
> > failures.
> > 
> > I've been investigating possible takeover failure solutions but none of
> > them are easy. For example, we could try creating a new mddev at the
> > start of level_store and using that for the pers->foo calls but there
> > are a lot of shared resources so it becomes tricky.
> 
> Separating shared resources (eg. private, thread, bitmap, all_mddevs, etc.)
> is a trivial and error-prone task, and we need to have a clear understanding
> of the lifecycle of these shared resources.
> 
> > We could try
> > something like an undo log (each change tell how to undo itself) but
> > that would need to be passed into the personality functions or attached
> > to the mddev.
> 
> The undo log solution will also bring significant changes, and maintaining
> the newly added level_store process in the future will be relatively
> difficult.
> 
> So far, I cannot find a more suitable solution.
> > 
> > Should we have a discussion on this issue? I feel like we have
> > some holes here that need fixing.
> > 
> > On Wed, Sep 23, 2026 at 07:21:56PM +0800, Zhihao Cheng wrote:
> > > Set 'raid_disks' after raid5_run() failure will trigger an
> > > null-ptr-deref problem:
> > >   BUG: kernel NULL pointer dereference, address: 0000000000000038
> > >   RIP: 0010:raid5_check_reshape+0xad
> > >   Call Trace:
> > >    update_raid_disks+0x124
> > >    raid_disks_store+0x145
> > >    md_attr_store+0xd7
> > >    sysfs_kf_write+0x7c
> > > 
> > > The trigger process is simple:
> > >   mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
> > >   --force --assume-clean # create raid1
> > >   echo 5 > /sys/block/md0/md/level
> > >    level_store
> > >     mddev->pers = pers
> > >     mddev->private = priv
> > >     raid5_run
> > >      fail to abort (eg. raid5_create_ctx_pool fails)
> > >      mddev->private = NULL
> > >   echo 10 > /sys/block/md0/md/raid_disks
> > >    raid_disks_store
> > >     if (mddev->pers) // true
> > >      update_raid_disks
> > >       raid5_check_reshape
> > >        conf = mddev->private
> > >         conf->algorithm = mddev->new_layout // null-ptr-deref !
> > > 
> > > Similar process exists in do_md_stop->__md_stop_writes->raid5_quiesce.
> > > Similar process exists in raid10 too.
> > > 
> > > Fix it by handling the error from pers->run, next active-type order will
> > > restart the mddev.
> > > 
> > > Fixes: 245f46c2c221e ("md: add ->takeover method to support changing the personality managing an array")
> > > Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> > > ---
> > >   drivers/md/md.c | 29 ++++++++++++++++++++++++++++-
> > >   1 file changed, 28 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 02798f2dbf0e..ff78bf8656ff 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -97,6 +97,7 @@ static struct workqueue_struct *md_misc_wq;
> > >   static int remove_and_add_spares(struct mddev *mddev,
> > >   				 struct md_rdev *this);
> > >   static void mddev_detach(struct mddev *mddev);
> > > +static void __md_stop(struct mddev *mddev);
> > >   static void export_rdev(struct md_rdev *rdev);
> > >   static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
> > > @@ -4243,7 +4244,33 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
> > >   		mddev->in_sync = 1;
> > >   		timer_delete_sync(&mddev->safemode_timer);
> > >   	}
> > > -	pers->run(mddev);
> > > +	rv = pers->run(mddev);
> > > +	if (rv) {
> > > +		/*
> > > +		 * ->run() has released the private data of the new personality,
> > > +		 * while the old one has already been released as well. There is
> > > +		 * nothing to fall back to, so stop the array to avoid leaving
> > > +		 * 'mddev->pers' pointing to a personality which has no private
> > > +		 * data, and reminds user to try to active the mddev again.
> > > +		 */
> > > +		pr_warn("md: %s: failed to run %s after takeover, please try to active\n",
> > > +			mdname(mddev), pers->head.name);
> > > +		if (mddev->pers->sync_request && mddev->to_remove == NULL)
> > > +			mddev->to_remove = &md_redundancy_group;
> > > +		if (md_bitmap_enabled(mddev, true))
> > > +			mddev->bitmap_ops->flush(mddev);
> > > +		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
> > > +		mddev_destroy_serial_pool(mddev, NULL);
> > > +		__md_stop(mddev);
> > > +		rdev_for_each(rdev, mddev)
> > > +			if (rdev->raid_disk >= 0)
> > > +				sysfs_unlink_rdev(mddev, rdev);
> > > +		set_capacity_and_notify(mddev->gendisk, 0);
> > > +		mddev->changed = 1;
> > > +		md_new_event();
> > > +		sysfs_notify_dirent_safe(mddev->sysfs_state);
> > > +		goto out_unlock;
> > > +	}
> > >   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> > >   	if (!mddev->thread)
> > >   		md_update_sb(mddev, 1);
> > > -- 
> > > 2.52.0
> > > 
> > > 
> > 
> > 
> > .
> > 
> 

