Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732BF38E17F;
	Wed, 17 Dec 2025 14:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980290; cv=none; b=BiQHvmMFpd3QVguoaM7mnwNNqc9kwcQjdR9ICQBaG85187u4L13kIomX2c77uSkEeLl5skBGUk8g9ui1Hku3/oqxD8XwVZjKh2uga039xtYB1ViWCS+l8SOR+/4PZnxI8NtNX1i+c4+m0fesX5uzgOI5SA8PFCV+/WEETPDgSlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980290; c=relaxed/simple;
	bh=ckJeJ5g6WxjOTeVMfNXeSoANYt8vgfEOY0wGDT2r/yM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B78zG7DsXWCXgsGZWz87ZL4mdBX8QzbXgv2+1iYh2KVwe+ku9xG1m0M5tr89P5f8VARy/7+c4OBFqCn1i8rPmD3CH9JKtGRM4K265sSwb6uV8v0U3iooInPsPivs/5th0nK9CAQGeAWjk/8y/BW/U+Vc6gIsCu/p7KfLv2cS6K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=as5vfWmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="as5vfWmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D381C4CEF5;
	Wed, 17 Dec 2025 14:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765980290;
	bh=ckJeJ5g6WxjOTeVMfNXeSoANYt8vgfEOY0wGDT2r/yM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=as5vfWmkPVbZ9860gyrbNmxfT4nuhD+4EGGFYnO+/S3jp/P/0xc0sx5M5wh0bp6NV
	 ishUND4J0qLTqSp9fsjN0q+UOAQUhgdr7hKSMpjrKUNMcmObZneGXYdcANVEkIEdU/
	 yKeAuj2hsMShohmDJCRMW/kh9go1CnH56AMbzrb4=
Date: Wed, 17 Dec 2025 15:04:46 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: linan666@huaweicloud.com
Cc: stable@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	yangerkun@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH stable/6.18-6.17] md: add check_new_feature module
 parameter
Message-ID: <2025121700-pedicure-reckless-65b9@gregkh>
References: <20251217130513.2706844-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217130513.2706844-1-linan666@huaweicloud.com>

On Wed, Dec 17, 2025 at 09:05:13PM +0800, linan666@huaweicloud.com wrote:
> From: Li Nan <linan122@huawei.com>
> 
> commit 9c47127a807da3e36ce80f7c83a1134a291fc021 upstream.
> 
> Raid checks if pad3 is zero when loading superblock from disk. Arrays
> created with new features may fail to assemble on old kernels as pad3
> is used.
> 
> Add module parameter check_new_feature to bypass this check.

This is a new feature, why does it need to go to stable kernels?

And a module parameter?  Ugh, this isn't the 1990's anymore, this is not
good and will be a mess over time (think multiple devices...)

thanks,

greg k-h
