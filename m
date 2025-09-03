Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BECB283CBD
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 12:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756902943; cv=none; b=GV7rRlCv2Ym6u5orPNyojxKGsrZlYNGqX06NcmOmyzfAci608cKTvC8OIdiUyqxG/hFkp4lal4ykLEgnk9cQbscZRi+P4SixI5EQ45X6yH0RuLz2KiqSQAijacFhF/3VEYc+N9/JT1+CejP/DgoOn9pjd3Lq4jP5cy+3kBugSts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756902943; c=relaxed/simple;
	bh=93LDiLn2Bsaj5xutdH6sVXerFMVT3fsouyULipnIfVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=u91/ZjQTKJwQ02gRixYnQY4pZ6UYlSi80DkIG50qVwP+3XyJ3Kc28fFARrInLJPMh0a5CuElzUMEFWjOzUU1HR7sn5+sy5xz1hMyF/v6872YDGxZ0yNyFuM0JuDmP0eFVgCu4EXZFi72vs8flRgn7oOv/N8o4QNwabEuU2lL2+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eXtxlqAy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v35cduo1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=eXtxlqAy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=v35cduo1; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eXtxlqAy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v35cduo1";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="eXtxlqAy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="v35cduo1"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3865621206;
	Wed,  3 Sep 2025 12:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756902940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgcyrXxmX4h+0wV9cfbMYGpHRZQ4bIHASK/621rrHjI=;
	b=eXtxlqAy97XkMC22lcqlmg473P6d5siH6OFTutCac68KXt24lpQUnn9MinxIDv9RPz1euJ
	NuQ5FXCsSO6FKcGeEa6j9GUHpUVpJ2UmZCXeEjXqKw4lKdy8uGDTesACrNzPyozIjKYlrF
	ISUEHu2OHZ8zRdAsQbNomUxcyS7KOBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756902940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgcyrXxmX4h+0wV9cfbMYGpHRZQ4bIHASK/621rrHjI=;
	b=v35cduo1GAtDhsDxMbjk7QtU76j+rS+etCquWJgMue8u6I6jEOjTx8oO6GVaQVtTGzwH7G
	zadA7TctER5VlNCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eXtxlqAy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=v35cduo1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756902940; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgcyrXxmX4h+0wV9cfbMYGpHRZQ4bIHASK/621rrHjI=;
	b=eXtxlqAy97XkMC22lcqlmg473P6d5siH6OFTutCac68KXt24lpQUnn9MinxIDv9RPz1euJ
	NuQ5FXCsSO6FKcGeEa6j9GUHpUVpJ2UmZCXeEjXqKw4lKdy8uGDTesACrNzPyozIjKYlrF
	ISUEHu2OHZ8zRdAsQbNomUxcyS7KOBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756902940;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FgcyrXxmX4h+0wV9cfbMYGpHRZQ4bIHASK/621rrHjI=;
	b=v35cduo1GAtDhsDxMbjk7QtU76j+rS+etCquWJgMue8u6I6jEOjTx8oO6GVaQVtTGzwH7G
	zadA7TctER5VlNCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2531D13A31;
	Wed,  3 Sep 2025 12:35:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MZBbCBw2uGiyMAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 03 Sep 2025 12:35:40 +0000
Message-ID: <c4fcc07a-eeaa-4307-8a5a-973c6df69bcd@suse.de>
Date: Wed, 3 Sep 2025 14:35:39 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 3865621206
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:mid,suse.de:email];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Score: -4.51

On 9/3/25 13:55, Stefanie Leisestreichler (Febas) wrote:
> Hi.
> I have the system layout shown below.
> 
> To avoid data loss, I want to change HDs which have about 46508 hours of 
> up time.
> 
> I thought, instead of degrading, formatting, rebuilding and so on, I could
> - shutdown the computer
> - take i.e. /dev/sda and do
> - dd bs=98304 conv=sync,noerror if=/dev/sda of=/dev/sdX (X standig for 
> device name of new disk)
> 
Why would you do that?
In the end, you will have to transfer data from the entire disk
(to a new disk). And that will be the main drag, at it'll take ages.
And there it doesn't matter if you use 'dd' or md resync; both will
be taking roughly the same time.

> Is it save to do it this way, presuming the array is in AA-State?
> 
I would not recommend it.
Replacing drives is _precisely_ why RAID was created in the first place,
so really there is no difference between replacing a faulty drive or
replacing a non-faulty drive.

So I would strongly recommend to use MD tools to replace the drive;
it will serve as a nice exercise on what to do in case of a real
fault :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
