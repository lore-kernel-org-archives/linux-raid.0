Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.55
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233677;
	b=XcPH6Qsyyb+L5mfWdgD5yJWUyU+eVNB+W1hX0BgTfZvyuyzjEMoCCnzeEtqhZT9jr7RO
	 xY5x7wU5zH/zaMV+fYa2ruaF25VT8WRfxDat33/ZMvg8tgwaDwBBNVLmINB4QSsbXxODF
	 2B+l1rbIotC/e2S2tNXWOdZ8VIYPMNyUXff7VizpvuqEGMZnaunAvILCzKhR778VZ9+8P
	 PxF4SPL8scNj6IIvrBJ4u0zQILv5mYt4BgjwXbzxooOlovdPGDBYErJGoUjX4v9gBLwgo
	 PhGfsQyBqxA8+LrjbMFFNOPCPnl882p05Xr4ovax9dC8k3mhBFIVNOEpgzqSKXNhaaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233677;
	h=DMARC-Filter:DKIM-Signature:To:Cc:Message-Id:X-Lms-Return-Path:Date:
	 X-Original-From:Content-Type:From:Subject:Received:User-Agent:
	 Content-Transfer-Encoding:Reply-To:Mime-Version:In-Reply-To:
	 References;
	bh=UrcsvVeftCe2h0jVeUHs33Nz3YoSo2TG8AcMNWNV8dk=;
	b=Q180WY4DKWuX2WjE/vdfAhYUcstmLK20h9HyqQl/zMRq2aBbOjQWAJCWuKhmDG3I6StB
	 FqQy7w077MDynePqWBdYDrwsMqj5OaXsbRNuJ+zyNSrQghF3WcTGlo/U802xwCAly9JgW
	 LosXyHOu6C/yeGY8r8DoFr5Og7purOGsiIvUvZTxjf601oDH42OZCEpETdNZLNzhMcGqk
	 v4dPsQzjD6thHatZflhixosNBSWHc9SB0P06Mj1+f7/nl2R53/s6pmotAyQHk8wBNFS+j
	 aDwgecB4TWT+IYrwbWXETr1P8a1dF1beCGaNy0JSQAtGCaWjiWT8g7k0oTIh9O0PAvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=Fy6iWUnI;
	arc=none smtp.remote-ip=209.127.231.55
Received: from va-2-55.ptr.blmpb.com (va-2-55.ptr.blmpb.com [209.127.231.55])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618B0606A6A9
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 04:01:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 618B0606A6A9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=Fy6iWUnI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795233664;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=UrcsvVeftCe2h0jVeUHs33Nz3YoSo2TG8AcMNWNV8dk=;
 b=Fy6iWUnIEumqBg3C1pK0gOl0/VxPPt7Si4Pp8cTmqTtmaXJj2nm2zZgZnMl5MOjVjJKiGH
 6TVH5k6Mjhb9G4v1LVvf57de95Hr43mzTAkB0pw3mJ4pzdEFScgqY3+WJ+IQZxv6wOLhu2
 d1d5/ppeJiYAuKApahWwa7xVMFEKvQr+42zJPYZqtaSHXHgTZIEdHxoNK4yrj5179Wvwkj
 XaI3b1lKbrVsLAOj1ABx/HhdmtM8IyyzcG4T4g2SGjZojhFV2mMk9IDPanDs+9rONhPbjP
 N03+bBlIerjlrF6PF8GqqDB3rsWFNFinW+inck/L8au2LbJAB3vi6FBwe3NLlw==
To: "Miroslav Cimerman" <mc@raidlab.org>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"NeilBrown" <neil@brown.name>, "Namhyung Kim" <namhyung@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-Id: <6d3ad75f-71a8-4ea8-bbab-3aec886249f1@fygo.io>
X-Lms-Return-Path: <lba+26b01177f+0fe80b+vger.kernel.org+yukuai@fygo.io>
Date: Sat, 21 Nov 2026 12:00:58 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: fix wrong read data on RAID-4/5 with two failed devices
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Sat, 21 Nov 2026 04:01:02 +0000
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
In-Reply-To: <20261115123817.48388-1-mc@raidlab.org>
References: <20261115123817.48388-1-mc@raidlab.org>

=E5=9C=A8 2026/11/15 20:38, Miroslav Cimerman =E5=86=99=E9=81=93:

