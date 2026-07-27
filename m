Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DCD22576E;
	Mon, 27 Jul 2026 02:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785120238; cv=none; b=uMDB1l5cJx7Ed2plg5M92L61vuwoIs2PPJ66Gp7X8NdH1xRUnDpCYjG12S7SEq3X1DpEznBN6ihfA77wzK6vT8HtcGY9D6mL6hMlqMcjO0Tlg9O1zrxnNVNLqCepdDqpSIIDD+dhAKIXxx62ccO0C5tInKVNnqU7ZqY2azTw0Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785120238; c=relaxed/simple;
	bh=FwPD6WK4ZvUUvn6FWSEhS5cnVnWA35y7eRp12AI88Ho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hk5qLE27EaSUoKB0XG5w3EQnTPiW68qJAdpiXuRwEUcu6ZMnK0jRbEB3IqEIcwgtymwhQt4e5jgEYlm7Z1vrsJlZaI3fgv07fZhPSBMSbJCf3OE5FCMVdoQkyL/VebrdSk6zJ6vjGzffOYN5UUyxEP5cCGoFsMSOHTfd6LECHjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wbuf4HYi; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wbuf4HYi"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785120231; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=EWkqU6B9O5H5BOWR7YO5skjnotbUeMUuhmDymxX/AWQ=;
	b=wbuf4HYih+UDbQo52cwlUzQTNrI3LQpSxpk81CwkANONs3FeKIC6JRtZYnaoDnIahFWdtnvbcu5+zfhsb/PZxO0OR8rV+mI9qi9L8QPBGwD253NZsBkIFL8LTZT+ck/EA3Ft2FYP3yEy9ERgG2tJNKJ4L4KNQCkYYD+gJEUI4bg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X7oimWp_1785120229;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X7oimWp_1785120229 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 27 Jul 2026 10:43:50 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: Mykola Marzhan <mykola@meshstor.io>
Cc: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] md/raid10: fix still_degraded being inverted in raid10_sync_request()
Date: Mon, 27 Jul 2026 10:43:47 +0800
Message-Id: <20260727024347.90544-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20260726122512.2176105-1-mykola@meshstor.io>
References: <20260726122512.2176105-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

> I posted the same one-liner on 19 July -- flagging it only so it is not
> applied twice:
>
>   https://lore.kernel.org/linux-raid/20260719144227.940444-2-mykola@meshstor.io/
>
> No objection to yours going in, and I will drop mine if it does:
>
> Reviewed-by: Mykola Marzhan <mykola@meshstor.io>
>
> Identical hunk and the same Fixes: tag.  Mine picked up Reviewed-by from
> Yu Kuai and Paul Menzel on that posting.
> Your changelog is the better of the two: it carries a measured
> reproducer where mine only reasons through the failure.

Thanks, and apologies for the duplication -- I missed your earlier
posting.  Yours was first on the list and already carries tags from
Kuai and Paul, so I am equally happy if the maintainers take your
copy instead.  If mine is picked up, I will carry your Reviewed-by
and a Link: to your posting should a v3 be needed.

> Your patch 3 and patch 2 of my 19 July series hit the same unit mismatch
> -- raid10's recovery cursor is in per-device space while its bitmap is
> indexed by array sectors -- but at different sites, and they do not
> overlap:
>
>   https://lore.kernel.org/linux-raid/20260719144227.940444-3-mykola@meshstor.io/
>
> Yours converts the bitmap-reported span into per-device sectors inside
> raid10_sync_request(); mine stops md_do_sync() handing
> bitmap_ops->skip_sync_blocks() an offset raid10 cannot interpret.  Both
> are still needed.  Yu Kuai has asked me to re-check mine against his
> llbitmap reshape series, so mine is still under discussion.

Agreed.

Your fix addresses the llbitmap mis-skip: md_do_sync() feeds the
per-device recovery cursor to skip_sync_blocks(), which llbitmap
indexes by array sectors, and once it answers for the wrong chunk
md_do_sync() takes "goto update" without ever entering
raid10_sync_request() -- so this has to be fixed at the caller, as
your patch does.

My patch 3 addresses the recovery crawl on a mostly-clean bitmap:
the classic bitmap does not implement skip_sync_blocks() at all, and
with your gate in place raid10 recovery no longer consults the
bitmap from md_do_sync() either way -- the layout-aware bulk skip
inside raid10_sync_request() then serves as raid10's fast path for
both bitmap flavours (it sits on start_sync(), which llbitmap also
implements).

The hunks are disjoint as well -- your series touches the
skip_sync_blocks() gate in md_do_sync() plus md.h/raid1/raid5, mine
touches raid10.c and a cond_resched() ~30 lines below your md.c hunk
-- so they apply cleanly in either order.

So both are needed, whichever order they land in.  I will follow
your discussion with Kuai on the llbitmap reshape series.

Thanks,
Yunye
