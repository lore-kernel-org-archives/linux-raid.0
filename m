Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45130C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 29 Mar 2022 07:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233254AbiC2HCA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 29 Mar 2022 03:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230505AbiC2HB6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 29 Mar 2022 03:01:58 -0400
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B63D9329A7
        for <linux-raid@vger.kernel.org>; Tue, 29 Mar 2022 00:00:14 -0700 (PDT)
Subject: Re: [PATCH] md/bitmap: don't set sb values if can't pass sanity check
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648537212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Iyl8uJS1aPgVoE7SAJvlqxMNgGDqJaMVlSBjBd779sI=;
        b=ibPgkEcDvVqug3ew2Z8cnSonQXwRrmnTyjgoEOrI4GJGoeCS8aNZR+b1Bi9SkRC44Hl9VI
        Kgk/cNb8AeVzpKRWzxFuOzrQGZSJ8AUc5CtQTRLXTsmT2aJ9eESA2h+oA/sYmewSUcOg4v
        i6Cj56sOu2rOXavl2qNNBFpTe8b1dJA=
To:     "heming.zhao@suse.com" <heming.zhao@suse.com>,
        linux-raid@vger.kernel.org, song@kernel.org
Cc:     xni@redhat.com
References: <20220325025223.1866-1-heming.zhao@suse.com>
 <cd198e0b-eebb-f13c-49e7-338aa6835099@linux.dev>
 <b9c2bbef-9bfd-1b60-9e56-9daedc016b3a@suse.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <54f68ed0-6674-3e8d-eea1-086b4c361411@linux.dev>
Date:   Tue, 29 Mar 2022 15:00:07 +0800
MIME-Version: 1.0
In-Reply-To: <b9c2bbef-9bfd-1b60-9e56-9daedc016b3a@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/29/22 10:37 AM, heming.zhao@suse.com wrote:
> Yes, legacy code already handle/print the reason before "goto out".
> For comment style, this area comment is legacy code, not my new added. 
> But I could
> modify it to follow the code rule. 

I am not blame you 😁. Since we are deal with relevant code, it would be 
better to correct
it's style as well, and a dedicated patch to improve style is usually 
not welcomed IMO.

Thanks,
Guoqing
