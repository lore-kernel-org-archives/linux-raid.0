Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702D51DE2CC
	for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 10:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787424; cv=none; b=Iw89VrQXZz/LRCSa2GEy1rQuLIDYx9jgQJbBUwbCT9wPFq4M/1nw8RQ4FSnX1FVjGBiYWsZ8u/R6QtO3bqAbx7oSZwvGcj3Enj0oQi2+V1bX4e/kL9ccoD0h+Dq+jYiIPZOBwVOaiToipb2KBWXHrpNQgTcMLcmCg+LduQBJ3sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787424; c=relaxed/simple;
	bh=rBrIx9GBDgrWs9Ymd4oZ50NeVRG2FjxCd7D5CWViQVM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=HK8Rk67rd7xY4JOKZTP2t2oSiCAqmyJZlyn79goN3agWnRC9P3Ia7Rt22spDV6SqoAqNjkoEjx3iLp6l+Ljptd79rIDaCZ8TjuO2/xVNySFv8BD8kt2MGplkYNdNoUgQa9ZLppWgqaYPG95NWK9y4N9oYhoaq76zRSFopVHp1ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bwmR7gNc; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bwmR7gNc"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-38f406e9f80so878454f8f.2
        for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 02:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739787421; x=1740392221; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IroPuYTAWG3M1jeVvmdP8OddzBr8Wr2D21+R/Oqlmuw=;
        b=bwmR7gNcJVsUKY7y6smHOKDkIAsGN47XWKojjk9s2rMgdU2QFmmkM6QIEj2W2Gl3jt
         lDgc4mXM9AQgLLWVAQzESha5pjomWCSuNLAbYmhE+SdW98rA4NKPl+Y/39mSqMWrgOqE
         Q+zvIOtw0zAo1rcX4FiRAVDMNx3EWUdfFkBDqsBAxfnYWNgsG4FZj6trcKkOF03cIoeS
         pGE4bcXB3m7OSHgQf+ZySQomONohKTKBbDWcjYx2BpAc4rU4BNhyXzuXs9topQ8wHDQn
         4eWOy12v8BeEztTvZBnAOhWBltf45/Yi0Z5j+/+bZt+bhEoXu1EdCA0jjBu74mKY8r3g
         6m9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739787421; x=1740392221;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IroPuYTAWG3M1jeVvmdP8OddzBr8Wr2D21+R/Oqlmuw=;
        b=RIuF882SLaM9QzuEAswjkkyVNHt1UPBmnV0zN+jOrAL7oMNMaWqonsirEwqU4CiaCl
         ro1F4xiBwMdUONPahoSgDZgaAK9oD+jLq4gtEdlpD9o2EpXWbmqsqETDBMpjZOFFimVH
         1nqHsktEQCBC703LN4+dOzmAlYit8P7sK/nCKtSVsjDKOdRel54iCavQuLe5lzZjWL9K
         jthnLd6B6HzPhEK6e2+Zll9bGQ1MEXjskAE+jyGobDuxWlnB0wn8M7K+zAvIfgmMRJt6
         +MR0HiWdh3LzhEhuywRXiUhzA5YoqQuLQu9ckw7VVU2yZjywV6k24GbSC/cchFcx093h
         vp4A==
X-Forwarded-Encrypted: i=1; AJvYcCUnfdOLozpSpXAAzqIQgyqgWjRKPhlI5wXFINz0WsNbRWI20Z4oC6KhVUbuIWCZzcs3D/qvgaCD1Bww@vger.kernel.org
X-Gm-Message-State: AOJu0YyJFWVR+yq0LW0ItSUC+THCM+rTgYm/P9IZeR3QzqE+JV0PP8G3
	BJby5XjwHOdrP+wtk2H0aY8W2AgamjfPHSjaSmOmfKMnbJ/nXXiRYhCWHF0TXNJqaVFABL2QTDI
	B
