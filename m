Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 642A1C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 09:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AB31610FE
	for <linux-raid@archiver.kernel.org>; Tue,  7 Sep 2021 09:18:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244782AbhIGJTq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Sep 2021 05:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245002AbhIGJTp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Sep 2021 05:19:45 -0400
X-Greylist: delayed 5193 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Sep 2021 02:18:39 PDT
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E43C061575
        for <linux-raid@vger.kernel.org>; Tue,  7 Sep 2021 02:18:39 -0700 (PDT)
Received: from natsu (natsu2.home.romanrm.net [IPv6:fd39::e99e:8f1b:cfc9:ccb8])
        by rin.romanrm.net (Postfix) with SMTP id 3E3F0664;
        Tue,  7 Sep 2021 09:18:36 +0000 (UTC)
Date:   Tue, 7 Sep 2021 14:18:35 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Ryan Patterson <ryan.goat@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: mdadm resync causes stable system to crash every 2 or 3 hours
Message-ID: <20210907141835.259010e3@natsu>
In-Reply-To: <20210907125201.0cc77658@natsu>
References: <CA+Kggd7mUF9MWdJsLtAQMv=KXtwaNvj6BqfM+NMyffE86iHBoQ@mail.gmail.com>
        <20210907125201.0cc77658@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 7 Sep 2021 12:52:01 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> On Mon, 6 Sep 2021 20:44:31 -0400
> Ryan Patterson <ryan.goat@gmail.com> wrote:
> 
> > My file server is usually very stable.  The past week I had two mdadm
> > arrays that required recync operations.
> > * newly created raid6 array (14 x 16TB seagate exos)
> > * existing raid 6 array, after a reboot resync on hot spare (14 x 4TB
> > seagate barracuda)
> > 
> > During both resync operations (they ran one at a time) the system
> > would routinely experience a major error and require a hard reboot,
> > every two or three hours.  I saw several errors, such as:
> > * kernel watchdog soft lockups [md127_raid6:364]
> > * general protection faults (I have a few saved with the full exception stack)
> > * exceptions in iommu routines (again I have the full error with
> > exception stack saved)
> > * full system lockup
> 
> So in other words the server is very stable, unless asked to do full-speed
> reads from all disks at the same time.
> 
> I'd suggest to check or improve cooling on the HBA cards, and then try a
> different PSU.

Also the motherboard chipset cooling, since that's a lot of PCI-E traffic.
Maybe the CPU cooling as well, or at least check the CPU temperatures during
this load.

And since you have full logs and backtraces, there's no point in waiting to
post those, just go ahead. Maybe they will point to something other than
suspect hardware, or at least to which part of hardware to suspect.

-- 
With respect,
Roman
