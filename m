Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDAD5C433DB
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 962B36521D
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCHPmL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:42:11 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17231 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhCHPl4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Mar 2021 10:41:56 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615218114; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=d+VXDrhFZEXzT+63H+aEWSEqwfzKrxUBoA0F9F6VLq6QKodK+ETl9WnjyjbDorGYTtSth0oIbd2KMt9h1Jate93Amao0lUsU9ZsUUl65ZRdKFw9+0ZPMq3MbOX4mZLxwm6RXn7Y6Ik0Yb1MtQF8M1+UhN9iyWZ+YniuyoltmhwM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615218114; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=/HVjVtc97wqJqWZ+c9rEm5pKH99YjyzklHPCSffuCQk=; 
        b=Gs3aYOKEaDsoXw63+UntTOn35paxdkvNFexs2h0hOfV55Q6JQzvdRkoASZObJ3j8gaHXg3fZxLHLdGmL+1NrzyHhCSk+3A1WoCDsacPkOVS5fuq+H9PnrhCqJOE0SMTjOnHCCY/cl93+PaqFcP/t9h2YBFuKBkCYekrdCosGQn0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615218112964401.52697691148876; Mon, 8 Mar 2021 16:41:52 +0100 (CET)
Subject: Re: [PATCH] imsm: nvme multipath support
To:     Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210115152824.51793-1-oleksandr.shchirskyi@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <6230b3e8-5d8f-2cb2-1a84-edae0b350a6c@trained-monkey.org>
Date:   Mon, 8 Mar 2021 10:41:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210115152824.51793-1-oleksandr.shchirskyi@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/15/21 10:28 AM, Oleksandr Shchirskyi wrote:
> From: Blazej Kucman <blazej.kucman@intel.com>
> 
> Add support for nvme devices which are represented
> via nvme-subsystem.
> Print warning when multi-path disk is added to RAID
> 
> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> ---
>  platform-intel.c | 83 +++++++++++++++++++++++++++++++++++++++++++++++-
>  platform-intel.h |  2 ++
>  super-intel.c    | 38 ++++++++++++++--------
>  3 files changed, 108 insertions(+), 15 deletions(-)

Hi

A couple of nits on this one.

> diff --git a/platform-intel.c b/platform-intel.c
> index f1f6d4cd..2ee5a8da 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -668,12 +668,71 @@ const struct imsm_orom *find_imsm_capability(struct sys_dev *hba)
>  	return NULL;
>  }
>  
> +/* Check whether the nvme device is represented by nvme subsytem,
> + * if yes virtual path should be changed to hardware device path,
> + * to allow IMSM capabilities detection.
> + * Returns:
> + *	hardware path to device - if the device is represented via
> + *		nvme virtual subsytem
> + *	NULL - if the device is not represented via nvme virtual subsytem
> + */
> +char *get_nvme_multipath_dev_hw_path(const char *dev_path)
> +{
> +	char buf[PATH_MAX];
> +	DIR *dir;
> +	struct dirent *ent;
> +	char *nvme_subsystem_path = "/devices/virtual/nvme-subsystem";
> +	char *ptr;
> +	char *rp = NULL;
> +
> +	if (!strstr(dev_path, nvme_subsystem_path))
> +		return NULL;
> +
> +	memcpy(buf, dev_path, sizeof(buf) - 1);
> +	buf[PATH_MAX-1] = '\0';

You are indiscriminately copying PATH_MAX here, even if dev_path is only
a few characters long.

> +	dir = opendir(buf);
> +	if (!dir)
> +		return NULL;

Second, the only thing you do with the copy is to pass it to opendir?
Why not just check the bounds and pass dev_path straight to opendir()?

> +	for (ent = readdir(dir); ent; ent = readdir(dir)) {
> +		if (!(strncmp(ent->d_name, "nvme", 4) == 0))
> +			continue;
> +
> +		// Needed is realpath to controller not to namespace.

Please use proper comments.

> +		ptr = ent->d_name + 4;
> +		if (!strstr(ptr, "n")) {
> +			char buf1[PATH_MAX + NAME_MAX + 1];

That's a lot of stack usage in this function, why not just alloca() what
you need?

> +
> +/* Verify if multipath is supported by NVMe controller
> + * Returns:
> + *	0 - not supported
> + *	1 - supported
> + */
> +int is_multipath_nvme(int disk_fd)
> +{
> +	char *ns_name;
> +	char path_buf[PATH_MAX];
> +	char ns_path[PATH_MAX];
> +	char *nvme_subsystem_path = "/devices/virtual/nvme-subsystem";
> +
> +	ns_name = fd2kname(disk_fd);
> +	sprintf(path_buf, "/sys/block/%s", ns_name);
> +	if (!realpath(path_buf, ns_path))
> +		return 0;
> +	if (!strstr(ns_path, nvme_subsystem_path))
> +		return 0;

Given both path_buf and ns_path are throwaway buffers, why not just use
one and save the stack space?

Thanks,
Jes

