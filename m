Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C4BC00140
	for <linux-raid@archiver.kernel.org>; Wed, 10 Aug 2022 17:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiHJRt3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Aug 2022 13:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232958AbiHJRtF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Aug 2022 13:49:05 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1761E8C47A
        for <linux-raid@vger.kernel.org>; Wed, 10 Aug 2022 10:48:56 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id a4so7042782qto.10
        for <linux-raid@vger.kernel.org>; Wed, 10 Aug 2022 10:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=b56RlgqsDjhndoKXh76AAfBh0fo34wRquvTp2LsFHgk=;
        b=exB4l+5E6/quhEzaiSIDb4pdiGPX1b7hO2HymEU/s0Ly9NVmwcqirP380zissRt0EU
         l7snuO/yv6izW4vfFWMEdB9B+D3ZVfwfxSr1WOYbDpIdqILXMI/K7LkiAKb+7oPxDfAJ
         hvMf5BPeFLFvnTXDiQf2qoOGMSr1kEyaRmsWqOHzHzLHA0Ef4sYYjUkkFgQ+If6pcK5P
         QP2rYx8ggkB2mQsu1SOwt0kvxoa+SZAhq0nCyBqRWQjksiwvXztpZ6vLKYwYnytRJsjW
         yMZCuHzeO0c/9Ug/c5WtOF5FmRfQQc+7qd6WRT4Nd27y1o4/ilC5FSwm4ts7sYLDeN85
         3fpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=b56RlgqsDjhndoKXh76AAfBh0fo34wRquvTp2LsFHgk=;
        b=R4YgnbU/p42WVJ2H92OiNKKf5lUpcrYNRMLkZHd5dE4qwJG+JFk/DM3hcUVKJnkY4U
         dMWijA0wnTXeDFSb7LYDGBpjGq35MWeQVziL1KOCKCcbZT1jqX4Qw1xyaUtOq4pj2oJv
         T1fyRctyeuU8/Rzx79rLdQEe40fFN/v11U4/mGqslUBM4N9GfaxbGeyRqcOXRVMcCfx5
         GeTCGEoElBjNEqhnDjhylbllAubwHTW60j7MC+0GHPExvYVzoBILLz3g830cqsuQRmeZ
         Et85Uqe5zg5xmKv0ItfMDImrrdAFkrreBBJLn5G/BVEoSm8BZ8+4J7k69LOMQAvu53gJ
         bZFg==
X-Gm-Message-State: ACgBeo2eVV/Jw7zhnhC4REoLuFrU+dkZq/qyJPxkgMQkixS3aWrwPoVw
        BJSbKguRa2mux9JtnnFFPa3q787z9y5toA==
X-Google-Smtp-Source: AA6agR7N7ISFUfCzkKkyp2mKsj1gWbPB/HcnKeULzt0zI4kXHOGqvXsg6K3Ka5VQlyfKqj8EDn9sRw==
X-Received: by 2002:a05:622a:3cf:b0:32c:1d47:2164 with SMTP id k15-20020a05622a03cf00b0032c1d472164mr25047708qtx.97.1660153735049;
        Wed, 10 Aug 2022 10:48:55 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id x14-20020a05620a258e00b006b9a89d408csm252567qko.100.2022.08.10.10.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 10:48:52 -0700 (PDT)
Date:   Wed, 10 Aug 2022 13:48:50 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Linux-RAID <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: stalling IO regression in linux 5.12
Message-ID: <YvPvghdv6lzVRm/S@localhost.localdomain>
References: <e38aa76d-6034-4dde-8624-df1745bb17fc@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e38aa76d-6034-4dde-8624-df1745bb17fc@www.fastmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Aug 10, 2022 at 12:35:34PM -0400, Chris Murphy wrote:
> CPU: Intel E5-2680 v3
> RAM: 128 G
> 02:00.0 RAID bus controller [0104]: Broadcom / LSI MegaRAID SAS-3 3108 [Invader] [1000:005d] (rev 02), using megaraid_sas driver
> 8 Disks: TOSHIBA AL13SEB600
> 
> 
> The problem exhibits as increasing load, increasing IO pressure (PSI), and actual IO goes to zero. It never happens on kernel 5.11 series, and always happens after 5.12-rc1 and persists through 5.18.0. There's a new mix of behaviors with 5.19, I suspect the mm improvements in this series might be masking the problem.
> 
> The workload involves openqa, which spins up 30 qemu-kvm instances, and does a bunch of tests, generating quite a lot of writes: qcow2 files, and video in the form of many screenshots, and various log files, for each VM. These VMs are each in their own cgroup. As the problem begins, I see increasing IO pressure, and decreasing IO, for each qemu instance's cgroup, and the cgroups for httpd, journald, auditd, and postgresql. IO pressure goes to nearly ~99% and IO is literally 0.
> 
> The problem left unattended to progress will eventually result in a completely unresponsive system, with no kernel messages. It reproduces in the following configurations, the first two I provide links to full dmesg with sysrq+w:
> 
> btrfs raid10 (native) on plain partitions [1]
> btrfs single/dup on dmcrypt on mdadm raid 10 and parity raid [2]
> XFS on dmcrypt on mdadm raid10 or parity raid
> 
> I've started a bisect, but for some reason I haven't figured out I've started getting compiled kernels that don't boot the hardware. The failure is very early on such that the UUID for the root file system isn't found, but not much to go on as to why.[3] I have tested the first and last skipped commits in the bisect log below, they successfully boot a VM but not the hardware.
> 
> Anyway, I'm kinda stuck at this point trying to narrow it down further. Any suggestions? Thanks.
> 

I looked at the traces, btrfs is stuck waiting on IO and blk tags, which means
we've got a lot of outstanding requests and are waiting for them to finish so we
can allocate more requests.

Additionally I'm seeing a bunch of the blkg async submit things, which are used
when we have the block cgroup stuff turned on and compression enabled, so we
punt any compressed bios to a per-cgroup async thread to submit the IO's in the
appropriate block cgroup context.

This could mean we're just being overly mean and generating too many IO's, but
since the IO goes to 0 I'm more inclined to believe there's a screw up in
whatever IO cgroup controller you're using.

To help narrow this down can you disable any IO controller you've got enabled
and see if you can reproduce?  If you can sysrq+w is super helpful as it'll
point us in the next direction to look.  Thanks,

Josef
