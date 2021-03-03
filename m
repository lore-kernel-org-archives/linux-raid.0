Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A39C433DB
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5332B64F37
	for <linux-raid@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241091AbhCDAAC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:00:02 -0500
Received: from smtpout2.vodafonemail.de ([145.253.239.133]:36208 "EHLO
        smtpout2.vodafonemail.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242414AbhCCRGP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 3 Mar 2021 12:06:15 -0500
X-Greylist: delayed 717 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2021 12:06:14 EST
Received: from smtp.vodafone.de (smtpa06.fra-mediabeam.com [10.2.0.36])
        by smtpout2.vodafonemail.de (Postfix) with ESMTP id 767D712297C;
        Wed,  3 Mar 2021 17:53:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
        s=vfde-smtpout-mb-15sep; t=1614790388;
        bh=hkyqJCac/TGNi0wtta2vOiHTn9pUzQjP09Dhv+4mscs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=li3KJ2BK/wGwWP+N2Jm1S+rKqkZeyz9Z7lvLd0KtsBH229gGRTwdr/XVVjrsbKLtM
         ES9BZhw8fVn32tPDbzIvV4P14rTpbRUooPQVsLIna0oFcyt2YWrILl+QvnEpwRHAUs
         +sD17aQsDtagvq0a8N3yttHWlDhwooDiddKDv29c=
Received: from lazy.lzy (p579d7ebd.dip0.t-ipconnect.de [87.157.126.189])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 1AEB814130A;
        Wed,  3 Mar 2021 16:53:07 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
        by lazy.lzy (8.16.1/8.14.5) with ESMTPS id 123GqwOT002785
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 3 Mar 2021 17:52:58 +0100
Received: (from red@localhost)
        by lazy.lzy (8.16.1/8.15.2/Submit) id 123Gqwl4002784;
        Wed, 3 Mar 2021 17:52:58 +0100
Date:   Wed, 3 Mar 2021 17:52:58 +0100
From:   Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
Subject: Re: release plan for mdadm
Message-ID: <YD++6ivr0zrUTO3B@lazy.lzy>
References: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com>
 <2cb77cb7-468d-88ed-a938-63b35e574177@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cb77cb7-468d-88ed-a938-63b35e574177@trained-monkey.org>
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-purgate-size: 235
X-purgate-ID: 155817::1614790388-00000891-9D4065A6/0/0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Mar 02, 2021 at 05:50:10PM -0500, Jes Sorensen wrote:
> Sorry for the slow response. Our daughter was born in late December and

Well! Congratulations!

I know, a bit OT, but still deserved!

bye,

-- 

piergiorgio
