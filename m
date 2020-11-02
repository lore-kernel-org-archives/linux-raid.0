Return-Path: <SRS0=c9Ba=EI=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E11DC388F2
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 07:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E52221FF
	for <linux-raid@archiver.kernel.org>; Mon,  2 Nov 2020 07:04:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vd7pj725"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgKBHEv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Nov 2020 02:04:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727743AbgKBHEv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 Nov 2020 02:04:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604300689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BhzMP52bVypIwFDjmwBPMHYXAhlB8gsyXxMfVoaGxIA=;
        b=Vd7pj725Vk6kAptFf2JXKH6FTjVFqqlulaN/mW2LcHjM4Eqor2ImsmuNqVbpRjSc6x4pNH
        6LlOmeebPKRSFN1cygFfKcFuXV0s7iAHHPFQWT2gr0MoLW9PRFqfX7MABas4pfcZ12bHf5
        kh1RqmJpFfQjPenlrimMwLazC1JfjIU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-y1M2nnBdMxeca6uFDOmWZQ-1; Mon, 02 Nov 2020 02:04:45 -0500
X-MC-Unique: y1M2nnBdMxeca6uFDOmWZQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B2F41882FA5;
        Mon,  2 Nov 2020 07:04:44 +0000 (UTC)
Received: from localhost.localdomain (ovpn-8-24.pek2.redhat.com [10.72.8.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E691E6EF6F;
        Mon,  2 Nov 2020 07:04:41 +0000 (UTC)
Subject: Re: [PATCH 0/3] mdraid sb and bitmap write alignment on 512e drives
To:     Christopher Unkel <cunkel@drivescale.com>,
        linux-raid@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>
References: <20201023033130.11354-1-cunkel@drivescale.com>
From:   Xiao Ni <xni@redhat.com>
Message-ID: <f5ba4699-5620-d30d-2b0b-51b39b46b589@redhat.com>
Date:   Mon, 2 Nov 2020 15:04:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20201023033130.11354-1-cunkel@drivescale.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 10/23/2020 11:31 AM, Christopher Unkel wrote:
> Hello all,
>
> While investigating some performance issues on mdraid 10 volumes
> formed with "512e" disks (4k native/physical sector size but with 512
> byte sector emulation), I've found two cases where mdraid will
> needlessly issue writes that start on 4k byte boundary, but are are
> shorter than 4k:
>
> 1. writes of the raid superblock; and
> 2. writes of the last page of the write-intent bitmap.
>
> The following is an excerpt of a blocktrace of one of the component
> members of a mdraid 10 volume during a 4k write near the end of the
> array:
>
>    8,32  11        2     0.000001687   711  D  WS 2064 + 8 [kworker/11:1H]
> * 8,32  11        5     0.001454119   711  D  WS 2056 + 1 [kworker/11:1H]
> * 8,32  11        8     0.002847204   711  D  WS 2080 + 7 [kworker/11:1H]
>    8,32  11       11     0.003700545  3094  D  WS 11721043920 + 8 [md127_raid1]
>    8,32  11       14     0.308785692   711  D  WS 2064 + 8 [kworker/11:1H]
> * 8,32  11       17     0.310201697   711  D  WS 2056 + 1 [kworker/11:1H]
>    8,32  11       20     5.500799245   711  D  WS 2064 + 8 [kworker/11:1H]
> * 8,32  11       23    15.740923558   711  D  WS 2080 + 7 [kworker/11:1H]
>
> Note the starred transactions, which each start on a 4k boundary, but
> are less than 4k in length, and so will use the 512-byte emulation.
> Sector 2056 holds the superblock, and is written as a single 512-byte
> write.  Sector 2086 holds the bitmap bit relevant to the written
> sector.  When it is written the active bits of the last page of the
> bitmap are written, starting at sector 2080, padded out to the end of
> the 512-byte logical sector as required.  This results in a 3.5kb
> write, again using the 512-byte emulation.

Hi Christopher

Which superblock version do you use? If it's super1.1, superblock starts 
at 0 sector.
If it's super1.2, superblock starts at 8 sector. If it's super1.0, 
superblock starts at the
end of device and bitmap is before superblock. As mentioned above, 
bitmap is behind
the superblock, so it should not be super1.0. So I have a question why 
does 2056 hold
the superblock?

Regards
Xiao

>
> Note that in some arrays the last page of the bitmap may be
> sufficiently full that they are not affected by the issue with the
> bitmap write.
>
> As there can be a substantial penalty to using the 512-byte sector
> emulation (turning writes into read-modify writes if the relevant
> sector is not in the drive's cache) I believe it makes sense to pad
> these writes out to a 4k boundary.  The writes are already padded out
> for "4k native" drives, where the short access is illegal.
>
> The following patch set changes the superblock and bitmap writes to
> respect the physical block size (e.g. 4k for today's 512e drives) when
> possible.  In each case there is already logic for padding out to the
> underlying logical sector size.  I reuse or repeat the logic for
> padding out to the physical sector size, but treat the padding out as
> optional rather than mandatory.
>
> The corresponding block trace with these patches is:
>
>     8,32   1        2     0.000003410   694  D  WS 2064 + 8 [kworker/1:1H]
>     8,32   1        5     0.001368788   694  D  WS 2056 + 8 [kworker/1:1H]
>     8,32   1        8     0.002727981   694  D  WS 2080 + 8 [kworker/1:1H]
>     8,32   1       11     0.003533831  3063  D  WS 11721043920 + 8 [md127_raid1]
>     8,32   1       14     0.253952321   694  D  WS 2064 + 8 [kworker/1:1H]
>     8,32   1       17     0.255354215   694  D  WS 2056 + 8 [kworker/1:1H]
>     8,32   1       20     5.337938486   694  D  WS 2064 + 8 [kworker/1:1H]
>     8,32   1       23    15.577963062   694  D  WS 2080 + 8 [kworker/1:1H]
>
> I do notice that the code for bitmap writes has a more sophisticated
> and thorough check for overlap than the code for superblock writes.
> (Compare write_sb_page in md-bitmap.c vs. super_1_load in md.c.) From
> what I know since the various structures starts have always been 4k
> aligned anyway, it is always safe to pad the superblock write out to
> 4k (as occurs on 4k native drives) but not necessarily futher.
>
> Feedback appreciated.
>
>    --Chris
>
>
> Christopher Unkel (3):
>    md: align superblock writes to physical blocks
>    md: factor sb write alignment check into function
>    md: pad writes to end of bitmap to physical blocks
>
>   drivers/md/md-bitmap.c | 80 +++++++++++++++++++++++++-----------------
>   drivers/md/md.c        | 15 ++++++++
>   2 files changed, 63 insertions(+), 32 deletions(-)
>

