Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9831913A3ED
	for <linux-raid@vger.kernel.org>; Wed, 22 Jan 2025 01:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737511009; cv=none; b=ICSpnz9nhwiphh2F3KrT1P10mTW61EniLoRHT+T5XbK2DWSzmPyiTI7qIxM0W8K7nLD7h1l8lIO7EchSNNPuMt2aSCzkygGoiZ09m2Nb4f7S/TKsaA9CPGb7f/8AeHrNbRMNsos3G4agRnYM7szTKIAE/x105F7cwn8hfcucpkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737511009; c=relaxed/simple;
	bh=pvrPgQle6Y3gq2A91Ip4mxGXGLEnHomF8kNFbO5oVCc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ennwYE0CHk/x7sbD9JxGI6sXKX3LFRKB1i+cBrKFHQkzk+/WtgvaCn5Z8vnYJHbtyKl4hZwbvnJF/hK9NTURbAamrUb7dGMT/kTypyIY7xmdPDkJCOYsNnXe8Wf+/2aFpDrkWQrAes8RQZP5YmQ5yl+Sl7yla39PZ1KPN+HE804=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DLIsZ6sA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=tKFuW/4+; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bbNAKmr0; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Z/5+6fSd; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="DLIsZ6sA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="tKFuW/4+";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bbNAKmr0";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Z/5+6fSd"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6CF7621161;
	Wed, 22 Jan 2025 01:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737511005; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBfBY4G27HtZqXOwQWV7/LaLZXKbIs5IkZYEVRR1Bko=;
	b=DLIsZ6sAApPfCJeH6+5fdNOIrMQjIYwQwJh3H8Nmlw0yMv1MKuWuTmyJzsuqwOo5f6uXBJ
	A6P7uDkhpZg16dzOtMCrvVCJsqR5mlSiecGi0VAmnW0bt9kHgtuAcTPzEjBTiOzQxhZNG5
	FpIXhowL2lBTinjW4QpOzqjQZ+nR+cE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737511005;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBfBY4G27HtZqXOwQWV7/LaLZXKbIs5IkZYEVRR1Bko=;
	b=tKFuW/4+k/DrpbJsTTYL5Hl6gixm7PZ2Anq+dqWw1cW6ktV80ga4aNjIkOnYitLtddV34Q
	XGhCK4zwWsD8uDCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737511004; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBfBY4G27HtZqXOwQWV7/LaLZXKbIs5IkZYEVRR1Bko=;
	b=bbNAKmr0ta+sdQGiUCUsUaF/bqyISdUo0Dp7BCZWeBoZDPeFtDlur7hFl421QUhX6V+eNY
	9jPe7NOU2AQ9z+fbIOzLFXPLS65QgtC/ReXxjXJ+ggcPRfKyKrgwI+VEQQLziS2S3LD+sT
	KIBqX24YnktpCH7deOvfKlMgMHLOTZc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737511004;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBfBY4G27HtZqXOwQWV7/LaLZXKbIs5IkZYEVRR1Bko=;
	b=Z/5+6fSd/G9E+Te4Njw+bM+SEtiLhyOd2sEC8lQT8RLmkOnBUfP8xDbQzUqclkBmE2AY+x
	f5m0lp7YrBvcXHCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8154A136A1;
	Wed, 22 Jan 2025 01:56:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RG5TCVtQkGffKAAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 22 Jan 2025 01:56:43 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [PATCH] mdopen: add sbin path to env PATH when call
 system("modprobe md_mod")
From: Coly Li <colyli@suse.de>
In-Reply-To: <20250121190925.0700621b@mtkaczyk-private-dev>
Date: Wed, 22 Jan 2025 09:56:26 +0800
Cc: linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4F214CB4-E466-47DB-8672-C65F9049C2A4@suse.de>
References: <20250121151603.235606-1-colyli@suse.de>
 <20250121190925.0700621b@mtkaczyk-private-dev>
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>
X-Mailer: Apple Mail (2.3826.300.87.4.3)
X-Spam-Score: -3.80
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MV_CASE(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 



> 2025=E5=B9=B41=E6=9C=8822=E6=97=A5 02:09=EF=BC=8CMariusz Tkaczyk =
<mtkaczyk@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, 21 Jan 2025 23:16:03 +0800
> Coly Li <colyli@suse.de> wrote:
>=20
>> During the boot process if mdadm is called in udev context, sbin =
paths
>> like /sbin, /usr/sbin, /usr/local/sbin normally not defined in PATH
>> env variable, calling system("modprobe md_mod") in
>> create_named_array() may fail with 'sh: modprobe: command not found'
>> error message.
>>=20
>> We don't want to move modprobe binary into udev private directory, so
>> setting the PATH env is a more proper method to avoid the above =
issue.
>>=20
>> This patch sets PATH env variable with
>> "/sbin:/usr/sbin:/usr/local/sbin" before calling system("modprobe
>> md_mod"). The change only takes effect within the udev worker
>> context, not seen by global udev environment.
>=20
> Hi Coly,
> Nice explanation, thanks!
>=20
>>=20
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>> mdopen.c | 12 ++++++++++++
>> 1 file changed, 12 insertions(+)
>>=20
>> diff --git a/mdopen.c b/mdopen.c
>> index 26f0c716..30cf781b 100644
>> --- a/mdopen.c
>> +++ b/mdopen.c
>> @@ -39,6 +39,18 @@ int create_named_array(char *devnm)
>>=20
>> fd =3D open(new_array_file, O_WRONLY);
>> if (fd < 0 && errno =3D=3D ENOENT) {
>> + char buf[PATH_MAX];
>> +
>> + /*
>> +  * When called by udev worker context, path of
>> modprobe
>> +  * might not be in env PATH. Set sbin paths into PATH
>> +  * env to avoid potential failure when run modprobe
>> here.
>> +  */
>> + memset(buf, 0, PATH_MAX);
>=20
> just:
> char buf[PATH_MAX] =3D {0};

OK, let me change this.

>=20
>> + snprintf(buf, PATH_MAX - 1, "%s:%s", getenv("PATH"),
>> +  "/sbin:/usr/sbin:/usr/local/sbin");
>> + setenv("PATH", buf, 1);
>=20
> Isn't it over-complicated? Why not simply:
> system("/sbin/modprobe md_mod");
>=20
> If modprobe is not always in /sbin (checked on my opensuse only)

Yes, it might be in /usr/local/sbin, /usr/sbin/ or somewhere else which =
I am not
able to take it for granted on other known or unknown distributions.


> we can make in configured during compilation, simple call `which
> modprobe` should do the job.
> What do you think?

Sure, it should work. But might be more complicated, I mean lines of =
code in total.

Thanks for the review.

Coly Li=
