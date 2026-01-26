Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C729629CE9
	for <linux-raid@vger.kernel.org>; Mon, 26 Jan 2026 05:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769406656; cv=none; b=PXSQZummRY1NI72LYZVGSRkJwYlvE6dT1gJBbFPMXJG8QSHRjWxRG76yJmJisdc1SusLqpv7L/fii3uGJ+QhzCIj5HupV4hMuSP9gJnKnjZIDH8nvTizJn8Ojp1V0TXcBEQpkn0r92mOlKmJVxM23Lnml8SnPOwNG486LHOYNao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769406656; c=relaxed/simple;
	bh=93XhwTDOf/KldTPQPjQGDiskuXdb3/ke9Z9Pc7vhru4=;
	h=Date:References:Subject:Message-Id:In-Reply-To:Mime-Version:To:
	 Content-Type:From; b=YvCSocVx+IIZ8AZ1oPgsnXdRXdgUyIzj+rpbT0TZU12OMeOAjvsGBB8SC8Q0kMS18Iv8ifyeZNRIhtTz1TDFJXzT5Ucg8UokC9E7DofB5+4HTrK5j5977cRaFMX4u/TchkfFyxP3WJSoQRhGzMcN0M3kWQYdL7yjS3oYHBVRrrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=aIBcjPwC; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="aIBcjPwC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1769406642;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=gJi+oesRq+/BRs6BA+pCdShxcw6MWirVjzFvfHB8V2E=;
 b=aIBcjPwCblkjmCyKD/m3xUOWyudOpTvwrn+IjV6RijS+oYYLCoD1JFFz0LvCuWK9qZXKuA
 wKgCDahdhHpAZsadH6PlIIi/YmX5vfGXNJxmxp7IVHshU3B+pnIHE4ri9aui8jIBpM9c4n
 QFLn+eOZ6X1mj0DaMVXnRk2t9M3UgScqDbA2MpmJC2s0+36fr5GQfpr5ysmZTrHQpKPGWW
 l88N/PKA+S1r1FcDSkZeOVNp9/oSMabykci3m/KZ0/p2844H3xvU5/QqL/rjbVTtmFwF76
 nw19EAp1X9CIa29So+TUupx0c2zg8/7uJFdbgtyHJPf2FvoeueY1Hr9JnzT9DA==
Date: Mon, 26 Jan 2026 13:50:37 +0800
References: <414ae6e0-604a-f4d3-d7ce-260bd8564927@huaweicloud.com> <d4bab4c8921eaecae856447131c4f4f1aa190dd3.1758631268.git.heinzm@redhat.com> <CAM23VxqYrwkhKEBeQrZeZwQudbiNey2_8B_SEOLqug=pXxaFrA@mail.gmail.com>
X-Lms-Return-Path: <lba+2697700b0+ce9bb1+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: Fwd: [PATCH V2] md raid: fix hang when stopping arrays with metadata through dm-raid
Message-Id: <53350e3b-aec6-47ac-bd39-9d3ec04ad51d@fnnas.com>
In-Reply-To: <CAM23VxqYrwkhKEBeQrZeZwQudbiNey2_8B_SEOLqug=pXxaFrA@mail.gmail.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.137]) by smtp.feishu.cn with ESMTPS; Mon, 26 Jan 2026 13:50:39 +0800
To: "Heinz Mauelshagen" <heinzm@redhat.com>, 
	"linux-raid" <linux-raid@vger.kernel.org>, 
	"Linux-Kernel" <linux-kernel@vger.kernel.org>, 
	"Song Liu" <song@kernel.org>, <yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Yu Kuai <yukuai@fnnas.com>
From: "Yu Kuai" <yukuai@fnnas.com>

=E5=9C=A8 2026/1/15 1:52, Heinz Mauelshagen =E5=86=99=E9=81=93:

> hen using device-mapper's dm-raid target, stopping a RAID array can cause=
 the
> system to hang under specific conditions.
>
> This occurs when:
>
> - A dm-raid managed device tree is suspended from top to bottom
>     (the top-level RAID device is suspended first, followed by its
>      underlying metadata and data devices)
>
> - The top-level RAID device is then removed
>
> Removing the top-level device triggers a hang in the following
> sequence: the dm-raid
> destructor calls md_stop(), which tries to flush the write-intent
> bitmap by writing
> to the metadata sub-devices. However, these devices are already
> suspended, making
> them unable to complete the write operations and causing an indefinite bl=
ock.
>
> Fix:
>
> - Prevent bitmap flushing when md_stop() is called from dm-raid
> destructor context
>    and avoid a quiescing/unquescing cycle which could also cause I/O
>
> - Still allow write-intent bitmap flushing when called from dm-raid
> suspend context
>
> This ensures that RAID array teardown can complete successfully even when=
 the
> underlying devices are in a suspended state.
>
> This second patch uses md_is_rdwr() to distinguish between suspend and
> destructor paths as elaborated on above.
>
> Signed-off-by: Heinz Mauelshagen<heinzm@redhat.com>
> ---
>   drivers/md/md.c | 12 +++++++-----
>   1 file changed, 7 insertions(+), 5 deletions(-)

There are conflicts now, applied with some rebasing:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 606f616190d7..59cd303548de 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6851,13 +6851,15 @@ static void __md_stop_writes(struct mddev *mddev)
 =C2=A0{
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 timer_delete_sync(&mddev->safemode_timer);

-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (mddev->pers && mddev->pers->quiesce) {
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mddev->pers->quiesc=
e(mddev, 1);
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mddev->pers->quiesc=
e(mddev, 0);
-=C2=A0 =C2=A0 =C2=A0 =C2=A0}
+=C2=A0 =C2=A0 =C2=A0 =C2=A0if (md_is_rdwr(mddev) || !mddev_is_dm(mddev)) {
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (mddev->pers && =
mddev->pers->quiesce) {
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mddev->pers->quiesce(mddev, 1);
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mddev->pers->quiesce(mddev, 0);
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}

-=C2=A0 =C2=A0 =C2=A0 =C2=A0if (md_bitmap_enabled(mddev, true))
-=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mddev->bitmap_ops->=
flush(mddev);
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (md_bitmap_enabl=
ed(mddev, true))
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0mddev->bitmap_ops->flush(mddev);
+=C2=A0 =C2=A0 =C2=A0 =C2=A0}

 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (md_is_rdwr(mddev) &&
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ((!mddev->in_sync && !mddev_is_c=
lustered(mddev)) ||

--=20
Thansk,
Kuai
