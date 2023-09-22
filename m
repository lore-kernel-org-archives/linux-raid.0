Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E639CD4843
	for <linux-raid@archiver.kernel.org>; Fri, 22 Sep 2023 16:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjIVQZ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 22 Sep 2023 12:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjIVQZz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 22 Sep 2023 12:25:55 -0400
X-Greylist: delayed 528 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Sep 2023 09:25:49 PDT
Received: from mail.ultracoder.org (unknown [188.227.94.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBD2139
        for <linux-raid@vger.kernel.org>; Fri, 22 Sep 2023 09:25:49 -0700 (PDT)
Message-ID: <b8f8cc10-8081-afe4-738b-376a1248ec05@ultracoder.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ultracoder.org;
        s=mail; t=1695399418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8XvFx35xAzPJ0O4ZKCag3dv6r/zGsoc37+tKPsb4+v4=;
        b=fB4QnQ1WyDHs7lIIdebLPLbD3CkqS60K/XtRJKwC/BiYKwafUlHPfiawci8zsHka687jvA
        ez3Wis6lG/02kC8dpKG2lxASfnXHFhAWKJoXKixKW+43r3u5jlPV2vN2osB9Uuj1meuDsv
        7GYF5AgtoLq5l3uHv9jvSyIocGI3mgTB6uzu5PlaERGvtFLLq1Lx2Unm4S0rEMlbKJ1fnB
        O+exkeaAKUqGC3WCwvi2uz0LQ8CjcTB31UYEyt75ClSzr8qTQofMy1z/UytOk0O35XLlTH
        fMJeiWcQRa4y8958wPd3Vg/XC/hgCBlgRkNd8B2qU8aQ9YUl653OXLagr0ZqEQ==
Date:   Fri, 22 Sep 2023 19:16:58 +0300
MIME-Version: 1.0
Subject: Re: fstrim on raid1 LV with writemostly PV leads to system freeze
Content-Language: ru-RU, en-US
To:     Mike Snitzer <snitzer@kernel.org>, Roman Mamedov <rm@romanrm.net>
References: <0e15b760-2d5f-f639-0fc7-eed67f8c385c@ultracoder.org>
 <ZQy5dClooWaZoS/N@redhat.com> <20230922030340.2eaa46bc@nvm>
From:   Kirill Kirilenko <kirill@ultracoder.org>
Cc:     Alasdair Kergon <agk@redhat.com>, heinzm@redhat.com,
        dm-devel@redhat.com, linux-raid@vger.kernel.org
In-Reply-To: <20230922030340.2eaa46bc@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 22.09.2023 00:45 +0300, Mike Snitzer wrote:
> Given your use of 'writemostly' I'm inferring you're using lvm2's
> raid1 that uses MD raid1 code in terms of the dm-raid target.

Yes, exactly.

On 22.09.2023 00:45 +0300, Mike Snitzer wrote:
> All said: hopefully someone more MD oriented can review your report
> and help you further.
Thank you. I don't need to send a new report to MD maintainers, do I?

On 22.09.2023 01:03 +0300, Roman Mamedov wrote:
> Maybe your system hasn't frozen too, just taking its time in processing all
> the tiny split requests.
I don't think so, because the disk activity light is off. Let me clarify:
if music was playing when the system froze, the last sound buffer begins 
to play cyclically.
