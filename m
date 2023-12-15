Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1368F4184E
	for <linux-raid@vger.kernel.org>; Fri, 15 Dec 2023 18:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vg9Ub1cj";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="fEk1aR66";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0ynlNqpu";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="p3VjQTPU"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 04206220AA;
	Fri, 15 Dec 2023 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702664921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+vnWAzuX52MjSQq2Sk17+Zq4D1+N7whmeWeTmKX6uBo=;
	b=vg9Ub1cjnSVsrkTIbNIbtaDGHrat0KxkN6sRxIpdig8ZyPm25C7EaISlf90D3E3MMFW45L
	2gzXoGy7VqyPxB0Y0ZNPB2J9rWkPHIQXZ93D+9LQ3/nEKAJVJ0jfrCxCarsYpQgwUB5AzV
	y8q72TBpcwPlOf1K8zqWbaA5xa3r8bk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702664921;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+vnWAzuX52MjSQq2Sk17+Zq4D1+N7whmeWeTmKX6uBo=;
	b=fEk1aR66FlbiWisbpJ/Eeu1o+OXdtZ2W2n2UyQqB/UDoGzb9wAcDrKA3sS4HdCUwNC55et
	MufQN8B0ouJ4UHBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1702664920; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+vnWAzuX52MjSQq2Sk17+Zq4D1+N7whmeWeTmKX6uBo=;
	b=0ynlNqpurU6kiJswWHDd24GTzSA74XvqlK7R7x25EEEVYEhIki+sspswEzuN6ygIQ9oWQN
	oQ/4vJevyQy6y/Lv4ocCen4SUkkFnU8dAljU5spDEVB8Msr/1aJJVKKaLKVhTDlYBya0pC
	LjsPYVrzfvQmmJVRpSHGNNHfBDZgtic=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1702664920;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+vnWAzuX52MjSQq2Sk17+Zq4D1+N7whmeWeTmKX6uBo=;
	b=p3VjQTPUlBn5OGTZ1X6R2B43yzXUXaMay026TPS9VxCD4VGkKtdX0MdTe1ABu2BrNwr9AK
	ZZcK+V2+V8c2ytDw==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 0B0DF13A08;
	Fri, 15 Dec 2023 18:28:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 8JXMKtWafGX8LgAAn2gu4w
	(envelope-from <colyli@suse.de>); Fri, 15 Dec 2023 18:28:37 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: Re: Announcement: mdadm maintainer update
From: Coly Li <colyli@suse.de>
In-Reply-To: <e5c7971f-a600-08ec-0f31-8f255bd99979@trained-monkey.org>
Date: Sat, 16 Dec 2023 02:28:24 +0800
Cc: "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
 Song Liu <songliubraving@fb.com>,
 "Luse, Paul E" <paul.e.luse@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <846BACCC-5CF2-4ABB-A31B-DE4D3C2C443F@suse.de>
References: <e5c7971f-a600-08ec-0f31-8f255bd99979@trained-monkey.org>
To: Jes Sorensen <jes@trained-monkey.org>,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3774.300.61.1.2)
X-Spam-Level: *
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0ynlNqpu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=p3VjQTPU
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.13 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 BAYES_HAM(-0.12)[66.60%];
	 FROM_HAS_DN(0.00)[];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCPT_COUNT_FIVE(0.00)[5];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 TO_DN_ALL(0.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 NEURAL_HAM_SHORT(-0.20)[-0.995];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Score: -1.13
X-Rspamd-Queue-Id: 04206220AA
X-Spam-Flag: NO

Hi Jes,

Thanks for extending the maintainer list by adding Mariusz.=20

Hi Mariusz,

Congratulations! And thank you for the long time contribution, in the =
past and in the future :-)

Coly Li

> 2023=E5=B9=B412=E6=9C=8814=E6=97=A5 22:18=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi
>=20
> I wanted to let everyone know that Mariusz Tkaczyk is joining as mdadm
> co-maintainer.
>=20
> Anyone who has spent time on this list over the last couple of years
> knows Mariusz as a serious and thorough patch reviewer and I believe =
he
> will do a great job as co-maintainer. Most people will also have =
noticed
> I have been struggling keeping up due to lack of time, especially =
since
> mdadm is no longer directly linked to my daytime job. Having Mariusz
> onboard should help us progress faster.
>=20
> Thanks for stepping up Mariusz!
>=20
> Jes

