Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1D4C001B0
	for <linux-raid@archiver.kernel.org>; Mon, 14 Aug 2023 13:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjHNNPp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Aug 2023 09:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjHNNPm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Aug 2023 09:15:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3215CF5
        for <linux-raid@vger.kernel.org>; Mon, 14 Aug 2023 06:15:41 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E7B6D1F7AB;
        Mon, 14 Aug 2023 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1692018939; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6m2Z0ju/fZJ8FXk1GwQeLIjXcf3CnTBaj778JLDwqK0=;
        b=bQqVnm6CCR3cyW5fNj6MJsma6Qm0nm/AFpw1QFeerbdrmFWBcigH0qHSRSRjmM7hFOP3rE
        oxAn3IxdK03crpd6ntY4S5zw+zSZBRFGKK7xJhMpML6SW7esFme6A/9CPc8w8MdCawHMWB
        2k9oYNuxmFV6KPUCBBrpU+VuwD3hnLg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1692018939;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6m2Z0ju/fZJ8FXk1GwQeLIjXcf3CnTBaj778JLDwqK0=;
        b=mgXQQGjoLDERccmKfIAIBYWCCr/Zim5WQiDTC9j6M5E/cSZNs5xz7jNXhcKfhrSgU+ALsV
        m/l5JWSjs5p/8SAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D89E4138E2;
        Mon, 14 Aug 2023 13:15:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id rondNPso2mRKVgAAMHmgww
        (envelope-from <jack@suse.cz>); Mon, 14 Aug 2023 13:15:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 72DDFA0769; Mon, 14 Aug 2023 15:15:39 +0200 (CEST)
Date:   Mon, 14 Aug 2023 15:15:39 +0200
From:   Jan Kara <jack@suse.cz>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Jan Kara <jack@suse.cz>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 2/2] md/raid0: Fix performance regression for large
 sequential writes
Message-ID: <20230814131539.qlsj774c7zxzyiet@quack3>
References: <20230814091452.9670-1-jack@suse.cz>
 <20230814092720.3931-2-jack@suse.cz>
 <7cf84094-c63f-374e-6a24-f35d0816266f@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7cf84094-c63f-374e-6a24-f35d0816266f@huaweicloud.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon 14-08-23 20:15:58, Yu Kuai wrote:
> Hi,
> 
> 在 2023/08/14 17:27, Jan Kara 写道:
> > Commit f00d7c85be9e ("md/raid0: fix up bio splitting.") among other
> > things changed how bio that needs to be split is submitted. Before this
> > commit, we have split the bio, mapped and submitted each part. After
> > this commit, we map only the first part of the split bio and submit the
> > second part unmapped. Due to bio sorting in __submit_bio_noacct() this
> > results in the following request ordering:
> > 
> >    9,0   18     1181     0.525037895 15995  Q  WS 1479315464 + 63392
> > 
> >    Split off chunk-sized (1024 sectors) request:
> > 
> >    9,0   18     1182     0.629019647 15995  X  WS 1479315464 / 1479316488
> > 
> >    Request is unaligned to the chunk so it's split in
> >    raid0_make_request().  This is the first part mapped and punted to
> >    bio_list:
> > 
> >    8,0   18     7053     0.629020455 15995  A  WS 739921928 + 1016 <- (9,0) 1479315464
> > 
> >    Now raid0_make_request() returns, second part is postponed on
> >    bio_list. __submit_bio_noacct() resorts the bio_list, mapped request
> >    is submitted to the underlying device:
> > 
> >    8,0   18     7054     0.629022782 15995  G  WS 739921928 + 1016
> > 
> >    Now we take another request from the bio_list which is the remainder
> >    of the original huge request. Split off another chunk-sized bit from
> >    it and the situation repeats:
> > 
> >    9,0   18     1183     0.629024499 15995  X  WS 1479316488 / 1479317512
> >    8,16  18     6998     0.629025110 15995  A  WS 739921928 + 1016 <- (9,0) 1479316488
> >    8,16  18     6999     0.629026728 15995  G  WS 739921928 + 1016
> >    ...
> >    9,0   18     1184     0.629032940 15995  X  WS 1479317512 / 1479318536 [libnetacq-write]
> >    8,0   18     7059     0.629033294 15995  A  WS 739922952 + 1016 <- (9,0) 1479317512
> >    8,0   18     7060     0.629033902 15995  G  WS 739922952 + 1016
> >    ...
> > 
> >    This repeats until we consume the whole original huge request. Now we
> >    finally get to processing the second parts of the split off requests
> >    (in reverse order):
> > 
> >    8,16  18     7181     0.629161384 15995  A  WS 739952640 + 8 <- (9,0) 1479377920
> >    8,0   18     7239     0.629162140 15995  A  WS 739952640 + 8 <- (9,0) 1479376896
> >    8,16  18     7186     0.629163881 15995  A  WS 739951616 + 8 <- (9,0) 1479375872
> >    8,0   18     7242     0.629164421 15995  A  WS 739951616 + 8 <- (9,0) 1479374848
> >    ...
> > 
> > I guess it is obvious that this IO pattern is extremely inefficient way
> > to perform sequential IO. It also makes bio_list to grow to rather long
> > lengths.
> > 
> > Change raid0_make_request() to map both parts of the split bio. Since we
> > know we are provided with at most chunk-sized bios, we will always need
> > to split the incoming bio at most once.
> 
> I understand the problem now, but I'm lost here, can you explain why "at
> most once" more ? Do you mean that the original bio won't be splited
> again?

Yes. md_submit_bio() splits the incoming bio by bio_split_to_limits() so we
are guaranteed raid0_make_request() gets bio at most chunk_sectors long.
If this bio is misaligned, it will be split in raid0_make_request(). But
after that we are sure both parts of the bio are meeting requirements of
the raid0 code so we can just directly map them to the underlying device and
submit them.

								Honza

> > Fixes: f00d7c85be9e ("md/raid0: fix up bio splitting.")
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >   drivers/md/raid0.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index d3c55f2e9b18..595856948dff 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -626,7 +626,7 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
> >   		struct bio *split = bio_split(bio, sectors, GFP_NOIO,
> >   					      &mddev->bio_set);
> >   		bio_chain(split, bio);
> > -		submit_bio_noacct(bio);
> > +		raid0_map_submit_bio(mddev, bio);
> >   		bio = split;
> >   	}
> > 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
