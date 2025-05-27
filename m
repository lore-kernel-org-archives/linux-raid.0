Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 209771E008B
	for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 05:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748325335; cv=none; b=BZ86PYlaQPihqz4xM//H4MrmWzbQ7NbZaJakKtc9P517l32j0yqYXQ5gQmSTv+2GSBAUzg6v/XA8UcRHlzzVCRK0Fdfu1N16ASgwkrB6xB/VqKZGA8T08gppArbXkc9xN4B6Gnm2klDlugcGUFwOE4leTnZ6B5KOppcsH/+ZJhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748325335; c=relaxed/simple;
	bh=baQmD9RPmEy7qG95jtjCIbZVdKDKg/8cNAGxlhvT6ho=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tIVugKcU8qttV4nbFhLtD/h21A7sucHQjhavo18FpOh+Y0TRD65TYRoCdBK2PbZjMHRjbnOITT87u3Fersl+qpVHHwTG/INl1GHgjtsYyETGHTLbUsJqJVgrGLPhjJfLZlz49ck5PvVoqwYGZ+YkXh61rRap8ia4pawia4/hrMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Yk4UUYT4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AFZCcsZL; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Yk4UUYT4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=AFZCcsZL; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Yk4UUYT4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AFZCcsZL";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Yk4UUYT4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="AFZCcsZL"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A2E91FDB6;
	Tue, 27 May 2025 05:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QDHetXb/eGzoUDRsMu2WUKUJfrLulGzaS7m+camrstc=;
	b=Yk4UUYT4IZ/68F3GJhfk9rbgh6vdlbVxBiAG4UZ6QGhP/PXMVWbqooJCI4Zp/6E0WjTF8t
	EF5PsqFohsxLUNUWCbzAB3oh3h0GbsspFcc+S3Iohcv0UokluQEG1JI/Lr52/kdTe23jtx
	yd6MSCfkxl4/gMCGrJE0TUK+0maItUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325332;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QDHetXb/eGzoUDRsMu2WUKUJfrLulGzaS7m+camrstc=;
	b=AFZCcsZLBuCW3vfsSWY5LYBegJ3tKsLVVzAfsYyIK1hnkgUKHXv0EyioAwDwIeXARuVTz+
	/LKu3Gx5svJeR3Ag==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1748325332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QDHetXb/eGzoUDRsMu2WUKUJfrLulGzaS7m+camrstc=;
	b=Yk4UUYT4IZ/68F3GJhfk9rbgh6vdlbVxBiAG4UZ6QGhP/PXMVWbqooJCI4Zp/6E0WjTF8t
	EF5PsqFohsxLUNUWCbzAB3oh3h0GbsspFcc+S3Iohcv0UokluQEG1JI/Lr52/kdTe23jtx
	yd6MSCfkxl4/gMCGrJE0TUK+0maItUc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1748325332;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QDHetXb/eGzoUDRsMu2WUKUJfrLulGzaS7m+camrstc=;
	b=AFZCcsZLBuCW3vfsSWY5LYBegJ3tKsLVVzAfsYyIK1hnkgUKHXv0EyioAwDwIeXARuVTz+
	/LKu3Gx5svJeR3Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8CB1136E0;
	Tue, 27 May 2025 05:55:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 03gDL9NTNWhhEwAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 27 May 2025 05:55:31 +0000
Message-ID: <88d3c914-0510-42bb-b9ba-4745fa470e7c@suse.de>
Date: Tue, 27 May 2025 07:55:31 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/23] md: factor out a helper raid_is_456()
To: Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de, xni@redhat.com,
 colyli@kernel.org, song@kernel.org, yukuai3@huawei.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-3-yukuai1@huaweicloud.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20250524061320.370630-3-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -3.10
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.10 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]
X-Spam-Level: 

On 5/24/25 08:12, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> There are no functional changes, the helper will be used by llbitmap in
> following patches.
> 
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>   drivers/md/md.c | 9 +--------
>   drivers/md/md.h | 6 ++++++
>   2 files changed, 7 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
