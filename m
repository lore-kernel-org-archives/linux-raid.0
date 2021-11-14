Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E61E4C4332F
	for <linux-raid@archiver.kernel.org>; Sun, 14 Nov 2021 17:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C184161213
	for <linux-raid@archiver.kernel.org>; Sun, 14 Nov 2021 17:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhKNRNr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 Nov 2021 12:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236628AbhKNRLm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 14 Nov 2021 12:11:42 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEE7C079786
        for <linux-raid@vger.kernel.org>; Sun, 14 Nov 2021 09:07:46 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y12so4444937eda.12
        for <linux-raid@vger.kernel.org>; Sun, 14 Nov 2021 09:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:organization:content-transfer-encoding;
        bh=/DEnz5yaCpSMfDnRZMBEGZJoD5p4D1PtNdciI4GtM3Y=;
        b=GCLPuwnAj2qeDLuAvmA3DHUgnJ9jgqwPeeD3aOJa3P4USDSFu0TdLsy38Xj6Mhp9lM
         DPHLX7XVjpTWPeSHT2QZT/wUmty9fdyfwfaxe/HxUHJdsSDSyM6Hgv7e2s6dBGhdUpeM
         +5WZ/uvAKi5naBP0NjouCyovNh6+kGXQcfMFUqLu9UB6GqeNSq1Li6Iv5b+DOpPFqkzR
         opEL/O0T9j8anwVjiwMtjHsno/SEJQtzb8SLLb5BYfYnzYj4cniVz2YmDQEO1ftGd5Xl
         btDjFC6fcX2ADKdn5rUpHzXi8yJ872PQyGXJDSbF7yCluvCzDiH1WiYcGTRdUfCPIwGi
         KPVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:organization
         :content-transfer-encoding;
        bh=/DEnz5yaCpSMfDnRZMBEGZJoD5p4D1PtNdciI4GtM3Y=;
        b=AV4rSRLs8cuZM46tG+gpeZqOmwV1vIl9a3xmbNBJknr4UDO5HS/eUrWhV1SaZ+0rUv
         jOauqMFB6DXx8gW7MnD1bj2KsoMOExfb84O0yrefgJFxu6vUDlCrfAJGz6Gimo67c3JD
         sYTpTbcP1gl72lX1nf8yvKOvAmPXbbjJ2R43OADSdMlxorBb0xsEPNUcIXA6ZkZxBoTB
         FrrihBAWa4orpHzb6YHrk/LXn55Ry5iGKH60OSWDj5/20G5G3Fel/kYZikPW/uMMdcMT
         2RLiBAUF/Q7ayUHFr2MdPvK2q/ppXo6BeFjk8s29eDW8Moj3OHQ+F9QxYyXnjpYsR5If
         jdmQ==
X-Gm-Message-State: AOAM53074UpdrD7jzyP1cb0hixYyT5ahcqU22aMueZ6y286mj6F2QJYx
        ZHmLxtSaCab5u07pigFtmrSAt+eU18zMLw==
X-Google-Smtp-Source: ABdhPJw7+z5D5zA3qZ6s9mQaJPHppcUHChXr5YE/yJp0HkInPA5p0gFq2DLg3dXm7DJJ3fat62aXeQ==
X-Received: by 2002:a05:6402:2712:: with SMTP id y18mr44597083edd.212.1636909664378;
        Sun, 14 Nov 2021 09:07:44 -0800 (PST)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id c7sm5344966ejd.91.2021.11.14.09.07.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 09:07:43 -0800 (PST)
Message-ID: <c978931b-d3ba-89c7-52ef-30eddf740ba6@scylladb.com>
Date:   Sun, 14 Nov 2021 19:07:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     Linux-RAID <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
From:   Avi Kivity <avi@scylladb.com>
Subject: raid0 vs io_uring
Organization: ScyllaDB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Running a trivial randread, direct=1 fio workload against a RAID-0 
composed of some nvme devices, I see this pattern:


              fio-7066  [009]  1800.209865: function: io_submit_sqes
              fio-7066  [009]  1800.209866: function:                
rcu_read_unlock_strict
              fio-7066  [009]  1800.209866: function:                
io_submit_sqe
              fio-7066  [009]  1800.209866: function:                   
io_init_req
              fio-7066  [009]  1800.209866: 
function:                      io_file_get
              fio-7066  [009]  1800.209866: 
function:                         fget_many
              fio-7066  [009]  1800.209866: 
function:                            __fget_files
              fio-7066  [009]  1800.209867: 
function:                               rcu_read_unlock_strict
              fio-7066  [009]  1800.209867: function:                   
io_req_prep
              fio-7066  [009]  1800.209867: 
function:                      io_prep_rw
              fio-7066  [009]  1800.209867: function:                   
io_queue_sqe
              fio-7066  [009]  1800.209867: 
function:                      io_req_defer
              fio-7066  [009]  1800.209867: 
function:                      __io_queue_sqe
              fio-7066  [009]  1800.209868: 
function:                         io_issue_sqe
              fio-7066  [009]  1800.209868: 
function:                            io_read
              fio-7066  [009]  1800.209868: 
function:                               io_import_iovec
              fio-7066  [009]  1800.209868: 
function:                               __io_file_supports_async
              fio-7066  [009]  1800.209868: 
function:                                  I_BDEV
              fio-7066  [009]  1800.209868: 
function:                               __kmalloc
              fio-7066  [009]  1800.209868: 
function:                                  kmalloc_slab
              fio-7066  [009]  1800.209868: function: __cond_resched
              fio-7066  [009]  1800.209868: function:                
rcu_all_qs
              fio-7066  [009]  1800.209869: function: should_failslab
              fio-7066  [009]  1800.209869: 
function:                               io_req_map_rw
              fio-7066  [009]  1800.209869: 
function:                         io_arm_poll_handler
              fio-7066  [009]  1800.209869: 
function:                         io_queue_async_work
              fio-7066  [009]  1800.209869: 
function:                            io_prep_async_link
              fio-7066  [009]  1800.209869: 
function:                               io_prep_async_work
              fio-7066  [009]  1800.209870: 
function:                            io_wq_enqueue
              fio-7066  [009]  1800.209870: 
function:                               io_wqe_enqueue
              fio-7066  [009]  1800.209870: 
function:                                  _raw_spin_lock_irqsave
              fio-7066  [009]  1800.209870: function: 
_raw_spin_unlock_irqrestore



 From which I deduce that __io_file_supports_async() (today named 
__io_file_supports_nowait) returns false, and therefore every io_uring 
operation is bounced to a workqueue with the resulting great loss in 
performance.


However, I also see NOWAIT is part of the default set of flags:


#define QUEUE_FLAG_MQ_DEFAULT   ((1 << QUEUE_FLAG_IO_STAT) |            \
                                  (1 << QUEUE_FLAG_SAME_COMP) |          \
                                  (1 << QUEUE_FLAG_NOWAIT))

and I don't see that md touches it (I do see that dm plays with it).


So, what's the story? does md not support NOWAIT? If so, that's a huge 
blow to io_uring with md. If it does, are there any clues about why I 
see requests bouncing to a workqueue?

