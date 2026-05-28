Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE70A34041D;
	Thu, 28 May 2026 22:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780005808; cv=none; b=Vw0FCUX57qdRPTPeIskLHYfgRzjeJfR98cs2H6usKlzF7k+lQSNW5n75q1fgaOwMRh+kSipFjy4BN3hPdQb6dCDf1MmSCZE8zSfKUaNbkA5Z2R2bHU4TIM5O4cSPvt0OVmLGBNxd3Thrf2T1/6JvsmuBvJV5r+m+4csYnqUI17c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780005808; c=relaxed/simple;
	bh=O0Hze0ky4/rNG6F8+M77htSvxrrhvd586dvH2Pb8gIQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=pRhXKFgsDgHDFLmORC7G042O4K3q3mdkkNS6HlBeMdiqt35Ma2KyRIXVzQh2UTylf/ecIgh4TF7uGF2diSw+5hNAhOpN8VSaGBjOCSzYEgOfWrSqVns9bSmWVnDZK4I/0OXinDh4ScsJmM4/ZHQdFvkcN1v3fzyo3Dq/k7cL7hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=McJgGw4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="McJgGw4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C3601F000E9;
	Thu, 28 May 2026 22:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780005807;
	bh=O0Hze0ky4/rNG6F8+M77htSvxrrhvd586dvH2Pb8gIQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=McJgGw4zRF6gJlFeTdF498Qz8KZT55LAlMMBBckJUC0xCc+ktkmAHgYqHvtksG0hC
	 wYIKmjnLLJ639scoceOX0Mi025vTVQXjvHPDXjQoeRnb415bZBsbt8mxSTP5y23YGO
	 gnTTvu2WZuFKY4pxfLZvQ5hoQd9g0dIwGYsQ8XO0=
Date: Thu, 28 May 2026 15:03:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, David Laight
 <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, Song Liu
 <song@kernel.org>, Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 0/2] lib/raid: replace __get_free_pages() call with
 kvmalloc()
Message-Id: <20260528150326.b238f9ab223c76fe8da6907a@linux-foundation.org>
In-Reply-To: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 28 May 2026 12:52:59 +0300 "Mike Rapoport (Microsoft)" <rppt@kernel.org> wrote:

> Subject: [PATCH v4 0/2] lib/raid: replace __get_free_pages() call with kvmalloc()

I'll rewrite this to "... kmalloc()"
