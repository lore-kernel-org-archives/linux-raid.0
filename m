Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A853425C82D
	for <linux-raid@vger.kernel.org>; Thu,  7 Aug 2025 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754576298; cv=none; b=AepegWya5ORbtgaTFeqDR3RrNIEOpbrxiwyB9zYrSfbWqnK/KVNC2RsOpbxBFhgPnELCgqIakyMiF9sTBWTRQBZIT+2rydR8qKfbLzgoghWohEE41fPescKTsd3WhW9g4XEwadgj0pAMTP6hK2UJRRMnjujxLmHpnWkmdFgDWWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754576298; c=relaxed/simple;
	bh=WWR9BCsx7CQzE4Tc4uPDDwKSJjjmeQu1fCUJ+ut78dI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=PWiciF8A6+lKH1aJWCWwhfBgZHfE1mypiAT+A0mJOk5rp+W1HFiosTg/h/iRyxXvynbV/uIFnTaNuR3sU/jd5et12iaU7MorFZHfb2vA9Q+vJp4oGDB0zPLGGw99/x5wdKvCYHS9KXFWjsBdhw7A4E+5Geo6gvVAZspuphmKagw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LdmbYLa8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LdmbYLa8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754576295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVLjH/mEq1xCwkQn3G0SDplwIEEXcMt0u1yzo7gOAEU=;
	b=LdmbYLa8XaRHHvXoF0KQfQRCgH1dcjlYdoUf7a1lqGZEnCy0KgSaRxy2sO87WAn+Xys17h
	+pBuT+PsZ23O2ygRbSdacvdzhUs8h1mx3uvoQ5cTyaJynVOrV6P32czU1RueVwCWBnk1L6
	KfsKwvqzqIO+s3152jr9s1ijkFdNABs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-550-er7rexPGMgOYNA8ehb2N4A-1; Thu,
 07 Aug 2025 10:18:12 -0400
X-MC-Unique: er7rexPGMgOYNA8ehb2N4A-1
X-Mimecast-MFC-AGG-ID: er7rexPGMgOYNA8ehb2N4A_1754576288
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C44141956086;
	Thu,  7 Aug 2025 14:18:07 +0000 (UTC)
Received: from [10.22.80.50] (unknown [10.22.80.50])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 62E681800285;
	Thu,  7 Aug 2025 14:18:05 +0000 (UTC)
Date: Thu, 7 Aug 2025 16:17:57 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Luca Boccassi <luca.boccassi@gmail.com>
cc: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai3@huawei.com>, 
    Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
    vkuznets@redhat.com, yuwatana@redhat.com
Subject: Re: md regression caused by commit
 9e59d609763f70a992a8f3808dabcce60f14eb5c
In-Reply-To: <CAMw=ZnTosW4OecBCFdVNqiw9VjSL6msUx6yYBE=9vsEn7JeKqA@mail.gmail.com>
Message-ID: <8c1bf191-a741-cd7a-29dc-babf24a13777@redhat.com>
References: <f654db67-a5a5-114b-09b8-00db303daab7@redhat.com> <CALTww28TpRRTzjqsOXGoUrLHEk=ca85zRcDanGqgTyytA-34ow@mail.gmail.com> <CAMw=ZnTosW4OecBCFdVNqiw9VjSL6msUx6yYBE=9vsEn7JeKqA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Thu, 7 Aug 2025, Luca Boccassi wrote:

> On Thu, 7 Aug 2025 at 01:04, Xiao Ni <xni@redhat.com> wrote:
> >
> > Hi all
> >
> > It needs to use the latest upstream mdadm
> > https://github.com/md-raid-utilities/mdadm/ which has fixed this
> > problem. And for fedora, it hasn't updated to the latest upstream. So
> > it has this problem. I'll update fedora mdadm to latest upstream.
> >
> > Best Regards
> > Xiao
> 
> Thank you for looking into it and providing a solution - however,
> isn't it against the rules to break existing released userspace
> components and requiring new versions to be released in order to use a
> new kernel version? Is there any way this kernel patch could be
> amended to avoid breaking the existing userspace as it is?
> 
> Thanks

I also think that the misbehavior should be fixed in the kernel.

We shouldn't use arbitrary timeouts to clean up the sysfs entries, because 
it would introduce race conditions.

What about destroying the sysfs entries when the file descriptor is 
closed? (instead of on the STOP_ARRAY ioctl) That wouldn't interfere with 
other code trying to stop the array and it would make it work with the 
buggy mdadm that calls STOP_ARRAY and then tries to find the sysfs entries 
and then calls SET_ARRAY_INFO.

Mikulas

