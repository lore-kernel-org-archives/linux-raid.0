Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EAA3BBEA
	for <linux-raid@vger.kernel.org>; Mon, 24 Jun 2024 07:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719213258; cv=none; b=EnLKo4WDBrRwbzXyww3LCqBkKcpJrG3WagDMzG96OuFrkdg+ayIQq5CGE5f9A2mdZe6IPPOR2HIF06oN4JwFYRNFlHBN3zCEXQyd0DyUKZMe70b/EM7MqM6FG4IKXGXSRH2H3rjDuNjyu+33mH5gK28Kfb79+lUvkfx6Tx8drp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719213258; c=relaxed/simple;
	bh=sqFObmYYN9Hwt22Qt9UVr0rnpkOOjeJjq+5lAYZeo4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKfP52HtxtYuKIqTJzL3WteJiMjO9Vne6wvFui6LJM/Ki+S7YOA/BHfwKwpR2WN/XW2PguvjclGb3fWpGMorqS7pannovXL4lBOgBkD4YNtxLnsn4rRA0hjk2OMeVwNWmWZQ/WDCVFPb9DLq24Z39YRBzJGauFloO9/3sFe4d9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IhEXl8iT; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IhEXl8iT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719213256; x=1750749256;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sqFObmYYN9Hwt22Qt9UVr0rnpkOOjeJjq+5lAYZeo4Q=;
  b=IhEXl8iTWe3KcMA1GowSgyqvrdzyJJRkqcxn7vj2knsta9pcmSFL1xLD
   +8e8XHzRGahzXhTVjkLKICV+ThPJZ41C14t1WqIFRz6MfKNCXOL881Jvf
   ntIrHkbp+IM+whle3YK2gRQdSuYXjOw3Rqd6e9PEHhFdnR6brsRDtrE07
   nLW36uEszIf86WdU5pnfjTb564KqfP8RvUb2/imOGNP0tO24PP8B0cRiT
   LMomd8Hbs9wMjGobgARhKBEFPN3an9wF+1BpPOVA7HASa4hzEhcsnUUUM
   oYiUkdCf/BtJAZDJiN4RsW9pradWGD1Rab2befCm+RVHazyiLno+JKl1b
   A==;
X-CSE-ConnectionGUID: D6iC6jKNSJecafzKJ5OgLA==
X-CSE-MsgGUID: R24OcUq1TSiSaoRP9bEd8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11112"; a="15860938"
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="15860938"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 00:14:15 -0700
X-CSE-ConnectionGUID: KGuhJMOdQvaMNa3xJK5XEw==
X-CSE-MsgGUID: aajR2n5/QBOWBYOeldIWRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,261,1712646000"; 
   d="scan'208";a="66436849"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.52])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 00:14:15 -0700
Date: Mon, 24 Jun 2024 09:14:10 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: MD: Long delay for container drive removal
Message-ID: <20240624091410.00007100@linux.intel.com>
In-Reply-To: <24cf4b0e-2cb5-4b50-8867-f7feadaf367d@linux.intel.com>
References: <814ff6ee-47a2-4ba0-963e-cf256ee4ecfa@linux.intel.com>
	<24cf4b0e-2cb5-4b50-8867-f7feadaf367d@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Jun 2024 14:43:50 +0200
Mateusz Kusiak <mateusz.kusiak@linux.intel.com> wrote:

> On 18.06.2024 16:24, Mateusz Kusiak wrote:
> > Hi all,
> > we have an issue submitted for SLES15SP6 that is caused by huge delays when
> > trying to remove drive from a container.
> > 
> > The scenario is as follows:
> > 1. Create two drive imsm container
> > # mdadm --create --run /dev/md/imsm --metadata=imsm --raid-devices=2
> > /dev/nvme[0-1]n1 2. Remove single drive from container
> > # mdadm /dev/md127 --remove /dev/nvme0n1
> > 
> > The problem is that drive removal may take up to 7 seconds, which causes
> > timeouts for other components that are mdadm dependent.
> > 
> > We narrowed it down to be MD related. We tested this with inbox mdadm-4.3
> > and mdadm-4.2 on SP6 and delay time is pretty much the same. SP5 is free of
> > this issue.
> > 
> > I also tried RHEL 8.9 and drive removal is almost instant.
> > 
> > Is it default behavior now, or should we treat this as an issue?
> > 
> > Thanks,
> > Mateusz
> >   
> 
> I dug into this more. I retested this on:
> - Ubuntu 24.04 with inbox kernel 6.6.0: No reproduction
> - RHEL 9.4 with usptream kernel: 6.9.5-1: Got reproduction
> (Note that SLES15SP6 comes with 6.8.0-rc4 inbox)
> 
> I plugged into mdadm with gdb and found out that ioctl call in
> hot_remove_disk() fails and it's causing a delay. The function looks as
> follows:
> 
> int hot_remove_disk(int mdfd, unsigned long dev, int force)
> {
> 	int cnt = force ? 500 : 5;
> 	int ret;
> 
> 	/* HOT_REMOVE_DISK can fail with EBUSY if there are
> 	 * outstanding IO requests to the device.
> 	 * In this case, it can be helpful to wait a little while,
> 	 * up to 5 seconds if 'force' is set, or 50 msec if not.
> 	 */
> 	while ((ret = ioctl(mdfd, HOT_REMOVE_DISK, dev)) == -1 &&
> 	       errno == EBUSY &&
> 	       cnt-- > 0)
> 		sleep_for(0, MSEC_TO_NSEC(10), true);
> 
> 	return ret;
> }
> ... if it fails, then it defaults to removing drive via sysfs call.
> 
> Looks like a kernel ioctl issue...
> 

Hello,
I investigated this. Looks like HOT_REMOVE_DRIVE ioctl almost always failed for
raid with no raid personality. At some point it was allowed but it was blocked
6 years ago in c42a0e2675 (this id leads to merge commit, so giving title "md:
fix NULL dereference of mddev->pers in remove_and_add_spares()").

And that explains why we have outdated comment in mdadm:

		if (err && errno == ENODEV) {
			/* Old kernels rejected this if no personality
			 * is registered */

I'm working to make it fixed in mdadm (for kernels with this hang), I will
remove ioctl call for external containers:
https://github.com/md-raid-utilities/mdadm/pull/31

On HOT_REMOVE_DRIVE ioctl path, there is a wait for clearing MD_RECOVERY_NEEDED
flag with timeout set to 5 seconds. When I disabled this for arrays
with no personality- it fixes issue. However, I'm not sure if it is right fix. I
would expect to not set MD_RECOVERY_NEEDED for arrays with no MD personality.
Kuai and Song could you please advice?

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c0426a6d2fd1..bd1cedeb105b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7827,7 +7827,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t
mode, return get_bitmap_file(mddev, argp);
        }

-       if (cmd == HOT_REMOVE_DISK)
+       if (cmd == HOT_REMOVE_DISK && mddev->pers)
                /* need to ensure recovery thread has run */
                wait_event_interruptible_timeout(mddev->sb_wait,
                                                 !test_bit(MD_RECOVERY_NEEDED,


Thanks,
Mariusz  
