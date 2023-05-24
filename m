Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E56AC77B73
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 09:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240108AbjEXJJ5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 05:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240560AbjEXJJq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 05:09:46 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2988497
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 02:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684919386; x=1716455386;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HKk1Pmw7xAum1nqjBzAxWwSxHXgF2riRw42q4Uz22tE=;
  b=fqZ8grNUHFLT2xUx5RmIh8OwCDOjaOtJltUcUlbdL1Nga2HB6nxo0w0D
   1x5KoQm3vvaDzsfm7jNjKAH0TPYfAOepKgVC/20WqxGLzeVmrcSCeneUW
   SbK1Gn3PFMbgYXl+j8tG4HNqgn3zBz3l3hWz6VQlDH766wsmzBfmcoxYv
   baR5k3to/ZVtd2piG7X3e0FQ/eLxBK2b2NhuZlYJ2GEPyLZeIFGyi6C4R
   ZQ1oYB647+MwXcqnjCtwFn3z8h71i26GHhrkhmemRzdzMGwjHwKtyZHH6
   R4WPGtGLVl/VhY6J+W5nb0q4GAOVM3me72Om8EBYUTa2MuoaCjL/GutBj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="352352283"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="352352283"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 02:09:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="735118729"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="735118729"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.129.144])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 02:09:43 -0700
Date:   Wed, 24 May 2023 11:09:38 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH tests 5/5] tests: add a regression test for raid456
 deadlock
Message-ID: <20230524110938.00005999@linux.intel.com>
In-Reply-To: <20230523133900.3149123-6-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
        <20230523133900.3149123-6-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 23 May 2023 21:39:00 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> The deadlock is described in [1], as the last patch described, it's
> fixed first by [2], however this fix will be reverted and the deadlock
> is supposed to be fixed by [3].
> 
> [1]
> https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
> [2]
> https://lore.kernel.org/linux-raid/20220621031129.24778-1-guoqing.jiang@linux.dev/
> [3]
> https://lore.kernel.org/linux-raid/20230322064122.2384589-5-yukuai1@huaweicloud.com/
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  tests/24raid456deadlock | 56 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 56 insertions(+)
>  create mode 100644 tests/24raid456deadlock
> 
> diff --git a/tests/24raid456deadlock b/tests/24raid456deadlock
> new file mode 100644
> index 00000000..161c3ab8
> --- /dev/null
> +++ b/tests/24raid456deadlock
> @@ -0,0 +1,56 @@
> +devs="$dev0 $dev1 $dev2 $dev3 $dev4 $dev5"
> +runtime=120
> +pid=""
> +old=`cat /proc/sys/vm/dirty_background_ratio`
> +
> +test_write_action()
> +{
> +	while true; do
> +		echo check > /sys/block/md0/md/sync_action &> /dev/null
> +		sleep 0.1
> +		echo idle > /sys/block/md0/md/sync_action &> /dev/null
> +	done
> +}
> +
> +test_write_back()
> +{
> +	fio -filename=$md0 -bs=4k -rw=write -numjobs=1 -name=test \
> +		-time_based -runtime=$runtime &> /dev/null
> +}
> +
> +set_up_test()
> +{
> +	fio -h &> /dev/null || die "fio not found"
> +
> +	# create a simple raid6
> +	mdadm -Cv -R -n 6 -l6 $md0 $devs --assume-clean || die "create raid6
> failed" +
> +	# trigger dirty pages write back
> +	echo 0 > /proc/sys/vm/dirty_background_ratio
> +}
> +
> +clean_up_test()
> +{
> +	echo $old > /proc/sys/vm/dirty_background_ratio
> +
> +	kill -9 $pid
> +	sync $md0
> +
> +	if ! mdadm -S $md0; then
> +		die "can't stop array, deadlock is probably triggered"
> +	fi

Stop is problematic, I described why in previous patch.
You can clean up array manually by ( I think you should to limit complexity):

echo inactive > /sys/block/mdX/md/array_state
echo clear > /sys/block/mdX/md/array_state

Probably, one of those actions will hang right? The question is how we can
catch it.
I'm fine with current approach too:

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz

