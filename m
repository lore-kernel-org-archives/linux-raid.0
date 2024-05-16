Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6CDF144D0C
	for <linux-raid@vger.kernel.org>; Thu, 16 May 2024 11:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715858503; cv=none; b=DpfRM6P1b4FQhdoFMDHyXY4V2vki+v2kIk//7QI+p9OAhLO2gi16ryDa9BTulrVvB37nUFnVwYrVMkeAApJVHLBiWUIRjZgVxWiEMdf58JktjG0Ks7/ECQhhQuRA0T8uizZWS37htn1sxs5uxQZ0Afp0uoHmiryAq+byn5LlzgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715858503; c=relaxed/simple;
	bh=AcXvFLaahltlW7+Whxk618IeYembQ8IggOp1mcUvcAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m2Mi3DziaU9Vbn/25SWNuErcY30G2MPVsfXOI4ihGliOiqd52e9Z8IjCLp4veiMvgqD0/cUWNbaOPqG60fypx+19PouVnEkAbNNgyrg/35majElx7LXJVg4e88SdTrckiFKFOP3k51qKYSz/cOOIJcZcsciP8MGC6QaJf/Q1AkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S2jc1fT1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S2jc1fT1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715858500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rcwfR3jWnTxHt4V8jGK3meuJpVRM0dLS4aHoroz2Fto=;
	b=S2jc1fT1yRmbVZ/iVH+s6USXavCue3N4mG7sLRH7v00VexRU/Z4ws3bcg2zSR3q+8xuVPc
	eb9v+/lyLoHHqC1AvqtNusCp9G14KdJjlKNaHjGu6izlyBwSyz88913udyHudVWRCq4H3J
	z6SJMNyoceHrrRKtO5TcfFmELKaW3cA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-XgIub75EMHqXRIyXYWsCcQ-1; Thu, 16 May 2024 07:21:37 -0400
X-MC-Unique: XgIub75EMHqXRIyXYWsCcQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD464800CA5;
	Thu, 16 May 2024 11:21:36 +0000 (UTC)
Received: from fedora (unknown [10.72.116.57])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A056840C6CBB;
	Thu, 16 May 2024 11:21:32 +0000 (UTC)
Date: Thu, 16 May 2024 19:21:28 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>,
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org, Xiao Ni <xni@redhat.com>
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
Message-ID: <ZkXsOKV5d4T0Hyqu@fedora>
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Cc raid and dm list.

On Thu, May 16, 2024 at 06:24:18PM +0800, Changhui Zhong wrote:
> Hello,
> 
> when create lvm raid1, the command hang on for a long time.
> please help check it and let me know if you need any info/testing for
> it, thanks.
> 
> repo:https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
> branch:for-next
> commit: 59ef8180748269837975c9656b586daa16bb9def
> 
> reproducer:
> dd if=/dev/zero bs=1M count=2000 of=file0.img
> dd if=/dev/zero bs=1M count=2000 of=file1.img
> dd if=/dev/zero bs=1M count=2000 of=file2.img
> dd if=/dev/zero bs=1M count=2000 of=file4.img
> losetup -fP --show file0.img
> losetup -fP --show file1.img
> losetup -fP --show file2.img
> losetup -fP --show file3.img
> pvcreate -y  /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
> vgcreate  black_bird  /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
> lvcreate --type raid1 -m 3 -n non_synced_primary_raid_3legs_1   -L 1G
> black_bird        /dev/loop0:0-300     /dev/loop1:0-300
> /dev/loop2:0-300  /dev/loop3:0-300
> 
> 
> console log:
> May 21 21:57:41 dell-per640-04 journal: Create raid1
> May 21 21:57:41 dell-per640-04 kernel: device-mapper: raid:
> Superblocks created for new raid set
> May 21 21:57:42 dell-per640-04 kernel: md/raid1:mdX: not clean --
> starting background reconstruction
> May 21 21:57:42 dell-per640-04 kernel: md/raid1:mdX: active with 4 out
> of 4 mirrors
> May 21 21:57:42 dell-per640-04 kernel: mdX: bitmap file is out of
> date, doing full recovery
> May 21 21:57:42 dell-per640-04 kernel: md: resync of RAID array mdX
> May 21 21:57:42 dell-per640-04 systemd[1]: Started Device-mapper event daemon.
> May 21 21:57:42 dell-per640-04 dmeventd[42170]: dmeventd ready for processing.
> May 21 21:57:42 dell-per640-04 dmeventd[42170]: Monitoring RAID device
> black_bird-non_synced_primary_raid_3legs_1 for events.
> May 21 21:57:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
> May 21 21:57:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
> May 21 21:58:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
> May 21 21:58:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
> May 21 21:59:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
> May 21 21:59:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
> May 21 21:59:53 dell-per640-04 kernel: INFO: task mdX_resync:42168
> blocked for more than 122 seconds.
> May 21 21:59:53 dell-per640-04 kernel:      Not tainted 6.9.0+ #1
> May 21 21:59:53 dell-per640-04 kernel: "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 21 21:59:53 dell-per640-04 kernel: task:mdX_resync      state:D
> stack:0     pid:42168 tgid:42168 ppid:2      flags:0x00004000
> May 21 21:59:53 dell-per640-04 kernel: Call Trace:
> May 21 21:59:53 dell-per640-04 kernel: <TASK>
> May 21 21:59:53 dell-per640-04 kernel: __schedule+0x222/0x670
> May 21 21:59:53 dell-per640-04 kernel: ? blk_mq_flush_plug_list+0x5/0x20
> May 21 21:59:53 dell-per640-04 kernel: schedule+0x2c/0xb0
> May 21 21:59:53 dell-per640-04 kernel: raise_barrier+0x107/0x200 [raid1]
> May 21 21:59:53 dell-per640-04 kernel: ?
> __pfx_autoremove_wake_function+0x10/0x10
> May 21 21:59:53 dell-per640-04 kernel: raid1_sync_request+0x12d/0xa50 [raid1]
> May 21 21:59:53 dell-per640-04 kernel: ?
> __pfx_raid1_sync_request+0x10/0x10 [raid1]
> May 21 21:59:53 dell-per640-04 kernel: md_do_sync+0x660/0x1040
> May 21 21:59:53 dell-per640-04 kernel: ?
> __pfx_autoremove_wake_function+0x10/0x10
> May 21 21:59:53 dell-per640-04 kernel: md_thread+0xad/0x160
> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_md_thread+0x10/0x10
> May 21 21:59:53 dell-per640-04 kernel: kthread+0xdc/0x110
> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_kthread+0x10/0x10
> May 21 21:59:53 dell-per640-04 kernel: ret_from_fork+0x2d/0x50
> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_kthread+0x10/0x10
> May 21 21:59:53 dell-per640-04 kernel: ret_from_fork_asm+0x1a/0x30
> May 21 21:59:53 dell-per640-04 kernel: </TASK>
> 
> 
> --
> Best Regards,
>      Changhui
> 

-- 
Ming

