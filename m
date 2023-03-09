Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDADC64EC4
	for <linux-raid@archiver.kernel.org>; Thu,  9 Mar 2023 15:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjCIP5S (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Mar 2023 10:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCIP5R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Mar 2023 10:57:17 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EC7F0FC7
        for <linux-raid@vger.kernel.org>; Thu,  9 Mar 2023 07:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678377436; x=1709913436;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iHr+xR7Kiw4CaiIIhFfs9RtJpTR8iTtMPjBAAHbA+wc=;
  b=GQP+enXAEt1yVU/8tKod118JrKAARLZ7rV6xyKEhuVjVp6YTKhEp3zbZ
   QRLSFjD21M6bhr7tH+c1OFhPG/KZri5Q2k7hsPEGxYVdeNXT+83wz6Ngu
   rN0GfLRmmcwlc+S6KEPTSibFzx3VrwFWtZaImC2gQjMZ4k7uYQcVKP8fo
   NriutRjESYzlHdvMqyt5NZvkMbYLYeYxLq3kjCSdB1iJ/7klHro0SCdVi
   0BBP3qCg6gSaW0D1phjvN6CcZ3lVG03mmNgcaZZFH5F1cd+Qh3Rt1wB38
   Yu7H3N3jMiMo56Av9Il5yg0aZ4WhAiJiYltOTPKZ27xo7uouXm//jn1cG
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="422748579"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="422748579"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 07:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="654796364"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="654796364"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.46.155])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 07:57:13 -0800
Date:   Thu, 9 Mar 2023 16:57:08 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     miaoguanqin <miaoguanqin@huawei.com>
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>,
        Wu Guanghao <wuguanghao3@huawei.com>, <lixiaokeng@huawei.com>
Subject: Re: [PATCH] Create /dev/md/x link when md device is created
Message-ID: <20230309165708.0000372c@linux.intel.com>
In-Reply-To: <f4aabc6f-22c1-3bf3-aef4-709051266f6c@huawei.com>
References: <f4aabc6f-22c1-3bf3-aef4-709051266f6c@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 9 Mar 2023 22:47:27 +0800
miaoguanqin <miaoguanqin@huawei.com> wrote:

> After the /dev/mdx is created,we can see that /dev/mdx file is
> created.When we reboot machines,we found /dev/md/x will be created,
> and map file will be rebuild and changed.
> 
> During RAID rebuild after the reboot, we found /dev/md/x is created
> with high priority. To consistent behavior, we think that /dev/md/x
> should also be created when creating devices.
> 
> We modified the logic for creating /dev/mdx,creating /dev/md/x at
> the same time.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> Signed-off-by: Lixiaokeng <lixiaokeng@huawei.com>
> ---
>   mdopen.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mdopen.c b/mdopen.c
> index 98c54e4..d128396 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -373,11 +373,12 @@ int create_mddev(char *dev, char *name, int autof, 
> int trustworthy,
> 
>   	sprintf(devname, "/dev/%s", devnm);
> 
> -	if (dev && dev[0] == '/')
> -		strcpy(chosen, dev);
> -	else if (cname[0] == 0)
> -		strcpy(chosen, devname);
> -
> +	if (strncmp(chosen, "/dev/md/", 8) != 0) {
> +		if (dev && dev[0] == '/')
> +			strcpy(chosen, dev);
> +		else if (cname[0] == 0)
> +			strcpy(chosen, devname);
> +	}
>   	/* We have a device number and name.
>   	 * If we cannot detect udev, we need to make
>   	 * devices and links ourselves.

Hi miaoguanqin,

Could you please share command used to create? If you are using:
#mdadm --create /dev/mdX

Then it is know issue (at least for me). Please use:
#mdadm --create /dev/md/X

I know that the interface is not consistent but I don't see you solution are
good fix. The create_mddev() is over complicated. Did you run this test:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/tests/00createnames

I think that it didn't passed- so we could have a regression.

BTW. I believe that "miaoguanqin" it is your real name, why lowercase?

Thanks,
Mariusz
