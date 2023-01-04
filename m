Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61434C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  4 Jan 2023 15:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbjADPWO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Jan 2023 10:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbjADPWB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Jan 2023 10:22:01 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5365DEB1
        for <linux-raid@vger.kernel.org>; Wed,  4 Jan 2023 07:22:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672845711; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DAfQte7l158amjF5gau3Xsw1v5vPuJF3mwyD09p5pVTWFqybY9BLmwkfLi4GA6oMWQxCXMgpnwcxifofI6AkbstQqWXS1Mbw+vq0aQv40wnz2ZahsD7wcMuQrhjyVzCroC/07k6iVsRFE7tpRihHhzsOkLf4PxVrgAHL+tNXUgM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672845711; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=n8D8E4QIQ4wafdx+uaC7PgiyUq3M4ToGLvcJ1+AeG6g=; 
        b=iMXoAuIQtCVWW4vrUI8UpQRLKTcSXt8eGXAaJkZFpuoxuS26sG8lW1dRP8CrizGaVX8o99I4Ccvk+tnL1p5OhLenFjpNQ5tvYbWQoDsVtmIzJ5Gd/6iUIgY/c59P7BJ5nKK9ZSMDKNTTr/Bekect0tdX8IxpJKIq58udH15ggQc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672845707536306.8213726627197; Wed, 4 Jan 2023 16:21:47 +0100 (CET)
Message-ID: <fb00dd4f-6696-f74a-c543-6891f0793124@trained-monkey.org>
Date:   Wed, 4 Jan 2023 10:21:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 00/10] Block update-subarray and refactor context
 update v2
Content-Language: en-US
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20230102083524.28893-1-mateusz.kusiak@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230102083524.28893-1-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/2/23 03:35, Mateusz Kusiak wrote:
> This is the v2 of the patchset I submitted long time ago.
> I applied the changes that were requested, but since long time has
> passed I'm submitting the whole patchset once again.
> 
> Mateusz Kusiak (10):
>   mdadm: Add option validation for --update-subarray
>   Fix --update-subarray on active volume
>   Add code specific update options to enum.
>   super-ddf: Remove update_super_ddf.
>   super0: refactor the code for enum
>   super1: refactor the code for enum
>   super-intel: refactor the code for enum
>   Change update to enum in update_super and update_subarray
>   Manage&Incremental: code refactor, string to enum
>   Change char* to enum in context->update & refactor code
> 
>  Assemble.c    |  46 ++++++++-------
>  Examine.c     |   2 +-
>  Grow.c        |  17 +++---
>  Incremental.c |   8 +--
>  Manage.c      |  42 ++++++++------
>  ReadMe.c      |  31 ++++++++++
>  maps.c        |  31 ++++++++++
>  mdadm.c       | 129 ++++++++++++++----------------------------
>  mdadm.h       |  65 ++++++++++++++++++---
>  super-ddf.c   |  70 -----------------------
>  super-intel.c |  48 +++++++++-------
>  super0.c      | 103 ++++++++++++++++++++-------------
>  super1.c      | 153 ++++++++++++++++++++++++++++++--------------------
>  13 files changed, 406 insertions(+), 339 deletions(-)
> 

Applied!

Thanks,
Jes

