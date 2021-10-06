Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9ECC4332F
	for <linux-raid@archiver.kernel.org>; Wed,  6 Oct 2021 11:13:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B10E610FC
	for <linux-raid@archiver.kernel.org>; Wed,  6 Oct 2021 11:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238565AbhJFLPn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Oct 2021 07:15:43 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17278 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238192AbhJFLPM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Oct 2021 07:15:12 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Oct 2021 07:15:12 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1633517886; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=NkvigmpN2lInNv7Gqrk0G4+fV3/cq5tU6zPX0kcM/yBvsn9xA4iMjGj46fuCFOQkKy8dNJKtwin4buinUVy6DgjQKHm3tOALbJ8LV5q//JdK7+a2L3iEGigRLVIKaaUenyfCY2HoOOgE8rHWAQfI1Edkiy17hyG8L5vKaRpR5mg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633517886; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=njNKFVdvs+DDHJXa2WRsdCD49rdXmgKF1c8MkxXWnt8=; 
        b=aRwONLaoHbSqt8m/lEI/cTPau/TuMhDT3dxqukYiu5U3i++WPFshh+Pi7fzLskDZM1qPTZGwgeIKlq1VZFZkCkYGWFi/c40Q+q/KVo3yC/FS8Tb23aZ4Ss1vDdr+vyeay6WSXCWbAadaHLx5pPKccr4Znaxz0uqyS+Rebu10qt4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.4.32] (85.184.170.180 [85.184.170.180]) by mx.zoho.eu
        with SMTPS id 1633517883638242.40005363509636; Wed, 6 Oct 2021 12:58:03 +0200 (CEST)
Subject: Re: [PATCH] mdadm: split off shared library
To:     Hannes Reinecke <hare@suse.de>, Xiao Ni <xni@redhat.com>
Cc:     Coly Li <colyli@suse.de>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <7461b27b-2a4b-fbbb-5cfd-8fab416cbc9f@suse.de>
 <CALTww29nZV4A1BM_ShrmL1ud4YZC2YTG8q4LvW8pfhZwb=MhVQ@mail.gmail.com>
 <75fdd0fe-154b-f8eb-9ac3-bb948b432e39@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <c79d649d-a237-8d24-f05f-aa843831c9b7@trained-monkey.org>
Date:   Wed, 6 Oct 2021 06:58:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <75fdd0fe-154b-f8eb-9ac3-bb948b432e39@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/14/21 3:26 AM, Hannes Reinecke wrote:
> On 9/14/21 9:08 AM, Xiao Ni wrote:
>> Hi Hannes
>>
>> Thanks for these patches. It's a good idea to make codes more clearly
>> that which codes belong to which file.
>> There are many efforts that move codes from mdadm.c and mdadm.h to
>> specific files. Is it better to put these
>> patches together? For example, the patches(6, 11, 12, 16, 19, 20, 27,
>> 28) try to clean mdadm.c. Could you put
>> similar patches together? And there are some rename patches too, they
>> are sporadic.
>>
> Sure. Wasn't sure how you'd like to handle it; some prefer smaller
> patches, some prefer less patches overall ...

Sorry I missed this mainly because it had PATCH in the title and I
didn't feel the shared library subject was an urgent issue. I am not
opposed to splitting things into a shared library, in fact I believe I
suggested this to Neil many years ago. I don't remember why it didn't
happen at the time.

That said, I don't think it's something that is appropriate for 4.2, but
rather something to target for 5.0.

For something like this I would prefer smaller patches so it's possible
to bisect our way back if something broke in the process. Jumbo patches
are always wrong.

Cheers,
Jes
