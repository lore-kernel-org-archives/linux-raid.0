Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E83111704
	for <linux-raid@vger.kernel.org>; Fri, 22 Dec 2023 10:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ICPbBFSb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xwxVbM2y";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ICPbBFSb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="xwxVbM2y"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0747621FC1;
	Fri, 22 Dec 2023 10:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703240283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eqDFqDF1s9j0x4MAUu6avch2krhSFygpUTgrAR+WkVQ=;
	b=ICPbBFSbUMlbfWdq4CAgtbKG407GqfrHzzlSv0cLv6fJwgNEZ3xyLnInPbSmesCryiufc9
	N3eRZW5QFxlSEsFvBlfec3HVaEZN+LJqAFTknBJcJrzOVEhvySQwN7tRSQkZ3IOYuEIAUk
	ZXWhIbd9fTFtFyYvy1KJvYM8Jcp4doM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703240283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eqDFqDF1s9j0x4MAUu6avch2krhSFygpUTgrAR+WkVQ=;
	b=xwxVbM2yN4rIB+YzpPvm3805befmsLmaNU3CRt+aFunUgHuNSYc5GKezLG0nwhW/9SSCp/
	BPNsOZbsJ9r6UHBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703240283; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eqDFqDF1s9j0x4MAUu6avch2krhSFygpUTgrAR+WkVQ=;
	b=ICPbBFSbUMlbfWdq4CAgtbKG407GqfrHzzlSv0cLv6fJwgNEZ3xyLnInPbSmesCryiufc9
	N3eRZW5QFxlSEsFvBlfec3HVaEZN+LJqAFTknBJcJrzOVEhvySQwN7tRSQkZ3IOYuEIAUk
	ZXWhIbd9fTFtFyYvy1KJvYM8Jcp4doM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703240283;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eqDFqDF1s9j0x4MAUu6avch2krhSFygpUTgrAR+WkVQ=;
	b=xwxVbM2yN4rIB+YzpPvm3805befmsLmaNU3CRt+aFunUgHuNSYc5GKezLG0nwhW/9SSCp/
	BPNsOZbsJ9r6UHBg==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id ACFB9139C4;
	Fri, 22 Dec 2023 10:18:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id sANtFlhihWVaZgAAn2gu4w
	(envelope-from <colyli@suse.de>); Fri, 22 Dec 2023 10:18:00 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: Re: [PATCH] Revert "raid: Remove now superfluous sentinel element
 from ctl_table array"
From: Coly Li <colyli@suse.de>
In-Reply-To: <ZYSPS+yUlzTYETgh@bombadil.infradead.org>
Date: Fri, 22 Dec 2023 18:17:47 +0800
Cc: Yu Kuai <yukuai1@huaweicloud.com>,
 Joel Granados <j.granados@samsung.com>,
 song@kernel.org,
 linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B44FA0F9-2A85-41C7-830E-C552E796222C@suse.de>
References: <20231221044925.10178-1-colyli@suse.de>
 <aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
 <ZYSPS+yUlzTYETgh@bombadil.infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
X-Mailer: Apple Mail (2.3774.300.61.1.2)
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Bar: /
X-Spam-Flag: NO
X-Spamd-Result: default: False [-0.45 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 BAYES_HAM(-0.64)[82.47%];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ICPbBFSb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xwxVbM2y
X-Spam-Score: -0.45
X-Rspamd-Queue-Id: 0747621FC1



> 2023=E5=B9=B412=E6=9C=8822=E6=97=A5 03:17=EF=BC=8CLuis Chamberlain =
<mcgrof@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Thu, Dec 21, 2023 at 02:19:56PM +0800, Yu Kuai wrote:
>> I can't find this by code review, and I think
>> maybe it's better to fix this in sysctl error path.
>=20
> Indeed, we want to fix anything in the way to remove the empty =
sentinel,
> we continue to do that in queued work on sysctl-next [0]. Although I
> won't be able to diagnose this right away, could you try the out of
> bounds fix by Joel [1] instead?
>=20
> We want to identify what caused this and fix it within sysctl code.
>=20
> [0] =
https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=3D=
sysctl-next
> [1] =
https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/commit/?h=
=3Dsysctl-next&id=3Dfd696ee2395755a292f7d49bf4c701a5bab2f076

Hi Luis,

Thanks of the above information. IMHO your code is good, When I cherry =
pick the upstream md code for testing, the sysctl related change leaked =
from my eyes. please ignore my noise.=20

Coly Li

