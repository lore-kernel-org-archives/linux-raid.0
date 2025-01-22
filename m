Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2BF212B2D
	for <linux-raid@vger.kernel.org>; Wed, 22 Jan 2025 12:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737549832; cv=none; b=KnmZk9fXm/J45BS3uMfThTNg1fpCBwVlsxcShyZOMoAxVE7fbg4KFMlsWy49yMqUVWcGi+0fTDv17U2ZIwgEJqHslDclN1nGAN8JfM/YvO9RaiFPA+rn4Bplfdt6f4ub9MiOSmbcKZ9tBE5SP28XkiShHquBdoIGmNJjZxdtMfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737549832; c=relaxed/simple;
	bh=4MNXJM29i2UqDEEYCxKOn2F/8eCPTBa9B7VgW8f4T68=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BueLVcqUEzvEXF1GH1Qk3WRhEjNzJEyXv0uohXQkfKvnZS3kf6GF/nt3oCWV0TBALGSNfYSuzTLmP+NlMaAI/tLLDGEBY5mLYbXWypM2rO2gYq0mYGGqQGe0ElaY69oeNjAwBiwQggMUvXGGj5CDFk44p1tl8+0CvLrj1aWbSJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=VUqShW04; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=my4CXm4N; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=rgTx0Sw6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=cxmIUeXO; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VUqShW04";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="my4CXm4N";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="rgTx0Sw6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="cxmIUeXO"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9AB90216EC;
	Wed, 22 Jan 2025 12:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737549829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MNXJM29i2UqDEEYCxKOn2F/8eCPTBa9B7VgW8f4T68=;
	b=VUqShW04jOUXLuLJcJDrOn5LBqUjhS+Rencb4suV+U/nrwp+bbNi8tpH65bAA1IDQN5K01
	WhIdWqHyMVQ83s0mUkxYlsRwODlJ2lB99bLhVoIvZtdaBaQDFl1x2UkGJVdSDQA5u0fa6J
	EDMY3J2ewVI5/hriVUqqCPGhrdSUK6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737549829;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MNXJM29i2UqDEEYCxKOn2F/8eCPTBa9B7VgW8f4T68=;
	b=my4CXm4NtuMV9rlkTEiEAH60EG9w1GMRvFXoQxKpnaxZfnRwTKkGwg4SDeHGMgW/XdbwXQ
	Q4jrsog/YvDKYhDQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1737549828; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MNXJM29i2UqDEEYCxKOn2F/8eCPTBa9B7VgW8f4T68=;
	b=rgTx0Sw6Y5StWPzz72yANyqjzbnQiyFKukN79HQSTgVSDCsikC0mOYncgtcRgjx0H4srGx
	VrVDq6ZmGYwjs06w77JlCsig/rOj1S86DBTof0wCIYS96ND+IFmc+uUysBPTDpvM0a3vyU
	qg9QsXOHlAjLpAL0hMnxeF5A4Ug8d2g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1737549828;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4MNXJM29i2UqDEEYCxKOn2F/8eCPTBa9B7VgW8f4T68=;
	b=cxmIUeXOU+9vEwD0ZzxfWZk5M7xg/wQCyfv3XugkbtT+jflyJSsc5gm5nKKloSIXKw5src
	fLbC7EdUOO77FHAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BCD9C136A1;
	Wed, 22 Jan 2025 12:43:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v9gYHQPokGc4XAAAD6G6ig
	(envelope-from <colyli@suse.de>); Wed, 22 Jan 2025 12:43:47 +0000
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
In-Reply-To: <20250122130136.04011312@mtkaczyk-private-dev>
Date: Wed, 22 Jan 2025 20:43:19 +0800
Cc: linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9F1A4711-351B-4E58-BC5F-D281AC936A4A@suse.de>
References: <20250122035359.251194-1-colyli@suse.de>
 <20250122130136.04011312@mtkaczyk-private-dev>
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



> 2025=E5=B9=B41=E6=9C=8822=E6=97=A5 20:01=EF=BC=8CMariusz Tkaczyk =
<mtkaczyk@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Coly,
> I read that once again and I have more comments. Even if it
> looks simple, we are calling many env commands in mdadm, that is why =
I'm
> trying to be careful.
>=20
> On Wed, 22 Jan 2025 11:53:59 +0800
> Coly Li <colyli@suse.de> wrote:
>=20
>> During the boot process if mdadm is called in udev context, sbin =
paths
>> like /sbin, /usr/sbin, /usr/local/sbin normally not defined in PATH
>=20
> normally defined? Please remove "not".

