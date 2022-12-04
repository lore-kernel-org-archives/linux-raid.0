Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 018C6C352A1
	for <linux-raid@archiver.kernel.org>; Sun,  4 Dec 2022 02:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiLDCxV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 21:53:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiLDCxU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 21:53:20 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF231401B
        for <linux-raid@vger.kernel.org>; Sat,  3 Dec 2022 18:53:18 -0800 (PST)
Received: from [73.207.192.158] (port=35544 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1f81-0002n0-QI
        for linux-raid@vger.kernel.org;
        Sat, 03 Dec 2022 20:53:17 -0600
Date:   Sun, 4 Dec 2022 02:53:16 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: about linear and about RAID10
Message-ID: <20221204025316.GF19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
 <25477.7682.651953.966662@quad.stoffel.home>
 <20221203055816.GT19721@jpo>
 <dad4a4d4-70bb-f09b-c2fc-05dc2d21f8bb@youngman.org.uk>
 <20221203182721.GV19721@jpo>
 <dfbbb68c-6563-a56b-d4de-dc932cd40005@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfbbb68c-6563-a56b-d4de-dc932cd40005@youngman.org.uk>
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

Wol, et al --

Just a couple of quick notes ...


...and then Wol said...
% On 03/12/2022 18:27, David T-G wrote:
% > 
% > ...and then Wols Lists said...
% > % On 03/12/2022 05:58, David T-G wrote:
% > % >
...
% > Or that's how I understood it in the very many RAID wiki pages and other
% > docs I read :-)
% > 
% Hmm ... so being pedantic about terminology that's a definite raid-1+0, not
% linux-raid-10.

OK.  I'll try rereading the wiki pages and see where I went wrong.
Perhaps they can be clarified.


...
% it to a true raid-10. You said you had plenty of spare 2TBs, so --replace
% one of your 4TBs onto a pair of 2TBs, then --replace one of your raid-0's

Er, no.  I have plenty of "less-than-two-terabyte" drives.  They are all
used as one-off drives for archiving content.  1T here, 750G there, and
so on all as second copies for an ~18T external archive disk.  But, no, I
don't have perfect lovely half-size disks waiting to bring into play (or
they would be holding archive content! :-)

Sorry for any confusion.


HANW

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

