Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AE0C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 02:30:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A50F64DE8
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 02:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCPC3o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 15 Mar 2021 22:29:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24021 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232313AbhCPC3b (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 15 Mar 2021 22:29:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615861770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0N1+/8EylQBGR7T1ZQPGqmQGfso7Rq68gTY4sIR3c2Y=;
        b=i0xPuVtODazT8rDtyehbPEoxs+s+qZok/ymGlry0TFPNsMTLyIF5oMbHHRKBzgTdg1Sa7S
        PE5ugSB7qOf7uVULDea2yxUSyQxXq6AOLkXWdpwdAQw0KnY+LOjFXVaa29PGCXDrjHy7Wu
        Gm/CPGa1wFhcdxRHlMU9O+bQKJcqwOc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-xXmP1n4hPNyTP5Vu7-EC_w-1; Mon, 15 Mar 2021 22:29:18 -0400
X-MC-Unique: xXmP1n4hPNyTP5Vu7-EC_w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A7143FD2;
        Tue, 16 Mar 2021 02:29:17 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B17119D7C;
        Tue, 16 Mar 2021 02:29:15 +0000 (UTC)
Subject: Re: [song-md:md-next 5/6] drivers/md/raid10.c:1526:8-27:
 atomic_dec_and_test variation before object free at line 1532.
To:     kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-raid@vger.kernel.org,
        Song Liu <songliubraving@fb.com>
References: <202103160841.GSRvizC4-lkp@intel.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <dda31d3a-3424-6eb3-4f36-e715affc7015@redhat.com>
Date:   Tue, 16 Mar 2021 10:29:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <202103160841.GSRvizC4-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all

The atomic_t r10_bio->remaining starts at 1 in raid10_handle_discard. It 
means
raid10_handle_discard uses it and sets it to 1. So in fact it starts at 
0 and sets to 1
when it's used at first time. Then r10_bio->remaining is added by 
atomic_inc per usage.

It decrements the value when leaving raid10_handle_discard and in every 
callback function.
So the count of r10_bio->remaining in this patch is right.

Regards
Xiao

On 03/16/2021 08:29 AM, kernel test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next
> head:   49c4d345c81f149a29b3db6e521e5191e55f02b6
> commit: f3cf8c2b2caf6ae77b7c786218d3b060faef63a6 [5/6] md/raid10: improve discard request for far layout
> config: x86_64-allyesconfig (attached as .config)
> compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
>
> "coccinelle warnings: (new ones prefixed by >>)"
>>> drivers/md/raid10.c:1526:8-27: atomic_dec_and_test variation before object free at line 1532.
>     drivers/md/raid10.c:1526:8-27: atomic_dec_and_test variation before object free at line 1537.
>
> vim +1526 drivers/md/raid10.c
>
>    1520	
>    1521	static void raid_end_discard_bio(struct r10bio *r10bio)
>    1522	{
>    1523		struct r10conf *conf = r10bio->mddev->private;
>    1524		struct r10bio *first_r10bio;
>    1525	
>> 1526		while (atomic_dec_and_test(&r10bio->remaining)) {
>    1527	
>    1528			allow_barrier(conf);
>    1529	
>    1530			if (!test_bit(R10BIO_Discard, &r10bio->state)) {
>    1531				first_r10bio = (struct r10bio *)r10bio->master_bio;
>> 1532				free_r10bio(r10bio);
>    1533				r10bio = first_r10bio;
>    1534			} else {
>    1535				md_write_end(r10bio->mddev);
>    1536				bio_endio(r10bio->master_bio);
>    1537				free_r10bio(r10bio);
>    1538				break;
>    1539			}
>    1540		}
>    1541	}
>    1542	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

