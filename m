Received: from beast.visionsuite.biz (beast.visionsuite.biz [85.163.23.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB12188A3E
	for <linux-raid@vger.kernel.org>; Fri, 23 Aug 2024 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.163.23.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724428622; cv=none; b=ohcdZHpIYuNvJhFYSvLDVb9kFvR8uy4CyALMC/gsJrATcJHS5xs6WmaJFXip3JCL6f3TpxFxc4eEUVaXnNWWHBDL7ELZYbz6PfBLmyEK9HkWjKQxtI8IbA947EqlGj1f8QNWKMLOkLgB7lKMzZs2cybIF3gFx11yJjvpwoXwB1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724428622; c=relaxed/simple;
	bh=pUGQ77fgWcfYWBi3EZstrc3sTU/4w9HNbKOHzfkAOKo=;
	h=MIME-Version:Date:From:To:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=GLxFdlxKURrokqoeZW2Wt9ykb1C5Z00ZcaRTGoM+66wm//RJ6EYorkT1EDkavfBA3HCX3f0RN6AVE5VKmFt46mIfK/5anSpF9UR1jRVsg3KrEZQFcQfVj4+LqzOqLHYUjccDQ/thL7T3prSY/f/z+kgnmwZw/Ot8HAEQNka/rxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fordfrog.com; spf=pass smtp.mailfrom=fordfrog.com; dkim=pass (1024-bit key) header.d=fordfrog.com header.i=@fordfrog.com header.b=Ycxp/PjJ; arc=none smtp.client-ip=85.163.23.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fordfrog.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fordfrog.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fordfrog.com header.i=@fordfrog.com header.b="Ycxp/PjJ"
Received: from localhost (beast.visionsuite.biz [127.0.0.1])
	by beast.visionsuite.biz (Postfix) with ESMTP id 9C91A4E1F31F
	for <linux-raid@vger.kernel.org>; Fri, 23 Aug 2024 17:56:56 +0200 (CEST)
X-Virus-Scanned: amavisd-new at visionsuite.biz
Received: from beast.visionsuite.biz ([127.0.0.1])
	by localhost (beast.visionsuite.biz [127.0.0.1]) (amavisd-new, port 10026)
	with LMTP id WUQKNjsD3zgj for <linux-raid@vger.kernel.org>;
	Fri, 23 Aug 2024 17:56:55 +0200 (CEST)
Received: from roundcube.visionsuite.biz (beast.visionsuite.biz [127.0.0.1])
	by beast.visionsuite.biz (Postfix) with ESMTPA id D2C5D4E1F315
	for <linux-raid@vger.kernel.org>; Fri, 23 Aug 2024 17:56:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fordfrog.com;
	s=beast; t=1724428615;
	bh=g+T2AhCHUGuBp58rEBtoaircaKvHgpH40M/gRp/9GY8=;
	h=Date:From:To:Subject:In-Reply-To:References;
	b=Ycxp/PjJZE+Q8nr3Qh3NOgiSc/BsgCyB4N/9eaoJXMq5yHHmiTT5hir0uHl7RW91t
	 DOJU+YHj8BgVd+xQJDZr/TYNnRUemmBw4m/soljtQkAwmeIaA1JT+4hRXCkaoq7JDH
	 cgFgT0yRsWkqdaYT5g6BEZn74bZ/IXng9TE6yZis=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 23 Aug 2024 17:56:55 +0200
From: =?UTF-8?Q?Miroslav_=C5=A0ulc?= <miroslav.sulc@fordfrog.com>
To: linux-raid@vger.kernel.org
Subject: Re: problem with synology external raid
In-Reply-To: <CALtW_ahB+mDUWVhc0Y5KCnkvn+0PyWprCnpD4ufgw2b_6UhFrg@mail.gmail.com>
References: <d963fc43f8a7afee7f77d8ece450105f@fordfrog.com>
 <CALtW_ahB+mDUWVhc0Y5KCnkvn+0PyWprCnpD4ufgw2b_6UhFrg@mail.gmail.com>
Message-ID: <a2e93ce11a1846e7e245e8856d775ce9@fordfrog.com>
X-Sender: miroslav.sulc@fordfrog.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

hi Dragan, thank you for your reply.

Dne 2024-08-22 18:24, Dragan Milivojević napsal:
>> according to my understanding, as the disk 1 never finished the sync, 
>> i
>> cannot use it to recover the data, so the only way to recover the data
>> is to assemble the raid in degraded mode using disk 2-5, if i ever
>> succeed to make a copy of the disk 3. i'd just like to verify that my
>> understanding is correct and there is no other way to attempt to 
>> recover
>> the data. of course any hints are welcome.
> 
> You figured it right, the only advice is to use dd_rescue in an attempt 
> to get
> most of the data from the disk #3.

today i finally tried to ddrescue the broken disk, but the reading is so 
slow that it seems to be unrecoverable this way.
