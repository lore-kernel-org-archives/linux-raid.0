Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D786CC77B7C
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 07:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239872AbjEXHx1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 03:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240097AbjEXHxY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 03:53:24 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F31B6
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 00:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684914803; x=1716450803;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JZnmIRsJzPeJDDkVJBsrWwVFhR5AS6jFxoDqE9Ktdsk=;
  b=N6+IAZ+xUkdZZj7b8BC9PIKPnxqhLMNPistdNQwxgrWckAaV0XEMg1E1
   kX5hq3lbuA4rc9gT5iGKDe26b6KgztdZXXAPunw5Kxjma7vVbN8XsTJWE
   L23LPyPsdDoQAqakL3RmyOMkCoJfY4IJ8PKZ+K36nnkND0Hutravx4yTT
   QXGgelS7kz1WX4uaAf7+j483D0jVs5Bu50EuCsg7CTymZZz1uaNZBfHRP
   BQ9n+b08feEasB+nmSiN0Vd7xYweax1dxS1JTj2MLPPVyos/J+3G23tUZ
   AM8WVObB+8p4YzUyAoruRgcudY+kxutysV0qPcVzmi6ZnmsX/gkOZbCTr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="419201455"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="419201455"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 00:53:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="828469487"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="828469487"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.129.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 00:53:18 -0700
Date:   Wed, 24 May 2023 09:53:14 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH tests 1/5] tests: add a new test to check if pluged bio
 is unlimited for raid10
Message-ID: <20230524095314.000007f9@linux.intel.com>
In-Reply-To: <20230523133900.3149123-2-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
        <20230523133900.3149123-2-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 23 May 2023 21:38:56 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Pluged bio is unlimited means that all submitted bio will be pluged, and
> those bio won't be issued to underlaying disks until blk_finish_plug() or
> blk_flush_plug(). In this case, a lot memory will be used for
> raid10_bio and io latency will be very bad.
> 
> This test do some dirty pages writeback for raid10, where plug is used, and
> check if device inflight counter exceed threshold.
> 
> This problem is supposed to be fixed by [1].

The test here is for md, mdadm has nothing to do here. I'm not against it
but please extract it to separate directory because like "md_tests".
We need to start grouping tests.
> 
> [1]
> https://lore.kernel.org/linux-raid/20230420112946.2869956-9-yukuai1@huaweicloud.com/
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  tests/22raid10plug | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>  create mode 100644 tests/22raid10plug
> 
> diff --git a/tests/22raid10plug b/tests/22raid10plug
> new file mode 100644
> index 00000000..fde4ce80
> --- /dev/null
> +++ b/tests/22raid10plug
> @@ -0,0 +1,41 @@
> +devs="$dev0 $dev1 $dev2 $dev3 $dev4 $dev5"
> +
> +# test will fail if inflight is observed to be greater
> +threshold=4096
> +
> +# create a simple raid10
> +mdadm --create --run --level=raid10 --raid-disks 6 $md0 $devs
> --bitmap=internal --assume-clean
You don't need 6 drives, 4 is enough (unless I miss something).
 
> +if [ $? -ne 0 ]; then
> +        die "create raid10 failed"
> +fi
> +
> +old_background=`cat /proc/sys/vm/dirty_background_ratio`
> +old=`cat /proc/sys/vm/dirty_ratio`
> +
> +# trigger background writeback
> +echo 0 > /proc/sys/vm/dirty_background_ratio
> +echo 60 > /proc/sys/vm/dirty_ratio
> +
> +# io pressure with buffer write
> +fio -filename=$md0 -ioengine=libaio -rw=write -bs=4k -numjobs=1 -iodepth=128
> -name=test -runtime=10 & +
> +pid=$!
> +
> +sleep 2
> +
> +# check if inflight exceed threshold
> +while true; do
> +        tmp=`cat /sys/block/md0/inflight | awk '{printf("%d\n", $1 + $2);}'`
> +        if [ $tmp -gt $threshold ]; then
> +                die "inflight is greater than 4096"

The message here is not meaningful, what 4096 is? Please add comment describing
why value above 4096 causes an error. We need to understand how the future
changes in md may affect this setting (I think that there is a correlation
between the value and MAX_PLUG_BIO).

> +                break

the break is dead condition because die has `exit` inside.

> +        elif [ $tmp -eq 0 ]; then
> +                break
> +        fi

I would prefer to make verification independent from user
environment and md device inflight state. Simply, we should rely on fio. If
there is a fio in background we should check if inflight doesn't exceeded
expected value. we should finish when fio ends. You set runtime to 10, please
think if we can make this shorter.

Thanks,
Mariusz

> +        sleep 0.1
> +done
> +
> +kill -9 $pid
> +mdadm -S $md0
> +echo $old_background > /proc/sys/vm/dirty_background_ratio
> +echo $old > /proc/sys/vm/dirty_ratio

