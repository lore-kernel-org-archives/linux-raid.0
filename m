Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E482111;
	Thu, 19 Jun 2025 23:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750375536; cv=none; b=fouqjtuq5dMB0PVaWHsWzbUMjIyX/DUsxjWJ20l+O4RbDRjdm5SX0eOa4gyve0nb5EWbtDN68mzykHMYIkvnqngBhin3vAXYUQ9vfrbBEj34okY4L8ScZWolrUqHSF+ZWyIqSdr6kN17pD6yr0L7n7yE5ZRZUKX5B0JmIXLPWAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750375536; c=relaxed/simple;
	bh=NAKGMS6m18zWCX+prfX4PKPrmhVMR2C/9JIj6rSRBFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kJOaxm5V6oVLFvzTyDKvOvqdRKHZh1DipxJmyiQYVf2WiqJCuZVsRtHAVwmfGDpj3U+LnYgxxa7p/lekLV/uS7C8Y3S7wr87eccD2WuzBVNX5ezIveLg7gO5+IHRdIROijTPr/nirmB6E8ObY1KeIKEqA7E0ZaObqFuATMxKn1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=I1AtB1Zn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="I1AtB1Zn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=dhbOUaVoCD41Ka92nDatdt94zwzchaNpzX61zhjuKX4=; b=I1AtB1ZnhrSGdI7wXfyMStiVo1
	HEy4fnyOTPpN9EqRBG+APasSXOgoJcTS3fyrmt4jTkfvLZnjVi3Nh3DYGJ1ylBOBwVpAThvyRgN8C
	F+I9l93zDCqOqqCey/STpmUlDbdMldh9FX+v9esYl4p6EY+Z7b89nq08cCwdaL/d7m33kVy7UilpC
	HoSyoLI8cEHpOu3tJ49x6p+W45C4/c+mloqJUvXBHcSI+8rP7+oTUb8LJlg5spR8thtED+eTb6ai8
	l9qfLfXqNz8VUAyjsvk2KsOJB/Mqaji4l+t0x1JSZNKKBCzlZQsvhOxCsR4LE6iEPaEEopC31Kh2C
	q25CDkEg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uSONt-000R52-2o;
	Fri, 20 Jun 2025 07:25:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jun 2025 07:25:17 +0800
Date: Fri, 20 Jun 2025 07:25:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org
Subject: Re: [v2 PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-ID: <aFScXXQ6CiroBnBQ@gondor.apana.org.au>
References: <Z9flJNkWQICx0PXk@gondor.apana.org.au>
 <aFPbSvxCaxhFHc5s@gondor.apana.org.au>
 <20250619161536.23338f800e313f9d84b1560c@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250619161536.23338f800e313f9d84b1560c@linux-foundation.org>

On Thu, Jun 19, 2025 at 04:15:36PM -0700, Andrew Morton wrote:
>
> Dunno.  I added it to mm.git and I shall drop it again if/when this
> patch lands in linux-next via the raid tree (please).

Thanks Andrew!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
