Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B96AC433F5
	for <linux-raid@archiver.kernel.org>; Thu, 12 May 2022 08:01:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351298AbiELIBS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 May 2022 04:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351288AbiELIBR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 May 2022 04:01:17 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44A3156438;
        Thu, 12 May 2022 01:01:13 -0700 (PDT)
Received: from [192.168.0.2] (ip5f5aeace.dynamic.kabel-deutschland.de [95.90.234.206])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id C0E6561EA1923;
        Thu, 12 May 2022 10:01:11 +0200 (CEST)
Message-ID: <c38cf859-4462-629e-1bc5-f3e300a8764c@molgen.mpg.de>
Date:   Thu, 12 May 2022 10:01:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] md: remove most calls to bdevname
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20220512061913.1826735-1-hch@lst.de>
 <290eada6-226a-6570-1860-c4ca1d680993@molgen.mpg.de>
 <20220512062727.GA20557@lst.de>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220512062727.GA20557@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Christoph,


Am 12.05.22 um 08:27 schrieb Christoph Hellwig:
> On Thu, May 12, 2022 at 08:25:28AM +0200, Paul Menzel wrote:

>> Am 12.05.22 um 08:19 schrieb Christoph Hellwig:
>>> Use the %pg format specifier to save on stack consuption and code size.
>>
>> consu*m*ption
>>
>> Did you do any measurements?
> 
> Each BDEVNAME_SIZE array consumes 32 bytes on the stack, and they are
> gone now without any additional stack usage elsewhere.

Understood.

For comparing the code size, out of curiosity, I built `drivers/md` from 
md-next, commit 74fe94569da7 (md: protect md_unregister_thread from 
reentrancy), without and with your patch with gcc 11.1.0, and got:

```
$ diff -u <(cd drivers/md-before/ && du -a | sort -k2) <(cd drivers/md/ 
&& du -a | sort -k2)
--- /dev/fd/63  2022-05-12 09:51:23.354107016 +0200
+++ /dev/fd/62  2022-05-12 09:51:23.355107064 +0200
@@ -1,4 +1,4 @@
-11064  .
+11052  .
  4      ./.built-in.a.cmd
  48     ./.dm-bio-prison-v1.o.cmd
  20     ./.dm-bio-prison-v1.o.d
@@ -287,7 +287,7 @@
  24     ./md-multipath.o
  260    ./md.c
  28     ./md.h
-308    ./md.o
+304    ./md.o
  4      ./modules.order
  1380   ./persistent-data
  48     ./persistent-data/.dm-array.o.cmd
@@ -356,7 +356,7 @@
  148    ./raid10.c
  8      ./raid10.h
  4      ./raid10.mod
-108    ./raid10.o
+104    ./raid10.o
  88     ./raid5-cache.c
  76     ./raid5-cache.o
  8      ./raid5-log.h
@@ -364,4 +364,4 @@
  48     ./raid5-ppl.o
  252    ./raid5.c
  32     ./raid5.h
-212    ./raid5.o
+208    ./raid5.o
```


Kind regards,

Paul
