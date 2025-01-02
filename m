Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D2B1B4120;
	Thu,  2 Jan 2025 15:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735831747; cv=none; b=MR6lAgKeOpb/ulgbmN0ofjTftZvmWnIwP1udlCVI2vg6UAI+YSTTPiZQmSwMylH/0TisDYqhNwB8OugSlHdJZnDsrzAM89UEGJF8+5TVc2uMkBVQ4yzF2kKa5PRQ/11EJLC6TH2vjOwAPzpsUMnfvtrM9qCkNqfZZVZaDmImA7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735831747; c=relaxed/simple;
	bh=/3bZNpOQLuGl3h/B7v/R+B6vxuMd4RxU1p/YlkFdxbc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=XUmz+l/QdfhLNaZEH/8MH+lqgrwGZcU+tBI4ejrRLg9XfrQPjXnHwDQ+7daVXHPoArEPFyBkffkqTFdYZTamFibFAfT5eV3/0N0elHVUmWPmkIhR1vs5tQTYyzl/kFEc3rrpt7EA5TMIBIxVx4xHQ/hc5Ae4zSrN2yFs5F+pe5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WpixpEOW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E5GVbbbA; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=WpixpEOW; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=E5GVbbbA; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WpixpEOW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E5GVbbbA";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="WpixpEOW";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="E5GVbbbA"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 05C0821160;
	Thu,  2 Jan 2025 15:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1735831744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fv/+LI6BXJi00N/o1ZDtZ7dv6dt2Am9l5I4TFZMfI70=;
	b=WpixpEOW/bkS0/Ox72Fq8b7F9rQwlNLaULMSxHBgbCfdugyPbVBC8avESfjt7rGDpVoJS1
	SglB/aQ3qhr0T9gDcbmOJpzGllo06Yxvv4Ah26wP/yhUPq0Ba6y+m2kr8JX+WNxWerf+hv
	JsDREO3fH12Sf8ZDh1jMWLr6Tocl70g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1735831744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fv/+LI6BXJi00N/o1ZDtZ7dv6dt2Am9l5I4TFZMfI70=;
	b=E5GVbbbAG1GwjNgD1TBw1ljj29YXvQ+Hcnk9OzHWK/ajgTSMDgPqHyoQYi12bTEUappkE6
	0I3OEfN++e93oYBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=WpixpEOW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=E5GVbbbA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1735831744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fv/+LI6BXJi00N/o1ZDtZ7dv6dt2Am9l5I4TFZMfI70=;
	b=WpixpEOW/bkS0/Ox72Fq8b7F9rQwlNLaULMSxHBgbCfdugyPbVBC8avESfjt7rGDpVoJS1
	SglB/aQ3qhr0T9gDcbmOJpzGllo06Yxvv4Ah26wP/yhUPq0Ba6y+m2kr8JX+WNxWerf+hv
	JsDREO3fH12Sf8ZDh1jMWLr6Tocl70g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1735831744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fv/+LI6BXJi00N/o1ZDtZ7dv6dt2Am9l5I4TFZMfI70=;
	b=E5GVbbbAG1GwjNgD1TBw1ljj29YXvQ+Hcnk9OzHWK/ajgTSMDgPqHyoQYi12bTEUappkE6
	0I3OEfN++e93oYBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1C18F132EA;
	Thu,  2 Jan 2025 15:29:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zfwQMrywdmexIwAAD6G6ig
	(envelope-from <colyli@suse.de>); Thu, 02 Jan 2025 15:29:00 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH RFC md-6.14] md: reintroduce md-linear
From: Coly Li <colyli@suse.de>
In-Reply-To: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
Date: Thu, 2 Jan 2025 23:28:48 +0800
Cc: song@kernel.org,
 yukuai3@huawei.com,
 thetanix@gmail.com,
 linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org,
 yi.zhang@huawei.com,
 yangerkun@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <58F4D954-1EC2-4E79-BE7C-3CB84F31CF49@suse.de>
References: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.300.87.4.3)
X-Rspamd-Queue-Id: 05C0821160
X-Spam-Score: -4.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-0.991];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_ALL(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,huawei.com,gmail.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,suse.de:mid,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 



> 2025=E5=B9=B41=E6=9C=882=E6=97=A5 19:28=EF=BC=8CYu Kuai =
<yukuai1@huaweicloud.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Yu Kuai <yukuai3@huawei.com>
>=20
> THe md-linear is removed by commit 849d18e27be9 ("md: Remove =
deprecated
> CONFIG_MD_LINEAR") because it has been marked as deprecated for a long
> time.
>=20
> However, md-linear is used widely for underlying disks with different =
size,
> sadly we didn't know this until now, and it's true useful to create
> partitions and assemble multiple raid and then append one to the =
other.
>=20
> People have to use dm-linear in this case now, however, they will =
prefer
> to minimize the number of involved modules.
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>=20

Acked-by: Coly Li <colyli@kernel.org>

I am fully supportive to bring md-linear back. There are still many =
people/company/products using md-linear, just like the discussion in =
another thread.

Thanks for doing this.

Coly Li


> ---
> drivers/md/Kconfig             |  13 ++
> drivers/md/Makefile            |   2 +
> drivers/md/md-autodetect.c     |   8 +-
> drivers/md/md-linear.c         | 354 +++++++++++++++++++++++++++++++++
> drivers/md/md.c                |   2 +-
> include/uapi/linux/raid/md_p.h |   2 +-
> include/uapi/linux/raid/md_u.h |   2 +
> 7 files changed, 379 insertions(+), 4 deletions(-)
> create mode 100644 drivers/md/md-linear.c
>=20

[snipped]

> 2.39.2
>=20

