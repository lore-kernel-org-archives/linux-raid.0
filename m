Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBEBC6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 12:54:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiINMyQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 08:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiINMyN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 08:54:13 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDED87820E
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663160052; x=1694696052;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F4F4H77jM0TMh5Ui3wWrPVMeahd+U0bbN3zqnt61zdg=;
  b=e7GxXPhhdRwIYDb64Hy0v4l6Q3er2l7ss3t5rRjg2s0hrrm4XvgTMzkz
   lvpTIus7n+Az7pw9NM+dNbyxGBO6xle2a6nuowmonIPL5OonFu/QIVbgy
   UkmtDcliwVFYiQ/GoB5wMw8A4ZxT63U0g9YUNNhqlpinYQRRnAfWC7pEw
   j2ClRW4Nsih1Trz3nUflfW/Pm1rtdl0Q1SegO3lhF+/JGNxYfGoSW4yEr
   IL00HOK+vxXZbKT2kAWnxOghx4/96xiwuoHXJEZlhfqGAf7DLPVM9JqFx
   5tXiZI5aYzK+SFzcBlWRfcy4AFGGoVdo8fDFXXIa1pCZSPoMdXJGAtjif
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10470"; a="384712676"
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="384712676"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 05:54:12 -0700
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="647381113"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.213.25.153])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 05:54:10 -0700
Date:   Wed, 14 Sep 2022 14:54:07 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     =?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@gmail.com>
Cc:     linux-raid@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jes Sorensen <jes@trained-monkey.org>,
        mariusz.tkaczyk@linux.intel.com
Subject: Re: [PATCH v2] mdadm: added support for Intel Alderlake RST on VMD
 platform
Message-ID: <20220914145407.00000d6a@intel.linux.com>
In-Reply-To: <20220831175729.1020-1-oldium.pro@gmail.com>
References: <20220831175729.1020-1-oldium.pro@gmail.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 31 Aug 2022 19:57:29 +0200
Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com> wrote:

> Alderlake RST on VMD uses RstVmdV UEFI variable name, so detect it.
>=20
> Signed-off-by: Old=C5=99ich Jedli=C4=8Dka <oldium.pro@gmail.com>
> ---
>  platform-intel.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>=20

Reviewed-by: Kinga Tanska <kinga.tanska@linux.intel.com>



Looks good to me. I've checked this patch with basic VMD test scope and
I didn't find any defect.

Kinga Tanska

