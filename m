Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CC4EC2;
	Wed, 16 Jul 2025 16:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752683379; cv=none; b=AZvUuOC97J91D807wNATALuz3byA8rADLwDnLqZXHxJE4oZ7cNXtFtz96aSBLraOXlMBfvKZK4jKXkS1/k0heDKgIe7n/r5IJ3j5aLebWg4ys7HwvKLjKLMN+dO061ixWrGw6h3mKLwkJxrgwuXAuMRwMuDwuAZWVKYvRZXbc2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752683379; c=relaxed/simple;
	bh=7LtaZGbcu3N/ibo5xwvQDTM1d1oOAkSar/tn3F2rQEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N43Y4inLC4fz6W73tn7qyZ5m4iMLPDOJrZOhUc+d9lAhF4KvTvcxPF6/mZUW9Lmj9zgf5gjiOzMbBzBsTXnqODVzhavbNxwjShgOM/ML42C08is7qvlFSd80SXLa4202OQyGS6XWpS58CgOTbEm6W7xmsu3sAxUUyBzilcwQ36c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMzghLaK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMzghLaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B964BC4CEE7;
	Wed, 16 Jul 2025 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752683376;
	bh=7LtaZGbcu3N/ibo5xwvQDTM1d1oOAkSar/tn3F2rQEc=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PMzghLaK3//doW21Uo6om0hMmYJHZ/MkKaICDlyY7Jvfkq1OPbDagN8iKYP4K4tEA
	 iL6Ju+zSsvFjyro+W5EB8KSs6JsDffUtExHr+3iQf3fpiEuYvStZWZMMt/jOsaBppY
	 P5T+vSt1rIckK8vyCeUTw5Wkfpt/0/anAGdMyusBXpo44NswwzoXIztHjW34Ij4Y6+
	 BcPaGaRydunkb5ABqS/ItRUQgwNxHjYJzEp2xsGpzSu1+Mrl1rePKttcN3pj8cadrd
	 n7F2YIj3OpWe1xKzVc6zZeO8RGlUSJTZowAkGVjCI4PCOheFQJMR0fOOdHY9v7+oB9
	 AKLSydxGzym3g==
Message-ID: <284433c9-c11d-401f-8015-41faa9d0fde1@kernel.org>
Date: Thu, 17 Jul 2025 00:29:27 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@kernel.org
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
To: Coly Li <i@coly.li>, Christoph Hellwig <hch@lst.de>
Cc: Coly Li <colyli@kernel.org>, linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
 Xiao Ni <xni@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Martin Wilck <mwilck@suse.com>, Keith Busch <kbusch@kernel.org>
References: <20250715180241.29731-1-colyli@kernel.org>
 <20250716113737.GA31369@lst.de>
 <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li>
 <20250716114121.GA32207@lst.de>
 <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li>
 <20250716114533.GA32631@lst.de>
 <danlsghtalte7sku3vlfxkgngujgwzspanfayaxy4jfnk54jbf@yfvmr5plavmp>
 <20250716121449.GB2043@lst.de> <DE36C995-4014-44DC-A998-1C4FF9AFD7F9@coly.li>
 <20250716121745.GA2700@lst.de> <109C6212-FE63-4FD2-ACC3-F64C44C7D227@coly.li>
Content-Language: en-US
From: Yu Kuai <yukuai@kernel.org>
In-Reply-To: <109C6212-FE63-4FD2-ACC3-F64C44C7D227@coly.li>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

在 2025/7/16 20:23, Coly Li 写道:
>
>> 2025年7月16日 20:17，Christoph Hellwig <hch@lst.de> 写道：
>>
>> On Wed, Jul 16, 2025 at 08:16:34PM +0800, Coly Li wrote:
>>>
>>>> 2025年7月16日 20:14，Christoph Hellwig <hch@lst.de> 写道：
>>>>
>>>> On Wed, Jul 16, 2025 at 08:10:33PM +0800, Coly Li wrote:
>>>>> Just like hanlding discard requests, handling raid5 read/write bios should
>>>>> try to split the large bio into opt_io_size aligned both *offset* and
>>>>> *length*. If I understand correctly, bio_split_to_limits() doesn't handle
>>>>> offset alignment for read5 read/write bios.
>>>> Well, if you want offset alignment, set chunk_sectors.
>>>>
>>> Do you mean setting max_hw_sectors as chunk_sectors?
>> Setting both to the desired value (full stipe width).
>>
> Do you mean setting chunk_size as (chunk_size * data_disks)?  This is deadlock…
>
> If opt_io_size is (chunk_size * data_disks), setting new max_hw_sectors as rounddown(current max_hw_sectors, opt_io_size) is good idea.

I think round down max_hw_sectors to io_opt(chunk_size * data_disks) 
will really
make things much easier, perhaps Christoph means this way. All you need 
to do is to
handle not aligned bio and split that part, and for aligned bio fall 
back to use
bio_split_to_limits().

Thanks,
Kuai
>
> Thanks.
>
> Coly Li
>
>

