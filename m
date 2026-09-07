Received: from va-2-54.ptr.blmpb.com (va-2-54.ptr.blmpb.com [209.127.231.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7093FC5AE
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 06:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762773; cv=none; b=IjAyvKlXvUeiESOc5OzPQNo7D35twFASu6JatfNEddpk3NK6wb4+Pb/UZsikYhXIacajP0Cpo7thPFFoNCxeThlt9R0YE1HGQ7c95YCkss+nqJ0dqkpr5CD+BYOGjC5DLZ6HkjM+ijLWOh6hvae73MiL1FvO+PavDyOK74iujR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762773; c=relaxed/simple;
	bh=Rwl6+KIHPaNEg/U11nkWziInYelHWzlevofguxlERD0=;
	h=Content-Type:To:From:Date:Message-Id:Mime-Version:References:Cc:
	 Subject:In-Reply-To; b=BnlJfi/fD6qy+g8jokL9+U9dl6D5PPFuO9BgxM6fbWqbngdx0AAZa7twufK4hczpnI2OoNzl58wLYKrc3IbE+F15bAV17D/DgzAjk+RviPuk/KZaPnbf1KpJ55sqF0fyqyCXPD7M3N0S9zRezuRUi22sakrY5PvgTq66PqrWUcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ebsptd27; arc=none smtp.client-ip=209.127.231.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ebsptd27"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1788762764;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=O8oIkgpyTsX/KGG5caPTVxOxKkkZWwf60569EzqLa9s=;
 b=ebsptd27m+L88D770bGLM7m3oz/zLWZRKouGzTEgIMedP6jSq7934Hx+PGLHOwdeBBrFga
 GP6qb/tDZQ227zQBeBPvDyFE1+0URCkNM4YLXTNtOA8+s1thh72cLweW65g9XM4oRJz9eP
 cCyTdcAl8Ampuj7riMXOo18/ffsTIjVFeQzkUAZtasBJSKYRRwZp+ATfr3QfNv5nM7Os1c
 IJIHp6i5jCOFaf6uMxrGX2GUEIhcLghrdAyeGjByU8/pW6S6CWodfm8p/EwD6a8qusfaMC
 6ycOZcXCxW0uGceANgdOqmx9MSAJX9Rfq24Z26RtfjhM4Zdyarxuo/kW5AFmKA==
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Hemanth Selam" <hemanth.selam@gmail.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 7 Sep 2026 14:32:39 +0800
Message-Id: <17352596-20c0-430a-8628-1202ded1b389@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Mon, 07 Sep 2026 06:32:43 +0000
References: <20260904124824.9585-1-hemanth.selam@gmail.com> <20260904124824.9585-2-hemanth.selam@gmail.com>
X-Lms-Return-Path: <lba+26a9e5a8b+24b9c0+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 1/2] md: fix typos in comments
In-Reply-To: <20260904124824.9585-2-hemanth.selam@gmail.com>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/9/4 20:48, Hemanth Selam =E5=86=99=E9=81=93:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>   drivers/md/raid1-10.c | 2 +-
>   drivers/md/raid10.c   | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)

I'll not accept typo fixed like this, because it will introduce conflicts f=
or
stable backport. However, it's still welcome to fix typos together with oth=
er
cleanup or bugfix.

>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 3b0e230692ba..852346420848 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -87,7 +87,7 @@ static inline struct resync_pages *get_resync_pages(str=
uct bio *bio)
>   	return bio->bi_private;
>   }
>  =20
> -/* generally called after bio_reset() for reseting bvec */
> +/* generally called after bio_reset() for resetting bvec */
>   static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pa=
ges *rp,
>   			       int size)
>   {
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 1093c798d9dd..2ac2dadda19a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1921,7 +1921,7 @@ static void raid10_status(struct seq_file *seq, str=
uct mddev *mddev)
>   }
>  =20
>   /* check if there are enough drives for
> - * every block to appear on atleast one.
> + * every block to appear on at least one.
>    * Don't consider the device numbered 'ignore'
>    * as we might be about to remove it.
>    */

--=20
Thanks,
Kuai
