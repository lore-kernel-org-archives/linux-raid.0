Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792897307;
	b=Y+3pyt2OTvDavc2LxMAiuP9wLSs0RoTirjhgtK3hmTUyVtj/2i6VnLjldY4WpGT33Z1k
	 5gslkj0VTXHSg4JhAJ1St3+gLEcbwcsE9BzmbEzr+ykzYTs2UA+x5kdNq9YBGL6NPbsU0
	 xsk3LtSzVA+8KsfqmvHNj5U5rkKzfCQ8Y5dp25dOFuBOckZBhtYZOkKzx2F3gAFMfBYHd
	 SyjVWzhTYp6a28zy/n6Rn0zWFpUNYWK1QyscM4Jnc5CErFBPXcU25XxQ1OtoDVUuW+o3K
	 ghDeLl0gmQ7eDolJEO4uI+SLE751LboFf0jUcPRs45VHiv9IGuIRu9sROZDYf3kChpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792897307;
	h=DMARC-Filter:DKIM-Signature:To:Received:Content-Transfer-Encoding:
	 Reply-To:Mime-Version:Cc:Date:References:X-Original-From:Content-Type:
	 User-Agent:From:Message-Id:X-Lms-Return-Path:In-Reply-To:Subject;
	bh=f6PX6afc5p7U4VK9oQ6kAEfAgV5x1//StyaUivK4W0A=;
	b=Hb4fJLUGtp2hlqIkS4JGzYDtpxEsH567mB87wUiPr5MFhmlmW8bOPnPHoZflVglHP/NU
	 AHL0KnAtzkXBnHneCa1vSt6JhztNQkAFTLtO5e2NO7rfIsbm/iCGvaWP5kxK/7r+GcHmN
	 lfeii4ztlzWSyd/z7Tnxu6z4F6xSpFEHqQ/ZOiSoFgkSUljKf04k5WR/6ci+LR+Jy/Orv
	 D9XTkakiyFf32/JYCvxgJXK/mBjGIpL7xZu6R8/cjVOgOsV2l9OaPWSqnNQj11CS1NBFD
	 Ju7Qs3WUJp3Dytl1bUU90CAIZHEjpf9mJmGqJhdZCuF6BaZiLLofwZHDpHbhtcjMGnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=VPXcQ9Kf;
	arc=none smtp.remote-ip=209.127.231.45
Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281D9606A31A
	for <linux-raid@vger.kernel.org>; Sun, 25 Oct 2026 03:01:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 281D9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=VPXcQ9Kf
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1792897301;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=f6PX6afc5p7U4VK9oQ6kAEfAgV5x1//StyaUivK4W0A=;
 b=VPXcQ9Kf0jItOUjNhf2FOomN0jffE/3PadvWlfa0c6Vw1l/HAjV/ThXKyLB/SPHvQQ8rPQ
 ECjEOEjG5Vzjka2+3NXjoo7R1UohcOz+iFbf291wYaHU+ekAvPof5gtvIVCNVRdLZLYjcD
 Pkc9jE0IJKOyl8zybiYx/2kF2hqqz3JbpVf5CzVyH1SRMp4mQF7cOSRng0CGvfsi7U9lzk
 tubCppRW2uT8xJVkuiOEym8Ii8F8C9LZJol85Hn/DF9N+2AlfcpCc6wACV5/XFZvU5qi2e
 QO+aOByCPOtnaRXhKnTHHCTqg/chgiTwJ+0REUKnkdorPBvGd4/lEWlIdFQIdg==
