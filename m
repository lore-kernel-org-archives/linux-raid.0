Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7798CCA47B
	for <linux-raid@archiver.kernel.org>; Fri, 10 Jun 2022 09:19:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348750AbiFJJTA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Jun 2022 05:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348984AbiFJJSd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Jun 2022 05:18:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110471F129B
        for <linux-raid@vger.kernel.org>; Fri, 10 Jun 2022 02:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654852589; x=1686388589;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G1sHpFuLe5A7gd+8UZ3A+/CD3n1Zr3x5QX9ntDsKgIU=;
  b=ckHW7rdNyL/vMedkvbBjQlS50+2DNs+JuF1P55iXSfsc7lRFSJG2b89L
   eVhnTzJtrFTgVY4nv8Fz0Cm7+bN4hbKs3u6TsjFUOKwzQmcZSR0V4q8AU
   8KgqWsNnuaNe0WMlIbXAGNWI9XHQk1SvblcriqLOXgPwoY3j9fYlR4IwY
   s9VOZtIds55lL7vnkbXvCEy4ePW+twQb/dN3NZ4hUbCc5LeKSMNz0Vfr/
   pwD96LRqPdYoSkkTJFCu/t1q4RMuv+LKhV9fxjBUncFaLCniSckYebPUR
   vDIfw39uHdLRBw0YtGEQ/h2tI7n+XeydTGum6vLfOIrI0ewqZUemZJljs
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="278709991"
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="278709991"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 02:16:28 -0700
X-IronPort-AV: E=Sophos;i="5.91,288,1647327600"; 
   d="scan'208";a="638035941"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.21])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 02:16:26 -0700
Date:   Fri, 10 Jun 2022 11:16:22 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
Cc:     <jes@trained-monkey.org>, <linux-raid@vger.kernel.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>
Subject: Re: [PATCH 4/5 v2] find_disk_attached_hba: fix memleak
Message-ID: <20220610111622.00007807@linux.intel.com>
In-Reply-To: <b54a5d8f-f6f4-af57-b54a-74e56f43dbb1@huawei.com>
References: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
        <b54a5d8f-f6f4-af57-b54a-74e56f43dbb1@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 9 Jun 2022 11:08:39 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

> If disk_path = diskfd_to_devpath(), we need free(disk_path) before
> return, otherwise there will be a memory leak
> 
> Reported-by: Coverity
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
>  super-intel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index ee9e112e..e94f3f65 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -701,12 +701,12 @@ static struct sys_dev* find_disk_attached_hba(int fd,
> const char *devname)
> 
>         for (elem = list; elem; elem = elem->next)
>                 if (path_attached_to_hba(disk_path, elem->path))
> -                       return elem;
> +                       break;
> 
>         if (disk_path != devname)
>                 free(disk_path);
> 
> -       return NULL;
> +       return elem;
>  }
> 
>  static int find_intel_hba_capability(int fd, struct intel_super *super,
> --
> 2.27.0

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
