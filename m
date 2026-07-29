Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E7E3C1D57
	for <linux-raid@vger.kernel.org>; Wed, 29 Jul 2026 15:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339055; cv=none; b=FMKWH7Iq4Yo6M0UTaOROcNzAPNMDMlcw58S9LZSy75PGnyFO1614tkMjvk4h/d/LfA5JEfH2+wavVq9Px0Unw+8SjtDXhOmUQ76AY6expdXuVESYbpBOQI3eEJnnJU53X2zLWbFg3fs0FjxEmarJFRJxJfdr9KZqvifACj/sMzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339055; c=relaxed/simple;
	bh=wX1zxXelqrRxRtFq86DU43AeEtPMH6+eRAzSHxL4rAw=;
	h=To:Cc:From:Date:Subject:Message-Id:Mime-Version:Content-Type:
	 In-Reply-To:References; b=Ftxx36CFrqXHTDfqcqOfF2CsFDNUFgmSw95jDaisg2Rue08/dYmn03prmYVuY8nh7QzPuL986lNzXR3uZ7qWQ9PV/8mNvc0JOUFIM9p9Sp9DKmPIDdVnSW3Lv0EfgFIZVTJyMXfJboaacn3cQNN8BTQmg/63MWZMKGcQqoPSLXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Y2eC5TU2; arc=none smtp.client-ip=209.127.231.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Y2eC5TU2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785339043;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=CZa7a6QQLUs7oI9vCtc2B0GXGpb5JT4b4ngmR5bJQio=;
 b=Y2eC5TU2rZFPI/x5ANSOA/wVIXXGfXPwbh5QJlYtd8nhOtvWILry0J9kty0jEgYXMTJ8tx
 ByDMeCSOj7rvig98s4bAFhr9Ms3zXnLpxpzn8JjS4N6UBMxE2TJYPqooKmnCit/5aZO+Xc
 XoBaQX8WiaJWTniMTvDEURwlXwOks4JhrgtTTGY75dzQciSdZkVJscxEc68P/rOD40IMAX
 cEaZh+NC83vAj1QMXbGMPu0QLmRL/ztgLiQHCa6yIbtXqErZ/h8L6uIcTVySio3RUHgLUl
 48bFIwv4ruQM+xX2t1w2Krb5bPzUfIUvwT45wmeqrv3g4rrhdTDcLGty6oCjRA==
Reply-To: yukuai@fygo.io
To: "Song Liu" <song@kernel.org>, "yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Wed, 29 Jul 2026 15:30:41 +0000
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Mykola Marzhan" <mykola@meshstor.io>, "Su Yue" <glass.su@suse.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Date: Wed, 29 Jul 2026 23:30:37 +0800
X-Lms-Return-Path: <lba+26a6a1ca2+92b0de+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v3 00/21] md/md-llbitmap: support reshape for RAID10 and RAID5
Message-Id: <d564abf6-dd0c-4d9a-b413-ce75ffd04752@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <cover.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/7/28 16:49, Yu Kuai =E5=86=99=E9=81=93:
> From: Yu Kuai <yukuai@fygo.io>
>
> Hi,
>
> This series adds llbitmap support for online reshape in RAID10 and RAID5.
>
> llbitmap has a different set of constraints from the existing bitmap code=
:
> there is one live bitmap instance, each bit state has richer semantics, a=
nd
> reshape can change the mapping from logical array ranges to bitmap ranges=
.
> The series therefore adds exact bitmap range mapping hooks, tracks old an=
d
> new llbitmap geometry during reshape, remaps checkpointed bits as reshape
> progresses, and wires the reshape lifecycle into RAID10 and RAID5.
>
> The main rules are:
>
> 1. split bios at the reshape position before bitmap accounting, so one bi=
o
>     is never accounted with mixed old/new geometry;
> 2. do not skip reshape ranges from stale llbitmap state, because reshape
>     progress is checkpointed by array metadata;
> 3. remap llbitmap bits when reshape progress is checkpointed;
> 4. reject llbitmap reshape if mddev->chunk_sectors shrinks, because the
>     effective data range represented by existing bitmap bits can shrink.
>
> The first patch fixes RAID5 bitmap stripe rounding before the exact mappi=
ng
> hooks are added, so the later RAID5 helper split starts from correct
> sector_t division semantics. The rest of the series prepares generic bitm=
ap
> and llbitmap infrastructure, wires RAID10, and then wires RAID5 with exac=
t
> old/new stripe mapping.

There are some real problems reported by sashiko review, will send v4 set s=
oon.

>
> Changes since v2:
> - Fix RAID5 bitmap stripe rounding for non-power-of-two stripe widths in
>    patch 1.
> - Fix partial discard chunks being marked unwritten in patch 11.
> - Fix RAID5 writes past component size being skipped by llbitmap accounti=
ng
>    in patch 11.
> - Fix stopped reshape reassembly losing target llbitmap geometry in patch=
 9.
> - Fix the page-cache-grow patch using target-geometry fields before they =
are
>    introduced in patch 7.
>
> Changes since v1:
> - Add Reviewed-by tags from Su Yue.
> - Rename llbitmap_resize_chunks() to llbitmap_calculate_chunks().
> - Use an unsigned index in llbitmap_expand_pages() error cleanup.
> - Rebase on mdraid/md-7.2, including the mddev_bio_split_at_reshape_offse=
t()
>    declaration needed by the RAID5 build reported by kernel test robot.
>
> Yu Kuai (21):
>    md/raid5: round bitmap stripes with sector division
>    md: add exact bitmap mapping and reshape hooks
>    md: skip bitmap accounting for empty write ranges
>    md: add helper to split bios at reshape offset
>    md/md-llbitmap: track bitmap sync_size explicitly
>    md/md-llbitmap: allocate page controls independently
>    md/md-llbitmap: grow the page cache in place for reshape
>    md/md-llbitmap: track target reshape geometry fields
>    md/md-llbitmap: finish reshape geometry
>    md/md-llbitmap: refuse reshape while llbitmap still needs sync
>    md/md-llbitmap: add reshape range mapping helpers
>    md/md-llbitmap: don't skip reshape ranges from bitmap state
>    md/md-llbitmap: remap checkpointed bits as reshape progresses
>    md/md-llbitmap: clamp state-machine walks to tracked bits
>    md/raid10: reject llbitmap reshape when md chunk shrinks
>    md/raid10: wire llbitmap reshape lifecycle
>    md/raid10: split reshape bios before bitmap accounting
>    md/raid5: add exact old and new llbitmap mapping helpers
>    md/raid5: reject llbitmap reshape when md chunk shrinks
>    md/raid5: wire llbitmap reshape lifecycle
>    md/raid5: split reshape bios before bitmap accounting
>
>   drivers/md/md-bitmap.c   |   8 +
>   drivers/md/md-bitmap.h   |   9 +
>   drivers/md/md-llbitmap.c | 659 ++++++++++++++++++++++++++++++++++++---
>   drivers/md/md.c          |  64 +++-
>   drivers/md/md.h          |   8 +
>   drivers/md/raid10.c      |  49 +++
>   drivers/md/raid5.c       | 123 ++++++--
>   7 files changed, 842 insertions(+), 78 deletions(-)
>
>
> base-commit: 55b77337bdd088c77461588e5ec094421b89911b

--=20
Thanks,
Kuai
