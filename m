Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150B5469D
	for <linux-raid@vger.kernel.org>; Mon,  3 Nov 2025 01:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762131923; cv=none; b=twdysDGcp8SXy1TZq26uQgfPmam43/PpIZTw1X9e6ng0Xkz9cDVC8wTHiLU5Lt9ifpoQ73PexUlL0z0Rjl8sFab9OsnqEvWF/nUpdOLvtT9seJSXtO1FGWiw62oGa7YYMAYktYR3tkpUUNCG0/bRXyircif9ALHDn0wb4JQzasA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762131923; c=relaxed/simple;
	bh=1FBrvtOksObuJVa44YUtnnKjMu+QdZnogB8JuMuKPAg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=K0DGcDuhKZeevMnkDAsZI3Jmvvx06oxL3b0gGZVvWs1/EPtWe7tfxuMX6jogax5/lkXkNgKBen/tIYGDYSOtRyBnvs/ibOIwmwThu/IkCWALFNvwDqllvzHU3EdMHH0ONAOidLTqRH4wyy/Liryc0Hleq+3GMHohd3Fl3EqQ8aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=oHpWM9H+; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="oHpWM9H+"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1FBrvtOksObuJVa44YUtnnKjMu+QdZnogB8JuMuKPAg=;
	b=oHpWM9H+vfFrc8m4OhXpt9Q7GmcocAFmQslcJRLzxuTc4WI0BmW9r4xgqwjExxHGs2m6f0Sng
	CF2lK44V3eQofyyOjftXpslhPSODE/UHKtoIuCcOtXiMvJg0dsNQ4HdLmSJutEMMVEn2zKaQV7i
	4JxtzZSlz7rpW84IWNA8OJY=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4d0CyK1Z3Tz1cyPl
	for <linux-raid@vger.kernel.org>; Mon,  3 Nov 2025 09:03:37 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id 489D2140230
	for <linux-raid@vger.kernel.org>; Mon,  3 Nov 2025 09:05:11 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Nov 2025 09:05:10 +0800
Message-ID: <1f33de91-3ff2-60e4-8281-153e388a8bbb@huawei.com>
Date: Mon, 3 Nov 2025 09:05:10 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To: <linux-raid@vger.kernel.org>, yangerkun <yangerkun@huawei.com>
From: yangerkun <yangerkun@huawei.com>
Subject: subscribe linux-raid
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100006.china.huawei.com (7.202.181.220)

subscribe linux-raid yangerkun@huawei.com
