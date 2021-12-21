Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0592C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 21 Dec 2021 13:56:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbhLUN4f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 21 Dec 2021 08:56:35 -0500
Received: from mga18.intel.com ([134.134.136.126]:39214 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235373AbhLUN4f (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 21 Dec 2021 08:56:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640094994; x=1671630994;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EnTKsDqEi8a1JaKIcFsQz6evqhtT7jsBkTnnlEg1ZlQ=;
  b=E4P+vNtGpaxSAqkS0drGuXUB1w+I/iQiJeufb9ZlERa+aIi3qhSNDcup
   pThWLCrc5pkLBwIw5zp8WIyS4M9y38oURsl4v8eJ5FlAL9n2a01gp1h9R
   ALl6hRxSwFUDjKm2SMFSsfYtIfv1DV6HL3LxiUdA+KX9HqQ3zNSbNlLqL
   +urxWOwe5RAjVUOLNbz9q/UFg1J5kiLopbFbeXSqQTRy1L20j7qBy45IV
   J16vvAw94u94KHgjZJE0i7+1+n5cuwvU/p/c/alRwWDlWoQW/5GhAV7+D
   JJk3EdZeklVyayCrL0uq433H2YotuLF3VhzKB2pIiXfh8bz6wZ9JIEn7x
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="227246427"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="227246427"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 05:56:34 -0800
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="521257479"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.10.190])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 05:56:33 -0800
Date:   Tue, 21 Dec 2021 14:56:28 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
Message-ID: <20211221145628.0000144f@linux.intel.com>
In-Reply-To: <CALTww28wmeuXA5V4ReTLjH-=AZ3VbR-qHEbBMEktHRU8PQQiVg@mail.gmail.com>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
        <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
        <CALTww2818H-T5W4oOSG_o_SU1MRAp+_=u9J824V0w1JcX8zZ8Q@mail.gmail.com>
        <20211220094519.000013d0@linux.intel.com>
        <CALTww28wmeuXA5V4ReTLjH-=AZ3VbR-qHEbBMEktHRU8PQQiVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,
On Tue, 21 Dec 2021 09:40:50 +0800
Xiao Ni <xni@redhat.com> wrote:

> Now for a raid0, it can't remove one member disk from raid0. It
> returns EBUSY and the raid0 still can work well. It makes sense.
> Because all member disks are busy, the admin can't remove the member
> disk and mdadm gives a proper error.

EBUSY means that drive is busy but it is not. Just drive cannot be
safety removed. As I wrote in patch 2:

If "faulty" was not set then -EBUSY was returned to
userspace. It causes that mdadm expects -EBUSY if the array
becomes failed. There are some reasons to not consider this mechanism
as correct:
- drive can't be failed for different reasons.
- there are path where -EBUSY is not reported and drive removal leads
to failed array, without notification for userspace.
- in the array failure case -EBUSY seems to be wrong status. Array is
not busy, but removal process cannot proceed safe.

For compatibility reasons i cannot remove EBUSY. I left more detailed
explanation in patch 2.

> With this patch, it changes the situation. In raid0_error, it sets
> MD_BROKEN. In fact, it isn't broken. So is it really good to set
> MD_BROKEN here? In patch 62f7b1989c0 ("md raid0/linear: Mark array as
> 'broken'...), MD_BROKEN is introduced
> when the member disk disappears and the disk is really broken. For
> raid0/linear, the raid device can't work anymore.

It is broken, any md_error() call should end with appropriate action:
- drive removal (if possible)
- failing array (if cannot degrade array)

We cannot trust drive if md_error() was called, so writes will be
blocked. IMO it is reasonable- to not engage level stack, because one
or more members cannot be trusted (even if it is still accessible). Just
allow to read old data (if still possible).
 
Thanks,
Mariusz

