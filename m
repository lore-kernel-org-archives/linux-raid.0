Received: from mr5.vodafonemail.de (mr5.vodafonemail.de [145.253.228.165])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C8611733
	for <linux-raid@vger.kernel.org>; Sat, 16 Mar 2024 11:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.165
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710587451; cv=none; b=tGVrbJS3yybmlRbTCQsKaKRWDZ2DeZ1y/evCQ5Azi5hi+/bykugv2HI8PU4+eLG2I0H7LcgIvZYmqhU88AMlHoAXbXOwl1c3H9AhaNN2opbTTsvFCnq+NWYXAhoaHrWd/PKmfz6E0On2xm4/sw07RbKcBqt6GGMtkfDLvu3VTTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710587451; c=relaxed/simple;
	bh=///pXV1xkCPSAtRVmd43xn782EB4vM3v7hs1V10uISw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R1MzsXxGYARv72eAiZasywODrqO0xJoj7Z8643LVH87oUnnf9fLapoOaPYNtrYwMiGwuigFeXlr6SqjvlD+l1B0yIZVUeChOkxlpTPvqgUBBXue9BLl+lCrjvJUjX//No+IDexCvWVKjC01lM2ppcZURi2JNQMvQ7iXEvqQ4DpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=LJKAgzsC; arc=none smtp.client-ip=145.253.228.165
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="LJKAgzsC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1710587082;
	bh=d77xJw/BXXoBfELGDJJdPzH9faiolOdXdtL5FuxTesg=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 In-Reply-To:From;
	b=LJKAgzsCQnNc2F1WEg0FolIPI3vQQv7VjXEkBsNTEbXR1Se9ksdiFOcopl8ed7jnQ
	 /UNJZvodyuq8Hgai5Qcppu+9+liG0ze1LsTBc4Zi5wazllfEMPIPORZ70mQV9OVKl4
	 UrIzSZUicTSFDuZulfg0DcoexFb+ZLOJElcITAsA=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr5.vodafonemail.de (Postfix) with ESMTPS id 4TxdYQ14K8z1yBr;
	Sat, 16 Mar 2024 11:04:42 +0000 (UTC)
Received: from lazy.lzy (p579d746a.dip0.t-ipconnect.de [87.157.116.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4TxdYG6g9Nz9sQ7;
	Sat, 16 Mar 2024 11:04:31 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.17.2/8.14.5) with ESMTPS id 42GB4V1A004901
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sat, 16 Mar 2024 12:04:31 +0100
Received: (from red@localhost)
	by lazy.lzy (8.17.2/8.17.1/Submit) id 42GB4UPi004900;
	Sat, 16 Mar 2024 12:04:30 +0100
Date: Sat, 16 Mar 2024 12:04:30 +0100
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: Swami Kevala <swami.kevala@ishafoundation.org>
Cc: linux-raid@vger.kernel.org
Subject: Re: fstrim on full stripes
Message-ID: <ZfV8vvMVq4O63SN3@lazy.lzy>
References: <CAAOcTUhwOPtyyoK4uP02rC0hgrZN1kzLvBY8YM6-1QUN5nELAw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAOcTUhwOPtyyoK4uP02rC0hgrZN1kzLvBY8YM6-1QUN5nELAw@mail.gmail.com>
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 3069
X-purgate-ID: 155817::1710587078-677F4B9B-F07DF470/0/0

On Sat, Mar 16, 2024 at 02:27:02PM +0530, Swami Kevala wrote:
> I have a RAID6 array made up of 8 NVMe SSD drives. I have noticed that
> the write speed for the array is slower than the write speed for an
> individual drive!

This could be.
There is some cache tuning in the folder:

/sys/class/block/mdXXX/md/stripe_cache_*

Two files, check for detailed docs.

It might help, or not.

> It is not possible for me to use trim on my array since my drives (WD
> SN650) report "Write Zeroes Not Supported"

So, don't trim.

Apart that, "Write Zeroes Not Supported" is new to me.
I guess it is always possible to write zeroes...
I know about "Return Zeroes After Trim" or similar.

> As per my understanding, the reason why trim on raid is complex to
> implement is due to the need to recalculate the parity blocks whenever
> data blocks are discarded.

It is implemented if 1) the SSD support RZAT or DRAT and
2) it is enable (under user responsability).
At least for RAID5, but it seems to me RAID6 as well.
The module parameter: devices_handle_discard_safely
Also in this case, check for detailed docs.

> My question is: Would it be possible (or a good idea), to make a
> version of fstrim (e.g. fstrimraid) that could discard at the stripe
> level? i.e. Discard only those blocks for which all blocks in the
> stripe can be discarded.
> 
> I guess this would need to call the md api to know which file system
> blocks are stored on which stripes.
> 
> Our server is used for editing large video files, so I would expect
> that a significant percentage of discard operations would result in
> entire stripes being discarded at once. So I wonder if this would be a
> relatively simple and effective way of improving write performance on
> SSD RAIDs without having to worry about parity.
> 
> Would be interested to know what people think.

It's not clear to me the connection you see
between "trim" and "write speed" in RAID6.

I mean, if the SSDs have speed problems due to
missing trims, then maybe better to change SSDs.
On the other hand, as wrote at the beginning,
maybe playing with the RAID stripe cache could
help more (or not, as wrote).

Hope this helps a bit,

bye,

pg


> -- 
> - 9442504660
> 
> -- 
> The information contained in this electronic message and any attachments to 
> this message are intended for the exclusive use of the addressee(s) and may 
> contain proprietary, confidential or privileged information. If you are not 
> the intended recipient, you should not disseminate, distribute or copy this 
> e-mail. Please notify the sender immediately and destroy all copies of this 
> message and any attachments. WARNING: Computer viruses can be transmitted 
> via email. The recipient should check this email and any attachments for 
> the presence of viruses. The Organisation accepts no liability for any 
> damage caused by any virus transmitted by this email. 
> www.ishafoundation.org <http://www.ishafoundation.org>
> 
> -- 
> 
> 

-- 

piergiorgio
