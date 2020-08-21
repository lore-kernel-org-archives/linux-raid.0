Return-Path: <SRS0=1IH2=B7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF9A9C433E1
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 00:46:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE3B20720
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 00:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597970805;
	bh=h9S5QbVVzMMP477gwCn5Bzxa2vHJYtVVKBdJ663oFM8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Q8MUpb3gAGgk8YlX4MXxUvAGWeQ73rywLKTnyVI2HThfyBmCFObYMGED5e4VkVaWK
	 0v9Je5+GvetBR7k54v/u7hhDquJorzGPPpXQaW0+GpbzGmIGyQkJwWqOO1VyTD61Ke
	 yfQKPPzI9cG3ld7285U37AbXNl0FGn2U78afIsyU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgHUAqp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:46:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgHUAqo (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 Aug 2020 20:46:44 -0400
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D0C120720
        for <linux-raid@vger.kernel.org>; Fri, 21 Aug 2020 00:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970804;
        bh=h9S5QbVVzMMP477gwCn5Bzxa2vHJYtVVKBdJ663oFM8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eB8SbHhZfJgDi5wh7QHcOWYx67kY/T0dFHp+73wQiGBmf/XunwvqXyYfSEGzIf6kp
         0t/lgrNLwBVMlPavIlNgLNRx7z/cuV58Z/q113wd6o05bjJU8drAdF0C8WFssFUUjd
         zALAaGlHjWGn4PxzUBJDRHQ6wp4WOBPyOccDdr6s=
Received: by mail-lj1-f170.google.com with SMTP id g6so14264ljn.11
        for <linux-raid@vger.kernel.org>; Thu, 20 Aug 2020 17:46:44 -0700 (PDT)
X-Gm-Message-State: AOAM531OOfkOTvLUL3VIRSA2bCFPNBVgFWy3GzW4v56cfBJg5DKzgNeJ
        1mwnHESwOFxk320F02E8ojuuTSsA9ckZU/aeSPA=
X-Google-Smtp-Source: ABdhPJzqmEmTlthx0Ogsl8bzUrc+NCwYvD/VMIKx7qhkHK5V10vXH2R7lCBh5ZSvn6AGauqHINTvakkkwPm1v/9imk8=
X-Received: by 2002:a2e:5748:: with SMTP id r8mr269086ljd.27.1597970802664;
 Thu, 20 Aug 2020 17:46:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200820132214.3749139-1-yuyufen@huawei.com> <20200820132214.3749139-2-yuyufen@huawei.com>
In-Reply-To: <20200820132214.3749139-2-yuyufen@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Aug 2020 17:46:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6T8KgzKmntQ-+wDSgsUJQYRTnN_4PoF9XknKZ6EPyiqg@mail.gmail.com>
Message-ID: <CAPhsuW6T8KgzKmntQ-+wDSgsUJQYRTnN_4PoF9XknKZ6EPyiqg@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] md/raid5: make sure stripe_size as power of two
To:     Yufen Yu <yuyufen@huawei.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 20, 2020 at 6:21 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
> Commit 3b5408b98e4d ("md/raid5: support config stripe_size by sysfs
> entry") make stripe_size as a configurable value. It just requires
> stripe_size as multiple of 4KB.
>
> In fact, we should make sure stripe_size as power of two. Otherwise,
> stripe_shift which is the result of ilog2 can not represent the real
> stripe_size. Then, stripe_hash() and stripe_hash_locks_hash() may
> get unexpected value.
>
> Fixes: 3b5408b98e4d ("md/raid5: support config stripe_size by sysfs entry")
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>

Applied to md-fixes. Thanks!
