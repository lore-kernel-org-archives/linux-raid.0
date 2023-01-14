Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12867C3DA78
	for <linux-raid@archiver.kernel.org>; Sat, 14 Jan 2023 03:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjANDsj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 13 Jan 2023 22:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjANDsi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 13 Jan 2023 22:48:38 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A989A461
        for <linux-raid@vger.kernel.org>; Fri, 13 Jan 2023 19:48:37 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id q64so24240223pjq.4
        for <linux-raid@vger.kernel.org>; Fri, 13 Jan 2023 19:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wjb/l2Eny9Ne+C4GdrYn2IKk4Y0UwpmKhl13Q0adp98=;
        b=yWdiV/xH8oZZGUb4M+cJq+M6OYl7a4beBHhQzP559k6d9TWHqIbF63kmeR4eGJWb39
         IEcrruGU39UcxjfNlRj/y+GKRSFpboZfHJkN3CWEENW2e7GWZvvz2uy04aanJ1j6k/8Y
         6xfbsKEyY3a5alv1kRbXIjGaeo2qDFNqK+bhAcmkq9RowfXH2i+juFr+zbM7v/gidaTH
         e3G6X+F4MtxErYdpCopI78sCXA2RKZiOWI9kVzUqJxtaspBRgtStLyGfnzKQ9vAwdauv
         cBC0WkFYqcQ7LUdI6YkUTN+o1JJdhBfDoO96jQtsbiFDRD7oQ2ra7tE5t5blj+oDDMbz
         MR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wjb/l2Eny9Ne+C4GdrYn2IKk4Y0UwpmKhl13Q0adp98=;
        b=jpnl583dZu8u0da3v+/4J46QLI0vmhg7He4Sbgr7E5Oc/K6h/rXex3AdBBZmVudBS6
         fd1F6jO9npbL2aEgeRuDzKhtITkFSOCCQKNk4+s2qrY2kl824xzYTNafwkqVSYUWX2V3
         RDQAkkW9kU7qZtyKZ2Ea9wthN1x87pTmlqwGrVD8mIxBHvlFbLByICm3t2QM/dXKy4/v
         AupKN0I6XGuAn+bl3j94Xer3g72aIAbeBeew0aYZ6w234HzYmWQunCd8dEKx+cYA77EQ
         //oDFAXCXa0sk8q8CfrNbnTUocEKSvLlWYYh9k4cFYZgZ5wS0oY/BBFacTF7aQOqmfcL
         SENA==
X-Gm-Message-State: AFqh2kq9oEVAiE70JKjyYw7cE3Yrrh5eRLI+S1WXkY5nj8D31qzvvv3d
        yEmTzRl2l7RsqfzzT8ABumzr1g==
X-Google-Smtp-Source: AMrXdXu/8s5GqtLBoBvO5tkGNTP/bDM+0eu09RjFsnLnnVFIQ558KaeI9yqTaW+NoB0E+Dfw4UKa/A==
X-Received: by 2002:a05:6a20:a587:b0:a7:c027:f84a with SMTP id bc7-20020a056a20a58700b000a7c027f84amr26113739pzb.1.1673668116991;
        Fri, 13 Jan 2023 19:48:36 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g18-20020a635212000000b004a1e160b431sm12066051pgb.68.2023.01.13.19.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 19:48:36 -0800 (PST)
Message-ID: <2192deab-e74b-c86e-7904-f893a6660c85@kernel.dk>
Date:   Fri, 13 Jan 2023 20:48:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [GIT PULL] md-fixes 20230113
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Adrian Huang <ahuang12@lenovo.com>, Christoph Hellwig <hch@lst.de>
References: <316DF255-F73A-41FF-AA1C-758669C0C466@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <316DF255-F73A-41FF-AA1C-758669C0C466@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/13/23 4:13 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-fixes on top of your
> block-6.2 branch. It fixes an issue introduced by recent code refactor. 

Pulled, thanks. It won't make -rc4 as that already went out, it'll
be for next week.

-- 
Jens Axboe


