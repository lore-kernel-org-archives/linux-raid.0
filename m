Received: from mr4.vodafonemail.de (mr4.vodafonemail.de [145.253.228.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D16374735
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 17:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=145.253.228.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783706065; cv=none; b=WbOf58gIBN22B7sOPLtRuolwHTfEYhpRLzrQJufl1aYW+z/hWTUHMKPRZ4TffLnr9d1FgDC2+W/VmCUe0X0vUxmRUdz6yqjP1UthBXOiX3Mevu8AxN96nYcMCio55mNlPK53tJba00WlEdiluCRHJQkER7lLjci8eEmuUqEaxt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783706065; c=relaxed/simple;
	bh=C+XXgU/pRJDLkIsJuTxfOVy8sGsm+0wA3JWeJ3JLQ6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4Aa4byUvep/0ngjGr6lMA2Kaw0b8ARnBPxZSsvTAO+ye/f506qPkg90bsZEUGA1UAy3xNubzjgFJYXYw7KvW4FpEAoCjZ2AyksyjKVQGgYKz3Z+GTIHOeRrIwoKzwuozTw4wEpufFSZzn1hWxuCBlbOLBqIq/7Tzt/+eaaYlTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nexgo.de; spf=pass smtp.mailfrom=nexgo.de; dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b=WSKyybb0; arc=none smtp.client-ip=145.253.228.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nexgo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nexgo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nexgo.de header.i=@nexgo.de header.b="WSKyybb0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
	s=vfde-mb-mr2-23sep; t=1783706058;
	bh=pNtbA93V0D7V7T1qaO4xizgl4W90/jzn2j2JCtGBtls=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 In-Reply-To:From;
	b=WSKyybb0gDHNJLh/cqqRvkvK5/3kbmMFeZLAvaUMvv9aGFiUtiYZBYnedbuZ3/xE7
	 rrPPSrP2aD0jwlyVwpOwVh3yo+JZIMOKEx0O/51qa7ybKLJmyXLuxgCRLGKdbRU/IH
	 Cbw4+7Y+yIdnIDiUE4IY/p1wIZVDMVUD+UnsqKWk=
Received: from smtp.vodafone.de (unknown [10.0.0.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mr4.vodafonemail.de (Postfix) with ESMTPS id 4gxfbZ3SyVz3sWC5;
	Fri, 10 Jul 2026 17:54:18 +0000 (UTC)
Received: from lazy.lzy (p579d7d31.dip0.t-ipconnect.de [87.157.125.49])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.vodafone.de (Postfix) with ESMTPSA id 4gxfbS22PXz92kX;
	Fri, 10 Jul 2026 17:54:09 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
	by lazy.lzy (8.18.2/8.14.5) with ESMTP id 66AHs8Ls039564;
	Fri, 10 Jul 2026 19:54:08 +0200
Received: (from red@localhost)
	by lazy.lzy (8.18.2/8.18.2/Submit) id 66AHs83i039563;
	Fri, 10 Jul 2026 19:54:08 +0200
Date: Fri, 10 Jul 2026 19:54:08 +0200
From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To: Wol <antlists@youngman.org.uk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
        linux-raid@vger.kernel.org
Subject: Re: LBS setup
Message-ID: <alExwDILVwd3nVvK@lazy.lzy>
References: <ahLSj1Ua5WJ0GTgY@lazy.lzy>
 <alEb50Nmqt8IW2Nu@lazy.lzy>
 <811c24a5-0c72-4b83-af19-609e42e12613@youngman.org.uk>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <811c24a5-0c72-4b83-af19-609e42e12613@youngman.org.uk>
X-purgate-server: smtpa02
X-purgate-type: clean
X-purgate: clean
X-purgate-size: 3413
X-purgate-ID: 155817::1783706058-BA53788B-8F4409AB/0/0

Hi Wol

thanks for the answer.

My question is about "what to do?".
Not much what happened.

The log says we should copy some size
from somewhere to somewhere else.
The docs says this should be done
with array at rest.

Is there any documentation about this?
Should we just ignore the log?
What should be done, if any?

The log:

md1: echo current LBS to md/logical_block_size to prevent data loss issues from LBS changes.
               	Note: After setting, array will not be assembled in old kernels (<= 6.18)

The docs:

logical_block_size

Configure the array’s logical block size in bytes.
This attribute is only supported for 1.x meta.
*Write the value before starting array.* (emphasis mine)
The final array LBS uses the maximum between this
configuration and LBS of all combined devices.
Note that LBS cannot exceed PAGE_SIZE before RAID
supports folio.
WARNING: Arrays created on new kernel cannot be
assembled at old kernel due to padding check,
Set module parameter ‘check_new_feature’ to
false to bypass, but data loss may occur.

The kernel is pretty new, actually 7.1.3,
from Fedora.

Old kernels is for me no problem, it would
be a problem losing the array.

There is no procedure explained, documentation
is, for me, quite dry.
It would be good to have some comments from
whom wrote it (and the code as well).

Thanks,

bye,

pg

On Fri, Jul 10, 2026 at 06:10:47PM +0100, Wol wrote:
> On 10/07/2026 17:20, Piergiorgio Sartor wrote:
> > Hi again,
> > 
> > not sure, but has anybody comments
> > on the topic?
> 
> I don't understand what you're asking, but I do think I remember the events
> you're talking about.
> 
> Basically, some change accidentally slipped into the wild with a kernel,
> probably a 6.x, and people started creating kernels with the new kernel.
> 
> Then, as people started upgrading kernels, they suddenly realised that this
> change affected the raid format, such that  new kernels couldn't read old
> arrays, and vice versa. More importantly, and more dangerously, it led to
> arrays being trashed!
> 
> What to do? They couldn't pull old kernels obviously, there were too many
> arrays out there. They couldn't pull new kernels, there were already some
> arrays out there.
> 
> So they rushed out a fix, such that if a new kernel created an array, it
> flagged it as being a new array. If you booted a new kernel with an array
> that didn't have the flag IT WOULDN'T LOAD THE ARRAY. And they trusted to
> luck that people wouldn't downgrade an array and try to load a new array on
> an old kernel.
> 
> So this now meant that all of a sudden new kernels wouldn't boot on old
> systems, until the user explicitly set the flag on the array to say "this is
> an old-style array". If they happened to be upgrading from one of the few
> early new-style kernels, they could set the flag to "this is a new-style
> array".
> 
> Point is, this code was meant to make it very hard to upgrade your kernel
> without being prompted what sort of array you had, so that the kernel devs
> could try to ensure you didn't lose your array.
> 
> A pretty awful way of doing it, but nobody could think of anything better.
> 
> Hopefully that explains what's going on there, and you'll be able to work
> out your own answer from this information.
> 
> Cheers,
> Wol

-- 

piergiorgio
