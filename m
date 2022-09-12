Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F409AC6FA83
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 19:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiILTMj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 15:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiILTMi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 15:12:38 -0400
X-Greylist: delayed 223 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 12 Sep 2022 12:12:37 PDT
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6620D32D82
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 12:12:37 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 94C28E608E; Mon, 12 Sep 2022 15:12:06 -0400 (EDT)
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org>
 <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org>
 <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
 <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org>
 <CAJJqR23RE3Hfrm-bkiyMm3OjUTCFhXsRvBXr4H8563t1VyY=0g@mail.gmail.com>
 <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com>
User-agent: mu4e 1.7.12; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Luigi Fabio <luigi.fabio@gmail.com>
Cc:     Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Subject: Re: RAID5 failure and consequent ext4 problems
Date:   Mon, 12 Sep 2022 15:09:24 -0400
In-reply-to: <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com>
Message-ID: <87fsgw8l15.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Luigi Fabio <luigi.fabio@gmail.com> writes:

> Well, I found SOMETHING of decided interest: when I run dumpe2fs with
> any backup superblock, this happens:
>
> ---
> Filesystem created:       Tue Nov  4 08:56:08 2008
> Last mount time:          Thu Aug 18 21:04:22 2022
> Last write time:          Thu Aug 18 21:04:22 2022
> ---
>
> So the backups have not been updated since boot-before-last? That
> would explain why, when fsck tries to use those backups, it comes up
> with funny results.


That's funny.  IIRC, the backups virtually never get updated.  The only
thing e2fsck needs to get from them is the location of the inode tables
and block groups, and that does not change during the life of the
filesystem.

I might have something tickling the back of my memory that when e2fsck
is run, it updates the first backup superblock, but the others never got
updated.

