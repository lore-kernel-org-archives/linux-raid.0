Received: from mail.bonnevilleinformatics.com (mail.bn-i.net [69.92.154.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544D41547FE;
	Mon, 27 Jan 2025 08:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.92.154.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737967896; cv=none; b=FBLnFuOaYISK6XlKNucLEvuKNTXhdkdeYjQWoMdxVm0lAICAFxjoax8zJyfB5OeqlXRxNv46qBReqetlvx7fV3vYDikjbTu1idx0T3R7mWnyJtsyTTnVOxdeQVMKSo90yDVtAwrXpl6CmvfWP/xgLYYOTOMEU710vAaDSGAvrOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737967896; c=relaxed/simple;
	bh=YT6Evw6Bx7YVD4RnUNyyo2ofYRdyhbH1xONSR5WmpsY=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=HKvAsbE2C7dLu39o5Gmj6BMqVuGXGos6LBa2DewdtdbjU8AtKXzaAgnogTI8Y42xz1GzHQuRXS5j5S9E596S4vJGNUlh4Ih3kdI42gYHFySTf7d83pQZRsnR2EuT4pyCRCEibu3MRzIrozfwIrC8Z5hpyWf01siVap1EBPkfl78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net; spf=pass smtp.mailfrom=dougvj.net; dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b=acy+g8T1; arc=none smtp.client-ip=69.92.154.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dougvj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b="acy+g8T1"
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dougvj.net; s=dkim;
	t=1737967887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DagScD2NSC/c1C2EVWbGEEXnUNQJq3Kr6GHSC/gUJvY=;
	b=acy+g8T1fFIXSFdFTrItuKu0Ff8sxw6bopMx3MKwOOhXrjTht9HOY6bqhkUMpo97Q3D1UM
	+tE21z9aYZcUcWemfSjaEOxI26Nvtqm7JkoaOJJMEei3iZa4RS8OoFxvfGdjgbtqLTdmrN
	7iz44fI0/+boSrhOSv0qjHO95Xu3SXs=
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=dougvj@dougvj.net
Date: Mon, 27 Jan 2025 08:51:26 +0000
From: Doug V Johnson <dougvj@dougvj.net>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Doug Johnson <dougvj@gmail.com>, Song Liu <song@kernel.org>, "open
 list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 1/2] md/raid5: skip stripes with bad reads during reshape
 to avoid stall
In-Reply-To: <9c3420a9-8f6a-1102-37d2-8f32787b2f9a@huaweicloud.com>
References: <20250125012702.18773-1-dougvj@dougvj.net>
 <9c3420a9-8f6a-1102-37d2-8f32787b2f9a@huaweicloud.com>
Message-ID: <25cd636a52da0db2db91a220a9eea68b@dougvj.net>
X-Sender: dougvj@dougvj.net
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Bar: ---

> So, perhaps just abort the reshape will make more sense to me, because
> user will lost more data if so.

Ah yes, I agree that does make more sense. I appreciate the prompt 
feedback and explanation. I will submit a v2 soon.
