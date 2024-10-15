Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0A8158A1F
	for <linux-raid@vger.kernel.org>; Tue, 15 Oct 2024 01:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728957562; cv=none; b=KD01bXrHghjtRBMXSYUY9flPUBh43M8joVKICjh7S78GQ206yLDZnToAAEd1vmFW6UIGsEE7XjTrbodxmC3c6tcfRV/d86lFui6PaCMT+M3mf0E4FNiP0nOUAlMXpW20h9cWKqkI75xxngnqPGghd7Qo59jZm2LuGh1QiQGRdhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728957562; c=relaxed/simple;
	bh=/mpWQQUg4SLGbw0b6uVKlir/V5LQ1XvyAyhlgfEndo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rhYWJVJ/+GrpBhr9kzj9pG/otEI6w+FxZAM7R+ic1vVlNGmeXJ/q+FgtVLIJxC3fFDhafcBq+VcqESbyv1wJ2vuSldighirLJQWMIYMgE17GDKbH8qbYIxw1Ip5qsMhe/+xGARKONIE1FT0Fa4wUDrFhtRgycEZNkxb54z/YvXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PO6QRUSi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PO6QRUSi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728957560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ml1ZBBcs96kgD+D7cgCrxHrlfi6RlfUgZkDg/aeocjg=;
	b=PO6QRUSicuQZJI8spfEgOLvz+G9kiSqXYEeGkatBFQJzmWdiHW1Me7gLI07My4NLEXwZ4J
	gupc2flpLmtaxPc73O2vjb/7Q0FP0UF7PyPbWHhn+Q3IF8svYc0tKLbfT/PJ2gIgnxqWag
	eENUR4uMDRc73VJpqnwASEsFVK9FnXI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-m3OzuSbkP1ilKYyrQmSsqg-1; Mon,
 14 Oct 2024 21:59:16 -0400
X-MC-Unique: m3OzuSbkP1ilKYyrQmSsqg-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74E88195608B;
	Tue, 15 Oct 2024 01:59:14 +0000 (UTC)
Received: from fedora (unknown [10.72.116.119])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E666419560AA;
	Tue, 15 Oct 2024 01:59:07 +0000 (UTC)
Date: Tue, 15 Oct 2024 09:59:02 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
	Hamza Mahfooz <someguy@effective-light.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	linux-raid@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [Report] annoyed dma debug warning "cacheline tracking EEXIST,
 overlapping mappings aren't supported"
Message-ID: <Zw3MZrK_l7DuFfFd@fedora>
References: <ZwxzdWmYcBK27mUs@fedora>
 <426b5600-7489-43a7-8007-ac4d9dbc9aca@suse.de>
 <20241014074151.GA22419@lst.de>
 <ZwzPDU5Lgt6MbpYt@fedora>
 <7411ae1d-5e36-46da-99cf-c485ebdb31bc@arm.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7411ae1d-5e36-46da-99cf-c485ebdb31bc@arm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Mon, Oct 14, 2024 at 07:09:08PM +0100, Robin Murphy wrote:
> On 14/10/2024 8:58 am, Ming Lei wrote:
> > On Mon, Oct 14, 2024 at 09:41:51AM +0200, Christoph Hellwig wrote:
> > > On Mon, Oct 14, 2024 at 09:23:14AM +0200, Hannes Reinecke wrote:
> > > > > 3) some storage utilities
> > > > > - dm thin provisioning utility of thin_check
> > > > > - `dt`(https://github.com/RobinTMiller/dt)
> > > > > 
> > > > > I looks like same user buffer is used in more than 1 dio.
> > > > > 
> > > > > 4) some self cooked test code which does same thing with 1)
> > > > > 
> > > > > In storage stack, the buffer provider is far away from the actual DMA
> > > > > controller operating code, which doesn't have the knowledge if
> > > > > DMA_ATTR_SKIP_CPU_SYNC should be set.
> > > > > 
> > > > > And suggestions for avoiding this noise?
> > > > > 
> > > > Can you check if this is the NULL page? Operations like 'discard' will
> > > > create bios with several bvecs all pointing to the same NULL page.
> > > > That would be the most obvious culprit.
> > > 
> > > The only case I fully understand without looking into the details
> > > is raid1, and that will obviously map the same data multiple times
> > 
> > The other cases should be concurrent DIOs on same userspace buffer.
> 
> active_cacheline_insert() does already bail out for DMA_TO_DEVICE, so it
> returning -EEXIST to tickle the warning would seem to genuinely imply these
> are DMA mappings requesting to *write* the same cacheline concurrently,
> which is indeed broken in general.

The two io_uring tests are READ, and the dm thin_check are READ too.

For the raid1 case, the warning is from raid1_sync_request() which may
have both READ/WRITE IO.

Thanks,
Ming

