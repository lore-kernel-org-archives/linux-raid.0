Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D83826295;
	Fri, 23 Feb 2024 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708710072; cv=none; b=s1NgUlfoIUUeIyP/mU45J67Is2FL7V7ywDt/C7If1uFBBOPcBPvxy4BUa6Z248B4NYzXCnjMAA5WzwsylFOwoVBZkuNlcMEYTmndM53cVMquWRAlAhqd/SjOOXiR9rPw7Mn6TUg0JEnhYv2rQ446jDXRobJqofq1eAuP16x976A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708710072; c=relaxed/simple;
	bh=nH527Z6uZQjSMCf5Ca2ur6vZP8nbuTasR+ws194bvH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jV9InwJG9kIX6xENFq3UGsSWUQU/q5vmNbjOnyVXjUt3jhYMOaWJu0oA4WJ7Mv6RLyXOb2kkWzucPvXOnWlI4EkYTJUKwby/t6tvCVPVJjmTK0gsnwWUskltRzHt2WW84fyO6p7InIHq4AcJlNSTRiNpjE3JibpaAhfsce61edU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id AD2FB68B05; Fri, 23 Feb 2024 18:41:05 +0100 (CET)
Date: Fri, 23 Feb 2024 18:41:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: atomic queue limit updates for stackable devices
Message-ID: <20240223174105.GA5687@lst.de>
References: <20240223161247.3998821-1-hch@lst.de> <ZdjXsm9jwQlKpM87@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZdjXsm9jwQlKpM87@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Feb 23, 2024 at 12:36:50PM -0500, Mike Snitzer wrote:
> Which DM testsuite are you trying?  There is the old ruby-based
> "device-mapper-test-suite",

Yes.

> and a newer one written in python which
> should hopefully be less hassle to setup and run, see:
> https://github.com/jthornber/dmtest-python

Oh, I didn't know that one.  I'll give it a spin, and maybe the
lvm2 one as well.
