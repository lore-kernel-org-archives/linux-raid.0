Received: from mx.febas.net (mx.febas.net [168.119.129.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5473002BC
	for <linux-raid@vger.kernel.org>; Wed,  3 Sep 2025 12:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.129.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756903779; cv=none; b=oGbGNqOJTZGazAwTaY2HVHlpp0fRejhhgcQXSSTyeoDOR9cXV7EybRUcV4eYhs1n56o+WaycHxfNjzbKYrxDajODfBasjdPXGLpabxSTPk8LAD8HMLV0agkcy4o4q86LWDhT6adxMASjnSfU3zjACuBogN19cj1a1qY+sQAr4RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756903779; c=relaxed/simple;
	bh=6t7g99u+9lt5BdoAeEBh3R28oClH0U2PgGpAdk2e/bk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=NsxjQXTtUYR8OcaqEkad89gviTeWm9B1GNPtIznYXGzeibfMZqzwLeu+vwdvJxkU58wxNsxEsApWH3F1nYzoFDe90uu9gftLBs+H9KE6OPUDUFNItwkxLl1/ccJc+hTd5Z+GHb3jeIzHVd0n0Ct82Lzc+kXTGKTOs28CxqOppNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de; spf=pass smtp.mailfrom=peter-speer.de; arc=none smtp.client-ip=168.119.129.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=peter-speer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=peter-speer.de
Received: from mx.febas.net (localhost [127.0.0.1])
	by mx.febas.net (Proxmox) with ESMTP id 4BAC760D22;
	Wed,  3 Sep 2025 14:49:32 +0200 (CEST)
Message-ID: <e2fe9238-17dc-45a0-9854-5d4414f353f5@peter-speer.de>
Date: Wed, 3 Sep 2025 14:49:29 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: RAID 1 | Changing HDs
To: Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org
References: <5c8e3075-e45a-410e-a23a-cbf0e86bdfa6@peter-speer.de>
 <c4fcc07a-eeaa-4307-8a5a-973c6df69bcd@suse.de>
Content-Language: de-DE
From: "Stefanie Leisestreichler (Febas)"
 <stefanie.leisestreichler@peter-speer.de>
In-Reply-To: <c4fcc07a-eeaa-4307-8a5a-973c6df69bcd@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 1.0.7 at mail.febas.net
X-Virus-Status: Clean

On 03.09.25 14:35, Hannes Reinecke wrote:
> it will serve as a nice exercise on what to do in case of a real
> fault :-)

LOL, you nailed it :)
And I was trying to make my life easier with dd :)

