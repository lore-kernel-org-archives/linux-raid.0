Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCA0129A98
	for <linux-raid@vger.kernel.org>; Thu,  7 Mar 2024 13:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.187.191.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709817908; cv=none; b=HKJqdlTfJcA1PjoTrPYMXEa4KfFzvcl8AprZ0R+T/UBZY0bs0E1cuv1j/V+Mr9hwqipieHe6G+mipl3OmFs2C115wzu5m5i5IZf7QQl/nKRQhXnYuu3A6H3GrOfJBon6oTF+pGOPy6Y/edIqS6Dg3vtF4Y+nw1/RXwVOEljJ7C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709817908; c=relaxed/simple;
	bh=tZ1HCt8PYBAENrglUo2ZeTd15atW+qEBieFnFs17GtE=;
	h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:
	 MIME-Version:Content-Type; b=qUi/3vonwPej26P8lyg99hVc6zJEDpFWNlxuwgkIR9OsatQjkxhbeAfIrKtNFT1Nan+1jMs/JvFnH3xqIUhh/bSbM3eo2t4mIU/an8dDegpzCLfDBquJE+ZAbp+t1DRRPRfPnJusdaUCOrDbm9y7zlrsc999wfx2iQE6WZEkSrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=esperi.org.uk; spf=pass smtp.mailfrom=esperi.org.uk; arc=none smtp.client-ip=81.187.191.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=esperi.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=esperi.org.uk
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
	by mail.esperi.org.uk (8.17.2/8.17.2) with ESMTPS id 427D3RqU028809
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Thu, 7 Mar 2024 13:03:28 GMT
From: Nix <nix@esperi.org.uk>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: jes@trained-monkey.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/6] mdadm: remove ANNOUNCEs
References: <20240223145146.3822-1-mariusz.tkaczyk@linux.intel.com>
	<20240223145146.3822-2-mariusz.tkaczyk@linux.intel.com>
	<871q8wsld5.fsf@esperi.org.uk>
	<20240228164046.00001565@linux.intel.com>
Emacs: because idle RAM is the Devil's playground.
Date: Thu, 07 Mar 2024 13:03:28 +0000
In-Reply-To: <20240228164046.00001565@linux.intel.com> (Mariusz Tkaczyk's
	message of "Wed, 28 Feb 2024 16:40:46 +0100")
Message-ID: <87jzme9otb.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.3 (gnu/linux)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-x.dcc-servers-Metrics: loom 104; Body=3 Fuz1=3 Fuz2=3

On 28 Feb 2024, Mariusz Tkaczyk spake thusly:

> On Wed, 28 Feb 2024 14:40:22 +0000
> Nix <nix@esperi.org.uk> wrote:
>
>> On 23 Feb 2024, Mariusz Tkaczyk uttered the following:
>> 
>> > Release stuff is not necessary in repository. Remove it.  
>> 
>> ... it's actually pretty useful to have the ANNOUNCEs there for people
>> building from the repo. Given that the changelog is not updated, having
>> a summary of changes *somewhere* without having to grovel around in
>> mailing list archives seems like a thing that shouldn't just be thrown
>> out as "not necessary".
>
> Agree, we have to maintain it but in simpler form. I will create CHANGELOG
> instead. I will copy the content of those files to changelog, with some
> modifications.

They are a bit of a mess at the top level though. Maybe move them into
misc/ or a new doc/ or something?

-- 
NULL && (void)