X-Gm-Gg: ASbGncsUoN2BBLwmy5Cj0WYTW02iC1FXoasx7bZ2os7nKa9n42ZlqhINDqoFqKncZa+
	EMhuAzuf1cwdNRagaz1hlloMjTGMxNS+Uu+JNpXFGD3heMxdhtxv+ophqA4+t14oucvBxsSUACN
	TSIsBC8Fry7o7JLElCbZzJNsSuAailM7jUiSG/dVAEiJsbGWZ6R8ghFO6r+lZQLlY9KnJ28VgfL
	5fL0qXRlEAhoczoPoTrTyhaS1evahMfE3f3t3lePhhKAZw0IA3+VN1UQ0xBZY7cqxM4pwPUeEBm
	xytHY6NTKPUk5/QHow==
X-Google-Smtp-Source: AGHT+IFFV5PWwn6EsSJ6dUQgMR9uZDAGa064gJHzePhdsOJ3TxHaSBl6cHRtYDmTVFPFn0HFJ+Tzug==
X-Received: by 2002:a5d:6c63:0:b0:38f:4a0b:e764 with SMTP id ffacd0b85a97d-38f4a0bea35mr1412234f8f.28.1739787420651;
        Mon, 17 Feb 2025 02:17:00 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c0a0ef87c4sm76739585a.83.2025.02.17.02.16.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2025 02:17:00 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH md-6.15 1/7] md: merge common code into find_pers()
From: Glass Su <glass.su@suse.com>
In-Reply-To: <20250215092225.2427977-2-yukuai1@huaweicloud.com>
Date: Mon, 17 Feb 2025 18:16:42 +0800
Cc: song@kernel.org,
 yukuai3@huawei.com,
 linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com,
 yangerkun@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <CF631B40-3430-4ADC-BB6D-D535B3AF5D9E@suse.com>
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
 <20250215092225.2427977-2-yukuai1@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)



