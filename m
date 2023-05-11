Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0925C7EE22
	for <linux-raid@archiver.kernel.org>; Thu, 11 May 2023 13:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238032AbjEKNvM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 11 May 2023 09:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236577AbjEKNvL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 11 May 2023 09:51:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8900D9
        for <linux-raid@vger.kernel.org>; Thu, 11 May 2023 06:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683813069; x=1715349069;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gVejCnkEjtFBMOxPgpjeG6znbJ1c0sSR74WVPZREqlg=;
  b=CE5mqI2V6zE+UsWTDC4+AjrFiY1y3gX6qRqmm+gubPuAF5urnPij7ggY
   87DKm989AFhBJufQYtr3L8TEZOztjJkVMP0+c7aGaFsqAPzPNck7+pbLb
   ybJDOMYg4zzcMzVS2sd3Wfti+A9uHhqIFBOiOWuZZFKGRNF37zMzkkNLb
   NywbDBkG38A99gJuakp043czs/MIet/+IVfd5oYt5dHinmShbkUmcUmWw
   3RT7CWjJTUsIbMnGWVzezeVtXmaE496DkuMJqaahOtgetLcbDHqhJSssb
   v/xOtrc4colh3uVb0oE9LvsDnJm7dxrrrxnKnGOnEvWoswX8pkOlz75y2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="352730397"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="352730397"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 06:48:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="699728991"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699728991"
Received: from bkucman-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.0.38])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 06:48:12 -0700
Date:   Thu, 11 May 2023 15:48:07 +0200
From:   Blazej Kucman <blazej.kucman@linux.intel.com>
To:     miaoguanqin <miaoguanqin@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Martin Wilck <mwilck@suse.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <colyli@suse.de>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        <louhongxiang@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [QUESTION]mdadm4.1 upgrade to mdadm4.2,mdmonitor services
 failed to start if no raid in environment
Message-ID: <20230511154409.00002c8c@linux.intel.com>
In-Reply-To: <1c85276f-b44a-07f1-dd34-b853c5f7529f@huawei.com>
References: <1c85276f-b44a-07f1-dd34-b853c5f7529f@huawei.com>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 11 May 2023 15:56:31 +0800
miaoguanqin <miaoguanqin@huawei.com> wrote:

> Hi
>   Here we meet a question. After we upgrade mdadm from 4.1 to 4.2, we 
> execute :
>      systemctl start mdmonitor
> the mdmonitor service failed to start when no raid device in 
> environment. error message are as follows:
> 
> mdmonitor.service - MD array monitor
>       Loaded: loaded (/usr/lib/systemd/system/mdmonitor.service; 
> enabled; vendor preset: enabled)
>       Active: failed (Result: protocol) since Thu 2023-05-11 10:52:32 
> CST; 5s ago
>      Process: 999741 ExecStartPre=mkdir -p /run/mdadm (code=exited, 
> status=0/SUCCESS)
>      Process: 999743 ExecStart=/sbin/mdadm --monitor
> $MDADM_MONITOR_ARGS -f --pid-file=/run/mdadm/mdadm.pid (c>
> 
> May 11 10:52:32 localhost.localdomain systemd[1]: Starting MD array 
> monitor...
> May 11 10:52:32 localhost.localdomain systemd[1]: mdmonitor.service: 
> Can't open PID file /run/mdadm/mdadm.pid>
> May 11 10:52:32 localhost.localdomain systemd[1]: mdmonitor.service: 
> Failed with result 'protocol'.
> May 11 10:52:32 localhost.localdomain systemd[1]: Failed to start MD 
> array monitor.
> 
> In the mdmonitor service file, type is set to forking and the PIDFILE 
> field is set. The systemd detection process is as follows:
> (1)when the parent process exits, a signal is sent to systemd
> (2)systemd wakes up and checks whether pidfile exists by PIDFILE
> field. (3)If the pidfile file does not exist, the service status is
> set to fail. In function Monitor code logic, after the parent process
> creates a pidfile, before systemd detects the pidfile, the pidfile is
> deleted from the child process. As a result, the systemd cannot
> detect the pidfile and sets the service status to fail.
> 
> It is a problem for user, because the mdmonitor service status is
> fail. If there is no RAID device in the environment, We want the
> service status is expected to be inactive after the service is
> started. Can you have any advice for this problem ?

Hi,

I do not know if the service should be in this state for such a case,
but the start of the mdmonitor service is also forced by udev rule
udev-md-raid-arrays.rules

# ENV{MD_LEVEL}=="raid[1-9]*", ENV{SYSTEMD_WANTS}+="mdmonitor.service"

so if the service is failed, it will be started anyway after creating
a new RAID.

Regards,
Blazej
