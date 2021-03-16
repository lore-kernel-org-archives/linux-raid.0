Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D52C433E0
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 20:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF6164F73
	for <linux-raid@archiver.kernel.org>; Tue, 16 Mar 2021 20:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhCPUWx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Mar 2021 16:22:53 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17235 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhCPUWW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 16 Mar 2021 16:22:22 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1615926129; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=TIGVWFKTnuRacvHEJeb14X+ncA4cPyRuHAri+3N1Lpmud1MqUEWNUqlgCmQRbB+yyF2ztkqdXpa9ccTrCJeu+lK+c5GuNcZhtaSXuqxAKtwibP6IJzz7hNX/xSbKjuR5CegX9P9+Kfyz1+mMfoHMXIh2th4+eNO1owoOuPcBt+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615926129; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hocjA4GOPKMlNIpMUTo/xvXqA9LsdeDQKuDr9774CJk=; 
        b=b5wxdg6rsbOGpHJNFjVqTeb2nPvypDI2ag5fk38BZbwVYfbEYdem58yPFZhUTSBR2Dwt+34Jy3KMQopIqzBM5guOUwCtij4QP8ohpei3XKovChqMKe4Z98dn+cJZptuwiYUMJlaMCXD8oxsGQTINfBBM36pseJiL8Ywp7bM21lA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615926127995282.3764374690544; Tue, 16 Mar 2021 21:22:07 +0100 (CET)
Subject: Re: IMSM regresion
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <d7f430e5-fb47-a90a-60d0-e63ec85b4a3b@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <0a15c6a6-e8ba-be96-4323-bddcc2b993b8@trained-monkey.org>
Date:   Tue, 16 Mar 2021 16:22:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d7f430e5-fb47-a90a-60d0-e63ec85b4a3b@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/12/21 5:14 AM, Tkaczyk, Mariusz wrote:
> Hello Jes,
> 
> We discovered IMSM regression after last push in following scenario:
> 
> #mdadm -CR imsm0 -e imsm -n4 /dev/nvme[0125]n1
> #mdadm -CR volume -l0 --chunk 64 --raid-devices=1 /dev/nvme0n1 --force
> #mdadm -G /dev/md/imsm0 -n2
> 
> At the end of reshape, level doesn't back to RAID0.
> 
> This is an information. We are working on fix. Please don't mark release
> candidate yet.

Thanks for the heads up!

Jes

