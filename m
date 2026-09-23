Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF3A364EBF
	for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 18:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790188954; cv=none; b=q+squgV/hAlt1A2LrtLBFfUYk3hH4QfDtiBZyoXQ9TUtt/sKTOkO3z+fpdDowHgBue1MdkbKGWqJ+QNC4pn/S+dJbSFh2OsxM3eBnxwC/unNiGrrfNHKh71j2MJW6KmMc+nN5KjTCRZfwIAWFz6qKm5WHIjUnpTEA04HiArMyRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790188954; c=relaxed/simple;
	bh=6vSr8iHLVTCdGCuBykWORp6fuGHRtdK34+k0mRKUABE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0/I/EkVHP17ZftWhsWM7GowE5yAu6FdL9c0YH8WaRwMn8YZOtlT7AZOc7wVIuC8sJxpRS+5sxd26EMY0+AUOwhfPFeVTmEOSp5KGBqxpPaOK0uXQEf2CgqWMmFQP1brAWhDre3E/thVxsEccIUF4OiILTiCDgfvYJjFkeCY3e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JVw9Voy5; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l8srrI7T; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JVw9Voy5";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l8srrI7T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790188950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y5icEL/yh2v8hZ+Ai3DhoLE6wiyYETJEd/KmVs15zCY=;
	b=JVw9Voy5g8YZU57rvsBMuMBhijg4r/U1w9viL6kXWWH9XV6qGJKJwSKStYBBTWAYl/bnNn
	yzN7MyjPVtCuG4NMMlemsLqFGlcgcxXc7CJxwS//dr90qEujsoy5kig/mJ8K8ULw7CZTWY
	hH/iDKdMqlynzqQpmZAebxv4F8wFw6M=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-NUlJlqX7O824cOBSVleThg-1; Wed, 23 Sep 2026 14:42:29 -0400
X-MC-Unique: NUlJlqX7O824cOBSVleThg-1
X-Mimecast-MFC-AGG-ID: NUlJlqX7O824cOBSVleThg_1790188949
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a0b66ecd9so152407285a.2
        for <linux-raid@vger.kernel.org>; Wed, 23 Sep 2026 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790188949; x=1790793749; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y5icEL/yh2v8hZ+Ai3DhoLE6wiyYETJEd/KmVs15zCY=;
        b=l8srrI7TUjjsLtIzUHqG+cW+2j/jcmlwJuI1VFDwVOYC9c8w/XoDLSZ8SMHlEv5e+4
         eN5TfEXiJ1ZST9P61xYYf122WY15yUdFQ7+v/pM5WUvJ7/rZimyzCaR3KA++Prce6mxV
         poF1hBCeOVY5ii1Y+bNSZ2qsgOZp4Vhx5RPGYh0TR0PgLWHi2YScf65CNqXfCmrstMtu
         rrk29akFnuTAoPlxJjj+BAtUUAh1UahUXhldoAwtDh64d40TuQoQMn14+Q2zXLv9KBUT
         hzWVi/hlV/0fWe1zMStcz7CXSC9g0+oQygnOnjJTr06wLV13GeSnRE3TI0+Q4daCSuDd
         TKaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790188949; x=1790793749;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y5icEL/yh2v8hZ+Ai3DhoLE6wiyYETJEd/KmVs15zCY=;
        b=r7Ft/k+jWC5NgqWGEcKLDkYwdnxaUGCfLeBGWB9tdFGP/Og07QFqXjzHCcoaTJT9iB
         BUJbSxXmPuTQCIIv3eXl+g+SJrzvJkMictDcKB4uV2WjwVRBPtY0u0lzFh6Z5+Tl66qc
         fgO1d+qmgxkZnUy8faorIaXSfx/50B48BaRX9hOcKiawI4MIEoFEyZRwhluknnH6wGyS
         IIajTh/fZvuxBBevh5eTz4lQ9n6aeQ9XuoCxuHXCFbcx8nfuDs7FVoOk+F41dGZTAeZS
         rcY04FqbO0t5QRnFyy+ya38R6Si6grK3o0mDmxbn/LJBcPP7yFJI7FU5PJhpN52AqQ6A
         F1FA==
