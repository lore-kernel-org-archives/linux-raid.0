Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lh5r4BEV"
Received: from out-175.mta0.migadu.com (out-175.mta0.migadu.com [IPv6:2001:41d0:1004:224b::af])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA0EC6
	for <linux-raid@vger.kernel.org>; Thu,  7 Dec 2023 06:42:55 -0800 (PST)
Message-ID: <714b22c7-b8dd-008d-a1ea-a184dc8ec1cf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701960173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s/2/v98zCH6WS665133CT6K6dAqH+DX1nLJ4ZplpHfw=;
	b=lh5r4BEVv7vlSDvG6ZEJDFQSBwbg6AxLY7e9++STN6YAua4iOZiFZtMhiaY11QjrrjqXZ5
	AdRmWBRnTd5he/Qq4jPG+XckKWU37F1VMqTJfhmtiLSziTxvDv+Qnyi4DxuHXSkiV5a3ZB
	vg5GmLS3QsP1o4GKTr3jDadFyRJqQRY=
Date: Thu, 7 Dec 2023 22:42:44 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: md raid6 oops in 6.6.4 stable
To: Genes Lists <lists@sapience.com>, Bagas Sanjaya <bagasdotme@gmail.com>,
 snitzer@kernel.org, song@kernel.org, yukuai3@huawei.com, axboe@kernel.dk,
 mpatocka@redhat.com, heinzm@redhat.com,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux RAID <linux-raid@vger.kernel.org>,
 Linux Regressions <regressions@lists.linux.dev>
Cc: Bhanu Victor DiCara <00bvd0+linux@gmail.com>, Xiao Ni <xni@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <6e6816dd-2ec5-4bca-9558-60cfde46ef8c@sapience.com>
 <ZXHJEkwIJ5zKTMjV@archie.me>
 <be56b5df-fef8-4dbe-bb98-f6370a692d6e@sapience.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <be56b5df-fef8-4dbe-bb98-f6370a692d6e@sapience.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi,

On 12/7/23 21:55, Genes Lists wrote:
> On 12/7/23 08:30, Bagas Sanjaya wrote:
>> On Thu, Dec 07, 2023 at 08:10:04AM -0500, Genes Lists wrote:
>>> I have not had chance to git bisect this but since it happened in 
>>> stable I
>>> thought it was important to share sooner than later.
>>>
>>> One possibly relevant commit between 6.6.3 and 6.6.4 could be:
>>>
>>>    commit 2c975b0b8b11f1ffb1ed538609e2c89d8abf800e
>>>    Author: Song Liu <song@kernel.org>
>>>    Date:   Fri Nov 17 15:56:30 2023 -0800
>>>
>>>      md: fix bi_status reporting in md_end_clone_io
>>>
>>> log attached shows page_fault_oops.
>>> Machine was up for 3 days before crash happened.

Could you decode the oops (I can't find it in lore for some reason) 
([1])? And
can it be reproduced reliably? If so, pls share the reproduce step.

[1]. https://lwn.net/Articles/592724/

Thanks,
Guoqing
