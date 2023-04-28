Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B8CDC77B61
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 07:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345485AbjD1HbL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Apr 2023 03:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345434AbjD1HbJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Apr 2023 03:31:09 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DEA40FE
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 00:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682667059; x=1714203059;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q1p3lSRBxOwj9YSRU5p/nNsKxu+AJnTwRkeDUw5tNcs=;
  b=Kq36wosNsoGx8ChwmdbzrWc6LPz9BmZ/DFFSfYzM28rCHIYA0NdI+24B
   E0dqlU1lKDcaq5sbdftQ0QFE09qa94QDqlsezc29IQAf1FybgVHw1wei5
   HOuLYeXd9ZXMtWn/a63NSbQukEhmeWFEBVtPD+SRIKY0Vn5Ji8r8E9I0B
   JnEBzIh/UwVOOWz3/wCk6Qk23jVFfjGAq41ZX2gjENgnY+HLnTTzqy+Vo
   oznnEcGGSbvyX6cu3XIQLx36Svl087S/Pgl1CELX+VihWKshEOtmftfFO
   LODyfsWen20C6cVutOWEW+ZrNhbSQvm3EHbkSbSgKmis7CVn///0tQ/MK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="327296899"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="327296899"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 00:30:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10693"; a="759538586"
X-IronPort-AV: E=Sophos;i="5.99,233,1677571200"; 
   d="scan'208";a="759538586"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.213.10.112])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 00:30:58 -0700
Date:   Fri, 28 Apr 2023 09:30:56 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     Kevin Friedberg <kev.friedberg@gmail.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] enable RAID for SATA under VMD
Message-ID: <20230428093056.00006ca2@intel.linux.com>
In-Reply-To: <20230320093545.000016cc@linux.intel.com>
References: <20230216044134.30581-1-kev.friedberg@gmail.com>
        <CAEJbB426WWdu5KESE1T+T0JHSKx3CGjUcpdZ5yhppsxyXNJDvw@mail.gmail.com>
        <20230320093545.000016cc@linux.intel.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 20 Mar 2023 09:35:45 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> On Mon, 20 Mar 2023 02:26:31 -0400
> Kevin Friedberg <kev.friedberg@gmail.com> wrote:
> 
> > Hi Mariusz,
> > 
> > You mentioned on the previous version of this patch that it might
> > be a while before it could be tested.  Have you had a chance to try
> > this revision?
> 
> Hi Kevin,
> Sorry for that... I totally lost it. That for reminder. We will test
> the change soon.
> 
> Thanks,
> Mariusz

Hi,

We've been able to test this change and we haven't found problems.

Regards,
Kinga
