Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9285DC43334
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 18:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiGSSov (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiGSSou (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 14:44:50 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2CB5D0DA;
        Tue, 19 Jul 2022 11:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=g4n3pn/BdiidAVlG8n7vW9SOKjeAQObM3+2LI6wCqWc=; b=LlysqE2TdB89G+TLfwT00mqfzD
        2OpHtnNOFfryQhYFboKAvRYOx1TpReXdtvA6ultRLboH1tneT+1kKgyOWhbBihF1qQzi7XUt1rK+f
        5MoojWrZSO4ZwBD7ia0UTjdMIVc34JDmRtXcPCJ2njWOd8boC9/Bwds2IKZupCipCVRjSYKYfqMen
        Iyqu5MBY7H6pzY9vEO+UsK13679ENFBi5UlPci5j4DSFXRltBOxZoCsjXKWExuEVthFotA1OiJNEZ
        3U+kdUhhHhMkhXLKQzSQM4mzhQ0URr2FavNwTIbr8FzaQj2WBv5CWkSQ2gLU779hMc1YlvwerdpUW
        zO/E5r7g==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDsD7-001XEL-RH; Tue, 19 Jul 2022 12:44:46 -0600
Message-ID: <f601eb55-54cf-ff0f-8ec0-586ca4dbe38a@deltatee.com>
Date:   Tue, 19 Jul 2022 12:44:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
References: <20220719091824.1064989-1-hch@lst.de>
 <CAPhsuW7hYzg-o6a7rdLs4==fv+0hqFtEyUVS0XtPjOqLHYg3eg@mail.gmail.com>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CAPhsuW7hYzg-o6a7rdLs4==fv+0hqFtEyUVS0XtPjOqLHYg3eg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: song@kernel.org, hch@lst.de, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: fix md disk_name lifetime problems v4
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-19 12:42, Song Liu wrote:
> On Tue, Jul 19, 2022 at 2:18 AM Christoph Hellwig <hch@lst.de> wrote:
>>
>> Hi all,
>>
>> this series tries to fix a problem repored by Logan where we see
>> duplicate sysfs file name in md.  It is due to the fact that the
>> md driver only checks for duplicates on currently live mddevs,
>> while the sysfs name can live on longer.  It is an old problem,
>> but the race window got longer due to waiting for the device freeze
>> earlier in del_gendisk.
>>
>> Changes since v3:
>>  - remove a now superflous mddev->gendisk NULL check
>>  - use a bit in mddev->flags instead of a new field
>>
>> Changes since v2:
>>  - delay mddev->kobj initialization
>>
>> Changes since v1:
>>  - rebased to the md-next branch
>>  - fixed error handling in md_alloc for real
>>  - add a little cleanup patch
> 
> Applied to md-next. Thanks!

I've only just finished my testing on this and it all looks good to me.

I've also reviewed the last 2 patches, for what it's worth.

Logan

