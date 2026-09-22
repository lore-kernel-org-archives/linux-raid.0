Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811384CB8B7
	for <linux-raid@vger.kernel.org>; Tue, 22 Sep 2026 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790060854; cv=none; b=kHBbhHmKhiSOOVsOY1evdD45rXxd+ZmxPnLQUhOxXRGyabXC+ygOVg8KoyKRTDD1ziYGA2FU9/6090exzC0h0mGe/RBuRUxDxSYmlQRrlOSCpv4jMViLGiwGNemZUb3dMgdB36+7CsKHjqMOJEswI2nKPFvQCufeDPsQDmdNE6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790060854; c=relaxed/simple;
	bh=Dcr8ih5cU5LQLe0KzKSf3x2nn7WzcnwVVBHFzUh3x3g=;
	h=Date:Mime-Version:Cc:Message-Id:Content-Type:In-Reply-To:From:
	 Subject:To:References; b=jHQLJx+CVn6I9A0iJzA1pJeXyeO9hWX0NA/tuk2kbO7Gm7DiJj6k3am/v1Plh6i+2en5JtD93bugniBBJMlTzLn0KwVLKEJGpKWnM7Z6+CokmtNGQKcmA8JsGt9hL3uxWZYJYn3giWtIY/18xhAbB9fPpHPelA4MsWcFRqcKbME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=bP9BvABX; arc=none smtp.client-ip=209.127.231.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="bP9BvABX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1790060844;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aQE1nSzGBjOGDJk5QhoY//gOlFIvu09fD99BrdzL5k0=;
 b=bP9BvABX6djOpUDBiQy/lFpRiQiKuI1w9NOEkuk1biQmVCpdJI4XkUK8HTFU7JZRpsRzhm
 Xdem6gCB04AsyUgRMTyI59G0D5U17goNkx09qQPzxccbShoMpDfWtL+veR4sKzMtwFHnSk
 E/Q5TOLDs4HHG9cLv5/f1owDVSTElTjkvTemYQhtyPYE9oHfQebRrwP7AAhECMAGi6lXt4
 B79OdqBfpSVPXsagSPdoC96objtS48RzVMhGdMt0Sly+sBWk3p9vPb0lucW2xBecbULvdn
 CNpa9/fwdyBuctWAEWl+qe52jN2orxG1qNAFe4qJTn62UdqJZnuqWqlYNdaxvA==
X-Lms-Return-Path: <lba+26ab2292c+759031+vger.kernel.org+yukuai@fygo.io>
Date: Tue, 22 Sep 2026 15:07:19 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Artur Paszkiewicz" <artur.paszkiewicz@intel.com>, 
	<syzbot+2ef75c54d0b2ac5d00ba@syzkaller.appspotmail.com>
Message-Id: <0c58abf7-2c23-44ad-a836-ddaa11484c9c@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260920091533.413-1-yogeshgaur.83@gmail.com>
Received: from [192.168.1.104] ([39.182.0.179]) by smtp.larksuite.com with ESMTPS; Tue, 22 Sep 2026 07:07:23 +0000
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: give the io_unit slab caches per-array names
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Yogesh Gaur" <yogeshgaur.83@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
References: <20260920091533.413-1-yogeshgaur.83@gmail.com>

=E5=9C=A8 2026/9/20 17:15, Yogesh Gaur =E5=86=99=E9=81=93:

> Both raid5 log backends create their io_unit slab cache per array but
> name it after the struct:
>
> 	ppl_conf->io_kc =3D KMEM_CACHE(ppl_io_unit, 0);
> 	log->io_kc      =3D KMEM_CACHE(r5l_io_unit, 0);
>
> KMEM_CACHE() passes the stringified type as the cache name, so every
> array that enables PPL or attaches a journal asks for a cache called
> "ppl_io_unit" or "r5l_io_unit".  With two such arrays live at the same
> time the second one trips kmem_cache_sanity_check():
>
>    kmem_cache of name 'ppl_io_unit' already exists
>    WARNING: mm/slab_common.c:112 at __kmem_cache_create_args+0xae/0x460
>     ppl_init_log+0x285/0x1310 drivers/md/raid5-ppl.c:1363
>     log_init drivers/md/raid5-log.h:138 [inline]
>     raid5_change_consistency_policy+0x255/0x740 drivers/md/raid5.c:9141
>     consistency_policy_store+0x7f/0x230 drivers/md/md.c:5883
>     md_attr_store+0x3b7/0x640 drivers/md/md.c:6158
>
> which is reachable by any user that can write "ppl" to
> md/consistency_policy on two arrays, and equally by assembling two
> journalled arrays.  The cache is created and destroyed correctly on
> every path, so this is a name collision only - duplicate names confuse
> slabtop and /proc/slabinfo, which is what the check is there to catch.
>
> Build the name from the array instead, the way grow_stripes() already
> does for the stripe_head cache in this driver, and fall back to the
> mddev pointer for dm-raid where mdname() is the constant "mdX".  The
> buffer is sized like conf->cache_name[] because mdname() can return up
> to DISK_NAME_LEN bytes.
>
> The explicit size/align arguments keep what KMEM_CACHE() expanded to,
> so object layout does not change.
>
> Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging impleme=
ntation")
> Fixes: f6bed0ef0a80 ("raid5: add basic stripe log")
> Reported-by:syzbot+2ef75c54d0b2ac5d00ba@syzkaller.appspotmail.com
> Closes:https://syzkaller.appspot.com/bug?extid=3D2ef75c54d0b2ac5d00ba
> Assisted-by: LLM
> Signed-off-by: Yogesh Gaur<yogeshgaur.83@gmail.com>
> ---
>   drivers/md/raid5-cache.c | 12 +++++++++++-
>   drivers/md/raid5-ppl.c   | 12 +++++++++++-
>   2 files changed, 22 insertions(+), 2 deletions(-)
Applied to md-7.4

--=20
Thanks,
Kuai
