Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2490033F582
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782317013; cv=none; b=DCZpDkWRUuC+ce3jcdQqODGaL5XN1ouxFCgzqa4IgjZvg6uGAMu+yUmA5faZFwuHdXCYz3HVmEf6PBCs5Poac/IdTST46VVlU2cZMq7u3SMZC34Vw9eryE4I/qZQZL21ozxuwN1xHaUPPnCK23+H+7OkDtYkW16vK8tIxHRTx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782317013; c=relaxed/simple;
	bh=0VjNLQdtbZP9OdwVJ/H7EMMkMv3SkMHrHEEFq2lcYCM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Q/6cR6YAoDpXk+HQlHFCQlibqzH5QynuCAheENZEcj86muPwjERxPY/zguOA4WcD4TAMG1DmBDoG8/RoTlLrH6NIzskjdLKsL3xva1gVT0EnbGCRBGVkb7UYE17Mzx+HPsCt70e6yYreEjwxjbWwFPRH7B6sH1ZlFqAJZSqm/gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FApj8uF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FApj8uF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5F51F000E9;
	Wed, 24 Jun 2026 16:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782317011;
	bh=CW7fpDYwBj8TqHkvodvEf2FifZUltkMHYTKR8wBSs5M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FApj8uF1eBIm3DhnFwpCN4XRGfooGl4XmScTsS8IDwXN8jQY40zhglcEbuBXzwZxL
	 oS32nWAD2vg83ErFXXGwX48TLukfIRtXyfWY5p7bBIPyCxvhjT1kv7rXDPKy6Fwdsg
	 DUohXarcbbHiiAGfIHTb8p5ETiqVyCuXzVFkj9JbFZcy0J63M1Odx0hVrheubWDH30
	 +wklDpmUCVit92QClHFEz+wTMoiklXyA7wPXV1qCnWp1CDmv4YCewOaRTkT0hsjhSJ
	 Re3/cXeIwxXvQ2Bun0OG3qcXbtv0pXmNZu4tSay8KvcGb8SlNxOvwTrESgMNB6lSQ7
	 uL87I4Rbe5DjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/5] md: use sector_t for recovery_active in
 status_resync()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260624155421.211626-5-nishidafmly@gmail.com>
References: <20260624155421.211626-1-nishidafmly@gmail.com>
 <20260624155421.211626-5-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 16:03:31 +0000
Message-Id: <20260624160331.9C5F51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The commit message falsely claims `mddev->recovery_active` is a =
'sector-typed atomic' and that declaring a local variable as `int` 'needles=
sly narrows it', but the structure field remains a standard 32-bit `atomic_=
t`.
--

commit 7ec77a6b233ce4d151f7fc723e5f312b20b4ac92
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md: use sector_t for recovery_active in status_resync()

This commit changes the local variable recovery_active in status_resync()
from int to sector_t. The commit message states this is to match the type
of mddev->recovery_active and avoid needlessly narrowing the value.

> recovery_active holds a sector count read from the sector-typed atomic
> mddev->recovery_active and is then combined with the sector_t values
> curr_mark_cnt and resync_mark_cnt. Declaring it as a plain int needlessly
> narrows it and mixes signedness into sector_t arithmetic; declare it
> sector_t to match.

[Severity: Medium]
Is this description accurate? Looking at struct mddev in drivers/md/md.h,
recovery_active is defined as a standard atomic_t:

drivers/md/md.h:struct mddev {
    ...
    atomic_t recovery_active;
    ...
}

Since atomic_t is a 32-bit signed integer, and atomic_read() returns an int,
does changing this local variable to sector_t actually prevent narrowing? T=
he
implicit cast from int to sector_t will now simply happen at assignment
rather than during the arithmetic operations.

Could the commit message be updated to reflect that mddev->recovery_active
is a standard atomic_t, rather than a "sector-typed atomic"?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155421.2116=
26-1-nishidafmly@gmail.com?part=3D4