> On RAID-4/5, a read of a block on a working member can return wrong
> data, without reading the member, when the stripe has two failed
> devices: the array has failed (MD_BROKEN only stops writes), or it is
> degraded and another member has a bad block in the stripe, for
> example after a write to it failed.
>
> fetch_block() computes two missing blocks at once when all but two
> blocks of the stripe are up to date and two devices have failed. That
> needs P and Q, but nothing limits the branch to RAID-6. On RAID-4/5,
> ops_run_compute5() computes sh->ops.target as the XOR of all the other
> blocks, including the second target, which was never read, and
> ops_complete_compute() marks both targets up to date. The read returns
> the XOR of the cached blocks and the unread page, and a later read of
> the second target returns that page instead of an error. The page is
> not cleared, so it can hold data of another block.
>
> Commit 93b3dbce6456 ("md/raid5: unite fetch_block5 and fetch_block6")
> brought the branch to RAID-4/5. fetch_block5() computed only one block.
>
> Take the branch on RAID-6 only, with the sh->qd_idx >=3D 0 test that the
> branch above already uses. On RAID-4/5 the block is then read from its
> member, and reads of failed members are failed by
> handle_failed_stripe() as before.
>
> For example, take a degraded 4-device RAID-5 (left-symmetric, 4 KiB
> chunks, device 1 missing) where block v holds the byte 0x10 + v. A
> write to block 3, on device 3, does a read-modify-write. Its write to
> device 3 fails: md records a bad block, keeps the device and fails the
> write. A read of block 4, on device 0, then returns 0x14 ^ 0x15 ^ the
> unread page (0x01 if it is zero) instead of 0x14, and a read of block
> 5 returns the unread page instead of EIO.
>
> Found with FuzzyRAID, a fault-injection tester for RAID.
>
> Fixes: 93b3dbce6456 ("md/raid5: unite fetch_block5 and fetch_block6")
> Cc:stable@vger.kernel.org
> Signed-off-by: Miroslav Cimerman<mc@raidlab.org>
> ---
> FuzzyRAID is not public yet. The analysis, the fix, the commit message
> and the reproducer were written with the help of an LLM. I reviewed
> everything and ran the reproducer on md-7.4 with and without this
> patch.
>
> Reproducer (needs only standard tools):
>
> #!/bin/bash
> # md RAID 5 with two failed devices for a stripe: a read of a block on a
> # working member returns wrong data, without reading the member, when exa=
ctly
> # disks-2 blocks of the stripe are cached.
> # Needs root, mdadm, losetup and GNU coreutils; uses /dev/md99 and 3 loop=
 devices.
> set -e
> D=3D$(mktemp -d)
> for i in 0 2 3; do
>          truncate -s 64M $D/m$i
>          L[i]=3D$(losetup -f --show $D/m$i)
> done
> blk() { head -c 4096 /dev/zero | tr '\0' "\\$(printf %o $1)"; }
> for v in $(seq 0 11); do blk $((0x10 + v)); done > $D/pattern   # block v=
 =3D 0x10+v
> blk 0xaa > $D/aa
>
> # degraded 4-device RAID 5, 4 KiB chunks;
> # stripe 1: block 3 on m3, block 4 on m0, block 5 on m1 (missing), P on m=
2
> mdadm -C /dev/md99 -R -l5 -n4 -c4 --assume-clean --bitmap=3Dnone \
>          ${L[0]} missing ${L[2]} ${L[3]}
> dd if=3D$D/pattern of=3D/dev/md99 bs=3D48k oflag=3Ddirect status=3Dnone
> mdadm -S /dev/md99                              # empty the stripe cache
> mdadm -A -R /dev/md99 ${L[0]} ${L[2]} ${L[3]}
>
> # read-modify-write of block 3: caches block 3 and P only
> dd if=3D$D/aa of=3D/dev/md99 bs=3D4k seek=3D3 oflag=3Ddirect status=3Dnon=
e
> # second failure; md fails m3 and returns EBUSY, the array has failed
> echo faulty >/sys/block/md99/md/dev-${L[3]#/dev/}/state 2>/dev/null || tr=
ue
>
> rd() { dd if=3D/dev/md99 bs=3D4k skip=3D$1 count=3D1 iflag=3Ddirect statu=
s=3Dnone | od -An -tx1 -N1 | tr -d " "; }
> echo "block 4 (m0, working), expected 14: $(rd 4)"
> echo "block 5 (m1, missing), expected I/O error: $(rd 5 2>&1)"
>
> mdadm -S /dev/md99
> for i in 0 2 3; do losetup -d ${L[i]}; rm $D/m$i; done
> rm $D/pattern $D/aa; rmdir $D
>
>   drivers/md/raid5.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
Applied

--=20
Thanks,
Kuai
