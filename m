Received: from ente.limmat.ch (ente.limmat.ch [62.12.167.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2946D25742C
	for <linux-raid@vger.kernel.org>; Sun, 14 Sep 2025 15:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.12.167.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757863953; cv=none; b=Qkc7QvDF7+31LaavomVWNkm48t4/0cL20fd3l0oux4rUD2Aa5qNQLl9arYEsQkDuo2MKYWyoyYVZZL9wcrpZ3P0C2UxPd0Je/CGLQUCPiOWTO+z6mjjpgaLOz8QW4TfoKXQJCub7Z5O7lGcBTK2qh7W+6O7AQmFHlOFlbU10rJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757863953; c=relaxed/simple;
	bh=xkNy47I2gJVKSCtCuiZV4PqZ0v5SVWjHHD3ojQac668=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VkOxd9M95+KIjCHIhXBKpPKNSzVbK2p94unYcp7u2AFSdyqVf3x12pqJF6CQchY2LQBsf4W5jvaCAtSWuCnaXPE63TWqSAacdluRqqQvLKGFK38fpt1F5GHhnEDY1qIo++onYY5yRrFwk/9ho0Wa4OV9Nai0Rr1w8gOEDToQPkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mailgurgler.com; spf=pass smtp.mailfrom=mailgurgler.com; dkim=pass (2048-bit key) header.d=mailgurgler.com header.i=@mailgurgler.com header.b=jmSl5eEI; arc=none smtp.client-ip=62.12.167.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mailgurgler.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailgurgler.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailgurgler.com header.i=@mailgurgler.com header.b="jmSl5eEI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=mailgurgler.com; s=main; h=X-MTA-Admin-Wish:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Date:To:From:Cc:User-Agent:
	Content-Transfer-Encoding:Content-ID:Content-Description:Content-Language:
	Autocrypt; bh=3QlFhKe4QJMt3fQRpQx5P++bFL82AfRdlkBHxmmF2n8=; b=jmSl5eEI5oEiNqI
	014B9kNZxYOaFGECzOSGHZAJ5b/xRnlKZdqjZpEcZCRGlxYH/2BMCWNwS1md33MYqTLhFVSjv0VNI
	OHV4lo0a+d2EzidLYGWg/pmrK3w11QzRAOeGgAzw6rHGspc9nnUg6tPYnH3o5v3ngBhkzVclLG6+V
	Hp8cldxMRBxH2+qoNtHe7xpgFF1FaPKGV+TlRJXkEYVLxatTFtJkZY4bvD8oQlZkfedw+XrGN2wJX
	c6OZZa9eP1M2Idn6hPuzfjhjmJS/aoTL3nCZEYjiTDuUSFA/T3ZKR5Pm78FqgrSTxMEJmYT2rGmMl
	fWkbC5id3NQ1Cg6CP1A==;
Received: from yoghurt.3eck.net ([62.12.167.105] helo=pave.localnet)
	by ente.limmat.ch with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.89)
	(envelope-from <vger.kernel.org@mailgurgler.com>)
	id 1uxoiB-0003nK-Cj
	for linux-raid@vger.kernel.org; Sun, 14 Sep 2025 17:32:19 +0200
From: Adrian Zaugg <vger.kernel.org@mailgurgler.com>
To: linux-raid@vger.kernel.org
Subject: Re: deprication warning using -a mdp
Date: Sun, 14 Sep 2025 17:32:14 +0200
Message-ID: <2623155.Y4W8hZkJsM@pave>
In-Reply-To: <4892474.rnE6jSC6OK@pave>
References: <4892474.rnE6jSC6OK@pave>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart10729855.U7f9L36N0a";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Welcome: ente.limmat.ch
X-Virus-Scanned: ClamAV on ente.limmat.ch
X-Spam-Scanned: No. Real men don't spam. (user authentication succeeded)
X-MTA-Admin-Wish: Preserve the environment, save the climate.

--nextPart10729855.U7f9L36N0a
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Adrian Zaugg <vger.kernel.org@mailgurgler.com>
To: linux-raid@vger.kernel.org
Subject: Re: deprication warning using -a mdp
Date: Sun, 14 Sep 2025 17:32:14 +0200
Message-ID: <2623155.Y4W8hZkJsM@pave>
In-Reply-To: <4892474.rnE6jSC6OK@pave>
References: <4892474.rnE6jSC6OK@pave>
MIME-Version: 1.0

Is the deprication warning using 

	--auto=mdp 

meant for the switch --auto itself or is it meant that partitionable RAIDs 
won't be supported any more in the future? If the latter is the case, what is 
the migration path for users like me that use this feature extensively on many 
machines?

Thank you for your answers.

Regatds, Adrian.


In der Nachricht vom Sonntag, 7. September 2025 20:07:52 CEST stand:

> Dear List
> 
> I just saw a deprication warning on a new system creating a RAID1 with
> 
> 	mdadm --create /dev/mdX --auto=mdp ...
> 
> Could you please tell me whether support for creation and handling of
> partitionable whole disk md raids will stop in the future?
> 
> Regards, Adrian.

--nextPart10729855.U7f9L36N0a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTslxP3vQdyHy9ATELk/KJTHAOrsQUCaMbf/gAKCRDk/KJTHAOr
sUd9AQDlBsCRaBLQ/YzC7d1SQkbh/qGvJExUgU+R2KV08Wf7LwEAz43IzYrQGdSK
EncupaxVGwOytMAI8mcKxf3GF8gCPQ8=
=TZFS
-----END PGP SIGNATURE-----

--nextPart10729855.U7f9L36N0a--



