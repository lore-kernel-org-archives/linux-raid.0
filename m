Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D075DC00A5A
	for <linux-raid@archiver.kernel.org>; Thu, 19 Jan 2023 16:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjASQmo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Jan 2023 11:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjASQml (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Jan 2023 11:42:41 -0500
X-Greylist: delayed 411 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 Jan 2023 08:42:36 PST
Received: from len.romanrm.net (len.romanrm.net [91.121.86.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031254DE0D
        for <linux-raid@vger.kernel.org>; Thu, 19 Jan 2023 08:42:36 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by len.romanrm.net (Postfix) with SMTP id 79CCC401A5;
        Thu, 19 Jan 2023 16:35:41 +0000 (UTC)
Date:   Thu, 19 Jan 2023 21:35:40 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     o1bigtenor <o1bigtenor@gmail.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>
Subject: Re: Question on sdds
Message-ID: <20230119213540.0da26fbb@nvm>
In-Reply-To: <CAPpdf599Vr2tEgpmURTbK09uesM6PYYof1ngCFkvAUmcHnowVA@mail.gmail.com>
References: <CAPpdf599Vr2tEgpmURTbK09uesM6PYYof1ngCFkvAUmcHnowVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 19 Jan 2023 10:12:03 -0600
o1bigtenor <o1bigtenor@gmail.com> wrote:

> There is smartmontools for testing the health of hdds.
> 
> Is there something comparable for sdds?
> (Thinking this includes nvme, sdds, usb sticks, m2 listed drives
> (is that in this group) or any similar.)

smartmontools does support NVMe and SATA SSDs no problem.

It does not support USB flash sticks, SD cards and eMMC storage.

-- 
With respect,
Roman
