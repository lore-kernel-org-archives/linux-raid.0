Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016ED1D4161;
	Tue,  5 Nov 2024 07:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730791593; cv=none; b=fsoxUJMQMQW0+N/1/VV7tzTcUwSspv8iKbrabahFJOvJuNp/OMIpPU7FJOylaqxJij+AQ/1DcKVsSBGJvit+v7nREADPVTbJHAgFpyTP9Ln0Bb7fDjEjmXmuKjuOgZ4AfD7BSMBfIDo+nTnyY1Exp7R6vl3rd5/W8Y2MDfz55TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730791593; c=relaxed/simple;
	bh=cGRU0+Lk6DlrmIujWp5Yr0HZxqaSSDFoVCLAF1HHb3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vhvnysbf+ULcx/bCrtT/iWPBrsmX27efLDlKyOMOSBQiryMgV3KkQUnsWYxk9NhoPEr7t+vkUApeaWt+JoJSdWVJM6M00mpKAn5em8XTkLUcTZT3CfhBoZoo04Lck1vXHFkxZreBWvmMnVW6QPrv8uqCZtHiWDuAbZuoFTYAmaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xgc3uhNV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nltLF65I; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=xgc3uhNV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=nltLF65I; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xgc3uhNV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nltLF65I";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="xgc3uhNV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nltLF65I"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0EDCD1FBAF;
	Tue,  5 Nov 2024 07:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVrqpQODTISyi63pWB1uVuqAwQ341DzseJPkhqzn6gc=;
	b=xgc3uhNVsHx3+isMiZ0yPCyz+bOZKTxYrOmRaIuWl1mk9AAzsrPVX2VpshcOy8Yfgi5AAX
	Cdjezm9oPe4Pt7wYxHWSmbVDBrheeDVnA5Gg/QvOVwwqFFKF7tj4kG/EIJjvzS94rbm0RH
	6P2TaiKC/lPTJQ+Wo74r/T+touB/c64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVrqpQODTISyi63pWB1uVuqAwQ341DzseJPkhqzn6gc=;
	b=nltLF65I5/jqh4KZr73QlFSJoWi14kyGI1GEonkegrP8JU0Nnd5XMl+l+uvihx7B02RNaI
	OYvN6SMUjLFPFQCw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1730791590; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVrqpQODTISyi63pWB1uVuqAwQ341DzseJPkhqzn6gc=;
	b=xgc3uhNVsHx3+isMiZ0yPCyz+bOZKTxYrOmRaIuWl1mk9AAzsrPVX2VpshcOy8Yfgi5AAX
	Cdjezm9oPe4Pt7wYxHWSmbVDBrheeDVnA5Gg/QvOVwwqFFKF7tj4kG/EIJjvzS94rbm0RH
	6P2TaiKC/lPTJQ+Wo74r/T+touB/c64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1730791590;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qVrqpQODTISyi63pWB1uVuqAwQ341DzseJPkhqzn6gc=;
	b=nltLF65I5/jqh4KZr73QlFSJoWi14kyGI1GEonkegrP8JU0Nnd5XMl+l+uvihx7B02RNaI
	OYvN6SMUjLFPFQCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A37E81394A;
	Tue,  5 Nov 2024 07:26:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AXodJqXIKWejGAAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 05 Nov 2024 07:26:29 +0000
Message-ID: <bff0e388-6190-4465-9ab1-8a2b65ff4f71@suse.de>
Date: Tue, 5 Nov 2024 08:26:29 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 yukuai3@huawei.com, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Johannes.Thumshirn@wdc.com
References: <20241031095918.99964-1-john.g.garry@oracle.com>
 <20241031095918.99964-6-john.g.garry@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20241031095918.99964-6-john.g.garry@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.30
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
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	URIBL_BLOCKED(0.00)[suse.de:mid,suse.de:email,oracle.com:email,imap1.dmz-prg2.suse.org:helo];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,oracle.com:email,suse.de:mid,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

On 10/31/24 10:59, John Garry wrote:
> Add proper bio_split() error handling. For any error, call
> raid_end_bio_io() and return.
> 
> For the case of an in the write path, we need to undo the increment in
> the rdev pending count and NULLify the r1_bio->bios[] pointers.
> 
> For read path failure, we need to undo rdev pending count increment from
> the earlier read_balance() call.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid1.c | 33 +++++++++++++++++++++++++++++++--
>   1 file changed, 31 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
