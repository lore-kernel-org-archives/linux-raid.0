Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3AE2F49F2;
	Wed, 16 Jul 2025 12:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752667840; cv=none; b=W4rTvX57pQbaqy8hR3BNFl/1oMbVugHh5Wf45W7M2eswaNJJToBq5347bRy80H3ZkVPwjufGGtWDTmg8BsxR4CINUR/4fS7j5i/wtKV7BsEY8xAUaceMLiUikssZLMw8fOiDc/qDTVcQxvWGijVi16HKzG3xJuqv6J+bsV92mDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752667840; c=relaxed/simple;
	bh=h3KUIie0v4YlgYAJZ1dELCURyvjtx5HZz2JBs6b4Wlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epEr0XNLLuQVg/d/aJxIY5jB8l38BvpV9yhch4xgah7/o8CwcRpfWzjVv/4A6dz3Qdug33dQil2AnhgYI+4Fb53+iRm50nXNz6SO67HY+WknadzBNXEbIABF8rv2du3cn76tjMhg3MrkNqNaMzQHIPjRyfe1268sJm9HyKK45as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BfyH4Zw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BfyH4Zw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC79C4CEF4;
	Wed, 16 Jul 2025 12:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752667840;
	bh=h3KUIie0v4YlgYAJZ1dELCURyvjtx5HZz2JBs6b4Wlw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BfyH4Zw3Gyd3SgWtd2ficUFHURJyQMF5WF/tXXIdPef/cm22GajAhJ8DM6osgMlHH
	 COYzB4yqUpFp145cqsNhFdIt3KRp0yP2LRzUo/iY23uWPNnJIKZ8gO1UTQoNNe3mbK
	 oSJZ2WST84Hiu7LzKsLduFcK9WB/cAvAZ82/aZkXA+mN15V1+FhJdCEcvWONyHEAsT
	 1x8iake1N2F6BYS3AxlHCslgPkrdO6+jBWzhOqjVyPp1E94A7DhpGmUFQLz95GyiRa
	 ZhfoP7yEh0RfKQ9W/uThGEq85Vk9L6yPk1ZB4ZwGKdzkoyjWn+NnU3YZEQyy8O6ivw
	 n4KTnSMa8MdFw==
Date: Wed, 16 Jul 2025 20:10:33 +0800
From: Coly Li <colyli@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Coly Li <i@coly.li>, linux-raid@vger.kernel.org, 
	linux-block@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>, Xiao Ni <xni@redhat.com>, 
	Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>, Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Message-ID: <danlsghtalte7sku3vlfxkgngujgwzspanfayaxy4jfnk54jbf@yfvmr5plavmp>
References: <20250715180241.29731-1-colyli@kernel.org>
 <20250716113737.GA31369@lst.de>
 <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li>
 <20250716114121.GA32207@lst.de>
 <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li>
 <20250716114533.GA32631@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250716114533.GA32631@lst.de>

On Wed, Jul 16, 2025 at 01:45:33PM +0800, Christoph Hellwig wrote:
> On Wed, Jul 16, 2025 at 07:44:38PM +0800, Coly Li wrote:
> > Do you mean setting max_hw_sectors as (chunk_size * data_disks)?
> 
> If that is what works best: yes.
>

Simplying setting max_hw_sectors as opt_io_size doesn't solve 2 issues,
1, the split length might be aligned to opt_io_size, but the start offset
   of a split bio cannot alwasy be aligned to opt_io_size. Current code
   in bio_split_rw() doesn't handle the alignment.
2, opt_io_size is not large enough comparing max_hw_sector, extra bios
   in the recursive md code path may hurt performance. Anyway this can be
   solved by setting max_hw_size as multiple of opt_io_size.

Just like hanlding discard requests, handling raid5 read/write bios should
try to split the large bio into opt_io_size aligned both *offset* and
*length*. If I understand correctly, bio_split_to_limits() doesn't handle
offset alignment for read5 read/write bios.

Coly Li
