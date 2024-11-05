Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7661FE109;
	Tue,  5 Nov 2024 07:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730791647; cv=none; b=Y9nWQFPB1b2EixTpUI8n2JcugyGVN864HXVr9ErrJsQDahsbKR8WU5JW0oAejY0YiLrPeVoM50kJUV8toMMAT5zBBSGcsJ/5hlST7jY1pbzOVGTSQPjQG3UC485Gxn0+1v37o7UAkNYuxheTcAcrbOtN1MgB/s3OHn6gcH/7yyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730791647; c=relaxed/simple;
	bh=TiL8f4qfH+mjEN4L9NMWEtVGaq1x5lzs/dWxaSC4qRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZFKKYv0cRpuFyB79QMN9cUsk5JDxwjpAa0RbO/k0Sbwz0Ob+9E27d5DNjbsaTl7+6H8abQT0d3aaKAYKe3t6OZwnYqgis/eOEE3JSJxl6mj+x/0dyHCYZ1agDEPMQhDBcWCabzXFRrXEB9sKd2pfazXr+Dq5baTZAL6njft+M18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jBzBBe6d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Iqian8kt; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jBzBBe6d; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Iqian8kt; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jBzBBe6d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Iqian8kt";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="jBzBBe6d";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Iqian8kt"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A54001FBAF;
	Tue,  5 Nov 2024 07:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3K9u8hz3jWj7gG+61BlB4e2Y14/5VD9mLmISrQ/fRKY=;
	b=jBzBBe6dlqWxtuHzPgVZsp3zOK5M2d+S+/SDlx9R/wL8uTOS2b0k2Spgq2O2kLantzrt0n
	xWKmbDeMZ17QPEyk2+QXGYABvThWxj9kpYQ/rzgy9vsdPS8WQfpkaiYxcMXd2HpYrRSlmZ
	PTtBRbhrCA7CYAkWKqrjTq4Grd13XKA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3K9u8hz3jWj7gG+61BlB4e2Y14/5VD9mLmISrQ/fRKY=;
	b=Iqian8ktzmkGaOEsSM4CpnYaJNhr/1VSzY70zblgqxV3t9l/GU/Q/o08RD9qpwu0OGpjB7
	6fUJ4UYTI2mUVLCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3K9u8hz3jWj7gG+61BlB4e2Y14/5VD9mLmISrQ/fRKY=;
	b=jBzBBe6dlqWxtuHzPgVZsp3zOK5M2d+S+/SDlx9R/wL8uTOS2b0k2Spgq2O2kLantzrt0n
	xWKmbDeMZ17QPEyk2+QXGYABvThWxj9kpYQ/rzgy9vsdPS8WQfpkaiYxcMXd2HpYrRSlmZ
	PTtBRbhrCA7CYAkWKqrjTq4Grd13XKA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791643;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3K9u8hz3jWj7gG+61BlB4e2Y14/5VD9mLmISrQ/fRKY=;
	b=Iqian8ktzmkGaOEsSM4CpnYaJNhr/1VSzY70zblgqxV3t9l/GU/Q/o08RD9qpwu0OGpjB7
	6fUJ4UYTI2mUVLCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 496BD1394A;
	Tue,  5 Nov 2024 07:27:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 40LYD9vIKWfnGAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 05 Nov 2024 07:27:23 +0000
Message-ID: <ce5f93d0-71da-4364-8e6f-064447b49fde@suse.de>
Date: Tue, 5 Nov 2024 08:27:22 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] md/raid10: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-7-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241031095918.99964-7-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,oracle.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -4.30
X-Spam-Flag: NO

On 10/31/24 10:59, John Garry wrote:
> Add proper bio_split() error handling. For any error, call
> raid_end_bio_io() and return. Except for discard, where we end the bio
> directly.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 46 insertions(+), 1 deletion(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
