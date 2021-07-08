Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BE3C07E96
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 23:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D11613BF
	for <linux-raid@archiver.kernel.org>; Thu,  8 Jul 2021 23:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhGHXdO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Jul 2021 19:33:14 -0400
Received: from tn-76-7-174-50.sta.embarqhsd.net ([76.7.174.50]:55368 "EHLO
        animx.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhGHXdO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 8 Jul 2021 19:33:14 -0400
Received: from wakko by animx.eu.org with local 
        id 1m1dTT-0001dy-MQ; Thu, 08 Jul 2021 19:30:31 -0400
Date:   Thu, 8 Jul 2021 19:30:31 -0400
From:   Wakko Warner <wakko@animx.eu.org>
To:     Reindl Harald <h.reindl@thelounge.net>
Cc:     linux-raid@vger.kernel.org
Subject: Re: bad sector and unused area.
Message-ID: <YOeKl6vWvy9iYliT@animx.eu.org>
References: <YOdyyGBnFKHr7Xyc@animx.eu.org>
 <c2e60c47-68fd-4be2-6a8b-633d651bc2e2@thelounge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2e60c47-68fd-4be2-6a8b-633d651bc2e2@thelounge.net>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Reindl Harald wrote:
> 
> 
> Am 08.07.21 um 23:48 schrieb Wakko Warner:
> > I have a raid5 of 3 disks.
> > 
> > 2 of them have bad sectors.  Sector 1110 and 1118.
> > 
> > I'm curious to know if these sectors actually contain any data or if they
> > can just be overwritten.
> 
> the RAID layer don't know anything about data by definition, it even don't
> care what filesystem is running on top

So did you actually read what I said?

    Data Offset : 262144 sectors
   Super Offset : 0 sectors

This is /dev/sda1 which starts at sector 128 of /dev/sda.  Sector 1110 on
/dev/sda is bad.  That would place it between super offset and data offset. 
Thus, there wouldn't be a filesystem there.  I'm asking if it contains any
"data" that might be "used" by "something".  My /dev/md0 data starts at
offset 262144 of /dev/sda1 which is well beyond sector 1110 of /dev/sda.

-- 
 Microsoft has beaten Volkswagen's world record.  Volkswagen only created 22
 million bugs.