> On Feb 15, 2025, at 17:22, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> From: Yu Kuai <yukuai3@huawei.com>
>=20
> - pers_lock() are held and released from caller
> - try_module_get() is called from caller
> - error message from caller
>=20
> Merge above code into find_pers(), and rename it to get_pers(), also
> add a wrapper to module_put() as put_pers().
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Su Yue <glass.su@suse.com>
> ---
> drivers/md/md.c | 68 +++++++++++++++++++++++++++----------------------
> 1 file changed, 38 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 30b3dbbce2d2..37f3a89eba94 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -888,16 +888,37 @@ struct md_rdev *md_find_rdev_rcu(struct mddev =
*mddev, dev_t dev)
> }
> EXPORT_SYMBOL_GPL(md_find_rdev_rcu);
>=20
> -static struct md_personality *find_pers(int level, char *clevel)
> +static struct md_personality *get_pers(int level, char *clevel)
> {
> + struct md_personality *ret =3D NULL;
> struct md_personality *pers;
> +
> + spin_lock(&pers_lock);
> list_for_each_entry(pers, &pers_list, list) {
> - if (level !=3D LEVEL_NONE && pers->level =3D=3D level)
> - return pers;
> - if (strcmp(pers->name, clevel)=3D=3D0)
> - return pers;
> + if ((level !=3D LEVEL_NONE && pers->level =3D=3D level) ||
> +    !strcmp(pers->name, clevel)) {
> + if (try_module_get(pers->owner))
> + ret =3D pers;
> + break;
> + }
> }
> - return NULL;
> + spin_unlock(&pers_lock);
> +
> + if (!ret) {
> + if (level !=3D LEVEL_NONE)
> + pr_warn("md: personality for level %d is not loaded!\n",
> + level);
> + else
> + pr_warn("md: personality for level %s is not loaded!\n",
> + clevel);
> + }
> +
> + return ret;
> +}
> +
> +static void put_pers(struct md_personality *pers)
> +{
> + module_put(pers->owner);
> }
>=20
> /* return the offset of the super block in 512byte sectors */
> @@ -3931,24 +3952,20 @@ level_store(struct mddev *mddev, const char =
*buf, size_t len)
>=20
> if (request_module("md-%s", clevel) !=3D 0)
> request_module("md-level-%s", clevel);
> - spin_lock(&pers_lock);
> - pers =3D find_pers(level, clevel);
> - if (!pers || !try_module_get(pers->owner)) {
> - spin_unlock(&pers_lock);
> - pr_warn("md: personality %s not loaded\n", clevel);
> + pers =3D get_pers(level, clevel);
> + if (!pers) {
> rv =3D -EINVAL;
> goto out_unlock;
> }
> - spin_unlock(&pers_lock);
>=20
> if (pers =3D=3D mddev->pers) {
> /* Nothing to do! */
> - module_put(pers->owner);
> + put_pers(pers);
> rv =3D len;
> goto out_unlock;
> }
> if (!pers->takeover) {
> - module_put(pers->owner);
> + put_pers(pers);
> pr_warn("md: %s: %s does not support personality takeover\n",
> mdname(mddev), clevel);
> rv =3D -EINVAL;
> @@ -3969,7 +3986,7 @@ level_store(struct mddev *mddev, const char =
*buf, size_t len)
> mddev->raid_disks -=3D mddev->delta_disks;
> mddev->delta_disks =3D 0;
> mddev->reshape_backwards =3D 0;
> - module_put(pers->owner);
> + put_pers(pers);
> pr_warn("md: %s: %s would not accept array\n",
> mdname(mddev), clevel);
> rv =3D PTR_ERR(priv);
> @@ -4026,7 +4043,7 @@ level_store(struct mddev *mddev, const char =
*buf, size_t len)
> mddev->to_remove =3D &md_redundancy_group;
> }
>=20
> - module_put(oldpers->owner);
> + put_pers(oldpers);
>=20
> rdev_for_each(rdev, mddev) {
> if (rdev->raid_disk < 0)
> @@ -6096,20 +6113,11 @@ int md_run(struct mddev *mddev)
> goto exit_sync_set;
> }
>=20
> - spin_lock(&pers_lock);
> - pers =3D find_pers(mddev->level, mddev->clevel);
> - if (!pers || !try_module_get(pers->owner)) {
> - spin_unlock(&pers_lock);
> - if (mddev->level !=3D LEVEL_NONE)
> - pr_warn("md: personality for level %d is not loaded!\n",
> - mddev->level);
> - else
> - pr_warn("md: personality for level %s is not loaded!\n",
> - mddev->clevel);
> + pers =3D get_pers(mddev->level, mddev->clevel);
> + if (!pers) {
> err =3D -EINVAL;
> goto abort;
> }
> - spin_unlock(&pers_lock);
> if (mddev->level !=3D pers->level) {
> mddev->level =3D pers->level;
> mddev->new_level =3D pers->level;
> @@ -6119,7 +6127,7 @@ int md_run(struct mddev *mddev)
> if (mddev->reshape_position !=3D MaxSector &&
>    pers->start_reshape =3D=3D NULL) {
> /* This personality cannot handle reshaping... */
> - module_put(pers->owner);
> + put_pers(pers);
> err =3D -EINVAL;
> goto abort;
> }
> @@ -6246,7 +6254,7 @@ int md_run(struct mddev *mddev)
> if (mddev->private)
> pers->free(mddev, mddev->private);
> mddev->private =3D NULL;
> - module_put(pers->owner);
> + put_pers(pers);
> mddev->bitmap_ops->destroy(mddev);
> abort:
> bioset_exit(&mddev->io_clone_set);
> @@ -6467,7 +6475,7 @@ static void __md_stop(struct mddev *mddev)
> mddev->private =3D NULL;
> if (pers->sync_request && mddev->to_remove =3D=3D NULL)
> mddev->to_remove =3D &md_redundancy_group;
> - module_put(pers->owner);
> + put_pers(pers);
> clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>=20
> bioset_exit(&mddev->bio_set);
> --=20
> 2.39.2
>=20
>=20

