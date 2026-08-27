Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEE837C93E
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 02:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787799241; cv=none; b=rb6jLXqnZ1hMgh9AYyCEf0ax+3Oc/kpC19ZRyYaz9NSOnO2jB4b/O8jPoC0mWKMMr5nGq43PM/zYL3kikLpiiIE3EMeLP7oxsLEcFaECCo+yG4Ez7XhRg465k2TpxQCDn0IifdfRBrt35sdx/5ovuEJMc9MaWuRsOpzDgoIEX30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787799241; c=relaxed/simple;
	bh=NfjkJmaoR57E5FCFjrssvvfrzjbeiJ2O7/Fi5THEl7M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=PQdscQ6eyTn8u27EpN6Jga3sHM3oYL9qRHV86Udpboc8Mc7y6o2Es9kXrAI9u2B4wuUMVk0V7Q2oVzKTtJn66UNaiU1AmH600IjPBZkT7IhlNnc9KuC+pSuAjokIBX/M4s2YHdbRjtnJagWKlQsYIHCZthkvVXMFnNNA3MWTkMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T1wD+zcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T1wD+zcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF0E21F00A3D;
	Thu, 27 Aug 2026 02:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787799240;
	bh=3MAH65blbPZejzpgMZVkHCzvDRsXO8X7E9SsQ6BYOaE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T1wD+zcU3HkLR/SoJ4C+HSXVp9U33QdIgj5CniQyphZ1FD7N+PoNX22RN3PGZqls9
	 46PGCe34UAS4FFgE6mNZQYxDwvsK53uPcbgAT6l0TqO7CKEmAzIHjTDlYzGdW22AqI
	 hWQgTizVbsH13uEasn8MAMvGPlIDTmBLo9VR95wa3Fa3L+S2p3aEJ91NVmarWP/YYX
	 0XyAj5dBknhkjoOL/Ukwas3pT3tdXzzCvjTgQWmyOuK33q4PpE2sCMVHxOttkgbiBJ
	 FFxz4CnFAFAbrcVMhupRYNWNvipoGyPdahxEnhXAQN3te4Yl9qBI0NbcCEwNhGOJVv
	 91cWQ9NYwfCvw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid5: set pool_size before extra_page allocation to
 fix leak on error path
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260827023803.36602-1-ghuicao@163.com>
References: <20260827023803.36602-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 02:53:59 +0000
Message-Id: <20260827025359.EF0E21F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Memory leak of extra_page and stripe pages during raid5 reshape er=
ror path.
- [High] Kernel panic due to NULL pointer dereference in `raid5_free_percpu=
()` when handling hotplug callback allocation failures.
--

commit e2a9b5ec799de7e8af41dc93ccf252fa2539b0d8
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md/raid5: set pool_size before extra_page allocation to fix leak on error p=
ath

Sets conf->pool_size right after the conf->disks array is allocated in
setup_conf(). This ensures that if subsequent initialization fails and
jumps to the abort label, free_conf() uses the correct pool size to clean
up the allocated extra_page entries, preventing a memory leak.

Cc: stable@vger.kernel.org

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index b91545ce090de..4efaef622fc05 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7733,6 +7733,7 @@ static struct r5conf *setup_conf(struct mddev *mdde=
v)
> =20
>  	if (!conf->disks)
>  		goto abort;
> +	conf->pool_size =3D max_disks;
> =20
>  	for (i =3D 0; i < max_disks; i++) {
>  		conf->disks[i].extra_page =3D alloc_page(GFP_KERNEL);

[Severity: High]
This isn't a bug introduced by this patch, but it exists in the surrounding
reshape logic. Does this same stale conf->pool_size issue leak memory in
resize_stripes()?

If alloc_page(GFP_NOIO) fails in step 4 of resize_stripes(), the function
returns -ENOMEM but fails to update conf->pool_size because it is gated by
if (!err).

However, conf->disks was already permanently replaced in step 3, and new
pages were already allocated for the newly added slots:

drivers/md/raid5.c:resize_stripes()
		} else {
			kfree(conf->disks);
			conf->disks =3D ndisks;
		}

Later in the function:
				if (!p)
					err =3D -ENOMEM;
			}

	if (!err)
		conf->pool_size =3D newsize;
	mutex_unlock(&conf->cache_size_mutex);

	return err;

Because conf->pool_size is not updated on error, subsequent teardown paths
like free_conf() and shrink_stripes() will use the old boundary and fail to
free the memory allocated for the new slots. Could this exhaust kernel
memory over multiple failed reshape attempts?

[Severity: High]
This is a pre-existing issue on the setup_conf() error path, but could
the abort path trigger a kernel panic due to a null pointer dereference
in raid5_free_percpu()?

If cpuhp_state_add_instance() fails in raid5_alloc_percpu(), the function
returns the error without cleaning up conf->percpu:

drivers/md/raid5.c:raid5_alloc_percpu()
	err =3D cpuhp_state_add_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
	if (!err) {

When setup_conf() receives the error and jumps to the abort label, free_con=
f()
calls raid5_free_percpu(). Because conf->percpu is not null, it incorrectly
assumes the hotplug node was hashed:

drivers/md/raid5.c:raid5_free_percpu()
	if (!conf->percpu)
		return;

	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);

Since the node was never actually added, hlist_del() in the hotplug state
removal blindly unlinks the node, dereferencing node->pprev which is null:

kernel/cpu.c:__cpuhp_state_remove_instance()
remove:
	hlist_del(node);

Can this crash the kernel during raid array initialization or hotplug events
if memory allocation fails in the hotplug subsystem?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827023803.3660=
2-1-ghuicao@163.com?part=3D1
