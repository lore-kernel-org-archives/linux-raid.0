Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF51C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 17 Nov 2022 14:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbiKQOHv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Nov 2022 09:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiKQOHu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Nov 2022 09:07:50 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF7D58BC3
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 06:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668694069; x=1700230069;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A8SczA7tcoiRX5tjTVCDuC7HUyR5Z9EhwMsIp4OL5LY=;
  b=G0MgdMrU76ObhZctwKgL80ydcOh+KTQ7jTiSz6Y3mwIPIuupb4Y5Ffnl
   70p+0bXfGFwsQSfyJ+JcOtAlTOrXj/pd/DXK4uVCANLjYtLuKEP85Damb
   7iYrTGfAIXoZLa4KgOX/AUUFUqgiNtj5LFT0s5enkMhizqbvhDllt1yCK
   8lGzFPX6Jwf5hfhv0xuwdh9jU0XZXIe8aiEnBMoxuYGvT8hitwj8QT3dT
   5g7dqhrF2UcSlzKegTYdZJN0ltq7SDVq2YMTI7R5gaQIj69Qifb9mFN3t
   7NaCmGxoQbluUyosEWgS6+U9tRnt2R1RTQVdjqdUv1T+mzXOsnsJ+M2lb
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="310487493"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="310487493"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 06:07:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="814525825"
X-IronPort-AV: E=Sophos;i="5.96,171,1665471600"; 
   d="scan'208";a="814525825"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.213.28.141])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 06:07:46 -0800
Date:   Thu, 17 Nov 2022 15:07:41 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Kinga Tanska <kinga.tanska@linux.intel.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
        jes@trained-monkey.org, mariusz.tkaczyk@intel.com,
        kinga.tanska@intel.com
Subject: Re: [PATCH] mdadm reshape hangs on external grow chunk
Message-ID: <20221117150525.00002743@linux.intel.com>
In-Reply-To: <20220929113521.000012af@intel.linux.com>
References: <20220923142635.470305-1-ncroxon@redhat.com>
 <20220929113521.000012af@intel.linux.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 29 Sep 2022 11:35:21 +0200
Kinga Tanska <kinga.tanska@linux.intel.com> wrote:

> On Fri, 23 Sep 2022 10:26:35 -0400
> Nigel Croxon <ncroxon@redhat.com> wrote:
> 
> > After creating a raid array on top of a imsm container. Try to
> > grow the chunk size and the reshape will hang with zero progress.
> > The reason is the computation of sync_max_to_set value:
> > if (before_data_disks <= data_disks)
> >         sync_max_to_set = sra->reshape_progress / data_disks;
> >     else
> >         sync_max_to_set = (sra->component_size * data_disks
> >                        - sra->reshape_progress) / data_disks;
> > 
> > Can produce a zero result. Which is then used to set the maximum
> > sync value, causing zero progress to the reshape.  The change is to
> > test if the sync_max_to_set value is zero. And if so, set the sysfs
> > sync_max to "max".
> > 
> > Steps to Reproduce:
> > 1. Create a container and RAID0 array
> > mdadm -CR /dev/md/imsm -e imsm -n2 /dev/nvme0n1 /dev/nvme1n1
> > mdadm -CR  /dev/md/vol -l0 --chunk=16 -n2 /dev/nvme0n1 /dev/nvme1n1
> > 2. Wait for resync
> > 3. Try to grow the chunk size
> > mdadm --grow /dev/md/vol --chunk=256
> > 
> > Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> > ---
> >  Grow.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Grow.c b/Grow.c
> > index 0f07a894..6c5021bc 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -943,7 +943,7 @@ int start_reshape(struct mdinfo *sra, int
> > already_running, if (!already_running)
> >  		sysfs_set_num(sra, NULL, "sync_min",
> > sync_max_to_set); 
> > -        if (st->ss->external)
> > +        if (sync_max_to_set)
> >  		err = err ?: sysfs_set_num(sra, NULL, "sync_max",
> > sync_max_to_set); else
> >  		err = err ?: sysfs_set_str(sra, NULL, "sync_max",
> > "max");
> 
> Hi Nigel,
> 
> I was trying to retest with your patch but still have the defect. I
> analyzed it and found another reason, which causes this defect. In
> validate_geometry_imsm function freesize and super is being checked and
> return 1 if any of those is NULL. In my opinion 0 shall be returned
> here, because it is an error and reshape should be stopped here. I will
> prepare proper patch and send to review immediately.
> 
Hi Nigel,
I agree with Kinga.
https://patchwork.kernel.org/project/linux-raid/patch/20221028025117.27048-1-kinga.tanska@intel.com/
Could you please retest the proposed patch on your side and provide feedback?

Thanks,
Mariusz
