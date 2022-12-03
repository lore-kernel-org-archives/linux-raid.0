Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C5EC352A1
	for <linux-raid@archiver.kernel.org>; Sat,  3 Dec 2022 05:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiLCFpc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Dec 2022 00:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiLCFpb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Dec 2022 00:45:31 -0500
Received: from www18.qth.com (www18.qth.com [69.16.238.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EBAACA62
        for <linux-raid@vger.kernel.org>; Fri,  2 Dec 2022 21:45:30 -0800 (PST)
Received: from [73.207.192.158] (port=34138 helo=jpo)
        by www18.qth.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <davidtg-robot@justpickone.org>)
        id 1p1LL7-0005t4-MF
        for linux-raid@vger.kernel.org;
        Fri, 02 Dec 2022 23:45:29 -0600
Date:   Sat, 3 Dec 2022 05:45:28 +0000
From:   David T-G <davidtg-robot@justpickone.org>
To:     Linux RAID list <linux-raid@vger.kernel.org>
Subject: Re: about linear and about RAID10
Message-ID: <20221203054528.GR19721@jpo>
Reply-To: Linux RAID list <linux-raid@vger.kernel.org>
References: <20221123220736.GD19721@jpo>
 <20221124032821.628cd042@nvm>
 <20221124211019.GE19721@jpo>
 <512a4cdd-9013-e158-7c77-7409cd0dc3a1@youngman.org.uk>
 <20221125133050.GH19721@jpo>
 <CAAMCDee6cyM5Uw6DitWtBL3W8NbW7j0DZcUp8A2CXWZbYceXeA@mail.gmail.com>
 <20221128144630.GN19721@jpo>
 <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548f5325-0c3b-1642-2b08-ae7b637b3ad3@thelounge.net>
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

Reindl, et al --

...and then Reindl Harald said...
% 
% Am 28.11.22 um 15:46 schrieb David T-G:
% > I don't at this time have a device free to plug in locally to back up the
% > volume to destroy and rebuild as linear, so that will have to wait.  When
% > I do get that chance, though, will that help me get to the awesome goal
% > of actually INCREASING performance by including a RAID0 layer?
% 
% stacking layers over layers will *never* increase performance - a pure RAID0
% will but if one disk is dead all is lost

True, and we definitely don't want that.


% 
% additional RAID0 on top or below another RAID won't help

I could believe that, because what I don't know about RAID would fill a
book, but I thought that the idea of RAID10 speeding up access was that
the first half of the data is on the FIRST half of the /first/ disk
and the second half of the data is on the FIRST half of the /second/
disk and so the heads only move over half the disk for reads.


% 
% your main problem starts by slicing your drives in dozens of partitions and
% "the idea being that each piece of which should take less time to rebuild if
% something fails"
[snip]

Whoops!  You're on the wrong machine.  This one mirrors two disks; that
one is the one that has a bunch.


HANN

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

