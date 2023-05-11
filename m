Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A97CC7EE22
	for <linux-raid@archiver.kernel.org>; Thu, 11 May 2023 07:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237486AbjEKH4o (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 May 2023 03:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237502AbjEKH4g (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 May 2023 03:56:36 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5C98690
        for <linux-raid@vger.kernel.org>; Thu, 11 May 2023 00:56:35 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QH4063H7pzLnsg;
        Thu, 11 May 2023 15:53:42 +0800 (CST)
Received: from [10.174.179.167] (10.174.179.167) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 15:56:32 +0800
Message-ID: <1c85276f-b44a-07f1-dd34-b853c5f7529f@huawei.com>
Date:   Thu, 11 May 2023 15:56:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <colyli@suse.de>,
        <linux-raid@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>, <louhongxiang@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
From:   miaoguanqin <miaoguanqin@huawei.com>
Subject: [QUESTION]mdadm4.1 upgrade to mdadm4.2,mdmonitor services failed to
 start if no raid in environment
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.167]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500002.china.huawei.com (7.221.188.171)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi
  Here we meet a question. After we upgrade mdadm from 4.1 to 4.2, we 
execute :
     systemctl start mdmonitor
the mdmonitor service failed to start when no raid device in 
environment. error message are as follows:

mdmonitor.service - MD array monitor
      Loaded: loaded (/usr/lib/systemd/system/mdmonitor.service; 
enabled; vendor preset: enabled)
      Active: failed (Result: protocol) since Thu 2023-05-11 10:52:32 
CST; 5s ago
     Process: 999741 ExecStartPre=mkdir -p /run/mdadm (code=exited, 
status=0/SUCCESS)
     Process: 999743 ExecStart=/sbin/mdadm --monitor $MDADM_MONITOR_ARGS 
-f --pid-file=/run/mdadm/mdadm.pid (c>

May 11 10:52:32 localhost.localdomain systemd[1]: Starting MD array 
monitor...
May 11 10:52:32 localhost.localdomain systemd[1]: mdmonitor.service: 
Can't open PID file /run/mdadm/mdadm.pid>
May 11 10:52:32 localhost.localdomain systemd[1]: mdmonitor.service: 
Failed with result 'protocol'.
May 11 10:52:32 localhost.localdomain systemd[1]: Failed to start MD 
array monitor.

In the mdmonitor service file, type is set to forking and the PIDFILE 
field is set. The systemd detection process is as follows:
(1)when the parent process exits, a signal is sent to systemd
(2)systemd wakes up and checks whether pidfile exists by PIDFILE field.
(3)If the pidfile file does not exist, the service status is set to fail.
In function Monitor code logic, after the parent process creates a 
pidfile, before systemd detects the pidfile, the pidfile is deleted from 
the child process. As a result, the systemd cannot detect the pidfile 
and sets the service status to fail.

It is a problem for user, because the mdmonitor service status is fail.
If there is no RAID device in the environment, We want the service 
status is expected to be inactive after the service is started. Can you 
have any advice for this problem ?
