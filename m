Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF14C7EE23
	for <linux-raid@archiver.kernel.org>; Wed, 24 May 2023 08:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbjEXImC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 May 2023 04:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240493AbjEXIlc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 May 2023 04:41:32 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C44110C6
        for <linux-raid@vger.kernel.org>; Wed, 24 May 2023 01:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684917612; x=1716453612;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zlX4YIDAZ8efnEFUx7edTL05F5BT5s4K4zYiyPuHAQI=;
  b=fDsVjImCxDgt75QLH1xdf7SdgIBOCi8UYTVK+ISBNGP+eyn9xSGQQKzn
   qhSeGRUHZ22VslhBKHEGRqqbVfCftP4c8nON2CBFIa4/Zj+uxPSB1APzH
   Qt8MSwkOJN+PpPa2lpSs/5hIiq6kkWKPgakECfnGiwG+W2qGld7JCTlOu
   k0sZN1xUmI/qJdumuWGzSHr9n6n2l6RuTAkzkKZxTu30yQythPXZYL85I
   RF5Ijul2MzAm343LBfXMGSb5rAfLop0uR8L33DR3uu9eKHT816IqRZlM4
   LbPNUNTbO90IR7Yr6ALnl05BmHTMoyQr8uBYUhD8rL7PQEEqSCNQ7lfSK
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="355857886"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="355857886"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:40:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="794099607"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="794099607"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.129.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:40:09 -0700
Date:   Wed, 24 May 2023 10:40:04 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        pmenzel@molgen.mpg.de, logang@deltatee.com, song@kernel.org,
        yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH tests 3/5] tests: support to skip checking dmesg
Message-ID: <20230524104004.000031bf@linux.intel.com>
In-Reply-To: <20230523133900.3149123-4-yukuai1@huaweicloud.com>
References: <20230523133900.3149123-1-yukuai1@huaweicloud.com>
        <20230523133900.3149123-4-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 23 May 2023 21:38:58 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Prepare to add a regression test for raid10 that require error injection
> to trigger error path, and kernel will complain about io error, checking
> dmesg for error log will make it impossible to pass this test.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  test | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/test b/test
> index 61d9ee83..b244453b 100755
> --- a/test
> +++ b/test
> @@ -107,8 +107,12 @@ do_test() {
>  		echo -ne "$_script... "
>  		if ( set -ex ; . $_script ) &> $targetdir/log
>  		then
> -			dmesg | grep -iq "error\|call trace\|segfault" &&
> -				die "dmesg prints errors when testing
> $_basename!"
> +			if [ -f "${_script}.inject_error" ]; then
> +				echo "dmesg checking is skipped because test
> inject error"

Following the convention, I would say that it is a "negative test' or just
'negative/md_negative' so errors are expected.

Why not just add some sort of "negative" to the test name?

Anyway:
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz
