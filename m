Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87E722B8AB
	for <linux-raid@vger.kernel.org>; Thu, 16 Oct 2025 06:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760594558; cv=none; b=LVhGcPipuh6TRmLZpydwnPRMYghXBupVZ0UP5UKlbIC3sh5LagXGuMXfABool3fDXslp7V0X2r5MuO4XYChIiCQjbI8rpYqNVJknkX7VRoz5BRJ4rDhFd47ALluB7PpFTMllPHt1g7im4ImzgaYH3z2oyJKcV4JS2XmwV9tec0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760594558; c=relaxed/simple;
	bh=ree1k2eoRKjk+Gp2k8ndstjRA2ZfEpuoIAZH5iSVoGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ISfnSHVOjOYu9dW70/OxlwdU2sO6BJiVbqu1ZeDYmaajmMJYZ82WDJNH5V8ITnxWqc62pSaJ5GBnjImoOytWL3n4PfWhln9+OmqWRa7HmJgPkzEK1op1jBmxdk843/eQcafyJz2bt+5kpI0s+Rvz7CI9cqOO3kAtUf+aC9GQI90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1lP7Ix0A; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I4xQBlKe; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=1lP7Ix0A; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=I4xQBlKe; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1lP7Ix0A";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I4xQBlKe";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1lP7Ix0A";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="I4xQBlKe"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id AE7EB1F7BE;
	Thu, 16 Oct 2025 06:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760594554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLG/iT3iF1JutIsDy/7itxRrjW1Dbf0lWGerg8QcpKc=;
	b=1lP7Ix0Axc6kdedcKD2HLUSCvWOQRLkCjHMk5iGLR3mn+JPzdnqXDoMPHS8DNQ+4mc+JnB
	l0cGcjs5L0TOlEleyXOgz0zBq1vOJSgVUae3cSuGZLdqv0+QlMXem0LZ3sBMF/dQCDnv6o
	2EvrK+G9QGrVLMNSQM0dDTXEPgXtt+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760594554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLG/iT3iF1JutIsDy/7itxRrjW1Dbf0lWGerg8QcpKc=;
	b=I4xQBlKeXzXGWa8oTTQy17fKnNKVhv5jw1TgqDmYMZUjyt3wM8PYslAdoNkg0ndJbyHjzJ
	RbUiJHwhZVPweDAQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760594554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLG/iT3iF1JutIsDy/7itxRrjW1Dbf0lWGerg8QcpKc=;
	b=1lP7Ix0Axc6kdedcKD2HLUSCvWOQRLkCjHMk5iGLR3mn+JPzdnqXDoMPHS8DNQ+4mc+JnB
	l0cGcjs5L0TOlEleyXOgz0zBq1vOJSgVUae3cSuGZLdqv0+QlMXem0LZ3sBMF/dQCDnv6o
	2EvrK+G9QGrVLMNSQM0dDTXEPgXtt+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760594554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WLG/iT3iF1JutIsDy/7itxRrjW1Dbf0lWGerg8QcpKc=;
	b=I4xQBlKeXzXGWa8oTTQy17fKnNKVhv5jw1TgqDmYMZUjyt3wM8PYslAdoNkg0ndJbyHjzJ
	RbUiJHwhZVPweDAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8EEF71340C;
	Thu, 16 Oct 2025 06:02:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FRAyIXqK8GipCQAAD6G6ig
	(envelope-from <hare@suse.de>); Thu, 16 Oct 2025 06:02:34 +0000
Message-ID: <92bc9643-53fe-4c56-abdd-7a9efb451f1c@suse.de>
Date: Thu, 16 Oct 2025 08:02:34 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: status of bugzilla #99171 - mdraid broken for O_DIRECT
To: Roland <devzero@web.de>, Reindl Harald <h.reindl@thelounge.net>,
 linux-raid@vger.kernel.org
References: <A4168F21-4CDF-4BAD-8754-30BAA1315C6F@web.de>
 <e686d669-c41f-42a7-be53-9538feb4721f@web.de>
 <9ef4398c-3488-492e-82ed-903fc46fed70@suse.de>
 <fd968202-04aa-48e3-bbd7-8520570d1ae2@web.de>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <fd968202-04aa-48e3-bbd7-8520570d1ae2@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_TO(0.00)[web.de,thelounge.net,vger.kernel.org];
	FREEMAIL_ENVRCPT(0.00)[web.de];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 

On 10/16/25 01:09, Roland wrote:
[ .. ]>
> thank you for your feedback.
> 
> i see, things are complicated and O_DIRECT is a very special beast....
> 
> meanwhile, i gave bcachefs a try today , because it looks interesting .
> 
> like zfs, it does not seem to be affected by this problem, at least from 
> my first tests reported at https://bugzilla.kernel.org/show_bug.cgi? 
> id=99171#c26 (i hope this is a valid test for consistency)
> 
> so we have at least a second "software raid" technology besides zfs, 
> which does NOT suffer from the "by design" O_DIRECT breakage.
> 
> that's at least surprising me, as bcachefs is far from production 
> ready,  and i wonder why it just seems to work at this early stage of 
> development.
> 
Hmm. True.

I would suggest bringing up this topic on linux-fsdevel; there is
always a chance that there is a bug somewhere.
At least some explanation would be warranted why bcachefs does not
suffer from this issue.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
