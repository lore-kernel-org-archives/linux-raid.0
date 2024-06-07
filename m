Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51DD31BC2F
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 06:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741193; cv=none; b=cJUQ8jJExcu9uKRfu8aZoq9eDhRIPydEuJedu31omE/1JiEgJE6kVRsis6CsaJJNvzMTa9tUdY/9brnfRM4p2L1ozdlEk1bSay8V88Oi9kamiel8ZYWISYud3shmAd7917b21fdXG74iO6EBAzErd+mdBX8AqVU/FHAyjIBpHQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741193; c=relaxed/simple;
	bh=ByjBemIJWwQafkbQTvfgC51II6V5Ko8aIz6ykG/9204=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XISDwpUNiOiU5/pTC2oPWAMVrp9EXpiyRCk0HvolX0ZkL4bjES/Fc5ijDKxfXtYmXpqggeENVIfL47VrWu1E0C0VMwld6OsEC1AhteDJvjlH3m5PLr3hCiIUUEYNmj/ay55FE/r/He5gOhqPd0r64uGxQQQRoYDRlNMAoWbUnj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2F8A068B05; Fri,  7 Jun 2024 08:19:48 +0200 (CEST)
Date: Fri, 7 Jun 2024 08:19:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH 1/2] md/raid0: don't free conf on raid0_run failure
Message-ID: <20240607061947.GA5200@lst.de>
References: <20240604172607.3185916-1-hch@lst.de> <20240604172607.3185916-2-hch@lst.de> <45ab7eb3-02d4-dbc2-8956-1387a008e53f@huaweicloud.com> <703d7cf4-e869-d96c-1778-818b29192a3e@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <703d7cf4-e869-d96c-1778-818b29192a3e@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jun 07, 2024 at 02:17:14PM +0800, Yu Kuai wrote:
> Sorry that I just noticed that the sysfs api level_store() calls the
> pers->run() as well, and it didn't handle failure by pers->free().
> It's weried that the api will return success in this case, and after
> this patch, it will require __md_stop() to free the conf.
>
> Can you also fix the level_store()? By checking pers->run() and if it
> failed, call pers->free() and return error.

I can look into it.  But if we don't have consistent callers anyway
I'd be tempted to not call ->free on ->run failure, as that is a
rather unusual convention.

