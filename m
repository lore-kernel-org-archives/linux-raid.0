Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD1720E711;
	Thu, 19 Jun 2025 23:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750374938; cv=none; b=pjrIANFy1GJBxg/2mFgzNGc4rftjKL4svqHDhS8sF4xtcUrchHjXD1u8GkbFbr7cWN61SzppyP+tipyDLwD5iFJwLg/H7da1ZnqWFNceMvKfPaEfJWPuWTlg0odPx5Az635rFeWVNJvPJESYZJfvJ1CrMcPtzD+PYESXLnYg1oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750374938; c=relaxed/simple;
	bh=ypENjnXGcORJ+i/IA+BCw64f/efrS3jbVTcazOylpec=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=cw7K2HaHRFHwcQNchmwnb9OvMw31xHuLzb43p+XWI2u9rdT28F8ZVy/OIyQSGH7rgS4/WvaKgCdz4yWNiTOQ8/f6gRRK48AqtqEjDQNPQryiEa+jOvptpUZPzUNJw2yhoBG4QCDIVAA2Ve2dUukZK+LrOGHBJhUPxvJn1jHz3t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XbT+WCac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XbT+WCac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38341C4CEEA;
	Thu, 19 Jun 2025 23:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750374937;
	bh=ypENjnXGcORJ+i/IA+BCw64f/efrS3jbVTcazOylpec=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XbT+WCacTxbTBGEiGgxzQac8pyEV1XLnUuVgN+OPW5Z6f+UCm391ZvUntk7Dx6e/5
	 3JeekVtCJmE3jFLRwB4JJOHF98zf7CI1XIGnFGDQHeeqeY9eVvxS65ctv5/S8z1T1C
	 IJAEv7xel9YqA3uC55aejezeXIXqIUIvHJ3nu25k=
Date: Thu, 19 Jun 2025 16:15:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Song Liu
 <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
Subject: Re: [v2 PATCH] lib/raid6: Replace custom zero page with ZERO_PAGE
Message-Id: <20250619161536.23338f800e313f9d84b1560c@linux-foundation.org>
In-Reply-To: <aFPbSvxCaxhFHc5s@gondor.apana.org.au>
References: <Z9flJNkWQICx0PXk@gondor.apana.org.au>
	<aFPbSvxCaxhFHc5s@gondor.apana.org.au>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 19 Jun 2025 17:41:30 +0800 Herbert Xu <herbert@gondor.apana.org.au> wrote:

> On Mon, Mar 17, 2025 at 05:02:28PM +0800, Herbert Xu wrote:
> > Use the system-wide zero page instead of a custom zero page.
> > 
> > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Why hasn't this patch been applied yet?
> 

Dunno.  I added it to mm.git and I shall drop it again if/when this
patch lands in linux-next via the raid tree (please).


btw, I wrote a patch:


From: Andrew Morton <akpm@linux-foundation.org>
Subject: MAINTAINERS: add lib/raid6/ to "SOFTWARE RAID"
Date: Thu Jun 19 04:13:17 PM PDT 2025

Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~a
+++ a/MAINTAINERS
@@ -23057,6 +23057,7 @@ F:	drivers/md/md*
 F:	drivers/md/raid*
 F:	include/linux/raid/
 F:	include/uapi/linux/raid/
+F:	lib/raid6/
 
 SOLIDRUN CLEARFOG SUPPORT
 M:	Russell King <linux@armlinux.org.uk>
_

