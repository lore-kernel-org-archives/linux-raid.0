Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582643AC0FA
	for <linux-raid@vger.kernel.org>; Sat, 30 May 2026 11:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780142305; cv=none; b=gPpTsYqTUOFaBObhLvQ0TCM7tEqjtDDsmHZs1ydmrH+o0EJpusljtz42BuB4pYzpUQmwn5mnecNRhgMwOlBmaI8S2nU+fyPOT36c5S0XJXzd7zHZRX0SBU0c/C/DFvl5OV880UdcsOhy1wH9gsqX+ilP0cM1YKTio94oaOoE6Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780142305; c=relaxed/simple;
	bh=8bzO5cTFMO0Kp0T/hIYtP3TlvEIKTh6DrvZhXhFROzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTVkKwNt0t1UWhww3DctbLLxqKUQRjM6vHeCotu/91NRA4JKlPebTOz43blDDR0GgHtzHa3jOi1C2xr7SJncLeq6jkSg80Eti0rh+LlGJOGmoPeQqlK/KFfAFfApUhGrxqFAT2he+Ok0moBEH19mSZYHhPIMKA8aNu/6ndammU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=NWsL0z3N; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=dkYxoZCW; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=ba32gy7G; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=DwTeCX6x; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="NWsL0z3N";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="dkYxoZCW";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="ba32gy7G";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="DwTeCX6x"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8C74B6B8DD;
	Sat, 30 May 2026 11:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780142302; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KpLOPb3zkhvAiTOtwrhUxobUkKnE1nhcJgSSWUvtXhs=;
	b=NWsL0z3NH3KmmKer+blRkDPyfse0AB+obt0G/Y1LXoHEL8VhoNIKNbqMGZaPZNZrlrx4Ca
	4mByaFTLQ0Tm6dfKWu6mFYt9SyTJno7bh332p5TDoB0tifGZY7749F5Y1czmrUBDVEFXlA
	E/xZCBDHwWxpxd4AKAuxQ1SNYP4mq4g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780142302;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KpLOPb3zkhvAiTOtwrhUxobUkKnE1nhcJgSSWUvtXhs=;
	b=dkYxoZCWPMDZSdVbIPiI0f0qDRGM35WeOZTfDXlPATyfom7RQKng+NgZmCapOokGhQFgpi
	JhqLvJG6R2BxJmDw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780142301; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KpLOPb3zkhvAiTOtwrhUxobUkKnE1nhcJgSSWUvtXhs=;
	b=ba32gy7GXE/UDUPTq21AQfrKZiQ+ONoI0rhGu6Eup6gVJY1yDnDOJoTS4o0vjrSDPdyZoY
	pfxQEHAtxXkkfjzHiKSB5UD/CCw0PYCy7TnbAVyecNn+7NJrbcIQmqZJcETXv7BwmspnaP
	UfN0TNYWvLyBzxSpGp+D6YweamFvPMM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780142301;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KpLOPb3zkhvAiTOtwrhUxobUkKnE1nhcJgSSWUvtXhs=;
	b=DwTeCX6xWPCK+w+DUE+6xG7Mm4j8f/8FZ7F4TB3k5RMcVS/z6IvlHYkvJ8Ewl9UrS4o50Y
	ZcDQQ5VnFe+FTpBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 823F1779A7;
	Sat, 30 May 2026 11:58:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6NXJH93QGmrVSwAAD6G6ig
	(envelope-from <jack@suse.cz>); Sat, 30 May 2026 11:58:21 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 42FFCA0EBD; Sat, 30 May 2026 13:58:17 +0200 (CEST)
Date: Sat, 30 May 2026 13:58:17 +0200
From: Jan Kara <jack@suse.cz>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v2 30/34] md-bitmap: Convert read_file_page and
 write_file_page to bh_submit()
Message-ID: <y73arbgifpvnmcmg5uzznfbrlhv3pfblayrbsfyzsjzuhccqpn@bijdwd3szzrg>
References: <20260528173150.1093780-1-willy@infradead.org>
 <20260528173150.1093780-31-willy@infradead.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528173150.1093780-31-willy@infradead.org>
X-Spam-Level: 
X-Spam-Score: -3.80
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_THREE(0.00)[3];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,infradead.org:email]

On Thu 28-05-26 18:31:43, Matthew Wilcox (Oracle) wrote:
> Avoid an extra indirect function call by using bh_submit() instead of
> submit_bh().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: linux-raid@vger.kernel.org

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  drivers/md/md-bitmap.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 028b9ca8ce52..7d778fe1c47c 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -502,6 +502,18 @@ static void write_sb_page(struct bitmap *bitmap, unsigned long pg_index,
>  static void md_bitmap_file_kick(struct bitmap *bitmap);
>  
>  #ifdef CONFIG_MD_BITMAP_FILE
> +static void end_bitmap_write(struct bio *bio)
> +{
> +	struct buffer_head *bh;
> +	bool uptodate = bio_endio_bh(bio, &bh);
> +	struct bitmap *bitmap = bh->b_private;
> +
> +	if (!uptodate)
> +		set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
> +	if (atomic_dec_and_test(&bitmap->pending_writes))
> +		wake_up(&bitmap->write_wait);
> +}
> +
>  static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
>  {
>  	struct buffer_head *bh = page_buffers(page);
> @@ -510,7 +522,7 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
>  		atomic_inc(&bitmap->pending_writes);
>  		set_buffer_locked(bh);
>  		set_buffer_mapped(bh);
> -		submit_bh(REQ_OP_WRITE | REQ_SYNC, bh);
> +		bh_submit(bh, REQ_OP_WRITE | REQ_SYNC, end_bitmap_write);
>  		bh = bh->b_this_page;
>  	}
>  
> @@ -519,16 +531,6 @@ static void write_file_page(struct bitmap *bitmap, struct page *page, int wait)
>  			   atomic_read(&bitmap->pending_writes) == 0);
>  }
>  
> -static void end_bitmap_write(struct buffer_head *bh, int uptodate)
> -{
> -	struct bitmap *bitmap = bh->b_private;
> -
> -	if (!uptodate)
> -		set_bit(BITMAP_WRITE_ERROR, &bitmap->flags);
> -	if (atomic_dec_and_test(&bitmap->pending_writes))
> -		wake_up(&bitmap->write_wait);
> -}
> -
>  static void free_buffers(struct page *page)
>  {
>  	struct buffer_head *bh;
> @@ -592,12 +594,11 @@ static int read_file_page(struct file *file, unsigned long index,
>  			else
>  				count -= blocksize;
>  
> -			bh->b_end_io = end_bitmap_write;
>  			bh->b_private = bitmap;
>  			atomic_inc(&bitmap->pending_writes);
>  			set_buffer_locked(bh);
>  			set_buffer_mapped(bh);
> -			submit_bh(REQ_OP_READ, bh);
> +			bh_submit(bh, REQ_OP_READ, end_bitmap_write);
>  		}
>  		blk_cur++;
>  		bh = bh->b_this_page;
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
