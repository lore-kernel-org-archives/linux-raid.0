Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 532B2C6FD1C
	for <linux-raid@archiver.kernel.org>; Wed, 22 Mar 2023 11:35:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCVLff (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Mar 2023 07:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCVLff (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Mar 2023 07:35:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28A15FD1
        for <linux-raid@vger.kernel.org>; Wed, 22 Mar 2023 04:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679484886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=De0Wvgfi0b5sNFH0L7f49fqn42kGTh8bynMEdDX5Ewc=;
        b=bKpk3hq56XM5R490ZxF5Dragi0vDIrYD54wghONMfKreap9DCjOEX7egr+1NnzvUEhWomn
        2NzIvkGMNos1QaUHLDjP69vG51KxRVUBBgMBzTe51V2KAEbNpCrzOtL6lVkbXi9b4a2sBb
        Lft72pF/TNQPE5H9Z+FvyRL5Tft3iFQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-94gfLH-kPS2WSVDH8hkW1g-1; Wed, 22 Mar 2023 07:34:43 -0400
X-MC-Unique: 94gfLH-kPS2WSVDH8hkW1g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DCE171C02D2C;
        Wed, 22 Mar 2023 11:34:42 +0000 (UTC)
Received: from ovpn-8-17.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA30140C6E67;
        Wed, 22 Mar 2023 11:34:35 +0000 (UTC)
Date:   Wed, 22 Mar 2023 19:34:30 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jan Kara <jack@suse.cz>
Cc:     Yu Kuai <yukuai1@huaweicloud.com>, hch@infradead.org,
        axboe@kernel.dk, yukuai3@huawei.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.zhang@huawei.com,
        yangerkun@huawei.com, ming.lei@redhat.com,
        Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] block: don't set GD_NEED_PART_SCAN if scan partition
 failed
Message-ID: <ZBrnxrQ8csN/xkRG@ovpn-8-17.pek2.redhat.com>
References: <ZBmYcuVzpDDTiaP+@ovpn-8-18.pek2.redhat.com>
 <20230322035926.1791317-1-yukuai1@huaweicloud.com>
 <ZBq1K90+9ASVbdTu@ovpn-8-17.pek2.redhat.com>
 <20230322094707.7xsexupiijmxxlom@quack3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322094707.7xsexupiijmxxlom@quack3>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 22, 2023 at 10:47:07AM +0100, Jan Kara wrote:
> On Wed 22-03-23 15:58:35, Ming Lei wrote:
> > On Wed, Mar 22, 2023 at 11:59:26AM +0800, Yu Kuai wrote:
> > > From: Yu Kuai <yukuai3@huawei.com>
> > > 
> > > Currently if disk_scan_partitions() failed, GD_NEED_PART_SCAN will still
> > > set, and partition scan will be proceed again when blkdev_get_by_dev()
> > > is called. However, this will cause a problem that re-assemble partitioned
> > > raid device will creat partition for underlying disk.
> > > 
> > > Test procedure:
> > > 
> > > mdadm -CR /dev/md0 -l 1 -n 2 /dev/sda /dev/sdb -e 1.0
> > > sgdisk -n 0:0:+100MiB /dev/md0
> > > blockdev --rereadpt /dev/sda
> > > blockdev --rereadpt /dev/sdb
> > > mdadm -S /dev/md0
> > > mdadm -A /dev/md0 /dev/sda /dev/sdb
> > > 
> > > Test result: underlying disk partition and raid partition can be
> > > observed at the same time
> > > 
> > > Note that this can still happen in come corner cases that
> > > GD_NEED_PART_SCAN can be set for underlying disk while re-assemble raid
> > > device.
> > > 
> > > Fixes: e5cfefa97bcc ("block: fix scan partition for exclusively open device again")
> > > Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> > 
> > The issue still can't be avoided completely, such as, after rebooting,
> > /dev/sda1 & /dev/md0p1 can be observed at the same time. And this one
> > should be underlying partitions scanned before re-assembling raid, I
> > guess it may not be easy to avoid.
> 
> So this was always happening (before my patches, after my patches, and now
> after Yu's patches) and kernel does not have enough information to know
> that sda will become part of md0 device in the future. But mdadm actually
> deals with this as far as I remember and deletes partitions for all devices
> it is assembling the array from (and quick tracing experiment I did
> supports this).

I am testing on Fedora 37, so mdadm v4.2 doesn't delete underlying
partitions before re-assemble.

Also given mdadm or related userspace has to change for avoiding
to scan underlying partitions, just wondering why not let userspace
to tell kernel not do it explicitly?

Thanks,
Ming

