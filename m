Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F7D2CE7B10
	for <linux-raid@archiver.kernel.org>; Thu, 28 Sep 2023 09:42:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjI1JmL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Sep 2023 05:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjI1JmF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Sep 2023 05:42:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5368E1A8
        for <linux-raid@vger.kernel.org>; Thu, 28 Sep 2023 02:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695894118; x=1727430118;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1BMX6+Im6saeNyitqnBik8b3JnSlRcb+WamVqEoq8tU=;
  b=YwrXRRqx9SkS0IZUDfmnsquYPoyPUxZHXwWG1edK8CsB99j9gjzWk3Ry
   rh2gKaNO1VhYD//rFmChZ85WOsfQFZ5lEN8zRkI60J+qJxAPMBHxgcsAs
   ouRabE4kYKYCErN+kVVFObV22HG8JTe/nTrSTOt+xG6kETaMt7TJVSJRb
   sfLyBkPxUtlI93OiQjvtRzoPhzzT/HluPL/7elsPTp4y3eCNb0Ss3Nw1y
   Xd6CCMauFHGcLNe/N6a+IOVeh0WgVR0lKNTr3rICk4zcd8XzCMK7EqkF5
   odybb8TFQSmOinnJXqIjwmUiEPiW91oGRvKdAiiMQo5X9H6e9fOSnitl3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="628836"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="628836"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:41:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10846"; a="865196460"
X-IronPort-AV: E=Sophos;i="6.03,183,1694761200"; 
   d="scan'208";a="865196460"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.152.98])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 02:41:54 -0700
Date:   Thu, 28 Sep 2023 11:41:49 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/4] mdadm: Avoid array bounds check of gcc
Message-ID: <20230928114149.000016a1@linux.intel.com>
In-Reply-To: <20230927025219.49915-4-xni@redhat.com>
References: <20230927025219.49915-1-xni@redhat.com>
        <20230927025219.49915-4-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 27 Sep 2023 10:52:18 +0800
Xiao Ni <xni@redhat.com> wrote:

> With gcc version 13.2.1 20230918 (Red Hat 13.2.1-3) (GCC), it reports err=
or:
> super-ddf.c:1988:58: error: array subscript -1 is below array bounds of
> =E2=80=98struct phys_disk_entry[0]=E2=80=99 [-Werror=3Darray-bounds=3D]
> The subscrit is defined as int type. And it can be smaller than 0.

If it can be smaller that 0 then it is something we need to fix.
I think that it comes from here:
		info->disk.raid_disk =3D find_phys(ddf, ddf->dlist->disk.refnum);
		info->data_offset =3D be64_to_cpu(ddf->phys->
						  entries[info->disk.raid_disk].
						  config_size);

find_phys can return -1.
It is handled few lines bellow. I don't see reason why we cannot handle it =
here
too.

		if (info->disk.raid_disk >=3D 0)
			pde =3D ddf->phys->entries + info->disk.raid_disk;

I think that it will be fair to abort because metadata seems to be corrupte=
d.
We are referring to info->disk.raid_disk from many places. We cannot return
error because it is void, we can just return.

> To avoid this error, add -Wno-array-bounds flag in Makefile.

If you want do it this way please provide strong justification. We are
disabling check in all code to hide particular case. It will not prevent us
from similar mistakes during development in the future.

Thanks,
Mariusz
