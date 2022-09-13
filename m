Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF76FC6FA82
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 12:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiIMMue (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 08:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiIMMud (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 08:50:33 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5683F20F46
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 05:50:31 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 823A5E62A5; Tue, 13 Sep 2022 08:50:30 -0400 (EDT)
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
 <87fsgw8l15.fsf@vps.thesusis.net>
 <CAJJqR21jhoE5Ot1Vc9qRB10sOCB70dMBsLQkZ71Buy1=kBtvyQ@mail.gmail.com>
User-agent: mu4e 1.7.12; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Luigi Fabio <luigi.fabio@gmail.com>
Cc:     Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Subject: Re: RAID5 failure and consequent ext4 problems
Date:   Tue, 13 Sep 2022 08:47:16 -0400
In-reply-to: <CAJJqR21jhoE5Ot1Vc9qRB10sOCB70dMBsLQkZ71Buy1=kBtvyQ@mail.gmail.com>
Message-ID: <87wna7zbe1.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Luigi Fabio <luigi.fabio@gmail.com> writes:

> The way I have found it explained in multiple places is that the
> backups only get updated as a consequence of an actual userspace
> interaction. So you have to run fsck or at least change settings in
> tune2fs, for instance, or resize2fs ... then all the backups get
> updated.

Exactly.  Changing the filesystem with tune2fs or resize2fs requires
that all of the backups be updated.

> The jury is still out on whether automated fscks - for those lunatics
> who haven't disabled them - update or not. There is conflicting
> information.

IIRC, a preen ( the automatic fsck at boot ) normally just sees that the
dirty flag is not set ( since the filesystem was cleanly unmounted,
right? ), and doesn't do anything else.  If there was an unclean
shutdown though, and a real fsck is run, then it updates the first
backup.


