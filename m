Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05604C433EF
	for <linux-raid@archiver.kernel.org>; Tue,  9 Nov 2021 21:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D9861078
	for <linux-raid@archiver.kernel.org>; Tue,  9 Nov 2021 21:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhKIWAA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 Nov 2021 17:00:00 -0500
Received: from sender12-1.zoho.eu ([185.20.211.225]:17232 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237422AbhKIV77 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 Nov 2021 16:59:59 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1636495031; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ko1FtRVHSQG9zfSchgP5Q6o497HTjYLaXnWT11GFaNlCkHDa5jVxWkVnRHuKww5RsBGIL9Ndf3SxU8uZWv0Mq1sYJWkH/eAppaykxll/j3CCK+eqPFT/fqewTVofwllqDgDShEz6JrsGNIbnxKbtEvymawmY5v4I/qblDGJnTpM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1636495031; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=aQof8LSMkpybDbo70Wu798wpY/9UDZrKpZDVV9dtOMI=; 
        b=lGHmT6zoj0H4pRb8tm97lkuFKp8ztq3ZLeNOrZaT/crayWmOUsg0ISB+DILsezvvY2Ev7TTnbB04FrzcV/hSSs3CRiKiOdXkBlyNCLG5j1HhrAUztXz2RsPcF6IoDDgJEDJk9zna9urzXkO3dDsxESMD5cg8UzxyenhZiAnIga0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1636495030355972.4652214430728; Tue, 9 Nov 2021 22:57:10 +0100 (CET)
Subject: Re: [PATCH] imsm: assert if there is migration but prev_map doesn't
 exist
To:     Pawel Piatkowski <pawel.piatkowski@intel.com>,
        linux-raid@vger.kernel.org
References: <20211108115312.5673-1-pawel.piatkowski@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <bdaa3402-0ac0-bb15-c381-8b0d868a6894@trained-monkey.org>
Date:   Tue, 9 Nov 2021 16:57:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211108115312.5673-1-pawel.piatkowski@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/8/21 6:53 AM, Pawel Piatkowski wrote:
> Verify that prev_map in not null during volume migration.
> Practically this case is not possible, device prev_map is being
> added if it is in the middle of migration.
> Add verification to silence static code analyze errors.
> 
> Change error handling for function is_gen_migration() (as well as
> values compared with return value from this function) to use boolean
> types provided by stdbool.h.
> 
> Signed-off-by: Pawel Piatkowski <pawel.piatkowski@intel.com>
> ---

Applied!

Thanks,
Jes


