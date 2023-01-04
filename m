Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E3CC4332F
	for <linux-raid@archiver.kernel.org>; Wed,  4 Jan 2023 16:07:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbjADQHU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Jan 2023 11:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239792AbjADQHH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Jan 2023 11:07:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C77F1705F
        for <linux-raid@vger.kernel.org>; Wed,  4 Jan 2023 08:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672848381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5RkufXgreEVZ8YCH6+2ZiVAKNx94MWpFTghk48SUqY=;
        b=fVLDZzxjwwm2AdvCqoNnG00eyXKFDm/tOkQVE2O+AQVIyr9zPjElqrRkKYmpFdsQCPeB4X
        /lBKI/uXZUhmQlBHHNf6fwamF/EXEFnJlng+SpqbSjBduoQXIA6fdfob8BrKGpXPBkx7v1
        Vcqqa0oJFmr/lCnoFcwGFsypWiesyok=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-412-nAzWAOrFP2WV3FkNMWI8AQ-1; Wed, 04 Jan 2023 11:06:20 -0500
X-MC-Unique: nAzWAOrFP2WV3FkNMWI8AQ-1
Received: by mail-pf1-f197.google.com with SMTP id 24-20020aa79118000000b00580476432deso16148943pfh.23
        for <linux-raid@vger.kernel.org>; Wed, 04 Jan 2023 08:06:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f5RkufXgreEVZ8YCH6+2ZiVAKNx94MWpFTghk48SUqY=;
        b=nacB/nExWsDkQnnLygY+b60Bj9OL0bIXAeB3sQB9taJHbtMGMXGnxTmFJgLGfXnNlA
         TEJqH9KI0ziqslFI+rZ4snL5i67e4ZRFIdUP1boojqaaeH5Wv3RtLU7miRhkIbz4SyVj
         0fvpgmANFuhv4CqY4OcDfz/Agbuaw6SKTSU8NxjRVloWTPOMgHAojYuUg1i47VbRE4E4
         Av3Q+Voa7HB7yq51Y2rZoaxyjqqCZfpqScTTwXaD6HtK8UTZtywiCHNc0H7aAiBWByyu
         uRn73VqaOvsdXGiC6m9m1jxPFxQI3VcPze+kjuvfybfvqUtvo8S/LPEjwUhI+zETa4+m
         KQyQ==
X-Gm-Message-State: AFqh2krqIGVeZlk7IoEFhqew+msU7v5ZMeoHDCZo0Ig1kwQMNtaIs46r
        s4/GY3HEobxhMM+ASX7y2ReZStlBlab8f1IG5bILBnZ0PdMI55V1X/rAjPYrTkr+58RIG5tn6BY
        4qBuKaBBIWjU9ydNckKdZ6A==
X-Received: by 2002:a17:90a:c695:b0:223:7de6:423e with SMTP id n21-20020a17090ac69500b002237de6423emr52997931pjt.31.1672848378827;
        Wed, 04 Jan 2023 08:06:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuYcBiiXmwYCFg2ARG8NMIVpHc0mffOmLPO2T9Nb/YURvdXuG7sSkiSo2kjcFJWzYsOh2zu8g==
X-Received: by 2002:a17:90a:c695:b0:223:7de6:423e with SMTP id n21-20020a17090ac69500b002237de6423emr52997914pjt.31.1672848378530;
        Wed, 04 Jan 2023 08:06:18 -0800 (PST)
Received: from [10.72.12.125] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a300300b0022618929f89sm12365448pjb.45.2023.01.04.08.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 08:06:18 -0800 (PST)
Message-ID: <fa688fc1-90ba-20ba-6b6e-c5c981d9d022@redhat.com>
Date:   Thu, 5 Jan 2023 00:06:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 1/1] Don't handle change event against raw devices
To:     Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com
References: <20221230090748.53598-1-xni@redhat.com>
 <293f8482-8032-d857-2811-1fdd022b0742@molgen.mpg.de>
 <CALTww28mmnVwL_FWT6zXXEdSk=6B24zXVxji-Etm=SxFhjPnVg@mail.gmail.com>
 <42c89d1a-44f8-1991-0a97-df7a0c06ffcc@trained-monkey.org>
From:   Xiao Ni <xni@redhat.com>
In-Reply-To: <42c89d1a-44f8-1991-0a97-df7a0c06ffcc@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


在 2023/1/4 下午11:48, Jes Sorensen 写道:
> On 12/30/22 05:37, Xiao Ni wrote:
>> On Fri, Dec 30, 2022 at 6:20 PM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>>> Dear Xiao,
>>>
>>>
>>> Thank you for the patch.
>>>
>>> Am 30.12.22 um 10:07 schrieb Xiao Ni:
>>>
>>> It’d be great if you described the problem.
>> Hi Paul
>>
>> Thanks. I'll describe more in next version.
> Hi Xiao,
>
> Did you post an updated version?
>
> Thanks,
> Jes
>
>
>
Hi Jes

I'll send the new version soon.

Regards

Xiao