To: "Yu Kuai" <yukuai@kernel.org>, "Jens Axboe" <axboe@kernel.dk>, 
	"yu kuai" <yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Sun, 25 Oct 2026 03:01:39 +0000
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
Cc: <linux-raid@vger.kernel.org>, <linux-block@vger.kernel.org>, 
	"Cao Guanghui" <caoguanghui@kylinos.cn>, 
	"Chandradhar Kumar" <chandradhar.2003@gmail.com>, 
	"Chen Cheng" <chencheng@fnnas.com>, 
	"Jack Wang" <jinpu.wang@cloud.ionos.com>, 
	=?utf-8?q?J=C3=A9r=C3=A9my_Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>, 
	"Li Youhong" <liyouhong@kylinos.cn>, 
	"Martin Wilck" <martin.wilck@suse.com>, 
	"Nguyen Ngoc Thang" <ngocthang2710.1999@gmail.com>, 
	"Peng Fan" <peng.fan@nxp.com>, "Sang-Hoon Choi" <csh0052@gmail.com>, 
	"Yogesh Gaur" <yogeshgaur.83@gmail.com>, 
	"Yuchao Zhang" <ndaugoing@gmail.com>, 
	"Zhihao Cheng" <chengzhihao1@huawei.com>, 
	"Zizhi Wo" <wozizhi@huawei.com>
Date: Sun, 25 Oct 2026 11:01:34 +0800
References: <20261013141241.2257621-1-yukuai@kernel.org>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <c5690a5d-9553-463e-b9f0-617b4d29b011@fygo.io>
X-Lms-Return-Path: <lba+26add7114+9a8226+vger.kernel.org+yukuai@fygo.io>
In-Reply-To: <20261013141241.2257621-1-yukuai@kernel.org>
Subject: Re: [GIT PULL] md-7.4-20261013

Hi Jens

=E5=9C=A8 2026/10/13 22:12, Yu Kuai =E5=86=99=E9=81=93:
> Hi Jens,
>
> Please consider pulling the following changes into your for-7.4/block
> branch.

Looks like this pr is missing for 7.4, should I regenerate it for block-7.4
later?

