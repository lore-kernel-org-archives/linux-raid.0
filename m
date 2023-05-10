Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E707C77B75
	for <linux-raid@archiver.kernel.org>; Wed, 10 May 2023 01:25:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjEJBZb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 9 May 2023 21:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjEJBZa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 9 May 2023 21:25:30 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA753E52
        for <linux-raid@vger.kernel.org>; Tue,  9 May 2023 18:25:29 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-619bebafb65so33038396d6.0
        for <linux-raid@vger.kernel.org>; Tue, 09 May 2023 18:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683681929; x=1686273929;
        h=content-language:content-transfer-encoding:mime-version:user-agent
         :date:message-id:subject:from:to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+VIOFfSKqppEwCw19vjEvimDEktI9PptOUm/UccnUJw=;
        b=ZRTykc9m1/8GNUR7GoDMxTjkK+Nc4Oo+nv4qF+fmrTiI7pZ8v0uIJyZl0rsT7JoX3F
         eyrFI8NTXQtb9k52jhWbxRkWwS855EZAVI/ZaIVp//cY+q29f5NPe6gMo1vXyWvMAwWF
         36UvGOY4OSHkx31pqVSeWjLHwwvBjT7w3Y99XS43ZgG0hC7ydMqyO6b3mBd+nK/Iww4q
         DxR8U9usymdZKzeqAt9Vbe/ltMcREJAGE5sMgAW4euAimAucMMTItFdM+tV14m4lXAzN
         wnqvJWv9tkG28xhlaNlyECBvbdGaN6D8C8byw79nUVOPd//7nCPp0mYgbOs/LTAHp9z9
         y8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683681929; x=1686273929;
        h=content-language:content-transfer-encoding:mime-version:user-agent
         :date:message-id:subject:from:to:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+VIOFfSKqppEwCw19vjEvimDEktI9PptOUm/UccnUJw=;
        b=d/HWOIhLupWUpOGOLsKlv0j0zuZ9whqD/B1KjUKXAO+PvHwfXS11RxK6XpyMD4IeNJ
         dxzWr5sdf2kJS1ntHWmfcARyb92WKvPUQ2VT0kx+Fq2STo6oE1YR9L0EdhtTBrByLeHH
         sHT7EaYXC/PsGF504Y+i0k9osmaMADJAG9/0hfeim8uCrcn36wVF0OnWF4VQmSojfefM
         gsnvide+e/XLh3LKq2R24rDMrohl1IEK60YkgzDMRYahfzAtNw9duCQUtHBd4/c+u/qN
         ZFrUm93+z3pg8WxnM8bu8VBwg8mqjH0pC2UyaVsi3ZLPHq7C5vdeQ6Se7aLXogDd8ZId
         Gzkg==
X-Gm-Message-State: AC+VfDxZT/O/shESm6wLDDQ5Is42FJURFuwDycezD6FlVQOFG3o+5/eF
        9/KOHFbj2BeYKxaH5ynl2R0=
X-Google-Smtp-Source: ACHHUZ5Ero1mDQyL43t3uAs+SBW0juwsVu+yOnyEojWyKoxD4m1LXEWMdpvHj+80z+qi4/Yuqm5UQg==
X-Received: by 2002:a05:6214:528b:b0:5ef:50a3:f9ca with SMTP id kj11-20020a056214528b00b005ef50a3f9camr19610728qvb.47.1683681928811;
        Tue, 09 May 2023 18:25:28 -0700 (PDT)
Received: from [192.168.125.2] (quantum.benjammin.net. [173.161.90.37])
        by smtp.gmail.com with ESMTPSA id y10-20020a0c8eca000000b0061b731bf3c2sm1183587qvb.80.2023.05.09.18.25.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 18:25:28 -0700 (PDT)
To:     Linux-RAID <linux-raid@vger.kernel.org>
From:   Benjammin2068 <benjammin2068@gmail.com>
Subject: how to set md device to specific group at boot
Message-ID: <cb1e4326-f5bd-c3c1-f262-d0106c19cb88@gmail.com>
Date:   Tue, 9 May 2023 20:25:27 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hey all,

I can't seem to find the answer (looking all around via google)...

I have a couple of RAID drives (/dev/md123, /dev/md124) I set up a long time ago (storage arrays) by hand... And have worked fine.

Tthey mount as root:root but I need them as root:disk

I can't seem to find where to change that.

Little help?

Thanks,

  -Ben

