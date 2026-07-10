Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87B739D6E5
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 20:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783716240; cv=none; b=JvvOAVuMIYViL7Ul65JDlJOY9ziDO5yJDcPZu5XEMrMl2HkCEgjNOGBV5aOmOf7Zu0aXmgi2wzEKRGx0osli+tgWqtFawoJZv8SD/CtDvp2VKCpPzdFZzZLabCArTyEKRliqGg6H6eUXXZweLa0XQwtgX6Av8CwkQU/5az7ziKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783716240; c=relaxed/simple;
	bh=SLoy+I6ziFsoV5XMfJILoChw/6VKOkNH7U+//h3rXqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KZsVGwoydxYlPxYkK4XXGnwlzEbJdOMKbapgVtDO6F2QMmV2+afxvy0/qSEmoWOkyJJKkDVZ5B+67c937ZJqPDB51V9S3Os5fZoRS1mQpylzbtRlE7H0iGPBxALEe0J3Kt/BV6HRFcof+ft5biBAq16PvXaQNkbacVbYZgq2+L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=fail smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=youngman.org.uk
Received: from host86-157-72-216.range86-157.btcentralplus.com ([86.157.72.216] helo=[192.168.1.70])
	by smtp.hosts.co.uk with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
	(Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1wiI4h-0000000FF2O-2QwY;
	Fri, 10 Jul 2026 21:43:55 +0100
Message-ID: <a2a4e6f6-5521-44f7-b045-7432e3e8e757@youngman.org.uk>
Date: Fri, 10 Jul 2026 21:43:56 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LBS setup
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
References: <ahLSj1Ua5WJ0GTgY@lazy.lzy> <alEb50Nmqt8IW2Nu@lazy.lzy>
 <811c24a5-0c72-4b83-af19-609e42e12613@youngman.org.uk>
 <alExwDILVwd3nVvK@lazy.lzy>
Content-Language: en-GB
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <alExwDILVwd3nVvK@lazy.lzy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/07/2026 18:54, Piergiorgio Sartor wrote:
> Hi Wol
> 
> thanks for the answer.
> 
> My question is about "what to do?".
> Not much what happened.
> 
> The log says we should copy some size
> from somewhere to somewhere else.
> The docs says this should be done
> with array at rest.
> 
> Is there any documentation about this?
> Should we just ignore the log?
> What should be done, if any?
> 
> The log:
> 
> md1: echo current LBS to md/logical_block_size to prevent data loss issues from LBS changes.
>                 	Note: After setting, array will not be assembled in old kernels (<= 6.18)

Ah. Personally I wouldn't do anything, then. Are you using any systems 
with kernel 6.18 or earlier?

Are you likely to use any kernels 6.18 or earlier in the future?

If the answer to both questions is no, then you're not going to have any 
trouble ...

Cheers,
Wol
