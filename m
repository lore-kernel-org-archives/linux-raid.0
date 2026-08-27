Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643FD35CB95
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 06:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787812067; cv=none; b=fC2s2kCw7u5XZZCWld1S92lPnjRhRs5d5JW6JqQwnmk1jLu7LXBwV9w6z7FjB+4mzbvfsfq0Fw20vYGE5q4r8FQOzQ03gIZvkbYj+Et0R0mFOTMkPt8aFbA7GSUQooub9jooJ2/87ww1f84utrOrorJ7rRCR1mo31YehUhDYLF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787812067; c=relaxed/simple;
	bh=MQ/x5uU/Fa6udaqoBIzexVBpyotcC/gWlQxYc3D4u6M=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ga4Ep16WAtRTzPkLulmeoyzmMQ8z/yRIdb4T8IgE6FCIxRM2tL1vZ/Etlu/dqm6GdsLocJzB5P5C6iP+aBYj3pkch8Qs3eJIEm7Qu5rureH9LarIZKHXG7UNP4YFPg8yncEGIG/9rv13aJiSu/PCZAXJp/uh8MoaGdQmUO6/e0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kg2F5E5i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kg2F5E5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB2E1F000E9;
	Thu, 27 Aug 2026 06:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787812066;
	bh=83rSLL8E0lubeBBrHMoF2+/ZHQurOGzefTWlljI/m9M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kg2F5E5i1PmamMWYOVav3DCsB3lEmvIjs83vKDbxr00Xssg4HXsTQlc4QVvnNF3PV
	 klgRq9Jd6QQWvpfT+ndFUbtsqoXPV0LJmPkZ9XQNmyWT1UqNNv4gj/xfC9qDrlvn67
	 H0ETlkn83a5F9ZdDPpOTUCC/jndg82ko6jkORiMPURP1+m1Qm9VSdlv/ecbjB6wKrm
	 wF5wY5TxrKw6BO/mM5SacZ3xk8cXnnUJJfbLD/DVzLCkLDFCddVzti37pRB9e2b5T7
	 NlOzqmnyg9f45yK0Epn6PzlARIkEoI3E4aBjJEO42wYb27HCKu1KfWGNKiN/hicN04
	 vwUvjXU35o5Rw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] md/raid5: set pool_size before extra_page
 allocation to fix leak on error path
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827060554.77849-1-ghuicao@163.com>
References: <20260827023803.36602-1-ghuicao@163.com>
 <20260827060554.77849-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 06:27:45 +0000
Message-Id: <20260827062745.DBB2E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] NULL pointer dereference in log_exit() when early allocations in s=
etup_conf() fail before conf->mddev is initialized.
--

commit 9327d7b2c0b735410bac76b4b55b188fa14875d3
Author: Cao Guanghui <caoguanghui@kylinos.cn>

    md/raid5: set pool_size before extra_page allocation to fix leak on err=
or path

    In setup_conf(), conf->disks is allocated with max_disks slots and
    extra_page is allocated for each slot. However, pool_size remains 0
    (uninitialized from kzalloc) until grow_stripes() sets it later. This
    fixes a memory leak by setting pool_size earlier.

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
This is a pre-existing issue, but I noticed a potential NULL pointer
dereference on these early error paths.

If any early memory allocation in setup_conf() fails (such as
conf->pending_data, conf->disks, or alloc_page() for extra pages here),
the code jumps to the abort label and calls free_conf(conf). This happens
before conf->mddev is assigned.

free_conf() unconditionally calls log_exit(conf). Because conf->log is NULL
on these paths, log_exit() checks raid5_has_ppl():

drivers/md/raid5-log.h:log_exit() {
	if (conf->log)
		r5l_exit_log(conf);
	else if (raid5_has_ppl(conf))
		ppl_exit_log(conf);
}

This function evaluates test_bit(MD_HAS_PPL, &conf->mddev->flags), which
dereferences the uninitialized conf->mddev pointer:

drivers/md/raid5-log.h:raid5_has_ppl() {
	return test_bit(MD_HAS_PPL, &conf->mddev->flags);
}

Can conf->mddev =3D mddev; be assigned immediately after conf is allocated =
in
setup_conf() to avoid this crash during early aborts?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827060554.7784=
9-1-ghuicao@163.com?part=3D1