This is correct, normally NOT defined. In boot time udev tasks just =
normally called
binaries in their private directory, they don=E2=80=99t call system =
binaries.

>=20
>> env variable, calling system("modprobe md_mod") in
>> create_named_array() may fail with 'sh: modprobe: command not found'
>> error message.
>>=20
>> We don't want to move modprobe binary into udev private directory, so
>> setting the PATH env is a more proper method to avoid the above =
issue.
>=20
> Curios, did you verified what is happening to our "systemctl" calls?
>=20
> mdmon and grow-continue are started this way, they are later followed =
by
> "WANTS=3D" in udev rule so the issue there is probably hidden, maybe =
we
> should fix these calls too?

For this specific case, md kernel module was not loaded yet, it was in =
quite early
stage from observation of me and bug reporter.


>=20
>>=20
>> This patch sets PATH env variable with
>> "/sbin:/usr/sbin:/usr/local/sbin" before calling system("modprobe
>> md_mod"). The change only takes effect within the udev worker
>> context, not seen by global udev environment.
>=20
> If we are running app from terminal (i.e mdadm -I, or ./mdadm -I) this
> change should not affect the terminal environment. I verified it to be
> sure. Could you please mention that in description?
>=20

OK, let me do it in next version.

>>=20
>> Signed-off-by: Coly Li <colyli@suse.de>
>> ---
>> Changelog,
>> v2: set buf[PATH_MAX] to 0 in stack variable announcement.
>> v1: the original version.
>>=20
>>=20
>> mdopen.c | 11 +++++++++++
>> 1 file changed, 11 insertions(+)
>>=20
>> diff --git a/mdopen.c b/mdopen.c
>> index 26f0c716..65bd8a1b 100644
>> --- a/mdopen.c
>> +++ b/mdopen.c
>> @@ -39,6 +39,17 @@ int create_named_array(char *devnm)
>>=20
>> fd =3D open(new_array_file, O_WRONLY);
>> if (fd < 0 && errno =3D=3D ENOENT) {
>> + char buf[PATH_MAX] =3D {0};
>> +
>> + /*
>> + * When called by udev worker context, path of
>> modprobe
>> + * might not be in env PATH. Set sbin paths into PATH
>> + * env to avoid potential failure when run modprobe
>> here.
>> + */
>> + snprintf(buf, PATH_MAX - 1, "%s:%s", getenv("PATH"),
>> + "/sbin:/usr/sbin:/usr/local/sbin");
>=20
> We can get NULL returned by getenv("PATH"), should we handle it? We
> probably rely on compiler behavior here.
>=20
> I did simple test. I tried: printf("%s\n", getenv("NOT_EXISTING"));=20
> I got segmentation fault.

Yes, this was my fault, I took it for granted that PATH should always be =
set in udev context.

You are right, I will add a NULL check in next version.

>=20
>> + setenv("PATH", buf, 1);
>=20
> I see here portability issues. We, assume that these binaries must be
> in locations we added here. We may even double them, if they are
> already defined.
> Even if I know that probably no one is enough brave to
> not have base binaries there, we should not force our PATH. I think it
> is not our task and responsibility to deal with binaries location
> issues. We should take what system provided.
>=20
> I still think that we should pass locations during compilation. Here
> example with EXTRAVERSION, of course it may require some adjustments
> but it is generally the way it can be achieved:
> =
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D03ab9763=
f51ddf2030f60f83e76cf9c1b50b726c
>=20
> I'm not strong convinced to the option I proposed, I just need
> argument because more or less code is not an argument. What we will
> choose today will stay here for years, we need to choose the best
> possible way we see.

The installation path might vary, depends on the way how mdadm is =
installed. If from rpm or other
installation pack, the dest location can be predicted. If mdadm is =
installed from source code compiling,
the destination varies depends on the pre-defined installation location, =
similar situation happens in containers.

So the patch is just a best-effort-try, if the binary is not installed =
in /sbin, /usr/sbin or /usr/local/sbin, my patch just gives up.

>=20
>> +
>> if (system("modprobe md_mod") =3D=3D 0)
>> fd =3D open(new_array_file, O_WRONLY);
>=20
>> }
>=20
> The change will affect code executed later, probably we don't want
> that. Shouldn't we restore old PATH here to minimize risk?

For my understanding if the code was called after boot up, these path =
should be set already by shell initialization scripts.
And for udev context, it is called and exited, and NOT shared with other =
udev tasks, almost no influence.

Thanks for your detailed comments.

Coly Li=
