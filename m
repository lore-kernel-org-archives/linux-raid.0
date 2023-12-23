Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62B93D2E4
	for <linux-raid@vger.kernel.org>; Sat, 23 Dec 2023 12:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eYnDfVSb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kCO4ny6I";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eYnDfVSb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="kCO4ny6I"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 209D01F38C;
	Sat, 23 Dec 2023 12:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703335371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vR4gz1cLDKBadwLkSdvwq9zPKp8EpjsJWUrBAd9www=;
	b=eYnDfVSbidtpDNvaj98SLFZ5Cp6pjak9j+Kd/87Wo/jcyvu+QbmsryDxXyHrsoeH8tCc0u
	i/FntBY7eLaP2y2lksEsMmYtGnM7exr1elHO9szxP44WC9iSaiIi90g+DqEmMSOyXDP1o5
	KE7raiEc1gbr9tDWKmvNkQjzSjIh0Ms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703335371;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vR4gz1cLDKBadwLkSdvwq9zPKp8EpjsJWUrBAd9www=;
	b=kCO4ny6I6IybNwF70T7LjyCrKsb1QHfIJO9xJ5zi8IzK07wzHcBuVo8Xbhsm3S/Hf03pJN
	u1gDxcTEG2LB36CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703335371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vR4gz1cLDKBadwLkSdvwq9zPKp8EpjsJWUrBAd9www=;
	b=eYnDfVSbidtpDNvaj98SLFZ5Cp6pjak9j+Kd/87Wo/jcyvu+QbmsryDxXyHrsoeH8tCc0u
	i/FntBY7eLaP2y2lksEsMmYtGnM7exr1elHO9szxP44WC9iSaiIi90g+DqEmMSOyXDP1o5
	KE7raiEc1gbr9tDWKmvNkQjzSjIh0Ms=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703335371;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2vR4gz1cLDKBadwLkSdvwq9zPKp8EpjsJWUrBAd9www=;
	b=kCO4ny6I6IybNwF70T7LjyCrKsb1QHfIJO9xJ5zi8IzK07wzHcBuVo8Xbhsm3S/Hf03pJN
	u1gDxcTEG2LB36CQ==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id DFB47139C4;
	Sat, 23 Dec 2023 12:42:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id Kl90I8jVhmWmVAAAn2gu4w
	(envelope-from <colyli@suse.de>); Sat, 23 Dec 2023 12:42:48 +0000
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
In-Reply-To: <20231223122523.auzswchtrsrlc5vp@localhost>
Date: Sat, 23 Dec 2023 20:42:35 +0800
Cc: Luis Chamberlain <mcgrof@kernel.org>,
 Yu Kuai <yukuai1@huaweicloud.com>,
 Song Liu <song@kernel.org>,
 "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <28E06ABA-0861-486A-9C7F-2C3D4E7F0AED@suse.de>
References: <20231221044925.10178-1-colyli@suse.de>
 <aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
 <ZYSPS+yUlzTYETgh@bombadil.infradead.org>
 <B44FA0F9-2A85-41C7-830E-C552E796222C@suse.de>
 <CGME20231222173129eucas1p297a35e505eb08c27963ab4bf7ff1e9b6@eucas1p2.samsung.com>
 <ZYXH5vtBkkHRaVJ2@bombadil.infradead.org>
 <20231223122523.auzswchtrsrlc5vp@localhost>
To: Joel Granados <j.granados@samsung.com>
X-Mailer: Apple Mail (2.3774.300.61.1.2)
X-Spam-Level: ******
X-Spam-Level: 
X-Spamd-Result: default: False [0.40 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-0.00)[29.44%];
	 FROM_HAS_DN(0.00)[];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 TO_DN_ALL(0.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Score: 0.40
X-Spam-Flag: NO



> 2023=E5=B9=B412=E6=9C=8823=E6=97=A5 20:25=EF=BC=8CJoel Granados =
<j.granados@samsung.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, Dec 22, 2023 at 09:31:18AM -0800, Luis Chamberlain wrote:
>> On Fri, Dec 22, 2023 at 06:17:47PM +0800, Coly Li wrote:
>>>=20
>>>=20
>>>> 2023=E5=B9=B412=E6=9C=8822=E6=97=A5 03:17=EF=BC=8CLuis Chamberlain =
<mcgrof@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> On Thu, Dec 21, 2023 at 02:19:56PM +0800, Yu Kuai wrote:
>>>>> I can't find this by code review, and I think
>>>>> maybe it's better to fix this in sysctl error path.
>>>>=20
>>>> Indeed, we want to fix anything in the way to remove the empty =
sentinel,
>>>> we continue to do that in queued work on sysctl-next [0]. Although =
I
>>>> won't be able to diagnose this right away, could you try the out of
>>>> bounds fix by Joel [1] instead?
>>>>=20
>>>> We want to identify what caused this and fix it within sysctl code.
>>>>=20
>>>> [0] =
https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/log/?h=3D=
sysctl-next
>>>> [1] =
https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/commit/?h=
=3Dsysctl-next&id=3Dfd696ee2395755a292f7d49bf4c701a5bab2f076
>>>=20
>>> Hi Luis,
>>>=20
>>> Thanks of the above information. IMHO your code is good, When I =
cherry
>>> pick the upstream md code for testing, the sysctl related change
>>> leaked from my eyes. please ignore my noise.=20
>=20
> So this was triggered because the tree was missing the changes that
> actually handled the removal of the sentinel?
>=20

It was from a regular update of the subsystem I maintainer for our own =
product. This is quite common to happen when a tree wide changes happen =
and subsystem maintainers of downstream products were not aware of the =
changes out of the subsystem.

Just as I said, please ignore the noise.

How to avoid such unnecessary noise? Maybe the patches to subsystems =
should add more information about the tree wide changes, e.g. this patch =
goes with the core change of xxx, when you pick it for backport please =
also be aware of the changes in xxxx.

But this is suggestion and not mandatory, finally the developer who =
partially picked patches for  his backport will find out where he made =
mistake. Just like this time.


> Get back to me if the oops persists even after you have included the
> changes in sysctl-next

Thanks for the help. I do appreciate :-)

Coly Li=