X-Gm-Message-State: AFuF++loPqGUa/glOViTB198biVK/ogqBzp4qe7cMtP9bGJIonG63qfO
	ghXeusAunnmeFM7ykkbG+LSCPc1NgFaXWs7mhBNSKuo2NayyuGBl4grjDStSNvOIDnUpVT/CkrH
	EpK4q0kkyLpRkScCivt/Lv60Hgky6isvDVo95NL+9ROPdU3I9CCvPyq3Swq+a+kM+UDesuGY=
X-Gm-Gg: AYBFou3DlKiHlQfx0GUbA3rV3jHrpBtndyrpsmLahNx9DWdisMGP/OQ1DL2LpWO5sI5
	fv/xxxX5zpd8G746QvBZhVuSGa7zhTBFdveIQfbOo/l6xaUctGJOErfWceLpv/Q/4UhYkQOP0i0
	P9VWWS31WjkhtLMDfxwuw09wsyTXw9jvhtWzn42NyPSJvnSTG+tJfzyICzVgjsA8s/cs6YgA/1B
	bGYgbNMueb5d+kz9G2ecQyPaVuTs3poWrOO89itus8mIUmdtW1zSHJwsXLK623zmT8Ap46elO29
	DDz89ISoNVavLEJ9Mn4oYzdS1emr+E6x7TWVVIFplXXtoz1WGPvDsh/QoipPLv4XtO9GHj8PT+o
	U3etlhTSCTB9SbSsPisGYrjjWuqSorQWmFam87jFzxKPBw0h4StYwcTy3Iw==
X-Received: by 2002:a05:620a:4145:b0:93b:d79a:c465 with SMTP id af79cd13be357-93c3480db85mr688885a.61.1790188948556;
        Wed, 23 Sep 2026 11:42:28 -0700 (PDT)
X-Received: by 2002:a05:620a:4145:b0:93b:d79a:c465 with SMTP id af79cd13be357-93c3480db85mr686085a.61.1790188948022;
        Wed, 23 Sep 2026 11:42:28 -0700 (PDT)
