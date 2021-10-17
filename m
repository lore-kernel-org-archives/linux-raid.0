Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F7FC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 16:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E0761151
	for <linux-raid@archiver.kernel.org>; Sun, 17 Oct 2021 16:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242531AbhJQQ20 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 17 Oct 2021 12:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233820AbhJQQ20 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 17 Oct 2021 12:28:26 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5716EC06161C
        for <linux-raid@vger.kernel.org>; Sun, 17 Oct 2021 09:26:16 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id w11so12448610ilv.6
        for <linux-raid@vger.kernel.org>; Sun, 17 Oct 2021 09:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UTayOQS6NMmtQmpLeEorjBDh793Tfq0LJcx60uzbfrM=;
        b=kBhVOMSvcYjsHD7+LejRSuF7S7XkdDQfGfQNXE7eaAleCqxIOr9p9ias9/q0Z80AjR
         B5SH7Pao92VU3U/jpkx5T4IkV0yeo+bAH56Er6WmM9gYF+i7Bbss3/M96JW2fsOsCTna
         Yu3c0OB2bEZ1rZNwZvpiQiEQj68gBIJxwJrxh1l2FCiqGQxlLlDBK1jzDL8oe/q36DQL
         8Gc82ySb1zxkZfD0s/poxVQW80jQkkHOqUeiW+9rsCavCMK0Qg2eCgpM8ylRCI6w87ub
         Q38WztWU0UMBr52W8TYIxNm2iHpeWdzxXeibuGntA7eWQ8nFgV4cKAPMGFc+eKjhiFpb
         lEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UTayOQS6NMmtQmpLeEorjBDh793Tfq0LJcx60uzbfrM=;
        b=oVymqKYF1ZnS73C+rCPvYsG9i5WU4mZqBnaJsqE853Fyy74DvCYY+QVTtKUm1ag4uK
         QQP8wG4e/qWTkpKg18IhawxD6PMd0bcEj5O6tjoV9rFfVxdJ1W4gGRbpZj7BzBXYzf3l
         k9f47BVWX25SyP/ArodeZfBq1BJrVqYAjqh8GXpdkczge+7LtVSurYdVW4N712fAXUuE
         r6gAZEvGT38EYL3S/b5C1jXSlT1B/9g82RknDCtOIHoEJGjDYFuzeaTgF29WlNAWZnuV
         +ewdA2HbMncezgvQSSaFrgdNQ83RVRQUUljJznTlBdthOzCKYkIio8468V03cqtbJ6vo
         Glcw==
X-Gm-Message-State: AOAM533YG2U6ICLk5L/BDBANfe8iQtUDTcP3k9u12RhPhJwSFlc4O07g
        IMbVQ8d9DIzs+mWaeSozwkxCEg==
X-Google-Smtp-Source: ABdhPJwcf1Bxxq/xPeO5pYq66pm8UZe5M9Gvm8syAM+RgSm1tTVA9o17qdyw/iaXSMtWyU2bAT8npQ==
X-Received: by 2002:a92:ca0c:: with SMTP id j12mr12163738ils.50.1634487975772;
        Sun, 17 Oct 2021 09:26:15 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id h9sm5567522ild.68.2021.10.17.09.26.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Oct 2021 09:26:15 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20211014
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Guoqing Jiang <jgq516@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>, Xiao Ni <xni@redhat.com>,
        Li Feng <fengli@smartx.com>
References: <7A48D169-FBD9-4F13-8E4C-022DCFAE3D8B@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <07ee5687-96cc-b38b-85cb-4af1a3cec896@kernel.dk>
Date:   Sun, 17 Oct 2021 10:26:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7A48D169-FBD9-4F13-8E4C-022DCFAE3D8B@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/14/21 6:28 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-5.16/drivers branch. The major changes are:
> 
> 1. add_disk() error handling, by Luis Chamberlain;
> 2. locking/unwind improvement in md_alloc, by Christoph Hellwig;
> 3. update superblock after changing rdev flags, by Xiao Ni;
> 4. various clean-ups and small fixes, by Guoqing Jiang.

Pulled, thanks.

-- 
Jens Axboe

