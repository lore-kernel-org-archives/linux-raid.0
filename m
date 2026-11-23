Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795416976;
	b=3pp/FZERjeXyDofFKF1/hlslXIkmk973bLc+VVqBpUHFbkUk0cGJToIbldVtGYWen2bv
	 zEm2+uFgkmJMTid7XI1v2geNc1kB9tiZf8QzAMdPhXLKIgFMAfOUeKmZpeoqiSuzrS58f
	 yIBmwi5SxkuFFapBU59KEYCX6Hl7MdyRmuOUKbMFuP1Bsy0aw5/kmF2cv8DFcQleONymP
	 lvrgnMRJwa0Mdqf1KV06GU1l64yZ+yCSf3FvZVKMvaraN5Dxylmx0vf/Db1+SgOgDpq8X
	 od3GGmfJ7n7N8bd0ZGmmEA3YQ2ybbaj2OIWeZvKjjEdzq1pu6FEGRD2phjKm/TpcPjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795416976;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=gTnVWHTfUhZKo7t2K5Rcuo62SqfW6uLv+THwmmGd5vQj5zBDuzBkNJpGIlmUwrMdYyk2
	 sG8pFYRWlbnpiMHwTaiqFHG8XCp69n8uQA1sxYOdpj1v5h4CMLiYY8uldMdO1iUMc02uT
	 XFAtojtV9+Pw+9+rthB053Ubh85i/J0t8/0rvb7jnpFGJWQSu1iTJ2IkvOv7G8+3d6pe6
	 n3UyjRkH09zYxwQjuullJOQ4jxVokpXMVad7g5of5cWhSzoLmtCOPsGU6Q0vgCvYjrZRo
	 L/tT/c6pTsdC61K0O1E6NiT6QV+Qj6UBbExeqRNFao7vFTIG2IiSRD87pXZhDzIRk9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F45606A31E;
	Mon, 23 Nov 2026 06:56:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 07F45606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1B4B968BEB; Mon, 23 Nov 2026 07:56:12 +0100 (CET)
Date: Mon, 23 Nov 2026 07:56:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Miroslav Cimerman <mc@raidlab.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@lst.de>,
	David Laight <david.laight.linux@gmail.com>,
	Markus Stockhausen <markus.stockhausen@collogia.de>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] raid6: remove the sfence from the x86 xor_syndrome
 functions
Message-ID: <20261123065611.GB17691@lst.de>
References: <20261122032933.2306875-1-mc@raidlab.org> <20261122032933.2306875-3-mc@raidlab.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122032933.2306875-3-mc@raidlab.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

