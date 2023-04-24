Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3C21C77B61
	for <linux-raid@archiver.kernel.org>; Mon, 24 Apr 2023 20:33:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjDXUdE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 24 Apr 2023 16:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbjDXUdE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 24 Apr 2023 16:33:04 -0400
X-Greylist: delayed 481 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 24 Apr 2023 13:33:00 PDT
Received: from hoggar.fisica.ufpr.br (hoggar.fisica.ufpr.br [IPv6:2801:82:80ff:7fff::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8158C55AF
        for <linux-raid@vger.kernel.org>; Mon, 24 Apr 2023 13:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=fisica.ufpr.br;
        s=201705; t=1682367894;
        bh=NsojVrDjcWKQGs9HJvplN/bCpX5lFfTQQdOTV27CdD4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BiR5uLwpngnESyAWVZE+B8dmoN3BAov4upU9RktCXg78wl7xIHTW/S6Vd2prAbulY
         WcLTznSRRKO8PZX4+45qOoizC18oZOYRuSl/FA1Sa9qctMGUhcyMKClqFNlxf2+oa+
         xW4JN+60upsbHSR2ORoxtRO6XkeoxLJf0YTvstm+c/YWR/zGuCOHLlAUhqXNbaNXxr
         KrEBEe12Phkzq7TDC/s3UfERkSAaBDXXucRVvWzzA514EaYaZbi1PwaPr/5umhV54G
         REcNSYA6C4aYI/DCOU0uJ7G5c+syWPGdAUlxeAQ2raKUiK+ft7VNhkkOj3hhO89ZVr
         Rozg4qaHNLnJQ==
Received: by hoggar.fisica.ufpr.br (Postfix, from userid 577)
        id 8798E362015A; Mon, 24 Apr 2023 17:24:54 -0300 (-03)
Date:   Mon, 24 Apr 2023 17:24:54 -0300
From:   Carlos Carvalho <carlos@fisica.ufpr.br>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-raid@vger.kernel.org, Song Liu <song@kernel.org>
Subject: Re: [PATCH] md/raid5: Improve performance for sequential IO
Message-ID: <ZEblloZgE0FxMNow@fisica.ufpr.br>
References: <20230417171537.17899-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230417171537.17899-1-jack@suse.cz>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Jan Kara (jack@suse.cz) wrote on Mon, Apr 17, 2023 at 02:15:37PM -03:
> Commit 7e55c60acfbb ("md/raid5: Pivot raid5_make_request()") changed the
> order in which requests for underlying disks are created.

In which version was this first applied?

We've observed a large drop in disk performance since 4.* to the point that
6.1.* is almost unusable for some tasks. For example, we have 2 backup
machines, one using raid6/ext4 and another using zfs. The backup of a third
machine with a filesystem with ~25M inodes takes 6x-8x longer on the one using
raid6/ext4 than on the one using zfs... This is during the rsync phase.
Afterwards it removes old trees and the rm with raid6 takes eons even though
the disks are not at all busy (as shown by sar). Running several rm in parallel
speeds things up a lot, showing the problem is not in the disks.
