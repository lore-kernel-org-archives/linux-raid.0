Received: from mailout-l3b-97.contactoffice.com (mailout-l3b-97.contactoffice.com [212.3.242.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7521610B
	for <linux-raid@vger.kernel.org>; Mon,  1 Jan 2024 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=penguinpee.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=penguinpee.nl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=penguinpee.nl header.i=lists@penguinpee.nl header.b="lvn13iid"
Received: from smtpauth1.co-bxl (smtpauth1.co-bxl [10.2.0.15])
	by mailout-l3b-97.contactoffice.com (Postfix) with ESMTP id E03335A6
	for <linux-raid@vger.kernel.org>; Mon,  1 Jan 2024 17:10:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1704125413;
	s=20220317-a4qe; d=penguinpee.nl; i=lists@penguinpee.nl;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	l=816; bh=w/lLt/6d8RSlF8Z3qiaMidFI7IzIwBmMJ93k40Bq5dg=;
	b=lvn13iidOka6FP9Qy7Oc2f47DCGxwfIgilbNCZogYLe7Nr/qNAbWtEgtGaEEgp6T
	v1X7xkqFWaVB/QvXaf6nMjChmHrAQrH4YXuowOl4LjvBs/qvzYPCz8XkHMKSV+TzMfD
	cD7/H88Wqjz2EXCET7Vf6uYrqqjY78zbewjyUOk2+yZqyhrukCpT/mxqnZzyGW0qmUU
	01UWE0hYPgsX6kDyXReT1AfPNOr2+kGDwKL3wJN7ysr0LdM3XfE1/SNAnTjJNHccl7G
	jp4rz+mIfalfxHfFDAeGnc1C8uQ78XzALTkHfq2a4w9uJAOAB1shJA87u3oMQ8NSJLG
	7jxQK8t1rg==
Received: by smtp.mailfence.com with ESMTPSA
          for <linux-raid@vger.kernel.org> ; Mon, 1 Jan 2024 17:10:10 +0100 (CET)
Message-ID: <baa4af41-e187-4fb4-875b-df30ef442b68@penguinpee.nl>
Date: Mon, 1 Jan 2024 17:10:09 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Sandro <lists@penguinpee.nl>
Subject: Re: Two functional arrays are not assembled during boot after system
 upgrade
Content-Language: en-US, nl, de-DE
To: linux-raid@vger.kernel.org
References: <9e8cd48e-e4b1-4937-bf59-729dc5d4b5a1@penguinpee.nl>
In-Reply-To: <9e8cd48e-e4b1-4937-bf59-729dc5d4b5a1@penguinpee.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-ContactOffice-Account: com:132533765

On 28-12-2023 23:40, Sandro wrote:
> I recently upgraded my system from Fedora 37 to 39. During boot into the 
> upgraded system I was thrown into emergency mode. It turned out two MD 
> arrays had not been assembled. Unfortunately, I could not find any 
> information in the logs as to what went wrong where.

<snip>

Further troubleshooting and investigation determined (lib)blkid to be 
the culprit. The version shipped in Fedora 39 (2.39.2) returns 
incomplete partition information in certain circumstances. Among other 
properties, UUID and TYPE are missing. Downgrading to 2.38.1 fixes the 
issue.

Meanwhile version 2.39.3 of util-linux has been released. However, I 
haven't had the time yet to look at the changelog to see if it contains 
a fix for the issue.

Thanks for your time,

-- Sandro

