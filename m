Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505EB1E3DE8;
	Thu, 19 Jun 2025 09:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750326109; cv=none; b=c/mvPZGagOShSPfFtTg0bFnmVpD0kIkjyToPDH6s8ETBnWU72dbl0xiwJ94m6Eq5sQ55v1QWgOLR81qZ3ucw+3Bw9HQhIIo9akCIcsYsi13oyxKqDBeX3P7Qu19km9ywHAiCJ/5pRGVhEosND02i+efVZeqcBxPL7w8GJr/XlNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750326109; c=relaxed/simple;
	bh=6Kg55sbhzhwjhiprVxSq+GcLe6yjHcHSz6iixOl0tsA=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EBkRgRaI4uwy+PM4dFnVcU7CQWJBF2PhytS86jAwPapjZLe75IzSFpLyMO9RRYflDLj/Zyq/noduppLjYGdrorsp3y77F+vpy4vM6MqseI0bKv9DkKteTYAHDDIM8a4dShDkDFCRa1yZ6gQni2JaTO0WvkN0zTfuwEBtRGYmlB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=NWqEuZUc; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="NWqEuZUc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gIAyPD/RJ48Qpggk4OjyLNZuYhZUKPzUf+M33PEmv3Y=; b=NWqEuZUctRTBdW0875A5/ZLwWO
	tIFtMTDqUIJakeZGR5tuqagrPEsQ27ioGOafpkFpP1jLq9w5kVSUX66CWc6df+s/JvDv70RR5brIv
	juF6Um1WyR7za1yDgokARlW3iC1zMHqtnCFuL2dq+y1kZ3KNL2u6ixVOFFKFYnENlgSi/atVeg0Dr
	qRN9Os/G4QW1OPPZHEe/2hY7MJmrB8tseXB2QyyfiKt1vQykyKysO7buCs/kf8flkDHbtCTMMHHq0
	TUMRYFB7/EQui3+vpCNd/xGsAngKQAlw7FOi0z+Y/SsYoA+OfnzzBYF0jqxkuGq1THSipQ+cltoEe
	CvZ20Qww==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uSBWg-000HKk-2l;
	Thu, 19 Jun 2025 17:41:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 19 Jun 2025 17:41:30 +0800
Date: Thu, 19 Jun 2025 17:41:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org
Subject: Re: [v2 PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-ID: <aFPbSvxCaxhFHc5s@gondor.apana.org.au>
References: <Z9flJNkWQICx0PXk@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9flJNkWQICx0PXk@gondor.apana.org.au>

On Mon, Mar 17, 2025 at 05:02:28PM +0800, Herbert Xu wrote:
> Use the system-wide zero page instead of a custom zero page.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Why hasn't this patch been applied yet?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
