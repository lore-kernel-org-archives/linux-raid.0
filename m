Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E18C63798
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 11:46:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8788246F1
	for <linux-raid@archiver.kernel.org>; Thu, 19 Nov 2020 11:46:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CMUoMGmw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgKSLqk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 19 Nov 2020 06:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbgKSLqi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 19 Nov 2020 06:46:38 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96E1C0613CF
        for <linux-raid@vger.kernel.org>; Thu, 19 Nov 2020 03:46:37 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id ec16so2674171qvb.0
        for <linux-raid@vger.kernel.org>; Thu, 19 Nov 2020 03:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mcfThlyXo/aOVCyvJ5ImFe8S80pDBKtselX0cBz1vj8=;
        b=CMUoMGmwhpayt5YXYOit9QVzCPu9bQx2CjLA1hOW5IHVgrnb3COz2y+Y2+aJyP/1lf
         qvE7O1s0FX/NM80xe/TOb1TBNmsjgozOrdwphgcs0KILY6Zxh+342SzH5a2ahqyoGKnN
         0xHHPZk6ihJsTm/m8A/JFAkENW7SeN58C7PzmwjP1bXPWGYOz+LzWh9++D4fTPMGd4F7
         kCTW7zGVtW9Jhxq8vF1IWpU9ZAUs7PedIYY4tPGEvGsu7aXtt6c265JQYQU8XB12BYRL
         RpMBZtVbpx8r9FO+tAckTgOmZzIXrQnPiU4CC7v30FzrmYMbYb6hnHA6GdPv1LsrF36j
         hEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mcfThlyXo/aOVCyvJ5ImFe8S80pDBKtselX0cBz1vj8=;
        b=VOA9wE0vGASXwzQx9GHJe1C3rgPTOCrF126qLzczCw7Szq91NvNOKVpkculqtDMK1n
         tm/agaOXubHCTswiy3OJpAV9/4Z1L1Oe75JDBEGNH1jb/5ZOGVc6ylRPc6DRF7rfpwGL
         /17ImHWCYF+083o7y1v+8v7KVEkCvJR160NC1itmwE3Q3mzoJbnqIM5BVzNme0STtMA7
         VlQSUIl/Xn99dX9S1wXAzPfPC48LzXmMMXREbTn2VMuL5wFyhO/dJKYydPWNCH/f6opG
         XumpePcbTgwGKGSMXCwknaTFjj2RaA+dEkqSWe/sKyQKJ9ECvUXV/7A6UvNAgYpfnxly
         sWJQ==
X-Gm-Message-State: AOAM533NKakvBXTvpa/W18yTFYcO+mKU5MCnXM1rOnQ+kYcjnOYZqJS1
        fS5XlKbJsnlYk4aTXoItbpHZHkY0n1PmIA==
X-Google-Smtp-Source: ABdhPJx7pEgjc6AsxAt1A9HMzlW83LQLOEk20hI3SR7D1sPvn/ngSqJfZfbby7P+qOrQKbXf53CI9A==
X-Received: by 2002:a05:6214:9a5:: with SMTP id du5mr8528930qvb.56.1605786396730;
        Thu, 19 Nov 2020 03:46:36 -0800 (PST)
Received: from biodora.local ([104.238.233.190])
        by smtp.gmail.com with ESMTPSA id o21sm19021938qko.9.2020.11.19.03.46.36
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2020 03:46:36 -0800 (PST)
Subject: Re: Events Counter - How it increments
References: <819ff80e-10d0-8cc6-b34c-418fdea7b57a@gmail.com>
 <567bc78b-cf37-c40b-2e99-b86a80bdfb3e@suse.com>
 <f2d69b9a-9e2d-a104-0600-612f5d39084c@gmail.com>
 <4bade6e8-988c-11dd-0a77-5adffd926d7b@suse.com>
To:     linux-raid@vger.kernel.org
From:   =?UTF-8?Q?Jorge_F=c3=a1bregas?= <jorge.fabregas@gmail.com>
Message-ID: <847d5414-481f-5a5b-3a3d-e38861f3471f@gmail.com>
Date:   Thu, 19 Nov 2020 07:46:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <4bade6e8-988c-11dd-0a77-5adffd926d7b@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/19/20 7:27 AM, heming.zhao@suse.com wrote:
> the status/event is the content of struct mdp_superblock_1:
>     __le64  ctime;      /* lo 40 bits are seconds, top 24 are microseconds or 0*/
>     __le32  level;      /* -4 (multipath), -1 (linear), 0,1,4,5 */
>     __le32  layout;     /* only for raid5 and raid10 currently */
>     __le64  size;       /* used size of component devices, in 512byte sectors */
> 
>     __le32  chunksize;  /* in 512byte sectors */
>     __le32  raid_disks;
>     ... ...
>     __le64  reshape_position;   /* next address in array-space for reshape */
>     __le32  delta_disks;    /* change in number of raid_disks       */
>     __le32  new_layout; /* new layout                   */
>     ... ...
>     __le32  dev_number; /* permanent identifier of this  device - not role in raid */
>     ... ...
>     __le16  dev_roles[0];   /* role in array, or 0xffff for a spare, or 0xfffe for faulty */ 
> 
> I am not very familiar with md, and can't enumerate all the cases. For your writing:
> failed disk - dev_roles[X]
> read errors - may change: dev_roles[X], recovery_offset
> array checks - normally won't change, except disk fail is detected
> commands by user - depend on special cmd

Thanks Heming for  the breakdown.  That was helpful.

-- -
Jorge

