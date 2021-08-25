Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778D0C4338F
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 00:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 512236120A
	for <linux-raid@archiver.kernel.org>; Wed, 25 Aug 2021 00:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236135AbhHYApM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Aug 2021 20:45:12 -0400
Received: from out2.migadu.com ([188.165.223.204]:24154 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231552AbhHYApL (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Aug 2021 20:45:11 -0400
Subject: Re: [PATCH V4] raid1: ensure write behind bio has less than
 BIO_MAX_VECS sectors
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629852265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9t/GrhLatKW+eiEmbZWcrOJY77vGVMZzxqxH1qf1WiY=;
        b=AJJvpqvjlSw6zVOfqP2QTF09ElfJt8SU8//xGgw8HDme2cQcA00Ni6Lut8DtDb9UU0G2kW
        4O+T5c84Fc0tINJIOWG+dXlOms7xjxW+BUGipOkFxFpjSK9HL7WMwM+ChdVIHEt39ItCxw
        SJ18HcjsgnUwwnvA5gdIYyPaVKFVAqc=
To:     Song Liu <song@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <20210824011654.3829681-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mivBeA0uYGT-Z9UR7h_B=4Mp+BGqzrAW9BmNysQcGTw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <01dec1bc-5e3a-4237-6280-f0a480e6231f@linux.dev>
Date:   Wed, 25 Aug 2021 08:44:18 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW6mivBeA0uYGT-Z9UR7h_B=4Mp+BGqzrAW9BmNysQcGTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 8/25/21 5:55 AM, Song Liu wrote:
> On Mon, Aug 23, 2021 at 6:17 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>> From: Guoqing Jiang <jiangguoqing@kylinos.cn>
>>
>> We can't split write behind bio with more than BIO_MAX_VECS sectors,
>> otherwise the below call trace was triggered because we could allocate
>> oversized write behind bio later.
>>
>> [ 8.097936] bvec_alloc+0x90/0xc0
>> [ 8.098934] bio_alloc_bioset+0x1b3/0x260
>> [ 8.099959] raid1_make_request+0x9ce/0xc50 [raid1]
>> [ 8.100988] ? __bio_clone_fast+0xa8/0xe0
>> [ 8.102008] md_handle_request+0x158/0x1d0 [md_mod]
>> [ 8.103050] md_submit_bio+0xcd/0x110 [md_mod]
>> [ 8.104084] submit_bio_noacct+0x139/0x530
>> [ 8.105127] submit_bio+0x78/0x1d0
>> [ 8.106163] ext4_io_submit+0x48/0x60 [ext4]
>> [ 8.107242] ext4_writepages+0x652/0x1170 [ext4]
>> [ 8.108300] ? do_writepages+0x41/0x100
>> [ 8.109338] ? __ext4_mark_inode_dirty+0x240/0x240 [ext4]
>> [ 8.110406] do_writepages+0x41/0x100
>> [ 8.111450] __filemap_fdatawrite_range+0xc5/0x100
>> [ 8.112513] file_write_and_wait_range+0x61/0xb0
>> [ 8.113564] ext4_sync_file+0x73/0x370 [ext4]
>> [ 8.114607] __x64_sys_fsync+0x33/0x60
>> [ 8.115635] do_syscall_64+0x33/0x40
>> [ 8.116670] entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> Thanks for the comment from Christoph.
>>
>> [1]. https://bugs.archlinux.org/task/70992
>>
>> Reported-by: Jens Stutte <jens@chianterastutte.eu>
>> Tested-by: Jens Stutte <jens@chianterastutte.eu>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> I am confused. Which tree does this apply to?

Sorry, I forgot to mention it in this version (actually it is v4). It 
depends
on commit 018eca456c4b4dca56aaf1ec27f309c74d0fe246 in block tree
for-next branch, so it would be better to be picked by block tree for now
to avoid compile issue,  or after you rebase md tree from block tree with
that commit included.

Thanks,
Guoqing
