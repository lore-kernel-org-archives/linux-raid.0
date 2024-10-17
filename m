Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F061DE8AE
	for <linux-raid@vger.kernel.org>; Thu, 17 Oct 2024 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729179079; cv=none; b=cSE7xCKfO1JK+1wmLNWN/EIja5ZQDJVYwvGtFzg+DkTvshDuebzZw5peNvTiTMrKCJU2Ii/KXV+ncEla1gP5xG4CIOVYgw95UNIviF+ZrUBmRI1er6JRsNWjwvVtBEsPjwWLBN4peO5GH/BLgNF1vTVdhxbOmeGjfcsDIDjXm4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729179079; c=relaxed/simple;
	bh=dNbI8Sf/kvEzVpMHxsPaPYt6yizOiU16qseCjUCCavA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SS0jrEBimfM99MJFr1a6MoC3Ee0hzFcD6dzjxJn4KCUUWi7jsDTYD9DOv/4JJ1CowDvzFFHbr3+kdP2G4hwu63jK8RQCGXM2i6NxUhTPKSYEOT3mjR1fk0aHEIpAt1vNL3YmFOXiE5RWDGK0qnUybpbYoOQwYbQp4WplO5AjWyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ORCv1l3t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ORCv1l3t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=daZM9ts1QgnGyIL9RLy1xXUF+JUzIocTIgu7mwYtF3w=; b=ORCv1l3tBmvcBYyA4AajHuGax8
	r8MvHXrCqWi5FpTjxVemXBcPANEcvoPHSUnGkSo3jXYxyukmNS4BQw6xalIwv7sIdo7QYzq1D5hKr
	TsE3ScvNMSp+wfl/wOlhaRCprHpSSQUKyao2yVfqn/IzxjLFLGMQwb5jx4Vaz+YoS7+4Z8E/KfJgg
	glreobmfdOFuiibb24BOy5W3hD7z8QPjC9oR+UVK2wtzwVqkUrNv4pSlTADTQq8AG0GBt7SInq8QL
	mpqplu1D8h4UM0e23i6oKEHjyzYWlZL3aCz1gh8Kq/BZe+mpXW9zlEh4Q1WZOWerwoLMsbW4+Ae2H
	NwZggRTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t1ST7-0000000FHkU-0jdp;
	Thu, 17 Oct 2024 15:31:17 +0000
Date: Thu, 17 Oct 2024 08:31:17 -0700
From: "Hellwig, Christoph" <hch@infradead.org>
To: Laurence Oberman <loberman@redhat.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
	Xiao Ni <xni@redhat.com>, "Hellwig, Christoph" <hch@infradead.org>,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH] Add the ":" to the allowed_symbols list to work with the
 latest POSIX changes
Message-ID: <ZxEtxXTLZVgP-_kJ@infradead.org>
References: <20241015173553.276546-1-loberman@redhat.com>
 <20241016101433.00005bb9@linux.intel.com>
 <5321cf0e579ee5e025396e9f9b62432dd2ed3458.camel@redhat.com>
 <CALTww29q5M_to+nN4G6rSdVMMbBj5orBjTE3dCUcBc6ZzAX1bg@mail.gmail.com>
 <20241017132631.00004d46@linux.intel.com>
 <5a53110cad3519de3990cbe4eb67acee72f9238b.camel@redhat.com>
 <49af106759fc1ec3da109c166c4c09e7251bf9e8.camel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49af106759fc1ec3da109c166c4c09e7251bf9e8.camel@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Oct 17, 2024 at 11:27:24AM -0400, Laurence Oberman wrote:
> I re-ran all the tests in house and I can actually start the arrays
> that have the ":" in the names, just not create new ones. So I think we
> leave this as is and we keep the adherence to POSIX for newly created
> arrays only. 

Can we please stop talking about Posix compliance here?

The POSIX Portable Character Set is the minimum set of characters that
need to be supported in each character set for Posix compliance.

Including other characters is perfectly Posix complain, just not fully
portable.

