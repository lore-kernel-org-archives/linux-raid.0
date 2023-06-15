Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE133EB64D9
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 09:17:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbjFOJR5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 05:17:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjFOJRz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 05:17:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B5B01FF9
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 02:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686820628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5wdwaTIznppKhB6NUCbmVYuIfYVMoIycI5vIaDr3hDo=;
        b=Zhv/YLCuohVOgf1TIgDXKumv06tkDy5IJ6zf5i8f5P6ymlv55NFgkhk+kcicrgZhdSbIqF
        olA5Sq1NCOcTFxlJ3ZEnFnw7X2ytf6/G/69RHN1PUpZmS6pV0DeUlVo+Vprur7YOHc5d7V
        OkXlC9VXV7fkZZXVKsf9Snj3JBQrVKY=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-SDdDS6ImMFOBkjnyN_7ckg-1; Thu, 15 Jun 2023 05:17:06 -0400
X-MC-Unique: SDdDS6ImMFOBkjnyN_7ckg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-25e88203a08so577274a91.0
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 02:17:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686820625; x=1689412625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5wdwaTIznppKhB6NUCbmVYuIfYVMoIycI5vIaDr3hDo=;
        b=FXrf5y8WwKU3rgpdrh0p+dLQfkLhMWV23b/BP2vsVtmZnpXBUUiLZ0vlrnmY8sQtzM
         1gErmsEy5vu98He7V4jTqdl8MMqHahPNs2ykKGCUcd5Ps5NxawENHK67ZEH6pYLGpZHc
         1BYIc6w1XJICuEK1hs+toaGY4Q4XPseNLGsrkvsShzjajX84lVmizbxCFRwrpSiUXYf7
         x3Z0lpMOHow90JhdjSVet5z8llkWbKeLvbfN5EdLPP7gXTBg3FFwmhUyuD4uZ9Uom9sC
         PvaElPU91vg5vM/7DI5AiRelcVyg0RN2ZIo2hfuryIFF+kyxa5VrGtoXFxm5j7QNlG1H
         vlbA==
X-Gm-Message-State: AC+VfDwKEAF3L/l0PaGCb9ebRFEALs2Ob/Wf6Fuj1bTYXyGfTErUs33h
        h6DjtdE6L/ZUxvCGpa+DzWmS3rRdfh89Hf4winNIcpYCrY/Y2/cLrCiX3XFvO8u/OELLeOwesQC
        a2p+bGqX40JCRWNKtOPbrIo73o1afTk3E2AFAtg==
X-Received: by 2002:a17:90a:1917:b0:25c:1906:c1e0 with SMTP id 23-20020a17090a191700b0025c1906c1e0mr3423498pjg.15.1686820625584;
        Thu, 15 Jun 2023 02:17:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6T9fG536avHPjJmtx006/d3Zcut7DwUOZG0SOhhNR7ncmXXv8PNDcroav7GWhPoK7kq5jlnINBDXcKgyVVAsA=
X-Received: by 2002:a17:90a:1917:b0:25c:1906:c1e0 with SMTP id
 23-20020a17090a191700b0025c1906c1e0mr3423487pjg.15.1686820625234; Thu, 15 Jun
 2023 02:17:05 -0700 (PDT)
MIME-Version: 1.0
References: <20231506112411@laper.mirepesht>
In-Reply-To: <20231506112411@laper.mirepesht>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 15 Jun 2023 17:16:54 +0800
Message-ID: <CALTww29UZ+WewVrvFDSpONqTHY=TR-Q7tobdRrhsTtXKtXvOBg@mail.gmail.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Ali Gholami Rudi <aligrudi@gmail.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 15, 2023 at 4:04=E2=80=AFPM Ali Gholami Rudi <aligrudi@gmail.co=
m> wrote:
>
> Hi,
>
> This simple experiment reproduces the problem.
>
> Create a RAID1 array using two ramdisks of size 1G:
>
>   mdadm --create /dev/md/test --level=3D1 --raid-devices=3D2 /dev/ram0 /d=
ev/ram1
>
> Then use fio to test disk performance (iodepth=3D64 and numjobs=3D40;
> details at the end of this email).  This is what we get in our machine
> (two AMD EPYC 7002 CPUs each with 64 cores and 2TB of RAM; Linux v5.10.0)=
:
>
> Without RAID (writing to /dev/ram0)
> READ:  IOPS=3D14391K BW=3D56218MiB/s
> WRITE: IOPS=3D 6167K BW=3D24092MiB/s
>
> RAID1 (writing to /dev/md/test)
> READ:  IOPS=3D  542K BW=3D 2120MiB/s
> WRITE: IOPS=3D  232K BW=3D  935MiB/s
>
> The difference, even for reading is huge.
>
> I tried perf to see what is the problem; results are included at the
> end of this email.
>
> Any ideas?

