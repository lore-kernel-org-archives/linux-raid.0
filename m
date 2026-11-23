Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795416968;
	b=UapPxW4mDsabXX1i6etZnGQTywJSkFRG6M7gIzJlNOcCOBjqjgzZlWJeZUkI1e2jA4AD
	 JEn8CVQ761cXdVr9DoOY5044zYQ5RZiancYdbR+iYuOHMwPZ5laS/5lCwGwHgU/QOvK2l
	 /3bWfn72WXvC9NMizV3Gx22YcOfp4IxE+chENDFA+rVC/UmJXbDBad/EVOwS2y6dF40Kg
	 lE4PjeuJDy+6rMu8iyJFsGa1FHYBcdFGzOFodzdscCJq7fesejqjG/HQ5Gny/B7n6Lt3h
	 2+YriGPH9TolsMVzomKSVfGmOBLFpzjP+jMmq3OjoX8K/guvQW/pvKU0lNcxvuZOC2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795416968;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=TRM4zPo+EIfqIEzpeaRvb0i5GcinWjlFt565676QP9AjrTM0luAj7M8BErjYTFG8+iUm
	 4EWV0oafAHasn4+Q8ksf6+62mzt/Um+xGwQ1XKZ5/TZ4RhOXlHIfv8SHf+uCvESBjFE+a
	 wQk71m2pmObPp1Oxy3ApNVDDWWuaHThfsXUG23f/Hdu0bFUtnWmmhl0qeZo8RSs55lSHE
	 y5xWclUl4vAug9uTnN8lZlAH/X2WKECv/uoGf/I5eRAAYozoiJYCVB9yLOA+gX4rfK4Vv
	 kbiNpq7mnpnhy4Q2ivQ/qDY6zMZ18dLZmIkkcyqmMBNm9wHB4K4UqO8uNolt/zvb7yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39F2606A31A;
	Mon, 23 Nov 2026 06:56:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C39F2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2E58968AFE; Mon, 23 Nov 2026 07:55:56 +0100 (CET)
Date: Mon, 23 Nov 2026 07:55:56 +0100
From: Christoph Hellwig <hch@lst.de>
To: Miroslav Cimerman <mc@raidlab.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@lst.de>,
	David Laight <david.laight.linux@gmail.com>,
	Markus Stockhausen <markus.stockhausen@collogia.de>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] raid6: declare the AVX-512 P/Q stores as asm
 outputs
Message-ID: <20261123065555.GA17691@lst.de>
References: <20261122032933.2306875-1-mc@raidlab.org> <20261122032933.2306875-2-mc@raidlab.org>
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
In-Reply-To: <20261122032933.2306875-2-mc@raidlab.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
