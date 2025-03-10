Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E2D17C91
	for <linux-raid@vger.kernel.org>; Mon, 10 Mar 2025 14:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741617729; cv=none; b=ptqnu1Lnx3q9gyIVZwGCHL7gud18YDduDCtrAkcw9zEImd3CZYAijtIqS5hkp6WvtfnPMmsnkF5JVHEKlKYd3XqX+b8uMs2VeZXmHpuwByW13veleFomIp3yjWpThxtdJI7XSpQbPmuT+8XUUOeR0jBjjBT/UK4uSvNxXQbVAhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741617729; c=relaxed/simple;
	bh=SKeF+D6Ql9rVchD7ZsNmCejz+b9OLsxDElRCPwXqqB8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B8DwxYdEaFTxabU+6sjE9xVGtCCe7hu1FpnbJA+iH+fNUfWW4U+Ju8jL1STcutDJJ0LETT5jcIkX0hGeFCLZmKy22ngkjIGwZ/I0SmgxPL4jjP0pw8GVOBb4svea+6heIgFYqWs/DOGRvJGredZaOCGIKJRTF6T3qIGQ/BpwNgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FIGLpT+V; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FIGLpT+V"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741617729; x=1773153729;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SKeF+D6Ql9rVchD7ZsNmCejz+b9OLsxDElRCPwXqqB8=;
  b=FIGLpT+V0Yxbl2F3zIluDuhT1nzgKHMJaPzpmif6PpbADQoyfHkdEaLW
   dmskPbw0nvvFO8yFi17+GUS601WWy1umDNcH7w9bPqs2sqHwJi3gQzX7P
   0gwmqUMhrJYzhFM5sPGmRXTVo5tTzg3Rl0V2v9qaXDBurviqPXMEROFUZ
   ocv5Cjb7yRth/Y3yh9m6jb3ioBYjl5mPYYexGQpCtW1qbm9wGW62E3C33
   1aBr1HaWlgoamfn31fiEafAr5t45Qg4w3kAsIpFePkX5eoDWUXs8lVkK8
   8RuN8XS3zRZFsVKFw/6+muJTmdrcu9YfQWpaW3QyGAgTzTs5N3O8Cm8jX
   Q==;
X-CSE-ConnectionGUID: 66TwFs/oQZe9/1zbqwOFiQ==
X-CSE-MsgGUID: BXx4Ang5TgSpPzPpM6wxPg==
X-IronPort-AV: E=McAfee;i="6700,10204,11369"; a="42806874"
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="42806874"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 07:42:08 -0700
X-CSE-ConnectionGUID: lk2xCVB4RWao3gsCIloE7Q==
X-CSE-MsgGUID: HVDFDw5WRaelpinQbcDPqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,236,1736841600"; 
   d="scan'208";a="157214724"
Received: from bkucman-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.116.32])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 07:42:05 -0700
Date: Mon, 10 Mar 2025 15:41:59 +0100
From: Blazej Kucman <blazej.kucman@linux.intel.com>
To: Wu Guanghao <wuguanghao3@huawei.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Yu Kuai
 <yukuai1@huaweicloud.com>, <xni@redhat.com>, <ncroxon@redhat.com>,
 <linux-raid@vger.kernel.org>, <liubo254@huawei.com>
Subject: Re: [PATCH v2] mdadm: Clear extra flags when initializing metadata
Message-ID: <20250310154159.00007ea6@linux.intel.com>
In-Reply-To: <27127b7d-7da6-cd31-01db-6725884a7286@huawei.com>
References: <b894d081-eda9-6b28-5fef-75753838a916@huawei.com>
	<27127b7d-7da6-cd31-01db-6725884a7286@huawei.com>
Organization: intel
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Mar 2025 19:09:36 +0800
Wu Guanghao <wuguanghao3@huawei.com> wrote:

Hi,
Thanks for your patch.

you are only adding a change to native metadata so it would be good to
emphasize this in the title, please change "mdadm:" to "super1:"

There are also a few checkpatch issues,


> When adding a disk to a RAID1 array, the metadata is read from the
> existing member disks for sync. However, only the bad_blocks flag are
> copied, the bad_blocks records are not copied, so the bad_blocks
> records are all zeros. The kernel function super_1_load() detects
> bad_blocks flag and reads the bad_blocks record, then sets the bad
> block using badblocks_set().

WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit
description?) #8: 
the bad_blocks records are not copied, so the bad_blocks records are
all zeros.

> 
> After the kernel commit 1726c7746("badblocks: improve badblocks_set()
> for multiple ranges handling"), if the length of a bad_blocks record

please use SHA-1 ID - first 12 characters and space between ID and
(Tile) 

> is 0, it will return a failure. Therefore the device addition will
> fail.
> 
> So when adding a new disk, some flags cannot be sync and need to be
> cleared.
> 
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> ---
> Changelog:
> v2:
>     Add a testcase.
>     Clear extra replace flag.
> ---
>  super1.c                 |  4 ++++
>  tests/05r1-add-badblocks | 25 +++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
>  create mode 100644 tests/05r1-add-badblocks
> 
> diff --git a/super1.c b/super1.c
> index fe3c4c64..f4a29f4f 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -1971,6 +1971,10 @@ static int write_init_super1(struct supertype
> *st) long bm_offset;
>  	bool raid0_need_layout = false;
> 
> +	/* Clear extra flags */
> +	sb->feature_map &= ~__cpu_to_le32(MD_FEATURE_BAD_BLOCKS |
> +                                          MD_FEATURE_REPLACEMENT);

ERROR: code indent should use tabs where possible
#36: FILE: super1.c:1976:
+                                          MD_FEATURE_REPLACEMENT);$

WARNING: please, no spaces at the start of a line
#36: FILE: super1.c:1976:
+                                          MD_FEATURE_REPLACEMENT);$

However, in this case the code will fit on one line, the limit is 100
characters.

> +
>  	/* Since linux kernel v5.4, raid0 always has a layout */
>  	if (has_raid0_layout(sb) && get_linux_version() >= 5004000)
>  		raid0_need_layout = true;
> diff --git a/tests/05r1-add-badblocks b/tests/05r1-add-badblocks
> new file mode 100644
> index 00000000..88b064f2
> --- /dev/null
> +++ b/tests/05r1-add-badblocks
> @@ -0,0 +1,25 @@
> +#
> +# create a raid1 with a drive and set badblocks for the drive.
> +# add a new drive does not cause an error.
> +#
> +
> +# create raid1
> +mdadm -CR $md0 -l1 -n2 -e1.0 $dev1 missing
> +testdev $md0 1 $mdsize1a 64
> +sleep 3
> +
> +# set badblocks for the drive
> +dev1_name=$(basename $dev1)
> +echo "10000 100" > /sys/block/md0/md/dev-$dev1_name/bad_blocks
> +echo "write_error" > /sys/block/md0/md/dev-$dev1_name/state
> +
> +# maybe fail but that's ok, as it's only intended to
> +# record the bad block in the metadata.
> +mkfs.ext3 $md0
> +
> +# re-add and recovery
> +mdadm $md0 -a $dev2
> +check recovery
> +
> +mdadm -S $md0
> +

Since you added the test, would you be able to issue a PR on github
to get the tests running?

Thansk,
Blazej