Received: from vdo-obuilder-bjohnston.permabit.com (nat-pool-rdu-t.redhat.com. [66.187.233.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c248765fcsm284801285a.26.2026.09.23.11.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 11:42:27 -0700 (PDT)
Date: Wed, 23 Sep 2026 14:42:25 -0400
From: Bruce Johnston <bjohnsto@redhat.com>
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 2/4] md: Handle pers->run failure in level_store
Message-ID: <arQdkcalhtK5ySUz@vdo-obuilder-bjohnston.permabit.com>
References: <20260923112159.94175-1-chengzhihao1@huawei.com>
 <20260923112159.94175-3-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923112159.94175-3-chengzhihao1@huawei.com>

Hi. I've been looking into takeover for a little while as well. I was
planning to write up something to post into the mailing list about it
but say your submission and figured I would mention it here. I believe
just handling a failure in pers->run is insufficient to fixing takeover
errors.

IMO the contract for level_store should be that if something fails, we
end up where we were before the function was called. So if we try to go
from 1->5 and something fails, we are back at a working valid level 1.

The current level_store function roughly does the following:
1. Suspend & Validate: Suspends the mddev device and performs initial
   validation checks.
2. Takeover: Invokes pers->takeover().
3. Swap Personality: Swaps the array to the new RAID personality.
4. Free Old State: Frees the old personality configuration and internal
   information.
5. Update sysfs fields from old to new
6. Run Personality: Calls pers->run to initialize the new RAID
   personality.
7. Resume Device: Resumes the mddev device.

By the time we get to run, we have swapped and free'd the old
personality.

The code in md_run around pers->run cleanup is reasonable because if
something fails, the array isn't started. You can't really do anything
after that. But in takeover, on a failed run, we're now in a state where
we have a half swapped personality. How do we recover from that? Are we
just going to stop the array? 

There are also additional issues in level_store where the personality
functions like pers->takeover do things like remove unsupported flags
from the mddev based on the new personality but never repair them on
failures.

I've been investigating possible takeover failure solutions but none of
them are easy. For example, we could try creating a new mddev at the
start of level_store and using that for the pers->foo calls but there
are a lot of shared resources so it becomes tricky. We could try
something like an undo log (each change tell how to undo itself) but
that would need to be passed into the personality functions or attached
to the mddev.

Should we have a discussion on this issue? I feel like we have
some holes here that need fixing.

On Wed, Sep 23, 2026 at 07:21:56PM +0800, Zhihao Cheng wrote:
> Set 'raid_disks' after raid5_run() failure will trigger an
> null-ptr-deref problem:
>  BUG: kernel NULL pointer dereference, address: 0000000000000038
>  RIP: 0010:raid5_check_reshape+0xad
>  Call Trace:
>   update_raid_disks+0x124
>   raid_disks_store+0x145
>   md_attr_store+0xd7
>   sysfs_kf_write+0x7c
> 
> The trigger process is simple:
>  mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
>  --force --assume-clean # create raid1
>  echo 5 > /sys/block/md0/md/level
>   level_store
>    mddev->pers = pers
>    mddev->private = priv
>    raid5_run
>     fail to abort (eg. raid5_create_ctx_pool fails)
>     mddev->private = NULL
>  echo 10 > /sys/block/md0/md/raid_disks
>   raid_disks_store
>    if (mddev->pers) // true
>     update_raid_disks
>      raid5_check_reshape
>       conf = mddev->private
>        conf->algorithm = mddev->new_layout // null-ptr-deref !
> 
> Similar process exists in do_md_stop->__md_stop_writes->raid5_quiesce.
> Similar process exists in raid10 too.
> 
> Fix it by handling the error from pers->run, next active-type order will
> restart the mddev.
> 
> Fixes: 245f46c2c221e ("md: add ->takeover method to support changing the personality managing an array")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>  drivers/md/md.c | 29 ++++++++++++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 02798f2dbf0e..ff78bf8656ff 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -97,6 +97,7 @@ static struct workqueue_struct *md_misc_wq;
>  static int remove_and_add_spares(struct mddev *mddev,
>  				 struct md_rdev *this);
>  static void mddev_detach(struct mddev *mddev);
> +static void __md_stop(struct mddev *mddev);
>  static void export_rdev(struct md_rdev *rdev);
>  static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
>  
> @@ -4243,7 +4244,33 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>  		mddev->in_sync = 1;
>  		timer_delete_sync(&mddev->safemode_timer);
>  	}
> -	pers->run(mddev);
> +	rv = pers->run(mddev);
> +	if (rv) {
> +		/*
> +		 * ->run() has released the private data of the new personality,
> +		 * while the old one has already been released as well. There is
> +		 * nothing to fall back to, so stop the array to avoid leaving
> +		 * 'mddev->pers' pointing to a personality which has no private
> +		 * data, and reminds user to try to active the mddev again.
> +		 */
> +		pr_warn("md: %s: failed to run %s after takeover, please try to active\n",
> +			mdname(mddev), pers->head.name);
> +		if (mddev->pers->sync_request && mddev->to_remove == NULL)
> +			mddev->to_remove = &md_redundancy_group;
> +		if (md_bitmap_enabled(mddev, true))
> +			mddev->bitmap_ops->flush(mddev);
> +		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
> +		mddev_destroy_serial_pool(mddev, NULL);
> +		__md_stop(mddev);
> +		rdev_for_each(rdev, mddev)
> +			if (rdev->raid_disk >= 0)
> +				sysfs_unlink_rdev(mddev, rdev);
> +		set_capacity_and_notify(mddev->gendisk, 0);
> +		mddev->changed = 1;
> +		md_new_event();
> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
> +		goto out_unlock;
> +	}
>  	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>  	if (!mddev->thread)
>  		md_update_sb(mddev, 1);
> -- 
> 2.52.0
> 
> 

