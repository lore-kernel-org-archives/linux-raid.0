Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54462C6FA82
	for <linux-raid@archiver.kernel.org>; Sat, 10 Sep 2022 20:16:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIJUP7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 10 Sep 2022 16:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiIJUP5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 10 Sep 2022 16:15:57 -0400
Received: from hermes.turmel.org (hermes.turmel.org [IPv6:2604:180:f1::1e9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B969839B9C
        for <linux-raid@vger.kernel.org>; Sat, 10 Sep 2022 13:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=turmel.org;
         s=a; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:References:Cc
        :To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5r0dkTLn9TD2fKI7pxO42im+o33Eikrvc8L4OMQQKDA=; b=gE2/Y2ZePtCQ6+g5WXbe/ktvjs
        y6M/PaPk7pQyEdyzzrnDqbIYMNu9W3mj5C6QCvBrTZDpBavmZ1Y9cKJXOWic0zvCLhPMUgkBU7r5Q
        cc3y0etpkCkMr5UGPnaRYneFtstbbYs9vBvAH9ZKrQuYCPp2kRtLsuurP0jH9jHyMZjEKU3OaDdFP
        hL5QH2PK2ghwXtSLWsRHa2jzE9yooQtVaePjS9Upxf7p35aYWNj9nBonw6r7L4dJ2PxBGx6YT4Vbd
        PtLzLSaAEL6BusT7YbClPJgZKlIAWq1xc65CaPbNFiJnnbDZW+5Gficdru59HJHvfa7M87o3XrUB/
        CX87x20w==;
Received: from 108-70-166-50.lightspeed.tukrga.sbcglobal.net ([108.70.166.50] helo=[192.168.20.123])
        by hermes.turmel.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <philip@turmel.org>)
        id 1oX6tP-0004cp-RA; Sat, 10 Sep 2022 20:15:55 +0000
Message-ID: <4214394e-6f73-6ee9-08ce-2ba95b8e0713@turmel.org>
Date:   Sat, 10 Sep 2022 16:15:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: RAID5 failure and consequent ext4 problems
Content-Language: en-US
To:     Luigi Fabio <luigi.fabio@gmail.com>
Cc:     linux-raid@vger.kernel.org
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org>
 <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org>
 <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
 <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org>
 <CAJJqR23RE3Hfrm-bkiyMm3OjUTCFhXsRvBXr4H8563t1VyY=0g@mail.gmail.com>
 <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com>
 <CAJJqR20PcvMs5e3cKXf8DtLF_nVthii4rbkFLPYZ4QT7mpj0Kg@mail.gmail.com>
From:   Phil Turmel <philip@turmel.org>
In-Reply-To: <CAJJqR20PcvMs5e3cKXf8DtLF_nVthii4rbkFLPYZ4QT7mpj0Kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Do the fsck with an overlay in place.

I suspect the data in the inodes will provide corroboration for newer 
data in the various structures.  I think your odds are good, now.

On 9/10/22 16:12, Luigi Fabio wrote:
> Following up, I found:
> 
>>> The backup ext4 superblocks are never updated by the kernel, only after
>>> a successful e2fsck, tune2fs, resize2fs, or other userspace operation.
>>>
>>> This avoids clobbering the backups with bad data if the kernel has a bug
>>> or device error (e.g. bad cable, HBA, etc).
> So therefore, if we restore a backup superblock (and its attendant
> data) what happens to any FS structure that was written to *after*
> that time? That is to say, in this case, after Aug 18th?
> Is the system 'smart enough' to do something or will I have a big fat
> mess? I mean, reversion to 08/18 would be great, but I can't imagine
> that the FS can do that, it would have to have copies of every inode.
> 
> This does explain how I get so many errors when fsck grabs the backup
> superblock... the RAID part we solved just fine, it's the rest we have
> to deal with.
> 
> Ideas are welcome.
