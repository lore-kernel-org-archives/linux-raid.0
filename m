Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 921EDC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  8 Jun 2022 09:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbiFHJo5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Jun 2022 05:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbiFHJoh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Jun 2022 05:44:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81DF01C2D60
        for <linux-raid@vger.kernel.org>; Wed,  8 Jun 2022 02:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654679477; x=1686215477;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/TH7p17HcvNBeailiAtRznqw6viJHG5VyyYPI6sZd70=;
  b=WXzqhWRjk4mEDiTNK9WVd1VySu0f7rwU5iGeLhKKDe28fiH5pJrUv0R3
   W2qvpRTc3p/Mrd/p/T9CD8GD64jtiQPiNGDvN98Zygr7eCxQ3W5mkakot
   CCjRCHjXpkOMHDIrQLBbObJRbUu5xbBUTxSZXYSIi0PRtE/vo+iHrlCCZ
   1CM7YW3LEZztAfEa1t7KcYLgAmhKceFYsPfvmvhThN7QQeqgwId9u0nPG
   wNdsaitDWXN8EhzpR8xsCqGYBuFc0CHAa5Agtqkly1Owx8janU0Eicmxi
   PwvRLDi+3EuqVmt1RZ2C/HAW0MZ6ZDjXoakO7LrTm85X8cAHJIEcEKa3X
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="276855729"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="276855729"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 02:11:13 -0700
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="584758583"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.150])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 02:11:12 -0700
Date:   Wed, 8 Jun 2022 11:11:08 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Pavel <pavel2000@areainter.net>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Misbehavior of md-raid RAID on failed NVMe.
Message-ID: <20220608111108.000037c0@linux.intel.com>
In-Reply-To: <8b0c4bf1-a165-95ca-9746-8ef7be46092e@areainter.net>
References: <984f2ca5-2565-025d-62a2-2425b518a01f@ngs.ru>
        <20220608103209.00001d6a@linux.intel.com>
        <8b0c4bf1-a165-95ca-9746-8ef7be46092e@areainter.net>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 8 Jun 2022 15:52:14 +0700
Pavel <pavel2000@areainter.net> wrote:

> 08.06.2022 15:32, Mariusz Tkaczyk =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Hi Pavel,
> > IMO it is not a RAID problem. In this case some part of requests hangs
> > inside nvme driver and raid1d hanged too. It is rather nvme problem not=
 a
> > raid. RAID should handle it well if IO errors are continuously reported.
> >
> > Thanks,
> > Mariusz =20
>=20
> Hi,
>=20
> When we get I/O error on "generic" drive (not NVMe), we get device in=20
> failed state and degraded array.
> For reasons unknown to me, RAID on NVMe behaves in different way.

Because some IO requests are blocked inside nvme driver and RAID engine han=
gs
when it tries to flush next requests.

In "It is rather nvme problem" I meant nvme driver in kernel. Sorry for
confusion.

Thanks,
Mariusz
