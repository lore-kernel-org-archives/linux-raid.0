Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="VWGKDik+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="zFfLnjNi"
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2a07:de40:b251:101:10:150:64:1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52766FA
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 03:55:06 -0800 (PST)
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6417121B15
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 11:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700999704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0p3FHwmvmXu9HgaVpcqitG0dgS1aUzupu1QOQsmyxg=;
	b=VWGKDik+4KTAp06Jk2U6aOpajfG7S4icnnH4Ew1kvLzOK9HusBu9x1/UZJZyNOl9so8DPL
	7Glsv9ymli+baNpXF7NsGN/QWjT2pg1PQX0B65YRtZxe/WOKoLHU6ZBZCihhKZxkGM6ILn
	5k0bE/VxwaBzovuLwCfyIKJRC3q5zJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700999704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P0p3FHwmvmXu9HgaVpcqitG0dgS1aUzupu1QOQsmyxg=;
	b=zFfLnjNi2gaVszRYurjzUoVvVX6US9UD7F+yr0pHY3VtGf+aulz+l7q07gAMSETu+EeI/7
	/u9DvH4XET/+wvDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 506C413488
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 11:55:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gygWEhgyY2VjGAAAD6G6ig
	(envelope-from <hare@suse.de>)
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 11:55:04 +0000
Message-ID: <20938de4-65f2-4bab-90c0-018fe485c0e7@suse.de>
Date: Sun, 26 Nov 2023 12:55:03 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: SMR or SSD disks?
Content-Language: en-US
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
 <ZWMf+lg/CgRlxKtb@mail.bitfolk.com>
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <ZWMf+lg/CgRlxKtb@mail.bitfolk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Score: 7.23
X-Spamd-Result: default: False [7.23 / 50.00];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 TO_DN_ALL(0.00)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 SUBJECT_ENDS_QUESTION(1.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 BAYES_HAM(-0.06)[61.63%];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 PREVIOUSLY_DELIVERED(0.00)[linux-raid@vger.kernel.org];
	 RCPT_COUNT_ONE(0.00)[1];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_SPAM_LONG(3.39)[0.968];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_TLS_ALL(0.00)[]

On 11/26/23 11:37, Andy Smith wrote:
> Hello,
> 
> On Sun, Nov 26, 2023 at 11:18:39AM +0100, Gandalf Corvotempesta wrote:
>> i'm doing some maintenance replacing some not-yet-failed HDD with WD RED SSD.
>> I've read the warning on the homepage
>> https://raid.wiki.kernel.org/index.php/Linux_Raid
>>
>> Are SSD drives still subject to SMR ? I've thought that it was related
>> only to magnetic drives not on SSD.
> 
> SMR is not applicable to flash-based storage. I expect the warning
> on the wiki was written at a time when the only drives bearing the
> WD Red brand were HDDs, not any SSDs.
> 
Correct. Typically SATA SSDs do not expose SMR capabilities; it's all
hidden by the FTL there.

And the warning really is outdated. What matters is that the HDD needs
to support TLER (ie scterc capabilities); the brand or series really is 
immaterial. There are plenty of non-SMR HDDs which do not support it. 
Sadly it's not well advertised, so you really have to test
(or invest in the HDD range which is geared up for this kind of usage.)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Ivo Totev, Andrew McDonald,
Werner Knoblich

