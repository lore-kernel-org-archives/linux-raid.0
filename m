Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3110C76196
	for <linux-raid@archiver.kernel.org>; Tue, 28 Mar 2023 10:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbjC1K2z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Mar 2023 06:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjC1K2y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Mar 2023 06:28:54 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09DA6184
        for <linux-raid@vger.kernel.org>; Tue, 28 Mar 2023 03:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679999333; x=1711535333;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4QittuyVG0Uqm4UI1Iwh1a1xniG4wt22fiU14LdiwcY=;
  b=Ri7z1z+BQ1tt9H6Il279MYkgM4lORHNrBQlqSbdwZJmTp0ywhdeIZ0Fx
   idtnOqL/Q5+bNixHRjPhg2SzHFjN3g33kaxtv67Qjeq+GD7qOYK5W/AAP
   jRZtZnmyAe0+dcZEADOQTkLmP3+tg2jkOJmS2BvZoBHIvq2iiUHUEgspN
   XHtQ6KdkRq8m3gPx0r0o8Aj4R2QLN64DeNzfbU15mo233AvajrRXsZVXs
   TpVDDNC1+yjGuyCN5S/fA/eIYEmh6/BCIxLSfMsWZxoqWqDf203KRKpaH
   2I8WsT9+IyQpuRZGvVRfzYgunUvMq91sNbF9hKRz/q35m4mZAXxsscSiA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="403141631"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="403141631"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 03:28:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10662"; a="858024474"
X-IronPort-AV: E=Sophos;i="5.98,297,1673942400"; 
   d="scan'208";a="858024474"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.165])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2023 03:28:51 -0700
Date:   Tue, 28 Mar 2023 12:28:46 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     miaoguanqin <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH 3/4] Fix memory leak in file Manage
Message-ID: <20230328122846.00005a5b@linux.intel.com>
In-Reply-To: <20230323013053.3238005-4-miaoguanqin@huawei.com>
References: <20230323013053.3238005-1-miaoguanqin@huawei.com>
        <20230323013053.3238005-4-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 23 Mar 2023 09:30:52 +0800
miaoguanqin <miaoguanqin@huawei.com> wrote:

> When we test mdadm with asan,we found some memory leaks in Manage.c
> We fix these memory leaks based on code logic.

Missing space after comma.
> 
> Signed-off-by: miaoguanqin <miaoguanqin@huawei.com>
> Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
> ---
>  Manage.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/Manage.c b/Manage.c
> index fde6aba3..75bed83b 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -222,6 +222,8 @@ int Manage_stop(char *devname, int fd, int verbose, int
> will_retry) if (verbose >= 0)
>  			pr_err("Cannot get exclusive access to %s:Perhaps a
> running process, mounted filesystem or active volume group?\n", devname);
> +		if (mdi)
> +			sysfs_free(mdi);
>  		return 1;
>  	}
>  	/* If this is an mdmon managed array, just write 'inactive'
> @@ -818,8 +820,16 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  						    rdev, update, devname,
>  						    verbose, array);
>  				dev_st->ss->free_super(dev_st);
> -				if (rv)
> +				if (rv) {
> +					if (dev_st)
> +						free(dev_st);

We are calling dev_st->ss->free_super(dev_st) in this code branch so it seems
that dev_st cannot be null, just free is needed.



