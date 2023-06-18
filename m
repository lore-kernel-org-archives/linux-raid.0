Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142AEEB64DA
	for <linux-raid@archiver.kernel.org>; Sun, 18 Jun 2023 20:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjFRUxz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 18 Jun 2023 16:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjFRUxx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 18 Jun 2023 16:53:53 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3018C9B
        for <linux-raid@vger.kernel.org>; Sun, 18 Jun 2023 13:53:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-988883b0d8fso119616766b.1
        for <linux-raid@vger.kernel.org>; Sun, 18 Jun 2023 13:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687121567; x=1689713567;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=95UbieQ2cksw9CYBFwVRlfmpwK9KXTpHKCxn8Yv20gc=;
        b=i5VDQI4nmiZy0YEADmcqlH2ge0nfM7SmPrV0LXyG4JjOeOtOfHGbyI1MhBdhOjt9FJ
         3xh+moM/IRvdVc6R2NKk42kotM6OEUnxVxJzow7wjSz6yaE5k5kW9xhDgbMPwgE0qYHG
         evZVcwDUU+pS1zPOv0CBCZ6cCvwUsk9staneyCo7d4AtvphWRhhSuj7bHS0axYnlGTj8
         psVTHH3PcsD3IGcyVn5yXFzzuQCWFhiOn7zO0HytjdfBRcdCAXFUcLw/X5JMI/kMCKcW
         pd+G940Zaori4EbdLaX2as5pSGBa5aZ5St5pGAe/BH4vQmisa13GdbF73U6VlnwfnS6i
         MwLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687121567; x=1689713567;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=95UbieQ2cksw9CYBFwVRlfmpwK9KXTpHKCxn8Yv20gc=;
        b=XqXf+XXhoihbHEggWnDT9hCeXNtTk0WfL8VpSJXrgRzcTXncBayb5ZL4aMUGktEMr3
         f2MqBj2e4e7KkgEqllY9581agq7z+1MbluocBdlU/tPk5ry45dcMz5Fg1hLbTy4Rg55b
         hyO/gUpyNF1X3ErKFpFmhPgvoTR7uy1qaLgSU24d2Xy1OwsiTv2R0s8TqEP5rb8VmxWT
         vL4R1EDL9YUzdnw4AuZ/r/PJjJpk9vVJIOQjy1W+XD4HNWLiHFrI9QJ3ugcwpgdTHc07
         HQ0+Br85adwLgdILq7seyA9jlg7T/K3/V/h4nR3xNcotv6rqRD9d3peygnzmEoeJEZ8u
         6Bhg==
X-Gm-Message-State: AC+VfDwQlE3eLCdA4vE8JuviCtU155LWWehTXc6nUq8atKJci0O+tbyD
        vmW9j2T+x6gdjyhgkQmcV9A=
X-Google-Smtp-Source: ACHHUZ7reurJEn9455n0Vpb4yiAD7u5x5I7MHrNZotnKQqV3qvcRbUjXHXLLws95CoiWbESDGF/5SQ==
X-Received: by 2002:a17:906:dacb:b0:94e:e6b9:fef2 with SMTP id xi11-20020a170906dacb00b0094ee6b9fef2mr7059242ejb.67.1687121566823;
        Sun, 18 Jun 2023 13:52:46 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id k10-20020a17090646ca00b009827b97c89csm6202806ejs.102.2023.06.18.13.52.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 18 Jun 2023 13:52:45 -0700 (PDT)
Date:   Mon, 19 Jun 2023 00:00:51 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231906000051@laper.mirepesht>
In-Reply-To: <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
 <20231606115113@laper.mirepesht>
 <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
 <20231606122233@laper.mirepesht> <20231606152106@laper.mirepesht>
        <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

I tested raid10 with NVMe disks on Debian 12 (Linux 6.1.0), which
includes your first patch only.

The speed was very bad:

READ:  IOPS=360K BW=1412MiB/s
WRITE: IOPS=154K BW= 606MiB/s

Perf's output:

