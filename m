Received: from ns3.fnarfbargle.com (ns3.fnarfbargle.com [113.52.145.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7E918C03F;
	Mon,  8 Dec 2025 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.52.145.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765185580; cv=none; b=ay26/QQIiPtW/Z676+BYA47k7RcJ812nN6iZZeBVm4hJYT6Y+maMbmsD4Q7yJVxhG9bPi/eB2Lyf2uuUFH6geEUuLM6q35wLHuBbfqhrtzGXdF1kTYwjVfVfKLHqH68+9EvmZC0K35C16iHNXx3pTDdvb3mk6wPF3WqHY0Cs8Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765185580; c=relaxed/simple;
	bh=TdSj+Z7rSnHKZPtb4T60z5gP815UVD/P3YM4b6lKMKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mIHzrGvJmLqENFUgBWoCZgoIymo+pTQlnhFei2MgbBhkacx4N/CMxkCRqTHgS25Wu5V/hGhmR+oPIpj0TkhAPfBzufvMFczyJ/ouMxSvrYLjAvfj+gyKEAmy1emyzZiH6m8MJBV2A5inlk3ZdG8Sgx7UPVp8KA9ntCfTqJDDPKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fnarfbargle.com; spf=pass smtp.mailfrom=fnarfbargle.com; dkim=pass (1024-bit key) header.d=fnarfbargle.com header.i=@fnarfbargle.com header.b=mURRAzmP; arc=none smtp.client-ip=113.52.145.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fnarfbargle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnarfbargle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=fnarfbargle.com header.i=@fnarfbargle.com header.b="mURRAzmP"
Received: from [10.8.0.1] (helo=home.fnarfbargle.com)
	by ns3.fnarfbargle.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <brad@fnarfbargle.com>)
	id 1vSWqO-0007hO-2V;
	Mon, 08 Dec 2025 19:43:44 +1100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=fnarfbargle.com; s=mail; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=oHZu52l6cz+FXkGQvcVvd8GHMHrhu9c82SQRfVFrwnQ=; b=mURRAzmP5Cn8SQU6swHpGE34YB
	F2XuC83iKX5kFihmXNg7TQHlwO9R41Mk1i8dlg+eVQxiiLy5ElRO3IAmI0jn42qmsqwaY2cm+3+o6
	eol1PE0QsWu3L0Ps4iEUC0oUchpCWPuUoP8BhSmswVPoK8CvmU9mQGGtNw34MytG6DRs=;
Message-ID: <f6f1a5fd-814e-49f4-901e-28110feed5ee@fnarfbargle.com>
Date: Mon, 8 Dec 2025 16:43:43 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting
 reset, CSTS=0x1)
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
 =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org,
 linux-raid@vger.kernel.org
References: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
 <CALtW_ajVLbtUfVkKZU3tsxQbHMZsJR=jHK7PQNmvmSgjVhiUyg@mail.gmail.com>
 <CAO9zADx+5cNAxaz4R7SAndY5EX1z4V8i1e=rAdBbOTmxLmcopw@mail.gmail.com>
Content-Language: en-US
From: Brad Campbell <brad@fnarfbargle.com>
In-Reply-To: <CAO9zADx+5cNAxaz4R7SAndY5EX1z4V8i1e=rAdBbOTmxLmcopw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/12/25 22:14, Justin Piszcz wrote:
> On Tue, Nov 25, 2025 at 10:19 AM Dragan Milivojević <galileo@pkm-inc.com> wrote:
>>
>>> Issue/Summary:
>>> 1. Usually once a month, a random WD Red SN700 4TB NVME drive will
>>> drop out of a NAS array, after power cycling the device, it rebuilds
>>> successfully.
>>>
>>
>> Seen the same, although far less frequent, with Samsung SSD 980 PRO on
>> a Dell PowerEdge R7525.
>> It's the nature of consumer grade drives, I guess.
> 
> As this affects multiple NVME manufacturers, are you aware of any
> consumer-level NVME drives that do not have this problem or is moving
> to U.2/U.3 server drives necessary to avoid drives dropping offline?
> 
> 

Late to the party, but I've got Samsung 960Pro/970evo/980Pro, Crucial P2/T500, Kingston KC2000 and SKHynix P31 nvme drives in 24/7 machines and have *never* had an issue like this. 
The 960Pro suffers from long term slowdown, and the P2 is just an awful performer, but none of them have ever suffered from connectivity issues. The Samsungs, Kingston and the T500 are all in arrays.

None of these machines get power cycled and they might get rebooted once a year (or thereabouts).
