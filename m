Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF800C001B0
	for <linux-raid@archiver.kernel.org>; Tue,  8 Aug 2023 00:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjHHAD2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Aug 2023 20:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbjHHAD1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 7 Aug 2023 20:03:27 -0400
Received: from juniper.fatooh.org (juniper.fatooh.org [173.255.221.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC074BD
        for <linux-raid@vger.kernel.org>; Mon,  7 Aug 2023 17:03:26 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPS id B268B403B8;
        Mon,  7 Aug 2023 17:03:25 -0700 (PDT)
Received: from juniper.fatooh.org (juniper.fatooh.org [127.0.0.1])
        by juniper.fatooh.org (Postfix) with ESMTP id 8E7F9403F3;
        Mon,  7 Aug 2023 17:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; s=dkim; bh=whr1tacpaf/I
        8c0zeZWB8IzMUj4=; b=ZlFVqtDVNaFXsXgqcLfnNpkh4deLfHQfhC8nojyiIsA7
        nuu2rg/dzz/5HlwhMr3BTUkdpQyg8LrSluUKgYWCvOV6p5GRLDC+ENg50lFuflzA
        J3q7yuBi4crycRACq/D1Z4WX3tCMdgVOr2w454Fv97PQHvCbb81ryWGqjpAdDwE=
DomainKey-Signature: a=rsa-sha1; c=simple; d=fatooh.org; h=message-id
        :date:mime-version:subject:to:cc:references:from:in-reply-to
        :content-type:content-transfer-encoding; q=dns; s=dkim; b=Q3TLZu
        lOoxD1NmrmXL//FAGUExxndUeVq/t+HzDSgqqLImqZMMs3KsFjzIGk4mrlia8TuZ
        B7UiE1nUwTex0ffZ56NTkTjJT8L/3iOmmEHqc789eZUeQuvrugnGrTecFt99mFaI
        VLXyert3Vh6yrYbWpuaxBpIk4A4ThUMMX+pO0=
Received: from [198.18.0.3] (unknown [104.184.153.121])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by juniper.fatooh.org (Postfix) with ESMTPSA id 83C09403B8;
        Mon,  7 Aug 2023 17:03:25 -0700 (PDT)
Message-ID: <bd57c5f7-fec4-4f05-8d03-a62db6309740@fatooh.org>
Date:   Mon, 7 Aug 2023 17:03:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: NULL pointer dereference with MD write-back journal, where
 journal device is RAID-1
Content-Language: en-US
To:     Yu Kuai <yukuai1@huaweicloud.com>,
        'Linux RAID' <linux-raid@vger.kernel.org>
Cc:     "yangerkun@huawei.com" <yangerkun@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <7c57f3a8-36e9-4805-b1ea-a4fd3406f7bb@fatooh.org>
 <f8b858cc-8762-6b53-43ec-7f509a971f16@huaweicloud.com>
 <428ed674-6e8c-471b-93d7-0532549fb218@fatooh.org>
 <d7cf0981-2d7c-5285-ce63-a66caf97e1db@huaweicloud.com>
 <91d3a3b8-572e-b674-9dc2-c2a7af3b9806@huaweicloud.com>
 <cddd7213-3dfd-4ab7-a3ac-edd54d74a626@fatooh.org>
 <90f93747-2b16-eb7d-d149-01b98b5e4bcb@huaweicloud.com>
From:   Corey Hickey <bugfood-ml@fatooh.org>
In-Reply-To: <90f93747-2b16-eb7d-d149-01b98b5e4bcb@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2023-08-06 23:08, Yu Kuai wrote:
>> Thank you for this! I wasn't expecting such a fast response, especially
>> on the weekend.
> 
> It's Monday for us, actually 😄

Oh, I should have realized. Thank you all the same.

-Corey
