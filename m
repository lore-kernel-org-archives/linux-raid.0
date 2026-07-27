Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5273E6386
	for <linux-raid@vger.kernel.org>; Mon, 27 Jul 2026 08:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785141568; cv=none; b=f0z4sODQ2lDT/4bcrHRrOUogySY7OIUwGUF2Wpj5HmFvUldMKU86Y7wauDBDTlVIrws/hz2L5Jlaoyrv60lkplWKaX6DJRI27KBljV4oYAI4UBzO/eiDb8Y6nNdMm1wDhWGLDxBiWs1DMp0oNmfX3nW3K5NFn4ple2micrhEDCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785141568; c=relaxed/simple;
	bh=pa1dD51itovqyrvmvI6dQBPvutgG2QtkW1aS6cnv/DI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kZiK0/4D/73/Wi/qBCySm2fLaHhlz56+fVr86NjzkzJN+RkmUZNe5dS1Du7hcg5+scz2CIx7pyFTSVOrgNmFsb+pQwyAxfHb7YOwnzHQSDLDpjk7DNkm4KcPjdHyl5SXQg26zLGTK2O/22F2D5fzAIt4haA7VKEkNt40NysfSzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Ex7NJFoQ; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=FxccUXKF; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Ex7NJFoQ";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FxccUXKF"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7B0927D484;
	Mon, 27 Jul 2026 08:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785141560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pa1dD51itovqyrvmvI6dQBPvutgG2QtkW1aS6cnv/DI=;
	b=Ex7NJFoQwuziDhX4S+p5Bdx0eBoh/WSCjZls0+LlGVmeng59KyQr/4pewU43T/5iyl9jtg
	n2T6nsmbNvVNuodYWBy19wBUqhBnZFXZYk0BoFJpsFi5n9eI4rZv00ibj6dR+Y9tDqf395
	HGFzdJ1tybNdxvz1Brv2H27s6bLSm9E=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1785141556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pa1dD51itovqyrvmvI6dQBPvutgG2QtkW1aS6cnv/DI=;
	b=FxccUXKFZHE1VK4FwmDD0QEwjJdCY9LdHD2S4gL39Syk9rBqQpWroNezucBMHVjOiRpLjq
	zK3VVmAFTxtaJsZUiXStgytwG7YVGTLIx2CC9lJ6SmdYPvT3fXHhfyPVbQDsrPBPMZoD7c
	JJa57GCRiilDsZfjqCiicPktGX4mIhw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53C94779B9;
	Mon, 27 Jul 2026 08:39:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LSdmEzQZZ2rlawAAD6G6ig
	(envelope-from <mwilck@suse.com>); Mon, 27 Jul 2026 08:39:16 +0000
Message-ID: <09aae47428ab10f11ae4dab6c168cc24cc810aff.camel@suse.com>
Subject: Re: [PATCH] md/raid1: create serial pool adding rdev to array with
 serialize_policy=1
From: Martin Wilck <mwilck@suse.com>
To: Mykola Marzhan <mykola@meshstor.io>, Yu Kuai <yukuai@kernel.org>, Song
 Liu	 <songliubraving@fb.com>
Cc: Xiao Ni <xni@redhat.com>, Li Nan <linan122@huawei.com>, 
	linux-raid@vger.kernel.org
Date: Mon, 27 Jul 2026 10:39:15 +0200
In-Reply-To: <20260726121359.2173478-1-mykola@meshstor.io>
References: <20260723112741.1206836-1-mwilck@suse.com>
	 <20260726121359.2173478-1-mykola@meshstor.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.998];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.com:mid,meshstor.io:email,imap1.dmz-prg2.suse.org:helo]

On Sun, 2026-07-26 at 14:13 +0200, Mykola Marzhan wrote:
> This reply was drafted with AI assistance.
>=20
> > But when a new rdev is added to an existing array in
> > bind_rdev_to_array(),
> > the condition at mddev_create_serial_pool() causes creation of
> > rdev->serial
> > to be skipped. Fix it.
>=20
> I ran into the same early return from the other direction, so I can
> confirm the analysis: the new rdev fails rdev_need_serial() (it is
> not
> a write-mostly member with write-behind configured), CollisionCheck
> was never set on it, and mddev_create_serial_pool() returns without
> allocating rdev->serial. The first write routed to it then crashes in
> wait_for_serialization(), which is gated on the array-wide flag and
> assumes the tree exists. serialize_policy is array-wide, so creating
> the pool for every rdev bound while it is set is the right fix.
>=20
> Reviewed-by: Mykola Marzhan <mykola@meshstor.io>
>=20
> One interaction to flag. Patch 3 of my P2PDMA series changes that
> raid1 gate from MD_SERIALIZE_POLICY to per-rdev CollisionCheck, so
> that writes which skip write-behind also order against in-flight
> behind I/O on write-mostly members (the behind path already checks
> CollisionCheck; the non-behind path does not):
>=20
> =C2=A0
> https://lore.kernel.org/linux-raid/20260726113229.2154269-4-mykola@meshst=
or.io/
>=20
> For the rdev in your report the two gates disagree: without your fix
> it has no serial tree, and the CollisionCheck gate would skip
> serialization instead of crashing, hiding the oops but not the bug.
> So your patch is needed either way and should go in first; with it,
> every rdev in a serialize_policy array owns a serial tree, and the
> CollisionCheck gate covers everything the old one did. Patch 3
> carries a Link: to your fix.
>=20
> If you see a hole in that reasoning I would rather hear it now than
> after either patch lands.

I fully agree. My patch is just a small bug fix. Your changes go much
deeper.

Regards,
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>
SUSE Software Solutions Germany GmbH, Frankenstr. 146, 90461 N=C3=BCrnberg,
Germany
Gesch=C3=A4ftsf=C3=BChrer: Jochen Jaser, Andrew McDonald (HRB 36809,AG N=C3=
=BCrnberg)
