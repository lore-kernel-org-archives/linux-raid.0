Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4BACA0FE4
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 15:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjIAPr2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 11:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbjIAPr1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 11:47:27 -0400
Received: from sender-op-o10.zoho.eu (sender-op-o10.zoho.eu [136.143.169.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2EFBAC
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 08:47:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693583234; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=GUWtGUJnwS85qodaCopcRQR5fk1O4bqGfl9BPlrxlXSHzgmtaaBE5+0XRwmB3MvJowhGODWvLM5mV3ZlLg5zLHZkzXHgp9XoQL910rc4LM+9hBsbAB+zAUNVxjRF7pa2pWg89h+rgh1K8lv27/s6PosBK56rdL7qwoCWOEa8Vqs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693583234; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=TJYz4otTDPzaWEiWLNaOSp7MGE6u/0WjNZqj2OjCSvI=; 
        b=G1+ATEXGrgEfP6v8kuvUxjIunm3Rhmiji8Os/6O5HEyeQR4OKEH4DWEjuuq+Wd8vyUYSMrxbEYKQ7riMfK92cYupZa1RTjBd6hwTQTAJ2sy7c5y5qECTd4Mvd64yRnkH8OOHL7R7WlKpEkCiRUest3lFSQAPRzDXMQ/be/gEj6I=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1693583231036965.74410489708; Fri, 1 Sep 2023 17:47:11 +0200 (CEST)
Message-ID: <3dddeea7-cfda-63d3-7169-e42ef05f9467@trained-monkey.org>
Date:   Fri, 1 Sep 2023 11:47:09 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5] Incremental: remove obsoleted calls to udisks
Content-Language: en-US
To:     Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <20230813164613.11912-1-colyli@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230813164613.11912-1-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/13/23 12:46, Coly Li wrote:
> Utility udisks is removed from udev upstream, calling this obsoleted
> command in run_udisks() doesn't make any sense now.
> 
> This patch removes the calls chain of udisks, which includes routines
> run_udisk(), force_remove(), and 2 locations where force_remove() are
> called. Considering force_remove() is removed with udisks util, it is
> fair to remove Manage_stop() inside force_remove() as well.
> 
> In the two modifications where calling force_remove() are removed,
> the failure from Manage_subdevs() can be safely ignored, because,
> 1) udisks doesn't exist, no need to check the return value to umount
>    the file system by udisks and remove the component disk again.
> 2) After the 'I' inremental remove, there is another 'r' hot remove
>    following up. The first incremental remove is a best-try effort.
> 
> Therefore in this patch, where force_remove() is removed, the return
> value of calling Manage_subdevs() is not checked too.
> 
> Signed-off-by: Coly Li <colyli@suse.de>
> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Cc: Jes Sorensen <jes@trained-monkey.org>
> ---
> Changelog,
> v5: change Mariusz's email address as he suggested
> v4: add Reviewed-by from Mariusz.
> v3: remove the almost-useless warning message, and make the change
>    more simplified.
> v2: improve based on code review comments from Mariusz.
> v1: initial version.
> 
>  Incremental.c | 64 +++++++++++----------------------------------------
>  1 file changed, 13 insertions(+), 51 deletions(-)

Been out of the loop for a while, trying to catch up.

Mariusz, do you consider this one good to go now? You were the one
providing feedback multiple times.

Thanks,
Jes


