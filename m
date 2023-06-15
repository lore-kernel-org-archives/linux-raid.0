Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6952EB64D9
	for <linux-raid@archiver.kernel.org>; Thu, 15 Jun 2023 08:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244005AbjFOIB6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 15 Jun 2023 04:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244450AbjFOIB3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 15 Jun 2023 04:01:29 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1345C135
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 01:01:25 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-51a200fc3eeso1055510a12.3
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 01:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686816083; x=1689408083;
        h=content-transfer-encoding:mime-version:user-agent:date:message-id
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t3MpeOygt9wJahF9Dwn0HN9Yl4sjw+3Ynv0jnzzsHGM=;
        b=J1QQBZranhjqbfUGmyDAzpuMVQ1wTRasH6C/45EK1bnKmQCdD1BpSBOIJfKumZgrd/
         nfbVU0FtQmFKUuYPGiXqZzD8a9PK9JmJcDh6Y2RfaCZQUGnAFohGl61FvV9J5REv27U2
         UtEI7sKtkX8rY/BLPbpGul9ZkezGEBHRgfntUAxdAlmHkFTEykUBcNCGWGNIozbdCaal
         WkQeJzfzXBMwgATUF17vsK9wqXm8xB859i8fUAh6Rt3tKkZ4LYLGj/OlY7JC9PhncgvL
         m/F1X0XFt5pMwdZVOto1EFNbSp6m00B5BDlEyb3wdOr2vz7w1898LrNdvSMjgg+zyU4W
         N50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686816083; x=1689408083;
        h=content-transfer-encoding:mime-version:user-agent:date:message-id
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3MpeOygt9wJahF9Dwn0HN9Yl4sjw+3Ynv0jnzzsHGM=;
        b=g0z4Od6BL2O9V+6+RoxggotRvrZMsezB+fhQP+OlkK39Aa3/TmKkJE9RoNQIZo6sxK
         OwZrzXckPN/eWj9k+RhVjDmZgkskH15CTINuw06MmEYAmpVUajqXDEwOaovUW7j3LB/y
         kFBWIIed2WPnZ6gD0w1MduPJBBUwOPOPVAT5792/EJCqkCW6S6QbBAdgft7xQwX1jwB4
         ReTi5y185RjZj+5HiAiyxB1G7QVDOuQJK/z9Ke9dClXvb0oBfpAoU+wc2uAW2Fv1uMfm
         cK3fEkYgKreAGOd7VrAhi6K30RKXK376Jt16IKS9wnx8jtGHxAIHSKKov8phWmqEZ71l
         0KsQ==
X-Gm-Message-State: AC+VfDyJPvjwwzEiSfltiuYWpHZSwhaGgBOVGL0LuD05bY6jd5bwxx5j
        qL1V6WcyYv+imQZL7vwIdqb33d9aQWc=
X-Google-Smtp-Source: ACHHUZ7ebRgXAEA/c8z7fGUHZTArAlzFwDnZ/dG7hsHM2TFTwG2Ukt6edzC8e3ab70qQEdkOmzoU+A==
X-Received: by 2002:aa7:d518:0:b0:515:4043:4771 with SMTP id y24-20020aa7d518000000b0051540434771mr9269748edq.42.1686816082932;
        Thu, 15 Jun 2023 01:01:22 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id b20-20020aa7d494000000b00514a3c04646sm8603967edr.73.2023.06.15.01.01.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Jun 2023 01:01:22 -0700 (PDT)
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org
Subject: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231506112411@laper.mirepesht>
Date:   Thu, 15 Jun 2023 11:24:11 +0330
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

This simple experiment reproduces the problem.

Create a RAID1 array using two ramdisks of size 1G:

  mdadm --create /dev/md/test --level=1 --raid-devices=2 /dev/ram0 /dev/ram1

Then use fio to test disk performance (iodepth=64 and numjobs=40;
details at the end of this email).  This is what we get in our machine
(two AMD EPYC 7002 CPUs each with 64 cores and 2TB of RAM; Linux v5.10.0):

Without RAID (writing to /dev/ram0)
READ:  IOPS=14391K BW=56218MiB/s
WRITE: IOPS= 6167K BW=24092MiB/s

RAID1 (writing to /dev/md/test)
READ:  IOPS=  542K BW= 2120MiB/s
WRITE: IOPS=  232K BW=  935MiB/s

The difference, even for reading is huge.

I tried perf to see what is the problem; results are included at the
end of this email.

Any ideas?

We are actually executing hundreds of VMs on our hosts.  The problem
is that when we use RAID1 for our enterprise NVMe disks, the
performance degrades very much compared to using them directly; it
seems we have the same bottleneck as the test described above.

Thanks,
Ali

Perf output:

Samples: 1M of event 'cycles', Event count (approx.): 1158425235997
  Children      Self  Command  Shared Object           Symbol
+   97.98%     0.01%  fio      fio                     [.] fio_libaio_commit
+   97.95%     0.01%  fio      libaio.so.1.0.1         [.] io_submit
+   97.85%     0.01%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
-   97.82%     0.01%  fio      [kernel.kallsyms]       [k] io_submit_one
   - 97.81% io_submit_one
      - 54.62% aio_write
         - 54.60% blkdev_write_iter
            - 36.30% blk_finish_plug
               - flush_plug_callbacks
                  - 36.29% raid1_unplug
                     - flush_bio_list
                        - 18.44% submit_bio_noacct
                           - 18.40% brd_submit_bio
                              - 18.13% raid1_end_write_request
                                 - 17.94% raid_end_bio_io
                                    - 17.82% __wake_up_common_lock
                                       + 17.79% _raw_spin_lock_irqsave
                        - 17.79% __wake_up_common_lock
                           + 17.76% _raw_spin_lock_irqsave
            + 18.29% __generic_file_write_iter
      - 43.12% aio_read
         - 43.07% blkdev_read_iter
            - generic_file_read_iter
               - 43.04% blkdev_direct_IO
                  - 42.95% submit_bio_noacct
                     - 42.23% brd_submit_bio
                        - 41.91% raid1_end_read_request
                           - 41.70% raid_end_bio_io
                              - 41.43% __wake_up_common_lock
                                 + 41.36% _raw_spin_lock_irqsave
                     - 0.68% md_submit_bio
                          0.61% md_handle_request
+   94.90%     0.00%  fio      [kernel.kallsyms]       [k] __wake_up_common_lock
+   94.86%     0.22%  fio      [kernel.kallsyms]       [k] _raw_spin_lock_irqsave
+   94.64%    94.64%  fio      [kernel.kallsyms]       [k] native_queued_spin_lock_slowpath
+   79.63%     0.02%  fio      [kernel.kallsyms]       [k] submit_bio_noacct


FIO configuration file:

[global] 
name=random reads and writes
ioengine=libaio 
direct=1
readwrite=randrw 
rwmixread=70 
iodepth=64 
buffered=0 
#filename=/dev/ram0
filename=/dev/dm/test
size=1G
runtime=30 
time_based 
randrepeat=0 
norandommap 
refill_buffers 
ramp_time=10
bs=4k
numjobs=400
group_reporting=1
[job1]

