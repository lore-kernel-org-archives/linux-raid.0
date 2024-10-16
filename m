Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9FF1C4A29
	for <linux-raid@vger.kernel.org>; Wed, 16 Oct 2024 07:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729065206; cv=none; b=S4AbkNLiGuCJEnKYbNQ6ShvFAWxD5mO3eyH1a9/jjNxzaRQTMGL40G9e2XNTnkKVB1RUTdGFnvB9g3u13OGXu0w8V6+YH5afgJ+Drxlt7S7BA7lstsOQ3BhsUiF2glahsSqtJ4uNaq7SIJuHpGvMBPVbxrqqf6jCMbLrcqVsme0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729065206; c=relaxed/simple;
	bh=Mmbb+6O3pY5HjeP3ZsJsX54iDMfwfP0RCldHkeeZizg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tF/fyby0NactmBlfGLH5vyhUOWSgCJjThUA4SAef1RO+A8E36e9ThgJG/4rAgNAbjTMNUUd0CJJTgxfKf9tmZ1RoDz+GVu3ln6D6ETozEYTqHcoueC56TQ+A5NEnemQpmPei8dVgERt1mz8b3nHlvP52lpeR88JPiSGM4y5vAvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KHhxzNc1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KHhxzNc1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Qs7Ggg9nI5u0jLndc4wA8Ky5vnfkiWOoCVR1o4PGsRY=; b=KHhxzNc1MEWz7z3e8lP3APjEPx
	Tcfj3Kdsjigd8E0oXQ6kG6+qhIZ9Wevp9mgZF2ngUGFq2QW5PZLp/D563BlXYa4IgHb6eY6D1h7Ua
	PZnGPzbMRnwz1b28HAf+y4PJEZvOMYbC4tSw05cmpdFrJOwk77OfcIwRSklZ9HM+RDV+6EVgx5LV2
	f6IS7cUlncoAT1G84P9u//816OqbiZazYtmaQ7mX091261hh0ubM3obbjk3gTyedyAm9c3RsE86yU
	AGfl7clDce3q5rpY5Bg9A55WZQqZL6sl8F/QblVqN1gmYspNBdbcfJvjAHkNaqaQNeVQWMsaJKUnB
	Ec8MA6vQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0yqS-0000000Atou-1EGV;
	Wed, 16 Oct 2024 07:53:24 +0000
Date: Wed, 16 Oct 2024 00:53:24 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Laurence Oberman <loberman@redhat.com>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with the
 latest POSIX changes
Message-ID: <Zw9w9M4-_4E8EzvP@infradead.org>
References: <20241015173553.276546-1-loberman@redhat.com>
 <Zw86MBHnb5PsbH6c@infradead.org>
 <20241016095043.00000201@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016095043.00000201@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Oct 16, 2024 at 09:50:43AM +0200, Mariusz Tkaczyk wrote:
> On Tue, 15 Oct 2024 20:59:44 -0700
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > What are "the latest POSIX changes"?
> > 
> > 
> 
> This is mdadm change, it is not kernel.

Yes, I've seen that.

> I limited subset of supported symbols in
> md device name to make it more portable and compatible with udev.

So please state that.  No matter if kernel or userspace meaningful
commit messages are helpful.  And I don't know any "POSIX changes"
about "allowed characters".

> 
> If you are interested, here are details:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=e2eb503bd797908f515b58428b274f1ba6a05349

That is a significant better commit log, and it would be helpful
if this patch was as careful about wording and also referenced the
above commit.

