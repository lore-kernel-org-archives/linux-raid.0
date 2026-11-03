Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672251;
	b=3QRLY9AuFqEN9CawsevIWJUWMXtUqAGublbe4T26QCIrEBvlmdKAU/mT8dap19ljhkFc
	 GqBP4icv1ZAmekPYVRnJ6loC4gMFTDBjazSc+FSb471xDqzXApkrZFlgPoYq4244DD2oI
	 rmdAOYLcnDLPl2lhq5I9jNpmICZQber1tt6DpOPscwTI6cz2zdZmT3xTcQHVmdgKw1KVL
	 Jb7BT2Pgcb76xMpiHYlSc6My2vzSKuj9N7tWbxqpGl+uPvBBZCREvzWSqre8DMhZ4s3LL
	 yL9z/9ZRc7o0p0ec28nk+L7062sfHxyq3UPT2RWW8xwUfhvBjDjzth6FK0C13UYBrfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672251;
	h=DMARC-Filter:DKIM-Signature:Received:User-Agent:Reply-To:From:
	 Subject:Content-Type:Cc:Date:Message-Id:Mime-Version:
	 Content-Transfer-Encoding:X-Original-From:To:X-Lms-Return-Path:
	 References:In-Reply-To;
	bh=plM1RNTfkzjPFwIcUJoacAEK9nyx06xz7LtG90JphYg=;
	b=aVE3PjC5NjhyQpLyCIMO91lcn2eb9fNKxuytfGUuiRmWu8bTLcQY2Wgsv0FKmGxvFCHL
	 uBqDvIttOEy/MD2ZQvxuzZq5+ANLbFvmdR9jzHnVSkUIh4IBetDJGsXF+gt/bQvonlfPu
	 /WrASSPHkeuYABOr6aY3Ks36yyJPg1pn7L0kxlMRUOFjXYzXsMLshqBHfnmAv6L/vP2Sa
	 3ZS56Yfu0thDOjJTl8UGuXjRlBpbc3PsjBVq7KLkTWbwUV03XfV+p2aIYClZ2Fsd7+2E7
	 93jIBbdX/p/AKEkNajT5AE0+R6Z4mYoEdPMRuqbijjEg8FS3GKWR8N+f0CpAW8Tf1zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=h2SUoI98;
	arc=none smtp.remote-ip=209.127.231.43
Received: from va-2-43.ptr.blmpb.com (va-2-43.ptr.blmpb.com [209.127.231.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82651606A324
	for <linux-raid@vger.kernel.org>; Tue,  3 Nov 2026 02:17:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82651606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=h2SUoI98
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1793672238;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=plM1RNTfkzjPFwIcUJoacAEK9nyx06xz7LtG90JphYg=;
 b=h2SUoI987WKnH5IRglELJn+ZuN+NxEVu+i2CM1uvn8OU1OdZxgvoVIGir4hMWfnmiNBjzZ
 dXslE+7ckVI9R3BU4E4vNgRorenBDuQ8sTNoONdXnctI91Ov2fQMnjMlUJEpB6678FxVWk
 qwqbgmB0uIXchwqLkdFT8xUN24aOlsBSMeYpgTQkcZvjOjQknze4ApfR0tbayAyDuT69k6
 5PXXxwCTakrZs/LHEcvejNHQluuVr1k2n3pMihwR+hftfo0ym4Ngob5qXeE36oXVrtsIgf
 abrF92aiTATU6ocquBmG9mpgh1uWaVBV9JvZXvjG5DKUfoopD5VPE76yoaTsRA==
Received: from [192.168.1.104] ([39.182.0.25]) by smtp.larksuite.com with ESMTPS; Tue, 03 Nov 2026 02:17:16 +0000
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3] md/raid5: use dedicated llist for stripe plug
Content-Type: text/plain; charset=UTF-8
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Li Youhong" <liyouhong@kylinos.cn>, <stable@vger.kernel.org>
Date: Tue, 3 Nov 2026 10:17:13 +0800
Message-Id: <d79b53ed-6ad0-4663-92ce-901f905cddbc@fygo.io>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Li Youhong" <dayou5941@163.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26ae9442d+742937+vger.kernel.org+yukuai@fygo.io>
References: <20261021014009.1206807-1-dayou5941@163.com>
In-Reply-To: <20261021014009.1206807-1-dayou5941@163.com>

=E5=9C=A8 2026/10/21 9:40, Li Youhong =E5=86=99=E9=81=93:

> From: Li Youhong<liyouhong@kylinos.cn>
>
> release_stripe_plug() and do_release_stripe() share sh->lru.
> release_stripe_plug() sets STRIPE_ON_UNPLUG_LIST and
> list_add_tail()s sh->lru onto raid5_plug_cb.list without
> device_lock. do_release_stripe() holds device_lock and, when the
> last reference drops, list_add()s the same lru onto a handle or
> inactive list.
>
> Two list_add()s on one node corrupt it. sh->lru can be
> reinitialized into a self-loop while raid5_plug_cb.list still
> points at that stripe. raid5_unplug() then walks the list under
> device_lock with IRQs disabled and never finishes. Other CPUs
> waiting for the same lock hard-lockup.
>
> Add a dedicated llist_node, unplug_list, to stripe_head, as
> release_list is used for released_stripes.
>
> Fixes: 8811b5968f62 ("raid5: make_request use batch stripe release")
> Suggested-by: Yu Kuai<yukuai@fygo.io>
> Cc:stable@vger.kernel.org
> Signed-off-by: Li Youhong<liyouhong@kylinos.cn>
> ---
> v3:
> - Skip device_lock when llist_del_all() returns NULL. The plug
>    callback can still run with an empty list, and the check avoids
>    an unnecessary spin_lock.
> - v2: link:https://lore.kernel.org/linux-raid/20260922060928.3486799-1-da=
you5941@163.com/
>
> v2:
> - Drop taking device_lock in release_stripe_plug(). Add a dedicated
>    unplug_list.
> - v1: link:https://lore.kernel.org/linux-raid/20260902095307.358569-1-day=
ou5941@163.com/
>
> ---
>   drivers/md/raid5.c | 20 +++++++++++---------
>   drivers/md/raid5.h |  1 +
>   2 files changed, 12 insertions(+), 9 deletions(-)
Applied

--=20
Thanks,
Kuai
