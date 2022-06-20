Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA0ACCA480
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 15:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242303AbiFTPE0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 11:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242893AbiFTPDf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 11:03:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8DC13DCB
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 07:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655735762; x=1687271762;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zbm9fw54fBFC4ZIoGzRYWjZcxRvUwfgr62pl+KPzzgs=;
  b=kd0nY1Bya/8dx5FR/VzlF+MZZGcW7mYM6PutBN+jMWwPTZTBwHIt9rB7
   Cf5Sx7tVMZnTWQonncAkRI6URkkFBSHp9KElwrYhnVNPRxfNE2Sc/AKz+
   PhTbLE59SNPz8lXGUyUcqn4h+UkF/CkM6sprtkptR8zMDRYCPw/KzMPlT
   fdRWLRaLERL2frTC0paDknOhC59hm27jX+m19mmaz4PoOON/1IgMqzM0v
   6u69gua4YpaOOy+GsBUn3T6/wt+drOCKVaQ/Wc1Nz8PDXtHts2M38TyCx
   ilrcglb0bFiyT/F+E6sPT5HATX2h6fpbGpIo1dmYh6TIrR7PUQMJN9Mdf
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="305346940"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="305346940"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:36:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="591203601"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.65])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:35:59 -0700
Date:   Mon, 20 Jun 2022 16:35:55 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Donald Buczek <buczek@molgen.mpg.de>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Wu Guanghao <wuguanghao3@huawei.com>
Subject: Re: [PATCH mdadm v1 06/14] mdadm: Fix mdadm -r remove option
 regresision
Message-ID: <20220620163555.00005d74@linux.intel.com>
In-Reply-To: <20220609211130.5108-7-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
        <20220609211130.5108-7-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu,  9 Jun 2022 15:11:22 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> The commit noted below globally adds a parameter to the -r option but missed
> the fact that -r is used for another purpose: --remove.
> 
> After that commit, a command such as:
> 
>   mdadm /dev/md0 -r /dev/loop0
> 
> will do nothing seeing the device parameter will be consumed as a
> argument to the -r option; thus, there will only be one device
> seen one the command line, devs_found will only be 1 and nothing will
> happen.
> 
> This caused the 01r5integ and 01raid6integ tests to hang indefinitely
> as mdadm did not remove the failed device. With the device not removed,
> it would not be readded. Then the loop waiting for the array status to
> change would loop forever.
> 
> To fix this, revert the changes in the noted patch and create a new subopt
> type for the monitor mode with parameters required for -r.
> 
> Fixes: 546047688e1c ("mdadm: fix coredump of mdadm --monitor -r")
> Cc: Wu Guanghao <wuguanghao3@huawei.com>
> Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---


>  ReadMe.c | 7 ++++---
>  mdadm.c  | 1 +
>  mdadm.h  | 1 +
>  3 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/ReadMe.c b/ReadMe.c
> index 8f873c4895da..556104f75d72 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -81,11 +81,12 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE
> EXTRAVERSION "\n";
>   *     found, it is started.
>   */
>  
> -char
> short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
> +char
> short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k";
> +char
> short_monitor_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
> char short_bitmap_options[]=
> -
> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
> +
> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:"; char
> short_bitmap_auto_options[]=
> -
> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
> +
> "-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:"; 
>  struct option long_options[] = {
>      {"manage",    0, 0, ManageOpt},
> diff --git a/mdadm.c b/mdadm.c
> index be40686cf91b..d0c5e6def901 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -227,6 +227,7 @@ int main(int argc, char *argv[])
>  			shortopt = short_bitmap_auto_options;
>  			break;
>  		case 'F': newmode = MONITOR;
> +			shortopt = short_monitor_options;
>  			break;
>  		case 'G': newmode = GROW;
>  			shortopt = short_bitmap_options;
> diff --git a/mdadm.h b/mdadm.h
> index 09915a0009d9..559da3f6f440 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -419,6 +419,7 @@ enum mode {
>  };
>  
>  extern char short_options[];
> +extern char short_monitor_options[];
>  extern char short_bitmap_options[];
>  extern char short_bitmap_auto_options[];
>  extern struct option long_options[];

Jes applied Nigel's revert but I cannot see it on repository yet.
I consider adding short monitor options as valuable.
Could you apply revert manually and then adopt your patch?
https://lore.kernel.org/linux-raid/5f9a4417-d044-a87e-3945-2c6b29278d8c@trained-monkey.org/#t

Thanks,
Mariusz
