Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221D867E92
	for <linux-raid@vger.kernel.org>; Fri, 12 Jan 2024 11:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RzeAQ5S9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705059882; x=1736595882;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=89tGMXLp/ByoMzC2kVqSYERv6+Y8jACyPFuCOTBfWL4=;
  b=RzeAQ5S9s27Jn5E1JbTRq/eGhV+jEeu9Y2tRNO8xlByozqnaxIddqH7N
   XrhqwTgcpfJAwWQ3Vl3gYukdlNpoM8e0JTCv5yfXKhiyQ9OfRFoTfmFna
   FrNvHCpRsxLClKXpDL+NUPpvUthM0FOS7y3b4QuqWBBNf0FiLkuZ+7y00
   v5plPkWZp2LbxFJiwMEn6JfZYMxf/nUU7obF/bZvC747DhkArMEgI6UAT
   Mz3HwD1E7Gt0ALsZDSZgHVYiKQ0cx9NM/HzPad7Y9zgwlpzqF6W9RQx6y
   ODJYLv071/5iDbWBZlMcf4KlKSvXlj+Z50+rRm2zKAuCPjywZFPB20KHA
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="396294673"
X-IronPort-AV: E=Sophos;i="6.04,189,1695711600"; 
   d="scan'208";a="396294673"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2024 03:44:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="786315069"
X-IronPort-AV: E=Sophos;i="6.04,189,1695711600"; 
   d="scan'208";a="786315069"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.93])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2024 03:44:39 -0800
Date: Fri, 12 Jan 2024 12:44:34 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH] mdadm: stop using 'idle' for sysfs api "sync_action" to
 wake up sync_thread
Message-ID: <20240112124434.00005e3c@linux.intel.com>
In-Reply-To: <20240111120505.4135257-1-yukuai1@huaweicloud.com>
References: <20240111120505.4135257-1-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Jan 2024 20:05:05 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
>=20
> Echo 'idle' to "sync_action" is supposed to stop sync_thread while new
> sync_thread can still start. However, currently this behaviour is not
> correct, echo 'idle' will actually try to stop sync_thread and then
> start a new sync_thread. And mdadm relies on this wrong behaviour in
> some places.
>=20
> In kernel, if resync is not done yet, then recovery/reshape/check/repair
> can't not start in the first place, and if resync is done, echo 'resync'
> behaves the same as echo 'idle' for now.

Hi Kuai,
=46rom the last part I understand that in case of resync/reshape frozen threa=
d is
unblocked, not restarted.

I miss some explanation about that here. So far I understand is:

"Setting "resync" or "reshape" allow to continue frozen sync_thread instead
restarting it. Setting "resync" if resync is done, has same effect as "idle=
" so
it is safe."

Please describe setting "reshape", I can see that you use it in one place, I
think that with reshape we need to be more careful but you are the expert h=
ere,
maybe it is same as "resync"?

>=20
> Hence replace echo 'idle' with echo 'resync/reshape' when trying to
> continue frozed sync_thread. There should be no functional changes and
> prevent regressions after fixing that echo 'idle' will start new
> sync_thread in kernel.

Ok, so this is kind of preparing for kernel fix. Got it.
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---

I think that I understand purpose of the change. You are trying to avoid th=
read
restarting if not needed and remove reference to incorrect "idle" usage of
mdadm.
Unfortunately, the changes you need to make have strong reference to kernel
implementation. It requires to well describe them because blame is volatile.

I would like to propose separate enum to not rely on kernel states naming, =
some
proposals:

/* So far I understand write "resync" for both cases */
SYNC_ACTION_RESYNC_START
SYNC_ACTION_RESYNC_CONTINUE

/* So far I understand write "reshape" for both cases *
SYNC_ACTION_RESHAPE_START
SYNC_ACTION_RESHAPE_CONTINUE

/* Highlight known bug in comment and use "resync"? /*
SYNC_ACTION_IDLE
/* If needed? */
SYNC_ACTION_ABORT

It needs to be handled by proper function which will have comments describi=
ng
what is written to kernel and why. In userspace, I need more user/reader
friendly code.
I want to know what we exactly requested from kernel. In some cases we would
expect to restart thread is some other cases just to continue frozen one. I
would like to know what was a purpose of request in the particular case eve=
n if
now the same action is used behind.

Let me know what you think.

Thanks,
Mariusz
