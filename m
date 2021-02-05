Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5202CC433E6
	for <linux-raid@archiver.kernel.org>; Fri,  5 Feb 2021 09:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0ECE64F3B
	for <linux-raid@archiver.kernel.org>; Fri,  5 Feb 2021 09:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhBEJWB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Feb 2021 04:22:01 -0500
Received: from mga12.intel.com ([192.55.52.136]:44959 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhBEJT5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 5 Feb 2021 04:19:57 -0500
IronPort-SDR: 5lh1QE8wo/XqCntkse+4a5jffxsxCmte6KrMk6l1Nsav4Swcg295oY9RTrrSDMPIBDefX7fpx8
 XHkzi81t74Tg==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="160565323"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="160565323"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 01:17:42 -0800
IronPort-SDR: YOkIOaivRj4eMtR71uZZzxncQZ4mGnPifuxQLHPz1ioFLWN5OMWOj8sFrO1gwmKhFveu5N+2vj
 u9s2G3bgdyKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="373286857"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga008.fm.intel.com with ESMTP; 05 Feb 2021 01:17:42 -0800
Received: from [10.213.26.7] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.26.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 4979B5808B9;
        Fri,  5 Feb 2021 01:17:40 -0800 (PST)
Subject: Re: [RFC PATCH] super-intel: correctly recognize NVMe device during
 assemble
To:     Lidong Zhong <lidong.zhong@suse.com>, jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org, david.chang@hpe.com,
        "Shchirskyi, Oleksandr" <oleksandr.shchirskyi@intel.com>
References: <20210205071133.11139-1-lidong.zhong@suse.com>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <f07a286d-e56e-7b47-86a3-5677893876d6@linux.intel.com>
Date:   Fri, 5 Feb 2021 10:17:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210205071133.11139-1-lidong.zhong@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,
Thanks for the patch but we sent similar solution recently, see:
https://lore.kernel.org/linux-raid/20210115152824.51793-1-
oleksandr.shchirskyi@intel.com/
For namespaces exposed via nvme-subsystem, autorebuild scenarios won't
work because /dev/disk/by-path link doesn't exist.

Our patch fixes mdadm --detail-platform output additionally, this part is
missed here.

Mariusz

On 05.02.2021 08:11, Lidong Zhong wrote:
> We had a customer report the following error while assembling the raid
> device, which is created from Intel VMD configuration of RBSU(bios).
>> sudo /sbin/mdadm -v --incremental --export /dev/nvme0n1 --offroot
> /dev/disk/by-id/nvme-eui.355634304e2000530025384500000001
> /dev/disk/by-id/nvme-MZXL5800HBHQ-000H3_S5V4NE0N200053
> [sudo] password for root:
> mdadm: /dev/nvme0n1 is not attached to Intel(R) RAID controller.
> mdadm: No OROM/EFI properties for /dev/nvme0n1
> mdadm: no RAID superblock on /dev/nvme0n1
> 
> It's because in function path_attached_to_hba(), the string of disk
> doesn't match hba and thus it fails to be recognized as a valid device.
> The following is the debug output with this patch applied.
> mdadm: hba: /sys/devices/pci0000:c0/0000:c0:00.5/pci10002:00 - disk:
> /sys/devices/virtual/nvme-subsystem/nvme-subsys0
> mdadm: NVME:tmp_path:
> /sys/devices/virtual/nvme-subsystem/nvme-subsys0/nvme0
> mdadm: NVME:tmp_path:
> /sys/devices/virtual/nvme-subsystem/nvme-subsys0/nvme0 - real_disk_path:
> /sys/devices/pci0000:c0/0000:c0:00.5/pci10002:00/10002:00:04.0/10002:03:00.0/nvme/nvme0
> 
> Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
> Reported-by: David Chang <david.chang@hpe.com>
> ---
>   platform-intel.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/platform-intel.c b/platform-intel.c
> index f1f6d4c..e3c12a3 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -707,6 +707,17 @@ int path_attached_to_hba(const char *disk_path, const char *hba_path)
>   		rc = 1;
>   	else
>   		rc = 0;
> +	if (0 == rc && strstr(disk_path, "nvme-subsys")) {
> +		char tmp_path[PATH_MAX], *real_disk_path;
> +		int len = strlen(disk_path);
> +		snprintf(tmp_path,"%s/nvme%c",disk_path, disk_path[len-1]);
> +		real_disk_path = realpath(tmp_path, NULL);
> +		if (real_disk_path) {
> +			if (strncmp(real_disk_path, hba_path, strlen(hba_path)) == 0)
> +				rc = 1;
> +			free(real_disk_path);
> +		}
> +    }
>   
>   	return rc;
>   }
>
