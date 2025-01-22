Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1DF4D8CE
	for <linux-raid@vger.kernel.org>; Wed, 22 Jan 2025 15:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737559830; cv=none; b=sf025GyaKpbw0M7zLgEhvf7lltXJpyGJhLhwsvj3l5cSqdH34WFP1Q5S6MMtzm3CSb12abLfyQUqUGU5y6qUm1wg71iXzqcaQ/lSvbziAUpvdYKURIqIXF1dGcT1T/dySJgg8QBfoc7m1BS86pBpAiLovNY43pnuqqzO44IAJgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737559830; c=relaxed/simple;
	bh=nIz06pjEDl3z03s7M8ReF/2pyFg4/auv/2HeutDai/o=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=fDFe+YyWYrwkWdi0V2ASqp87JKvA2yXOFJU85k0hayC1U7Em+F32ng+648jl50I4SDvLrk/7AyiNt5J0ZjxBM77a344gBlrP8VszZyyRfaFixU4Pn1G/GqKF3vUsc+ZkW4qHh6FrWEfNxbUc8NY+SoVwt5cfUg5Msr0wnFLGUDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0g7vyKCy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2PI9cAoo; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=0g7vyKCy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2PI9cAoo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0g7vyKCy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2PI9cAoo";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="0g7vyKCy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2PI9cAoo"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A18B2218E5;
	Wed, 22 Jan 2025 15:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737559826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nIz06pjEDl3z03s7M8ReF/2pyFg4/auv/2HeutDai/o=;
	b=0g7vyKCyHL+83YE+l9ZKw8zwzfthIhu0oZitdTVXryjO5kI58YtCrB/AXTqz7RXLfbWPNk
	63AMlHvQ2Fm3Rb1+VJDcgQmy/0n8DWNtBEzOrL1iCoxltUVqo68kXSmN8RykODNPV+EkOo
	fPc4qg7gZ0POQaWnxPiEKy0gS5PcM3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737559826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nIz06pjEDl3z03s7M8ReF/2pyFg4/auv/2HeutDai/o=;
	b=2PI9cAoofcnlCw14c0gaPmkUVZGxP/lKH+kaMX9THXOHpmlB2GiMZIZuX/xG7nfqmXBUU+
	udQ2xU5uB48csiAg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0g7vyKCy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2PI9cAoo
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737559826; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nIz06pjEDl3z03s7M8ReF/2pyFg4/auv/2HeutDai/o=;
	b=0g7vyKCyHL+83YE+l9ZKw8zwzfthIhu0oZitdTVXryjO5kI58YtCrB/AXTqz7RXLfbWPNk
	63AMlHvQ2Fm3Rb1+VJDcgQmy/0n8DWNtBEzOrL1iCoxltUVqo68kXSmN8RykODNPV+EkOo
	fPc4qg7gZ0POQaWnxPiEKy0gS5PcM3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737559826;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nIz06pjEDl3z03s7M8ReF/2pyFg4/auv/2HeutDai/o=;
	b=2PI9cAoofcnlCw14c0gaPmkUVZGxP/lKH+kaMX9THXOHpmlB2GiMZIZuX/xG7nfqmXBUU+
	udQ2xU5uB48csiAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A563A1397D;
	Wed, 22 Jan 2025 15:30:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BQyDFREPkWcTWQAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 22 Jan 2025 15:30:25 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH v2]  mdopen: add sbin path to env PATH when call
 system("modprobe md_mod")
From: Coly Li <colyli@suse.de>
In-Reply-To: <20250122142655.031435cc@mtkaczyk-private-dev>
Date: Wed, 22 Jan 2025 23:30:08 +0800
Cc: linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4147907D-FE0C-42BC-AD59-FB0ADB8E0362@suse.de>
References: <20250122035359.251194-1-colyli@suse.de>
 <20250122130136.04011312@mtkaczyk-private-dev>
 <9F1A4711-351B-4E58-BC5F-D281AC936A4A@suse.de>
 <20250122142655.031435cc@mtkaczyk-private-dev>
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
X-Mailer: Apple Mail (2.3826.300.87.4.3)
X-Rspamd-Queue-Id: A18B2218E5
X-Spam-Level: 
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:25478, ipnet:::/0, country:RU];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim,suse.de:mid,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01
X-Spam-Flag: NO



> 2025=E5=B9=B41=E6=9C=8822=E6=97=A5 21:26=EF=BC=8CMariusz Tkaczyk =
<mtkaczyk@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed, 22 Jan 2025 20:43:19 +0800
> Coly Li <colyli@suse.de> wrote:
>>=20

[snipped]

>> So the patch is just a best-effort-try, if the binary is not
>> installed in /sbin, /usr/sbin or /usr/local/sbin, my patch just gives
>> up.
>>=20
>=20
> Maybe we can print error then? It would be useful for programmers
> to understand the problem. Sometimes, to debug early stages I simply
> redirected all error messages from mdadm to /dev/kmsg.
>=20

Currently there is error message: sh: modprobe: command not found.
This message was caught from console and this was how the root cause was =
found.

This might be enough?


>=20
>>>=20
>>>> +
>>>> if (system("modprobe md_mod") =3D=3D 0)
>>>> fd =3D open(new_array_file, O_WRONLY); =20
>>>=20
>>>> } =20
>>>=20
>>> The change will affect code executed later, probably we don't want
>>> that. Shouldn't we restore old PATH here to minimize risk? =20
>>=20
>> For my understanding if the code was called after boot up, these path
>> should be set already by shell initialization scripts. And for udev
>> context, it is called and exited, and NOT shared with other udev
>> tasks, almost no influence.
>=20
> I see, it is more theoretical problem, almost to possible to met.
> All fine then, we can continue with no clean up here as I cannot find
> normal scenario it can occur.
>=20
> Your change (after getenv fixes) LGTM. You can take a look into =
concept
> I proposed but I have no strong preference.

Copied. V3 posted.

Thanks.

Coly Li


