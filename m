Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7AB8613C
	for <linux-raid@vger.kernel.org>; Tue,  5 Mar 2024 14:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709648008; cv=none; b=aakS+4l01qVaUlKtdpOqFBBUXx8Hw0VXrtakrwTiku46qh1rp0SsipHYGtX52vFiJU4fmAtbhONZBTN6LBDtuCgmPrlCZ0qzbmJViYPirGwG8iLNZfdEfxqRsDs/p1w9b4whFVjbTcnG2DQaMBasve/E10jXIl0ZRzBH4EtWg8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709648008; c=relaxed/simple;
	bh=vF9xuUcbjRaoXnsRHRnuJ2WKQtD4EgJ9pc/dDobo/js=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NCOabcofvlWfrKsMG/VCIvyLOwchIJOrSKu68BCK0UAcX5HJmlLc3MxPHuQDf1+KxbSExrScW3qqZSbL4zJrWyLu8mNE9wMePs0BS8ajQQE1KkKF0D+SVO4E2M6qZUbDnJXYJGko7bkqXADqtYBE/5oKno+DoFVhEXZH5IwhIRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.34] (g34.guest.molgen.mpg.de [141.14.220.34])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 36C0D61E5FE36;
	Tue,  5 Mar 2024 15:10:45 +0100 (CET)
Message-ID: <7709385e-1770-4fc3-bc92-7a93b754375f@molgen.mpg.de>
Date: Tue, 5 Mar 2024 15:10:44 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] md: Replace md_thread's wait queue with the swait
 variant
Content-Language: en-US
To: =?UTF-8?Q?Florian-Ewald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Cc: Jack Wang <jinpu.wang@ionos.com>, song@kernel.org, yukuai3@huawei.com,
 linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
References: <20240305105419.21077-1-jinpu.wang@ionos.com>
 <9874f0e8-32d4-4c29-a332-718fb95a365a@molgen.mpg.de>
 <CAHJVUegG9cL6WnNCeokOnAAJyb4yEWnyzi=S20=K=sREJy3AOQ@mail.gmail.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <CAHJVUegG9cL6WnNCeokOnAAJyb4yEWnyzi=S20=K=sREJy3AOQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Florian-Ewald,


Thank you for your quick reply.

Am 05.03.24 um 13:25 schrieb Florian-Ewald Müller:

> Regarding the INTERRUPTIBLE wait:
> - it was introduced that time only for _not_ contributing to load-average.
> - now obsolete, see also explanation in our patch.

Yes, I understood that. My question was regarding, if this should be 
backported to the stable series.

> Regarding our tests:
> - we used 100 logical volumes (and more) doing full-blown random rd/wr
> IO (fio) to the same md-raid1/raid5 device.

Do you have a script to create these volumes and running the fio test, 
so it’s easy to reproduce?

Was it a spinning disk or SSD device?


Kind regards,

Paul
