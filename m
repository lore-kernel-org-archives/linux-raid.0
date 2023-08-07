Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336B3C0015E
	for <linux-raid@archiver.kernel.org>; Mon,  7 Aug 2023 03:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjHGDWb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Aug 2023 23:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjHGDWa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Aug 2023 23:22:30 -0400
X-Greylist: delayed 16454 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 06 Aug 2023 20:22:28 PDT
Received: from juniper.fatooh.org (juniper.fatooh.org [IPv6:2600:3c01:e000:3fa::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A017C10F7
        for <linux-raid@vger.kernel.org>; Sun,  6 Aug 2023 20:22:28 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id 51305403E5;
        Sun,  6 Aug 2023 20:22:28 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 275D9403F3;
        Sun,  6 Aug 2023 20:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:references:from:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=v0MTsch4GzWp
        YoYklII0iFcj8p4=; b=TA8M855WNp8KQzwD0+2o3U7HY5ctEnthw5U1+WblZn42
        bNuC+X7Mq25kiN/ACZ+qBDsmNd6QpMDUMKiaNVgk61YhHIHeGzDkofgGXtCjO46l
        EgQ5o1kSU9HQGn+4DBbPtRDtB7Tt+4E+oneGCbkTd3faPFzAHBIOs6nhPJyWnpo=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:references:from:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=ZoIm8Y
        9RszOXfOV2suTecKOlyzebNY0iwLRApgM6kxifiozf2bE2EiDd+CkLbTIasgxnnk
        DyopeqEvk9/qFpXO7nD3AWP+QZ24mCUgcz44IJpL/YSVoaoOJqKdzNIo6641zetd
        nmUD0MgOZEFw4hlfHPhkYwQsNbweCwXNWLmN8=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 16468403E5;
        Sun,  6 Aug 2023 20:22:28 -0700 (PDT)
Message-ID: <c494be98-904d-48cd-938f-1ceaa3b3d780@fatooh.org>
Date:   Sun, 6 Aug 2023 20:22:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: NULL pointer dereference with MD write-back journal, where
 journal device is RAID-1
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        'Linux RAID' <linux-raid@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org>
 <f8b858cc-8762-6b53-43ec-7f509a971f16@huaweicloud.com>
 <428ed674-6e8c-471b-93d7-0532549fb218@fatooh.org>
 <d7cf0981-2d7c-5285-ce63-a66caf97e1db@huaweicloud.com>
From:   Corey Hickey <bugfood-ml@fatooh.org>
In-Reply-To: <d7cf0981-2d7c-5285-ce63-a66caf97e1db@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2023-08-06 19:15, Yu Kuai wrote:
>> Is that what you are looking for?
> 
> Yes, and can you provide witch commit are you testing?

This is 6.4.8 from the release tarball:
https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.4.8.tar.xz

Thank you,
Corey