Hello Ali

Because it can be reproduced easily in your environment. Can you try
with the latest upstream kernel? If the problem doesn't exist with
latest upstream kernel. You can use git bisect to find which patch can
fix this problem.

>
> We are actually executing hundreds of VMs on our hosts.  The problem
> is that when we use RAID1 for our enterprise NVMe disks, the
> performance degrades very much compared to using them directly; it
> seems we have the same bottleneck as the test described above.

So those hundreds VMs run on the raid1, and the raid1 is created with
nvme disks. What's /proc/mdstat?

Regards
Xiao
>
> Thanks,
> Ali
>
> Perf output:
>
> Samples: 1M of event 'cycles', Event count (approx.): 1158425235997
>   Children      Self  Command  Shared Object           Symbol
> +   97.98%     0.01%  fio      fio                     [.] fio_libaio_com=
mit
> +   97.95%     0.01%  fio      libaio.so.1.0.1         [.] io_submit
> +   97.85%     0.01%  fio      [kernel.kallsyms]       [k] __x64_sys_io_s=
ubmit
> -   97.82%     0.01%  fio      [kernel.kallsyms]       [k] io_submit_one
>    - 97.81% io_submit_one
>       - 54.62% aio_write
>          - 54.60% blkdev_write_iter
>             - 36.30% blk_finish_plug
>                - flush_plug_callbacks
>                   - 36.29% raid1_unplug
>                      - flush_bio_list
>                         - 18.44% submit_bio_noacct
>                            - 18.40% brd_submit_bio
>                               - 18.13% raid1_end_write_request
>                                  - 17.94% raid_end_bio_io
>                                     - 17.82% __wake_up_common_lock
>                                        + 17.79% _raw_spin_lock_irqsave
>                         - 17.79% __wake_up_common_lock
>                            + 17.76% _raw_spin_lock_irqsave
>             + 18.29% __generic_file_write_iter
>       - 43.12% aio_read
>          - 43.07% blkdev_read_iter
>             - generic_file_read_iter
>                - 43.04% blkdev_direct_IO
>                   - 42.95% submit_bio_noacct
>                      - 42.23% brd_submit_bio
>                         - 41.91% raid1_end_read_request
>                            - 41.70% raid_end_bio_io
>                               - 41.43% __wake_up_common_lock
>                                  + 41.36% _raw_spin_lock_irqsave
>                      - 0.68% md_submit_bio
>                           0.61% md_handle_request
> +   94.90%     0.00%  fio      [kernel.kallsyms]       [k] __wake_up_comm=
on_lock
> +   94.86%     0.22%  fio      [kernel.kallsyms]       [k] _raw_spin_lock=
_irqsave
> +   94.64%    94.64%  fio      [kernel.kallsyms]       [k] native_queued_=
spin_lock_slowpath
> +   79.63%     0.02%  fio      [kernel.kallsyms]       [k] submit_bio_noa=
cct
>
>
> FIO configuration file:
>
> [global]
> name=3Drandom reads and writes
> ioengine=3Dlibaio
> direct=3D1
> readwrite=3Drandrw
> rwmixread=3D70
> iodepth=3D64
> buffered=3D0
> #filename=3D/dev/ram0
> filename=3D/dev/dm/test
> size=3D1G
> runtime=3D30
> time_based
> randrepeat=3D0
> norandommap
> refill_buffers
> ramp_time=3D10
> bs=3D4k
> numjobs=3D400
> group_reporting=3D1
> [job1]
>

