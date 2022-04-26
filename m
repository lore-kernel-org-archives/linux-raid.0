Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282E8C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 26 Apr 2022 14:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245100AbiDZOlj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Apr 2022 10:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241689AbiDZOlh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Apr 2022 10:41:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7BF817E237
        for <linux-raid@vger.kernel.org>; Tue, 26 Apr 2022 07:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650983909; x=1682519909;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HxQNgPGpfG+GbdUuiuD8P8jC7Lv4pUXKPFcC1d9KUAw=;
  b=dImFL6Y/FtGpi76DxZsHkCtuVFslkraPzZr04FaNCOp81htE9WBTm5Ya
   v7m1X2KhGMyd5pYDTgVFXUrNI2c+8CYg5j0QPn6AnbCOsGi6jjTrBcKRq
   zx30wz0e7zfzeGHjRKdKo4AAnGeYd9lJYjv8yqd6FmKgsON1bqPzAMfy1
   skq8SGAI+KEy38kYD+V//omeIScvYgcXcoE3SN4DtJlsTJaY83Vz9GZfl
   O+kRVepR4WaBCvNXNoj1zApCaNJUoCn9aR9s0ho76bmzqyJAm9Cdgbpkp
   EHdphIjUR8pd6YlgVYabU/wJUBlT795e5ZK3JgUBQvhJbVa2T4J/70BaC
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="265761033"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="265761033"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 07:38:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="538816675"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.213.21.135])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 07:38:28 -0700
Date:   Tue, 26 Apr 2022 16:38:23 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Marius Kittler <mariuskittler@gmx.de>
Cc:     linux-raid@vger.kernel.org
Subject: Re: [PATCH] Print concrete error when creating mddev
Message-ID: <20220426163823.000024dc@linux.intel.com>
In-Reply-To: <20220425132745.7952-1-mariuskittler@gmx.de>
References: <20220425132745.7952-1-mariuskittler@gmx.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 25 Apr 2022 15:27:45 +0200
Marius Kittler <mariuskittler@gmx.de> wrote:

> Example from my testing:
> ```
> mdadm: unexpected failure opening /dev/md127: No such device or address
> ```
> 
> Before it would just print:
> ```
> mdadm: unexpected failure opening /dev/md127

Hi Marius,
Thanks for the patch. Could you provide reproduction steps?

> diff --git a/util.c b/util.c
> index cc94f96e..7c8c0bb1 100644
> --- a/util.c
> +++ b/util.c
> @@ -1088,8 +1088,9 @@ int open_dev_excl(char *devnm)
>  	long delay = 1000;
> 
>  	sprintf(buf, "%d:%d", major(devid), minor(devid));
> +	int fd = -1;
>  	for (i = 0; i < 25; i++) {
> -		int fd = dev_open(buf, flags|O_EXCL);
> +		fd = dev_open(buf, flags|O_EXCL);
>  		if (fd >= 0)
>  			return fd;
>  		if (errno == EACCES && flags == O_RDWR) {
> @@ -1102,7 +1103,7 @@ int open_dev_excl(char *devnm)
>  		if (delay < 200000)
>  			delay *= 2;
>  	}
> -	return -1;
> +	return fd;

There is no change, it is just a refactor. If you really want to change that,
then please follow kernel coding style guide. Please also run checkpatch script
from kernel source.

Could you add Jes and Coly to CC in v2?

Thanks,
Mariusz
