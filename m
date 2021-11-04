Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C684C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 12:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62A90611C3
	for <linux-raid@archiver.kernel.org>; Thu,  4 Nov 2021 12:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhKDM4Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 4 Nov 2021 08:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbhKDM4P (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 4 Nov 2021 08:56:15 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92CEC061203
        for <linux-raid@vger.kernel.org>; Thu,  4 Nov 2021 05:53:37 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id r3so5267585iod.6
        for <linux-raid@vger.kernel.org>; Thu, 04 Nov 2021 05:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6w8o3WS6DFFpTMjQXm5psT4Qx5D68tU62B92Jeja+Zo=;
        b=ldR/C8KEc7oOIEzM0/TFcM+FBsb189UFzrCibuqX+cslz918BHC2riRxUFvjgu3Op3
         ikmUUyMutn1eSuL9G5N2lLZxG8k2vK5myYOonRec81EiqQbvekpeNsBa00jPZgMx4WiX
         3IBl0MQku2Y2p144oqcG64Z2mnfjktMCkwmWF9dAIhQ4W2IBbUCW+4YHb9o/2Jmv/9Tw
         hGpikCSQpN9z6DeavUQECTDqikd99/o3mkqfEVu6mqpz9Gx9jkEiZpwANAqmZkd85B0/
         m/Ianql51H9Jy/J/1kxUhwHF1US2q9kDGNvXpdnMpDKlINUqn69dt106HpLPNNOU8ar4
         D8sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6w8o3WS6DFFpTMjQXm5psT4Qx5D68tU62B92Jeja+Zo=;
        b=OL4g+I8YwGIORESl9WtB2fT/1PMD7dxx6dLKi8YG+thHEPVyzpoIgnpVm7+66c1+Yu
         D5gX+eJgSWTEEfukpOq2uinoGNqYd9MRRTrzay00odEksbgUOCmf4Brr+vpNfQeG2L6M
         ms9rNq6puoNgBoAfjLSQCQsmu2k8AWK1ml20fGKpeukXfpSAnTpid1Xefp1fgQnEogN0
         lvd7RatrUS1l1tTAFXgGw9RCH3PGgowzOFYhiqq6mlXIgoItqgU6Tq52Gh/fqyEB6AC1
         7KVao3JdaiPiFjaxOBxTnCFC3JVn74qrIT/NeWV9YxRH+W6VtWF/lI8H8q3K3TVsjt4C
         gZ1g==
X-Gm-Message-State: AOAM533kPdM6sc+I7qaUqj35t28BR4Jm1gtjYsGt2r1ifEMsTLVYxNRW
        CTqDt5KD6XjJszswhPMSQ0YYIA==
X-Google-Smtp-Source: ABdhPJwH6c+P5mnSghF2qajSekhAmW/D+2dMZvQnCwkU8gTuNOoExbbBh3PXxAXNBqTnJ4DFVPx/Yw==
X-Received: by 2002:a05:6602:2c07:: with SMTP id w7mr36082747iov.122.1636030416900;
        Thu, 04 Nov 2021 05:53:36 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id d14sm2967722ilv.2.2021.11.04.05.53.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Nov 2021 05:53:36 -0700 (PDT)
Subject: Re: [PATCH v5 00/14] last set for add_disk() error handling
From:   Jens Axboe <axboe@kernel.dk>
To:     miquel.raynal@bootlin.com, martin.petersen@oracle.com,
        hare@suse.de, Luis Chamberlain <mcgrof@kernel.org>, jack@suse.cz,
        hch@lst.de, song@kernel.org, dave.jiang@intel.com, richard@nod.at,
        vishal.l.verma@intel.com, penguin-kernel@i-love.sakura.ne.jp,
        tj@kernel.org, ira.weiny@intel.com, vigneshr@ti.com,
        dan.j.williams@intel.com, ming.lei@redhat.com, efremov@linux.com
Cc:     linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20211103230437.1639990-1-mcgrof@kernel.org>
 <163602655191.22491.10844091970007142957.b4-ty@kernel.dk>
Message-ID: <4764286a-99b4-39f7-ce5c-9e88cee1a538@kernel.dk>
Date:   Thu, 4 Nov 2021 06:53:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <163602655191.22491.10844091970007142957.b4-ty@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/4/21 5:49 AM, Jens Axboe wrote:
> On Wed, 3 Nov 2021 16:04:23 -0700, Luis Chamberlain wrote:
>> Jens,
>>
>> as requested, I've folded all pending changes into this series. This
>> v5 pegs on Christoph's reviewed-by tags and since I was respinning I
>> modified the ataprobe and floppy driver changes as he suggested.
>>
>> I think this is it. The world of floppy has been exciting for v5.16.
>>
>> [...]
> 
> Applied, thanks!
> 
> [01/14] nvdimm/btt: use goto error labels on btt_blk_init()
>         commit: 2762ff06aa49e3a13fb4b779120f4f8c12c39fd1
> [02/14] nvdimm/btt: add error handling support for add_disk()
>         commit: 16be7974ff5d0a5cd9f345571c3eac1c3f6ba6de
> [03/14] nvdimm/blk: avoid calling del_gendisk() on early failures
>         commit: b7421afcec0c77ab58633587ddc29d53e6eb95af
> [04/14] nvdimm/blk: add error handling support for add_disk()
>         commit: dc104f4bb2d0a652dee010e47bc89c1ad2ab37c9
> [05/14] nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
>         commit: accf58afb689f81daadde24080ea1164ad2db75f
> [06/14] nvdimm/pmem: use add_disk() error handling
>         commit: 5a192ccc32e2981f721343c750b8cfb4c3f41007
> [07/14] z2ram: add error handling support for add_disk()
>         commit: 15733754ccf35c49d2f36a7ac51adc8b975c1c78
> [08/14] block/sunvdc: add error handling support for add_disk()
>         commit: f583eaef0af39b792d74e39721b5ba4b6948a270
> [09/14] mtd/ubi/block: add error handling support for add_disk()
>         commit: ed73919124b2e48490adbbe48ffe885a2a4c6fee
> [10/14] ataflop: remove ataflop_probe_lock mutex
>         commit: 4ddb85d36613c45bde00d368bf9f357bd0708a0c
> [11/14] block: update __register_blkdev() probe documentation
>         commit: 26e06f5b13671d194d67ae8e2b66f524ab174153
> [12/14] ataflop: address add_disk() error handling on probe
>         commit: 46a7db492e7a27408bc164cbe6424683e79529b0
> [13/14] floppy: address add_disk() error handling on probe
>         commit: ec28fcc6cfcd418d20038ad2c492e87bf3a9f026
> [14/14] block: add __must_check for *add_disk*() callers
>         commit: 1698712d85ec2f128fc7e7c5dc2018b5ed2b7cf6

rivers/scsi/sd.c: In function ‘sd_probe’:
drivers/scsi/sd.c:3573:9: warning: ignoring return value of ‘device_add_disk’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
 3573 |         device_add_disk(dev, gd, NULL);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/scsi/sr.c: In function ‘sr_probe’:
drivers/scsi/sr.c:731:9: warning: ignoring return value of ‘device_add_disk’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
  731 |         device_add_disk(&sdev->sdev_gendev, disk, NULL);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


Dropping the last two patches...

-- 
Jens Axboe

