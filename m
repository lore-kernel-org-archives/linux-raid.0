Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6583C43334
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 14:55:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242197AbiFTOzn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 10:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233752AbiFTOza (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 10:55:30 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E44D583A9
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 07:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655734420; x=1687270420;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QMK/AIkKwQhaAI/xL7VnemxcUJPAohjNPaVvp1ZTSec=;
  b=A7VyKPdy/lEupj40TGGn6yrQnOZC3JfpQ1DxgjeuwBqVtc588YEdDDUh
   sQMa55ToY/qxEwz9iMjyPbmr0nDBHA8OzDKVizDUtCgjypxWsW67bgPLF
   NZWdKuFTMx1+xC46XcODdLHKUGDsCBkf+ArF2jDk6m/Gpysy+YU8xLUOY
   h7dnP6gkTuKJ1fs6rm1eyL0jbjcjp6uhN8k3J/+CM3DW7ILUl1ofwbkL2
   H/JhWtyzHEUpbxySTX1mV0XvaQYsTIkwNQ6z8VZcQlJ56za9Y8WlCRRw5
   bjjTNzzHGMjzBak2bpCXGn5zuSs0+66AJWgvFqzY0/RoQhM1rFQvuDZKI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="305342306"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="305342306"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:13:39 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="591196630"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.65])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 07:13:36 -0700
Date:   Mon, 20 Jun 2022 16:13:33 +0200
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
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v1 03/14] DDF: Fix NULL pointer dereference in
 validate_geometry_ddf()
Message-ID: <20220620161333.00007160@linux.intel.com>
In-Reply-To: <20220609211130.5108-4-logang@deltatee.com>
References: <20220609211130.5108-1-logang@deltatee.com>
        <20220609211130.5108-4-logang@deltatee.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu,  9 Jun 2022 15:11:19 -0600
Logan Gunthorpe <logang@deltatee.com> wrote:

> A relatively recent patch added a call to validate_geometry() in
> Manage_add() that has level=LEVEL_CONTAINER and chunk=NULL.
> 
> This causes some ddf tests to segfault which aborts the test suite.
> 
> To fix this, avoid dereferencing chunk when the level is
> LEVEL_CONTAINER or LEVEL_NONE.
> 
> Fixes: 1f5d54a06df0 ("Manage: Call validate_geometry when adding drive to
> external container") Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>  super-ddf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/super-ddf.c b/super-ddf.c
> index d3c7a4082046..6bd357cf9b82 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -3369,9 +3369,6 @@ static int validate_geometry_ddf(struct supertype *st,
>  	 * If given BVDs, we make an SVD, changing all the GUIDs in the
> process. */
>  
> -	if (*chunk == UnSet)
> -		*chunk = DEFAULT_CHUNK;
> -
>  	if (level == LEVEL_NONE)
>  		level = LEVEL_CONTAINER;
>  	if (level == LEVEL_CONTAINER) {
> @@ -3381,6 +3378,9 @@ static int validate_geometry_ddf(struct supertype *st,
>  						       freesize, verbose);
>  	}
>  
> +	if (*chunk == UnSet)
> +		*chunk = DEFAULT_CHUNK;
> +
>  	if (!dev) {
>  		mdu_array_info_t array = {
>  			.level = level,

Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
