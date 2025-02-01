Received: from zenith.plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B19E126F1E
	for <linux-raid@vger.kernel.org>; Sat,  1 Feb 2025 21:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738444387; cv=none; b=SRL++oyfsBaLZy/w4UI1k9kU2WmRUtVDv4v3H1+qSxz5r2KzgOr/Rj8ZMwhZgA2iolECqCMED5m0OEZdGRzRpzMDMbcPc2d8sICaVU70Pe4JEvEELJF3yevkk1jlBVB60cqwjsZPZWuw4G0fhTtA0C3Xqk0zfKNmzAhwUBIOAJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738444387; c=relaxed/simple;
	bh=LlXS8aGOC7V01JMFqCxuNpahmqPwdIKK8m/+sdmmbcI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=f9uo0v+zmE2ypHDw/L9HxOiiH2vDby/Yg9LRXcTVlcS1G1XSNVrZqeyG9fzZgJsvWfdcTbW7BtULs6JDPs3h2OsbHLd/ickabClYhYvhgUdcpu6GInFLCMWYhPbhlkvL1X9imIbWZTbf7CbX/RuBeNWHQnwXpDRdK2jmZe/WOTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Received: from [192.168.0.252]
	by zenith.plouf.fr.eu.org with esmtp (Exim 4.89)
	(envelope-from <pascal@plouf.fr.eu.org>)
	id 1teKGJ-0003dF-7D
	for linux-raid@vger.kernel.org; Sat, 01 Feb 2025 21:38:43 +0100
Message-ID: <bbd2c2b2-69d9-4262-8c33-6b59ef45fa7e@plouf.fr.eu.org>
Date: Sat, 1 Feb 2025 21:38:41 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mdadm/raid5, spare disk or spare space
Content-Language: en-US
To: linux-raid@vger.kernel.org
References: <CAAiJnjqvFAK1b26tVfzt2An1=Uxbftru7VRmVtQ55R0zH69mYA@mail.gmail.com>
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <CAAiJnjqvFAK1b26tVfzt2An1=Uxbftru7VRmVtQ55R0zH69mYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 at 20:45, Anton Gavriliuk wrote:
> 
> Here is raid5 setup during build time
> 
>      Number   Major   Minor   RaidDevice State
>         0     259        3        0      active sync   /dev/nvme3n1
>         1     259        4        1      active sync   /dev/nvme4n1
>         3     259        5        2      spare rebuilding   /dev/nvme5n1
> 
>         4     259        6        -      spare   /dev/nvme6n1
>         5     259        7        -      spare   /dev/nvme7n1
> 
> I'm asking because during build time according to iostat or sar,
> writes occurs only on /dev/nvme5n1 and never on /dev/nvme3n1 and
> /dev/nvme4n1.
> 
> So if parity is distributed in mdadm/raid5, why mdadm writes only on
> /dev/nvme5n1 ?

Because, as you can see, nvme5n1 is being rebuilt from the two others.

 From mdadm(1) man page:
"When creating a RAID5 array, mdadm will automatically create a degraded 
array with an extra spare drive.  This is  because  building the spare 
into a degraded array is in general faster than resyncing the parity on 
a non-degraded, but not clean, array.  This feature can be overridden 
with the --force option."

I guess this way is faster on hard disks because it implies sequential 
read on N-1 drives and sequential write on the other drive, sequential 
read and write speeds are similar and sequential write does not cause 
significant wear. But it may differ on SSDs, spreading reads and writes 
among all drives may be more efficient.
