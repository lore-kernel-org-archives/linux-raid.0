Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEAD24A055;
	Tue, 27 May 2025 08:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748334126; cv=none; b=T+2KWeCAF7vdSy44LWZ5j02OGbs3U2Z8TiddlgBV4668f1l2G0yde0aRf+QX0Oo0+k7LVN1JOXuDSDNPKldHl/USMuVrYKjKHRIxvHgDV6VgUwOfwbW7jOztOlK30NnEy81fbeFyi/afZC1sGOYrLO7//x33CtgjEQYPs/wkC6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748334126; c=relaxed/simple;
	bh=NbPyEkW06QCEBgdkUttmPFbj0LSWvT4Np8QGwmUSxTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QGz5pSIE2Q6RIPr3suTIiB1I/mON7tF87bSXA+bj6F61pfTHOkDVGA4zZivn4EKNqNBNW3tI88xeUlJo2GPtRnL+aDxKv63z9QJ6rcngTeWorz9V+Uh84AOw8to165eQ9tSPzXLHH9j58JZWU14qw1KopZk9QaBS2+lmjqi1zmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 580E267373; Tue, 27 May 2025 10:21:53 +0200 (CEST)
Date: Tue, 27 May 2025 10:21:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, xni@redhat.com, colyli@kernel.org,
	song@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 06/23] md/md-bitmap: add a new sysfs api bitmap_type
Message-ID: <20250527082153.GA32045@lst.de>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-7-yukuai1@huaweicloud.com> <20250526063226.GB12811@lst.de> <577a1bf6-9f23-0ccd-c269-d625ae11890d@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <577a1bf6-9f23-0ccd-c269-d625ae11890d@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, May 26, 2025 at 03:45:39PM +0800, Yu Kuai wrote:
> Hi,
>
> 在 2025/05/26 14:32, Christoph Hellwig 写道:
>> On Sat, May 24, 2025 at 02:13:03PM +0800, Yu Kuai wrote:
>>> +  consistency_policy
>>
>> .. these doc changes look unrelated, or am I missing something?
>
> The position are moved to the front of the bitmap fields, because now
> bitmap/xxx is not always here.

Ah, ok.

