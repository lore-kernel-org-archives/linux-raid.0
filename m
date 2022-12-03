Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BEFFC352A1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 18:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLCSE3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 13:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLCSE2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 13:04:28 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5931FFA2
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 10:04:27 -0800 (PST)
Received: from [73.207.192.158] (port=34930 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1WsF-00051B-7i
        for linux-raid@vger.kernel.org;
        Sat, 03 Dec 2022 12:04:27 -0600
Date:   Sat, 3 Dec 2022 18:04:25 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: batches and serial numbers (was "Re: md vs LVM and VMs and ...")
Message-ID: <20221203180425.GU19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <CAAMCDecPXmZsxaAPcSOOY4S7_ieRZC8O_u7LjLLH-t8L-6+21Q@mail.gmail.com>
 <20221125132259.GG19721@jpo>
 <CAAMCDed1-4zFgHMS760dO1pThtkrn8K+FMuG-QQ+9W-FE0iq9Q@mail.gmail.com>
 <20221125194932.GK19721@jpo>
 <20221128142422.GM19721@jpo>
 <ab803396-fb7f-50b6-9aa8-2803aa526fe4@sotapeli.fi>
 <20221203054130.GP19721@jpo>
 <1e419d58-46d8-affa-36dc-ef8c14760305@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e419d58-46d8-affa-36dc-ef8c14760305@youngman.org.uk>
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

Anthony, et al --

...and then Wols Lists said...
% On 03/12/2022 05:41, David T-G wrote:
% > 
% > The good news here is that I don't mix disk sizes; all of these are not
% > only the same size but, for the foreseeable future, the exact same model.
% 
% From the exact same batch? That's BAD news actually.

I don't know about the same batch.  I got three together, so maybe, and
then I recently added a fourth.

  diskfarm:~ # for D in /dev/sd[bcdk] ; do printf "$D\t" ; smartctl -i $D | grep Serial ; done
  /dev/sdb        Serial Number:    61U0A0HQFBKG
  /dev/sdc        Serial Number:    61U0A0BEFBKG
  /dev/sdd        Serial Number:    61U0A007FBKG
  /dev/sdk        Serial Number:    91C0A03ZFBKG

How close is too close for SNs?  Anyone have a magic decoder ring?

I seriously think I'm going to be asking for another -- plus the
corresponding offsite external drive -- for Christmas, so we'll be
even more homogeneous as time goes on and maybe sooner than later.


% 
% Now that disk sizes have been standardised (and the number of actual
% factories/manufacturers seriously reduced), it should be that a 1TB drive is
% a 1TB drive is a 1TB drive. Decimal, that is, not binary. So there
% *shouldn't* be any problems swapping one random drive out for another.

That would be nice.  But it just feels so ... WRONG! :-)  I don't want
to have to sweat different numbers of sectors or different caches or
different speeds that will just make hiccups.  I'm not yet sold on
going multi-vendor all together ...  [In different arrays or machines,
certainly, but not when they're supposed to be identical members.]


% 
% But if all your drives are the same make, model(, and batch), there is a not
% insignificant risk they will all share the same defects, and fail at the
% same time. It's accepted the risk is small, but it's there.

What is the problem?  Is it the manufacturer's firmware?  Is it the day
they were made?  If I order a Tosh, a Seag, and a WD all on the same day
then it sounds like I'm [much more] likely to get clones made at the same
time in those few factories.  But I couldn't just buy a drive a quarter
and wait nearly a year to get up and running; I had to start somewhere ...


% 
% It's why my raid is composed of a Seagate Barracuda 3TB (slap wrist, don't
% use Barracudas!), 2 x 4TB Seagate Ironwolves, and 1 Toshiba 8TB N300.

These are Tosh X300s, FWIW.  Like 'em so far!


% 
% Cheers,
% Wol


HAND

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

