Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88CE1ECAAA1
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 22:11:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiIIWL1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 18:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiIIWLY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 18:11:24 -0400
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E0C6D556
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 15:11:20 -0700 (PDT)
Received: from [73.207.192.158] (port=46362 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1oWmDb-00059m-Pd
        for linux-raid@vger.kernel.org;
        Fri, 09 Sep 2022 17:11:19 -0500
Date:   Fri, 9 Sep 2022 22:11:18 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     linux-raid@vger.kernel.org
Subject: Re: RAID5 failure and consequent ext4 problems
Message-ID: <20220909221118.GG7367@jpo>
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org>
 <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - www18.qth.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - justpickone.org
X-Get-Message-Sender-Via: www18.qth.com: authenticated_id: dmail@justpickone.org
X-Authenticated-Sender: www18.qth.com: dmail@justpickone.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Phil & Luigi, et al --

...and then Phil Turmel said...
% 
...

% 
% You haven't mentioned whether your --create operations specified
% --assume-clean.

He hasn't?


% 
% On 9/9/22 17:01, Luigi Fabio wrote:
...
% > 
% > On Fri, Sep 9, 2022 at 4:32 PM Luigi Fabio <luigi.fabio@gmail.com> wrote:
% > > 
...
% > > > But I'll be brutally honest:  your data is likely toast.
% > > Well, let's hope it isn't. All mdadm commands were -o and
% > > --assume-clean, so in theory the only thing which HAS been written are
% > > the md blocks, unless I am mistaken and/or I read the docs
% > > incorrectly?
...
% > > This is the list of --create and --assemble commands from the 6th
...
% > >   9813  mdadm --assemble /dev/md123 missing
% > >   9814  mdadm --assemble /dev/md123 missing /dev/sdf1 /dev/sdg1
...
% > >   9815  mdadm --assemble /dev/md123 /dev/sdf1 /dev/sdg1 /dev/sdk1
...
% > > /dev/sdm1
% > >   9823  mdadm --create -o -n 12 -l 5 /dev/md124 missing /dev/sde1
...
% > >   9824  mdadm --create -o -n 12 -l 5 /dev/md124 missing /dev/sde1
...
% > >   9852  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
...
% > >   9863  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
...
% > >   9879  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
...
% > >   9889  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
...
% > >   9892  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
...
% > >   9895  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
...
% > >   9901  mdadm --assemble /dev/md123 /dev/sdn1 /dev/sde1 /dev/sdf1
...
% > >   9903  mdadm --create -o --assume-clean -n 12 -l 5 --metadata=0.90
...
% > > 
% > > Note that they all were -o, therefore if I am not mistaken no parity
% > > data was written anywhere. Note further the fact that the first two
% > > were the 'mistake' ones, which did NOT have --assume-clean (but with
% > > -o this shouldn't make a difference AFAIK) and most importantly the
% > > metadata was the 1.2 default AND they were the wrong array in the
% > > first place.
[snip]

I certainly don't know what I'm talking about, so this is all I'll say,
but it looked reasonably complete to me ...


HTH & HANW

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