+   98.90%     0.00%  fio      [unknown]               [.] 0xffffffffffffffff
+   98.71%     0.00%  fio      fio                     [.] 0x0000563ae0f62117
+   97.69%     0.02%  fio      [kernel.kallsyms]       [k] entry_SYSCALL_64_after_hwframe
+   97.66%     0.02%  fio      [kernel.kallsyms]       [k] do_syscall_64
+   97.29%     0.00%  fio      fio                     [.] 0x0000563ae0f5fceb
+   97.29%     0.05%  fio      fio                     [.] td_io_queue
+   97.20%     0.01%  fio      fio                     [.] td_io_commit
+   97.20%     0.02%  fio      libc.so.6               [.] syscall
+   96.94%     0.05%  fio      libaio.so.1.0.2         [.] io_submit
+   96.94%     0.00%  fio      fio                     [.] 0x0000563ae0f84e5e
+   96.50%     0.02%  fio      [kernel.kallsyms]       [k] __x64_sys_io_submit
-   96.44%     0.03%  fio      [kernel.kallsyms]       [k] io_submit_one
   - 96.41% io_submit_one
      - 65.16% aio_read
         - 65.07% xfs_file_read_iter
            - 65.06% xfs_file_dio_read
               - 60.21% iomap_dio_rw
                  - 60.21% __iomap_dio_rw
                     - 49.84% iomap_dio_bio_iter
                        - 49.39% submit_bio_noacct_nocheck
                           - 49.08% __submit_bio
                              - 48.80% md_handle_request
                                 - 48.40% raid10_make_request
                                    - 48.14% raid10_read_request
                                       - 47.63% regular_request_wait
                                          - 47.62% wait_barrier
                                             - 44.17% _raw_spin_lock_irq
                                                  44.14% native_queued_spin_lock_slowpath
                                             - 2.39% schedule
                                                - 2.38% __schedule
                                                   + 1.99% pick_next_task_fair
                     - 9.78% iomap_iter
                        - 9.77% xfs_read_iomap_begin
                           - 9.30% xfs_ilock_for_iomap
                              - 9.29% down_read
                                 - 9.18% rwsem_down_read_slowpath
                                    - 4.67% schedule_preempt_disabled
                                       - 4.67% schedule
                                          - 4.67% __schedule
                                             - 4.08% pick_next_task_fair
                                                - 4.08% newidle_balance
                                                   - 3.94% load_balance
                                                      - 3.60% find_busiest_group
                                                           3.59% update_sd_lb_stats.constprop.0
                                    - 4.12% _raw_spin_lock_irq
                                         4.11% native_queued_spin_lock_slowpath
               + 4.56% touch_atime
      - 31.12% aio_write
         - 31.06% xfs_file_write_iter
            - 31.00% xfs_file_dio_write_aligned
               - 27.41% iomap_dio_rw
                  - 27.40% __iomap_dio_rw
                     - 23.29% iomap_dio_bio_iter
                        - 23.14% submit_bio_noacct_nocheck
                           - 23.11% __submit_bio
                              - 23.02% md_handle_request
                                 - 22.85% raid10_make_request
                                    - 20.45% regular_request_wait
                                       - 20.44% wait_barrier
                                          - 18.97% _raw_spin_lock_irq
                                               18.96% native_queued_spin_lock_slowpath
                                          - 1.02% schedule
                                             - 1.02% __schedule
                                                - 0.85% pick_next_task_fair
                                                   + 0.84% newidle_balance
                                    + 1.85% md_bitmap_startwrite
                     - 3.20% iomap_iter
                        - 3.19% xfs_direct_write_iomap_begin
                           - 3.00% xfs_ilock_for_iomap
                              - 2.99% down_read
                                 - 2.95% rwsem_down_read_slowpath
                                    + 1.70% schedule_preempt_disabled
                                    + 1.13% _raw_spin_lock_irq
                     + 0.81% blk_finish_plug
               + 3.47% xfs_file_write_checks
+   87.62%     0.01%  fio      [kernel.kallsyms]       [k] iomap_dio_rw
+   87.61%     0.14%  fio      [kernel.kallsyms]       [k] __iomap_dio_rw
+   74.85%    74.85%  fio      [kernel.kallsyms]       [k] native_queued_spin_lock_slowpath
+   73.13%     0.10%  fio      [kernel.kallsyms]       [k] iomap_dio_bio_iter
+   72.99%     0.11%  fio      [kernel.kallsyms]       [k] _raw_spin_lock_irq
+   72.76%     0.02%  fio      [kernel.kallsyms]       [k] submit_bio_noacct_nocheck
+   72.20%     0.01%  fio      [kernel.kallsyms]       [k] __submit_bio
+   71.82%     0.43%  fio      [kernel.kallsyms]       [k] md_handle_request
+   71.25%     0.15%  fio      [kernel.kallsyms]       [k] raid10_make_request
+   68.08%     0.02%  fio      [kernel.kallsyms]       [k] regular_request_wait
+   68.06%     0.57%  fio      [kernel.kallsyms]       [k] wait_barrier
+   65.16%     0.01%  fio      [kernel.kallsyms]       [k] aio_read
+   65.07%     0.01%  fio      [kernel.kallsyms]       [k] xfs_file_read_iter
+   65.06%     0.01%  fio      [kernel.kallsyms]       [k] xfs_file_dio_read
+   48.14%     0.12%  fio      [kernel.kallsyms]       [k] raid10_read_request

Note that in the ramdisk tests, I gate whole ramdisks or raid devices
to fio.  Here I used files on the filesystem.

Thanks,
Ali

# cat /proc/mdstat:
Personalities : [raid10] [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4]
md127 : active raid10 ram1[1] ram0[0]
      1046528 blocks super 1.2 2 near-copies [2/2] [UU]

md3 : active raid10 nvme0n1p5[0] nvme1n1p5[1] nvme3n1p5[3] nvme4n1p5[4] nvme6n1p5[6] nvme5n1p5[5] nvme7n1p5[7] nvme2n1p5[2]
      14887084032 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]
      [=======>.............]  resync = 37.2% (5549960960/14887084032) finish=754.4min speed=206272K/sec
      bitmap: 70/111 pages [280KB], 65536KB chunk

md1 : active raid10 nvme1n1p3[1] nvme3n1p3[3] nvme0n1p3[0] nvme4n1p3[4] nvme5n1p3[5] nvme6n1p3[6] nvme7n1p3[7] nvme2n1p3[2]
      41906176 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]

md0 : active raid10 nvme1n1p2[1] nvme3n1p2[3] nvme0n1p2[0] nvme6n1p2[6] nvme4n1p2[4] nvme5n1p2[5] nvme7n1p2[7] nvme2n1p2[2]
      2084864 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]

md2 : active (auto-read-only) raid10 nvme4n1p4[4] nvme1n1p4[1] nvme3n1p4[3] nvme0n1p4[0] nvme6n1p4[6] nvme7n1p4[7] nvme5n1p4[5] nvme2n1p4[2]
      67067904 blocks super 1.2 512K chunks 2 near-copies [8/8] [UUUUUUUU]
        resync=PENDING

unused devices: <none>

# lspci | grep NVM
01:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
02:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
03:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
04:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
61:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
62:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
83:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
84:00.0 Non-Volatile memory controller: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO
#

