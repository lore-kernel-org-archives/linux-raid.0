Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732ADC4708D
	for <linux-raid@archiver.kernel.org>; Thu,  5 Jan 2023 03:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjAEDl6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Jan 2023 22:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjAEDl5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Jan 2023 22:41:57 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5388A48818
        for <linux-raid@vger.kernel.org>; Wed,  4 Jan 2023 19:41:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672890107; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DUtIUw5GIjvU8IgIaB2+9CfmMfxt9fACo83JcCBpZ+fbQOqT9YzKrXt9993Lx7wx+T2jVBLCUz6oOTxP09RxNkD8YaW+bJT/UpT3CCNGYGaV+KNGPkk8C9flNhugl7zEtHGGfipIS4/Id/e4bVUaC65QCKphV7cABYOsn8iFiDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672890107; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=6rNSUoIKPcmRfcun7YvAqRBauusHxx5lhg0DamsoXQU=; 
        b=REJRrPdJyZo6FhAlEBWbrTyITtKnaxr2KuUCavcy0NQ7eqXqbOf2y4NCAiKxZhMoJ7UZZDj1XmQPwvzYn6F3W1299KNdO7xz9WsBxNO8/4JxbfQPinujxVrde3Twy6m9/+WdKpqxx0XsAMg1QKvfeHtVNaVEcTgImMl6SZZjSqc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672890105896572.8648310317793; Thu, 5 Jan 2023 04:41:45 +0100 (CET)
Message-ID: <4cd7e0e0-7faa-f156-1982-b7e198a82759@trained-monkey.org>
Date:   Wed, 4 Jan 2023 22:41:43 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2] super-intel: make freesize not required for chunk size
 migration
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, xni@redhat.com
References: <20221028025117.27048-1-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20221028025117.27048-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/27/22 22:51, Kinga Tanska wrote:
> Freesize is needed to be set for migrations where size of RAID could
> be changed - expand. It tells how many free space is determined for
> members. In chunk size migartion freesize is not needed to be set,
> pointer shouldn't be checked if exists. This commit moves check to
> condition which contains size calculations, instead of checking it
> always at the first step.
> Fix return value when superblock is not set.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  super-intel.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Applied!

Thanks,
Jes


