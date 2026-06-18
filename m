Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700E82F7EEE;
	Thu, 18 Jun 2026 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802554; cv=none; b=FqnOI7nNa7m7X8LbAay/vFcdR2elafiebgPbKkv6d29wuuRxpIfX43SZ2eq2iQHsF0I0i/UMt1Un7jXceql2TTX07mh3ihzt6RgXmdPHqjDHN7/XLQhh2ugLABW19rv6obAbSuyRsabk3EmVfiTiutAP2KxjAGNDgUGMMJwVxCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802554; c=relaxed/simple;
	bh=cPnssL4QSkHLuwqjV9ESlU0V3IKz7HfozfI/AlRPbHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cEvlsHYN5Cp9T26bXF9j16+8YLolxq5/xOWPhZ32XdnfUeLvyYE2ApO+YBQEnS+lZfhMQktgOb+P6Pr+p7InyptG07emdQfQIa1TD40oaKNOp7OH688JtkPDykOxmwuK9WVQ2T5opVqu8G7QrfICFjDP10vnqKTw2ilE/1kgMi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZX2lGVQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZX2lGVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3A5B1F000E9;
	Thu, 18 Jun 2026 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781802553;
	bh=rgLdSXU3Un570rqBdtfeqG0anO2liz6o80Mv+wxyFlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cZX2lGVQox6tLC0aU0s3gum4HD3fPnoythPORSE0TsnfFi5pWyY+ITplopf1USSv1
	 zqa0e4gKO52v7zKcabiD1iZTvpce9e5i8mye5Uz3tz3EqpVTgKDko+PHnAGHQfLzMX
	 ejNA+ezL4MDTfkvSklVS3mx0dey8JR5cPL6zIr9ES9vo+kTIUIz/Yvsy04vsTwdeTP
	 pOIBDxfU1//qfPszs8zymHwnqwhHAEVmiPwGieLumdFl04iigoGQlFomS6JeQ1HSVL
	 UmVf5gaG8RjrWvIS04chMPXCTTXPc1UBn3Kt+ELG2BIZCNu019X7ysWlIS0d5vsehZ
	 tdugJYlFgATqA==
Date: Thu, 18 Jun 2026 10:09:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH 2/2] xor/kunit: add a benchmark
Message-ID: <20260618170911.GA1808@quark>
References: <20260617054416.3841334-1-hch@lst.de>
 <20260617054416.3841334-3-hch@lst.de>
 <20260617171448.GD785086@google.com>
 <20260618092224.GB17530@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618092224.GB17530@lst.de>

On Thu, Jun 18, 2026 at 11:22:24AM +0200, Christoph Hellwig wrote:
> On Wed, Jun 17, 2026 at 05:14:48PM +0000, Eric Biggers wrote:
> > The #ifdef can be avoided using kunit_skip(), as the crypto and CRC
> > tests do:
> > 
> >     if (!IS_ENABLED(CONFIG_XOR_BENCHMARK))
> >             kunit_skip(test, "not enabled");
> 
> I saw that, but what's the point or just not compiling it?

Just the usual point of avoiding #ifdefs.  Developers won't have to
build the file with two different kconfigs to ensure it builds.

- Eric
