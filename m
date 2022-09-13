Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC242C6FA82
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 12:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbiIMM5K (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 13 Sep 2022 08:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiIMM5I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 13 Sep 2022 08:57:08 -0400
Received: from vps.thesusis.net (vps.thesusis.net [34.202.238.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D583425F3
        for <linux-raid@vger.kernel.org>; Tue, 13 Sep 2022 05:57:07 -0700 (PDT)
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id 1C62FE62B5; Tue, 13 Sep 2022 08:56:37 -0400 (EDT)
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org>
 <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org>
 <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
 <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org>
 <87k0688l6i.fsf@vps.thesusis.net>
 <CAJJqR21N2G5-nN_Ef+2W51FmQ40e8WbZfmrN6c42rdid2T_GoA@mail.gmail.com>
User-agent: mu4e 1.7.12; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Luigi Fabio <luigi.fabio@gmail.com>
Cc:     Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Subject: Re: RAID5 failure and consequent ext4 problems
Date:   Tue, 13 Sep 2022 08:51:25 -0400
In-reply-to: <CAJJqR21N2G5-nN_Ef+2W51FmQ40e8WbZfmrN6c42rdid2T_GoA@mail.gmail.com>
Message-ID: <87sfkvzb3u.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Luigi Fabio <luigi.fabio@gmail.com> writes:

> Well, there are several possible explanations, but persistence is
> desireable - so evidently enumeration occurs according to controller
> order in a repeatable way until something changes in the configuration
> - or until you change kernel, someone does something funny with a
> driver and the order changes. In 28 years of using Linux, however,
> this has happened.. rarely, save for before things were sensible WAY
> back when.

I *think* it is only because the probes are all *started* in the natural
order, so as long as the drives all respond in the same, short amount of
time, you get no surprises.  If one drive decides to take a little
longer to answer today though, it can throw things off.

