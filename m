Received: from plouf.fr.eu.org (plouf.fr.eu.org [213.41.155.166])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188A21DDEA
	for <linux-raid@vger.kernel.org>; Fri, 26 Jan 2024 18:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.41.155.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706295419; cv=none; b=SmdxBd9dnvGTK7mC40yWr176jE68OtZgpJdVgK8EZUoufUY2Is/MMor6BtVvT/510iCoDoAtx8BvycRpDgAwiiYHS4TGQs4q2DDLXJWvxYd8E8GFNnUDfN/2nYj3BkfyXB2ahaIQpUEgYYwKRCCG6nRNSgDiiVAp223671ZCBLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706295419; c=relaxed/simple;
	bh=tntvMEtJ6ZjqrHpAy4kKtLqYMSKt3+CEU0FCbkCCfX4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=md0IJz1qplI84vFsTEVDZy/b3N4mUk66cTJtE4Doqk3MzVTlHu20Txx76JEMM9y7vB5llbrmENlm/Sq8oON6KLgSUrM7G2TMMZRn8s8Q+X5fS5zPp0QWyBUsjlPRcGSFQEh5+HeT9PcJfXXu6H0Q0MNJs5fr+f6ueR8HjOz75w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org; spf=pass smtp.mailfrom=plouf.fr.eu.org; arc=none smtp.client-ip=213.41.155.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plouf.fr.eu.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plouf.fr.eu.org
Message-ID: <2e7b4c04-27b6-407b-8001-cad9240239bf@plouf.fr.eu.org>
Date: Fri, 26 Jan 2024 19:39:01 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: New device added but i did a mess
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXjrmVRBpP-vr1io0unxqKZ_QE464G9R6G4Ekct3ShVx6g@mail.gmail.com>
Content-Language: en-US
From: Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <CAJH6TXjrmVRBpP-vr1io0unxqKZ_QE464G9R6G4Ekct3ShVx6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 25/01/2024 at 15:49, Gandalf Corvotempesta wrote:
> 
> 2. how can I ensure that sdd is working as expected and data were
> synced properly?

You can "scrub" the array with madam --action=check.
