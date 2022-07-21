Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6C20C43334
	for <linux-raid@archiver.kernel.org>; Thu, 21 Jul 2022 08:19:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiGUITP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Jul 2022 04:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiGUITP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Jul 2022 04:19:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EE45E815
        for <linux-raid@vger.kernel.org>; Thu, 21 Jul 2022 01:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658391553; x=1689927553;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WjEdT4vvJq7p72Mlx/J31tBXJ3SPG3TTQzWCsjT613k=;
  b=Szr3mjLNiB6IA7shMAslVPobE1AzzKcGhhdEaIKn0G/nPTsWx06JdU08
   6a/Ring/Y95jk5u6x67nqdNJRuckGwvp4eH+wGpxuN+LzpZsoFRMbIRMc
   e9bDNtuAsG1Z/dBeXjYyFFro9dpaU1iRAKAzAyVHy5awe+A1ae2/eF3Th
   7iOvLaQdS9E/Cxyj0mv0guaE2Fv1ucV/AM/rd2+c+fc+Gdw1IAJntVKfo
   E+kNtlpMhV1ZVuiYvQl3KPhNhcBhvWzpKn6UqGoCyLPimH+uBPzF7Ll+S
   E/zVOKQqFglhfDnO8Zv+qsPb5qvpzsZC14d4szfQoySzIsQdfU0CCqbEj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10414"; a="284541123"
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="284541123"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 01:19:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,289,1650956400"; 
   d="scan'208";a="656640128"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.43.182])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2022 01:19:11 -0700
Date:   Thu, 21 Jul 2022 10:19:07 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     "NeilBrown" <neilb@suse.de>
Cc:     "Paul Menzel" <pmenzel@molgen.mpg.de>,
        "Jes Sorensen" <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH mdadm v2] super1: report truncated device
Message-ID: <20220721101907.00002fee@linux.intel.com>
In-Reply-To: <165768409124.25184.3270769367375387242@noble.neil.brown.name>
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>
        <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
        <165768409124.25184.3270769367375387242@noble.neil.brown.name>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Neil,

On Wed, 13 Jul 2022 13:48:11 +1000
"NeilBrown" <neilb@suse.de> wrote:

> When the metadata is at the start of the device, it is possible that it
> describes a device large than the one it is actually stored on.  When
> this happens, report it loudly in --examine.
> 
> ....
>    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
>           State : clean TRUNCATED DEVICE
> ....

State : clean TRUNCATED DEVICE is enough. "DEVICE TOO SMALL" seems to be
redundant.
> 
> Also report in --assemble so that the failure which the kernel will
> report will be explained.

Understand but you've added it in load_super1() so it affects all load_super()
calls, is it indented? I assume yes but please confirm. 
> 
> mdadm: Device /dev/sdb is not large enough for data described in superblock
> mdadm: no RAID superblock on /dev/sdb
> mdadm: /dev/sdb has no superblock - assembly aborted
> 
> Scenario can be demonstrated as follows:
> 
> mdadm: Note: this array has metadata at the start and
>     may not be suitable as a boot device.  If you plan to
>     store '/boot' on this device please ensure that
>     your boot-loader understands md/v1.x metadata, or use
>     --metadata=0.90
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md/test started.
> mdadm: stopped /dev/md/test
>    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
>           State : clean TRUNCATED DEVICE
>    Unused Space : before=1968 sectors, after=-2047 sectors DEVICE TOO SMALL
>           State : clean TRUNCATED DEVICE
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  super1.c | 34 +++++++++++++++++++++++++++-------
>  1 file changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/super1.c b/super1.c
> index 71af860c0e3e..4d8dba8a5a44 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -406,12 +406,18 @@ static void examine_super1(struct supertype *st, char
> *homehost) 
>  	st->ss->getinfo_super(st, &info, NULL);
>  	if (info.space_after != 1 &&
> -	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET))
> -		printf("   Unused Space : before=%llu sectors, after=%llu
> sectors\n",
> -		       info.space_before, info.space_after);
> -
> -	printf("          State : %s\n",
> -	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean");
> +	    !(__le32_to_cpu(sb->feature_map) & MD_FEATURE_NEW_OFFSET)) {
> +		printf("   Unused Space : before=%llu sectors, ",
> +		       info.space_before);
> +		if (info.space_after < INT64_MAX)
> +			printf("after=%llu sectors\n", info.space_after);
> +		else
> +			printf("after=-%llu sectors DEVICE TOO SMALL\n",
> +			       UINT64_MAX - info.space_after);
As above, for me this else here is not necessary.

> +	}
> +	printf("          State : %s%s\n",
> +	       (__le64_to_cpu(sb->resync_offset)+1)? "active":"clean",
> +	       info.space_after > INT64_MAX ? " TRUNCATED DEVICE" : "");

Could you use standard if instruction to make the code more readable? We are
avoiding ternary operators if possible now.

>  	printf("    Device UUID : ");
>  	for (i=0; i<16; i++) {
>  		if ((i&3)==0 && i != 0)
> @@ -2206,6 +2212,7 @@ static int load_super1(struct supertype *st, int fd,
> char *devname) tst.ss = &super1;
>  		for (tst.minor_version = 0; tst.minor_version <= 2;
>  		     tst.minor_version++) {
> +			tst.ignore_hw_compat = st->ignore_hw_compat;
>  			switch(load_super1(&tst, fd, devname)) {
>  			case 0: super = tst.sb;
>  				if (bestvers == -1 ||
> @@ -2312,7 +2319,6 @@ static int load_super1(struct supertype *st, int fd,
> char *devname) free(super);
>  		return 2;
>  	}
> -	st->sb = super;
>  
>  	bsb = (struct bitmap_super_s *)(((char*)super)+MAX_SB_SIZE);
>  
> @@ -2322,6 +2328,20 @@ static int load_super1(struct supertype *st, int fd,
> char *devname) if (st->data_offset == INVALID_SECTORS)
>  		st->data_offset = __le64_to_cpu(super->data_offset);
>  
> +	if (st->minor_version >= 1 &&
> +	    st->ignore_hw_compat == 0 &&
> +	    (__le64_to_cpu(super->data_offset) +
> +	     __le64_to_cpu(super->size) > dsize ||
> +	     __le64_to_cpu(super->data_offset) +
> +	     __le64_to_cpu(super->data_size) > dsize)) {
> +		if (devname)
> +			pr_err("Device %s is not large enough for data
> described in superblock\n",
> +			       devname);

why not just:
if (__le64_to_cpu(super->data_offset) + __le64_to_cpu(super->data_size) > dsize)
from my understanding, only this check matters.

Thanks,
Mariusz

