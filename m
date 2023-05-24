Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2296FC7EE23
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 08:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240308AbjEXIsl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 04:48:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240469AbjEXIsi (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 04:48:38 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711DA184
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 01:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684918116; x=1716454116;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8gyKpVk2xV72vFNd0hZbe+6POrbVEVHvovzjsCLFc80=;
  b=XzRWrixHjutP1LIBvjtzc36q/hBmK5ITONRDEQ3nRbJtbyE1m5wEkwYV
   TY55gzQCIDn4qoOS6TX4praUT5Ab/6QCj8DI5YU98cj7njqIdtREolyct
   gRI9jRoSkP1Xk+QdJkSs2LSZhsjjzrL715R/jTvk+UgFdamTT+6wpsODW
   w3Xq4+uio9g0SFtoaKosyVEtMMmHcDwut9UED+G/LiPRIBWh3MHWU2fkT
   mX94vtEHXNfWg5KfDWdB997+YYimYsAm8V9bKmIXGvFnbwwzGj12FgmxW
   /YjczIBZlAP6h29vSR4SHMDnr8svZ0vSg7BjeXSwbrE7In6iogCmYUDzN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="342964290"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="342964290"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:48:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="794103621"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="794103621"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.129.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:48:33 -0700
Date:   Wed, 24 May 2023 10:48:28 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH tests 4/5] tests: add a regression test for raid10
 deadlock
Message-ID: <20230524104828.000070bf@linux.intel.com>
In-Reply-To: <20230523133900.3149123-5-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
        <20230523133900.3149123-5-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 23 May 2023 21:38:59 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> The deadlock is described in [1], it's fixed first by [2], however,
> it turns out this commit will trigger other problems[3], hence this
> commit will be reverted and the deadlock is supposed to be fixed by [1].
> 
> [1]
> https://lore.kernel.org/linux-raid/20230322064122.2384589-5-yukuai1@huaweicloud.com/
> [2]
> https://lore.kernel.org/linux-raid/20220621031129.24778-1-guoqing.jiang@linux.dev/
> [3]
> https://lore.kernel.org/linux-raid/20230322064122.2384589-2-yukuai1@huaweicloud.com/
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  tests/24raid10deadlock              | 85 +++++++++++++++++++++++++++++
>  tests/24raid10deadlock.inject_error |  0
>  2 files changed, 85 insertions(+)
>  create mode 100644 tests/24raid10deadlock
>  create mode 100644 tests/24raid10deadlock.inject_error
> 
> diff --git a/tests/24raid10deadlock b/tests/24raid10deadlock
> new file mode 100644
> index 00000000..27869840
> --- /dev/null
> +++ b/tests/24raid10deadlock
> @@ -0,0 +1,85 @@
> +devs="$dev0 $dev1 $dev2 $dev3"
> +runtime=120
> +pid=""
> +
> +set_up_injection()
> +{
> +	echo -1 > /sys/kernel/debug/fail_make_request/times
> +	echo 1 > /sys/kernel/debug/fail_make_request/probability
> +	echo 0 > /sys/kernel/debug/fail_make_request/verbose
> +	echo 1 > /sys/block/${1##*/}/make-it-fail
> +}
> +
> +clean_up_injection()
> +{
> +	echo 0 > /sys/block/${1##*/}/make-it-fail
> +	echo 0 > /sys/kernel/debug/fail_make_request/times
> +	echo 0 > /sys/kernel/debug/fail_make_request/probability
> +	echo 2 > /sys/kernel/debug/fail_make_request/verbose
> +}
> +
> +test_rdev()
> +{
> +	while true; do
> +		mdadm -f $md0 $1 &> /dev/null
> +		mdadm -r $md0 $1 &> /dev/null
> +		mdadm --zero-superblock $1 &> /dev/null
> +		mdadm -a $md0 $1 &> /dev/null
> +		sleep $2
> +	done
> +}
> +
> +test_write_action()
> +{
> +	while true; do
> +		echo frozen > /sys/block/md0/md/sync_action
> +		echo idle > /sys/block/md0/md/sync_action
> +		sleep 0.1
> +	done
> +}
> +
> +set_up_test()
> +{
> +	fio -h &> /dev/null || die "fio not found"
> +
> +	# create a simple raid10
> +	mdadm -Cv -R -n 4 -l10 $md0 $devs || die "create raid10 failed"
> +}
> +
> +clean_up_test()
> +{
> +	clean_up_injection $dev0
> +	kill -9 $pid
> +	pkill -9 fio
> +
> +	sleep 1
> +
> +	if ! mdadm -S $md0; then
> +		die "can't stop array, deadlock is probably triggered"
> +	fi

stop may fail from different reasons I see it as too big to be marker of
"deadlock". I know that --stop still fails because md is unable to clear sysfs
attrs in expected time (or a least it was a problem few years ago). Is there a
better way to check that? I would prefer, different less complicated action to
exclude false positives.

In my IMSM environment I still see that md stop stress test is failing
sporadically (1/100).

Thanks,
Mariusz
