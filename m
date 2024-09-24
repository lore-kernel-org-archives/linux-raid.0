Received: from anvil.nuitari.net (mail.nuitari.net [192.99.15.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770002EAE6
	for <linux-raid@vger.kernel.org>; Tue, 24 Sep 2024 04:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.99.15.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727151551; cv=none; b=RAe26dBmi38pwTwiRdLy19i0FfoRslfuq/PBmHmJp05RwzaC/Wiuv5PQPyuPwP50kwVMOL0xxw8FuQCem33HXKLKZTIX2jSqnUDljIRJpgSYk5CjbwRLyQ7CGrqGJBKnTHN8m5qB4DoF/crBOaRmVriRuUMcYhSmZNmIv0R0iio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727151551; c=relaxed/simple;
	bh=EEN5LKZ+Bhd6ghBST7WTeJ7t1ogReA2vxrCdFWvt56g=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=qc50TZsPxrKIvfcTVsYCr6y76RIIWHROtLQrfCzD8JCXtj4z12l0jIdWHxPKh0JPHZKKqhvxUgWkRO2oKSQUVV4ssF9aFgO2TO01bALG6NYJ7uPMy5CEQb5XoCXZeIBMoya03aft/wKPC9pp6sh+YmkG58HxopTNw4D4HxAqHxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nuitari.net; spf=pass smtp.mailfrom=nuitari.net; dkim=pass (2048-bit key) header.d=nuitari.net header.i=@nuitari.net header.b=Rys7X5f4; arc=none smtp.client-ip=192.99.15.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nuitari.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nuitari.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nuitari.net header.i=@nuitari.net header.b="Rys7X5f4"
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=nuitari.net; h=date:from
	:to:cc:subject:in-reply-to:message-id:references:mime-version
	:content-type; s=anvil; bh=EEN5LKZ+Bhd6ghBST7WTeJ7t1ogReA2vxrCdF
	Wvt56g=; b=Rys7X5f40VcWpQY5SAJUuyjFyos+7/XZ5m6dJAePoml964I70RwAB
	hsQdhjEBqP/mnT+fFaUzlO7/8FG7uOR2MQf9OtU2ZHtK28/EUc2YKQM6ownsuEKu
	3atiL7D+oz6x+WNQjqekr6GzFO2pSHsFYcyX/SL/+gUKeGBiQtct5at2OtVUXM0R
	u31qThqysl09W6pBfbPPwSWH0pcsJZsasRRYaFwRE4G1osJInkRzVqjcy4enw30n
	YFw5fesO3QV1JjR7JmKOy7C6b4NGwC2FpnaB562tnb5uaq0T5DpmEvzkD7PwxRaF
	zj/kx28o+7CTrAjiYnXy5Ooakrar66n4w==
Received: (qmail 11433 invoked by uid 210); 24 Sep 2024 04:18:59 -0000
Received: from 127.0.0.1 by mail (envelope-from <nuitari-vger@nuitari.net>, uid 201) with qmail-scanner-2.08st 
 (clamdscan: 1.3.1/27407. spamassassin: 4.0.1. perlscan: 2.08st.  
 Clear:RC:1(127.0.0.1):. 
 Processed in 0.019899 secs); 24 Sep 2024 04:18:59 -0000
Received: from unknown (HELO localhost) (127.0.0.1)
  by localhost with ESMTPS (TLS_AES_256_GCM_SHA384 encrypted); 24 Sep 2024 04:18:59 -0000
Date: Tue, 24 Sep 2024 04:18:59 +0000 ()
From: Stephane Bakhos <nuitari-vger@nuitari.net>
To: William Morgan <therealbrewer@gmail.com>
cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid <linux-raid@vger.kernel.org>, 
    "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: RAID 10 reshape is stuck - please help
In-Reply-To: <CALc6PW71Bzzvv+M+SmXYCCHjCA6cni5HcAMiRvP-v+dwXhz24A@mail.gmail.com>
Message-ID: <0baa2f9a-68e9-92f5-962f-3ca1246638d2@nuitari.net>
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com> <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com> <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com> <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
 <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com> <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com> <b118cf34-2957-65ed-761b-f999c4ff03fc@nuitari.net>
 <CALc6PW71Bzzvv+M+SmXYCCHjCA6cni5HcAMiRvP-v+dwXhz24A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII

> smartctl shows all disks passing. I'm not a SMART expert, so I can
> post the results if you want to look at them yourself, but it seems
> like a lot to post if you don't want it.

Check the following attributes:

- Reallocated_Sector_Ct
- Seek_Error_Rate
- Current_Pending_Sector
- Offline_Uncorrectable
- Raw_Read_Error_Rate

If any of these are increasing, its a sign of a dead drive. If 
the drive is taking a long time to time out from a surface defect it could 
be the cause.

- UDMA_CRC_Error_Count

That one is usually a sign of a bad cable.

>> Are the components of md1 (the unrelated array) on a different hardware
>> controller / wires?
>
> Same controller, but I see the same results even if I unplug md1.

Have you tried replacing the cabling and the backplane?

I'm not sure what layout you have, but something I'd try is to remove the 
drives for md1 and put the md127 drives in the place where the md1 were. 
It would help rule out that either is the issue.