>
> This pull request contains:
>
> Bug Fixes:
> - Wake RAID10 barrier waiters when a pending-count rollback satisfies
>    an active array freeze. (Zizhi Wo)
> - Reject v0.90 superblocks whose device count cannot fit the metadata
>    format, preventing out-of-bounds access. (J=C3=A9r=C3=A9my Jean)
> - Track RAID5 disk-array allocation size and avoid removing an
>    unregistered CPU hotplug instance on setup or resize failure.
>    (Cao Guanghui)
> - Validate the RAID0 device count before allocating its device list.
>    (Chandradhar Kumar)
> - Validate RAID5 journal payload header, size, and checksum bounds
>    before accessing them. (Martin Wilck)
> - Reject inconsistent RAID5 reshape metadata instead of triggering a
>    kernel BUG. (Yogesh Gaur)
> - Reject invalid RAID4/5 disk counts before setup and invalid reshape
>    disk counts in raid5_run. (Chen Cheng)
> - Fix a NULL-pointer dereference in RAID5 setup error handling.
>    (Zhihao Cheng)
> - Reject RAID5 per-device sizes smaller than one chunk. (Zizhi Wo)
> - Fix mddev_unlock() on an unacquired mutex in lbs_store().
>    (Jack Wang)
> - Give RAID5 io_unit slab caches per-array names to avoid duplicate
>    cache names. (Yogesh Gaur)
> - Validate v1.x bad-block log size when loading superblocks.
>    (Yuchao Zhang)
> - Take reconfig_mutex while enabling PPL on an inactive array to
>    prevent a NULL PPL configuration. (Nguyen Ngoc Thang)
> - Drain released RAID5 stripes before destroying the stripe cache on
>    takeover setup failure. (Li Youhong)
> - Protect RAID5 big_stripe_tree lookup with RCU. (Sang-Hoon Choi)
> - Prevent a NULL mddev->private dereference when stopping an array
>    while I/O is being submitted. (Zhihao Cheng)
> - Don't publish an md array before md_alloc() finishes initializing
>    mddev->kobj. (Yogesh Gaur)
>
> Cleanups:
> - Annotate intentional lockless RAID10 freeze-state accesses.
>    (Zizhi Wo)
> - Add shared RAID write-error and bad-block-sector helpers, and share
>    flush_bio_list between RAID1 and RAID10. (Li Youhong)
> - Extract RAID5 min_raid_disks() helper. (Chen Cheng)
> - Use assign_bit() where applicable in MD/RAID. (Peng Fan)
>
> Thanks,
> Kuai
>
> ---
>
> The following changes since commit 85bffad4d2fea373a72d68bed8012e8cbccb8e=
e7:
>
>    block: simplify disk_zone_set_cond() (2026-09-15 06:53:06 -0600)
>
> are available in the Git repository at:
>
>    https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git tags/=
md-7.4-20261013
>
> for you to fetch changes up to d1472ca2ca5de8ecd2b358411eb14c031404ecf0:
>
>    md: don't hand out the array before md_alloc() has added mddev->kobj (=
2026-10-09 11:52:58 +0800)
>
> ----------------------------------------------------------------
> Cao Guanghui (2):
>        md/raid5: track disks array size to fix extra_page leak on error p=
aths
>        md/raid5: fix NULL pointer dereference in raid5_free_percpu
>
> Chandradhar Kumar (1):
>        md/raid0: validate device count before allocating devlist
>
> Chen Cheng (3):
>        md/raid5: reject raid4/5 arrays with too few disks
>        md/raid5: extract min_raid_disks()
>        md/raid5: reject invalid reshape disks in raid5_run()
>
> Jack Wang (1):
>        md: fix mddev_unlock() called without holding lock in lbs_store()
>
> J=C3=A9r=C3=A9my Jean (1):
>        md: reject v0.90 arrays with too many devices
>
> Li Youhong (4):
>        md: add rdev_record_write_error() helper
>        md/raid1-10: add rdev_bb_block_sectors() helper
>        md/raid1-10: share flush_bio_list between raid1 and raid10
>        md/raid5: drain released_stripes before destroying the cache
>
> Martin Wilck (1):
>        md/raid5: validate payload size before calculating payload_len
>
> Nguyen Ngoc Thang (1):
>        md: take reconfig_mutex when enabling PPL on an inactive array
>
> Peng Fan (1):
>        md/raid: use assign_bit() where applicable
>
> Sang-Hoon Choi (1):
>        md/raid5: protect big_stripe_tree lookup with RCU
>
> Yogesh Gaur (3):
>        md/raid5: don't BUG() on an inconsistent reshape state from the su=
perblock
>        md/raid5: give the io_unit slab caches per-array names
>        md: don't hand out the array before md_alloc() has added mddev->ko=
bj
>
> Yuchao Zhang (1):
>        md: validate bblog_size when loading v1.x badblocks metadata
>
> Zhihao Cheng (2):
>        md/raid5: setup_conf: Fix null-ptr-def in error handling path
>        md: Fix the null-ptr-deref of 'mddev->private' while submitting IO
>
> Zizhi Wo (3):
>        md/raid10: annotate lockless access to array_freeze_pending
>        md/raid10: fix missing wakeup in wait_barrier_nolock
>        md/raid5: reject a per-device size smaller than one chunk
>
>   drivers/md/md.c          |  72 ++++++++++++++++++++++----------
>   drivers/md/md.h          |   7 ++++
>   drivers/md/raid0.c       |  16 ++++---
>   drivers/md/raid1-10.c    |  27 ++++++++++++
>   drivers/md/raid1.c       |  42 +++----------------
>   drivers/md/raid10.c      |  59 ++++++--------------------
>   drivers/md/raid5-cache.c |  54 ++++++++++++++++++------
>   drivers/md/raid5-ppl.c   |  12 +++++-
>   drivers/md/raid5.c       | 106 +++++++++++++++++++++++++++++++++++-----=
-------
>   drivers/md/raid5.h       |   1 +
>   10 files changed, 244 insertions(+), 152 deletions(-)

--=20
Thanks,
Kuai
