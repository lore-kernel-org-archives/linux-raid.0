Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A8715E5CA;
	Wed, 16 Oct 2024 04:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729051914; cv=none; b=g4IjHbDlB90x1+xDEncoa98rAozKSeFedHWBQWhkAZFDyilVaifEx/SF3oMU5mCx4vVL0W4gSvikzuDnEnxj7/xKg6az37yl8VjojKdOHrlcv5Fyi8o/LwfMPM/7yNjksgSF9ULGyrsP5Tvf6pX7X8XIzUeie/Z9ON/M4a3MAu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729051914; c=relaxed/simple;
	bh=qW/R2Gq4KOn0d5a4imwYk170HFd/yGvEqT9iEjrI5Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pMNbzD39THFb34ymDY3NhsiTNB+oQkdiqwDb8oUMsBRTK0Fk3DB2Juw1QU1jBbOcQaBQeK4KWJOuYGUAEAUiUIn4H9MGHJ9vTbRCqpz+wyH5TCLQor4NOJTl5iVthBVEL6kzwkcyD5D7yw1tnk37qvUpd2ton3irAyEkQA1c2uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=juMa8LjC; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="juMa8LjC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0wJeGreMGEQBNcg/t4blcFMd82Lclp5TqJWibW3c+Ao=; b=juMa8LjCeThfpF+FQXYGcYfw+q
	goo8jcURFztK2RZXFmk+5B6Y2mIq6NbhcD9UE//EKkuVGXymlrGvo/0T4Gm23rWuJyc8gRfqrUquD
	a1r+VXOok8VquBv76C/dexyBtsDyevO5QNDDfTT/i6b+WQHtt4py9iuA+yFxKTeUuiTp6ImtEEJsF
	DIT33oJyMBhd8mogYit8E0ZC04qxsQzOnYvhJB0vk6OJ+chT8DQil+lsggf64h0DrjCkwrG5f7qNK
	zdPXQZUanWpoFrJT6+E6XGnIkToJLkwm4f7lM1dtDwEbFwMppf9OAGGDYp2zx1mvSuLb82VgUWW3t
	Guzdv+OA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t0vO2-0000000ARZE-3qAO;
	Wed, 16 Oct 2024 04:11:50 +0000
Date: Tue, 15 Oct 2024 21:11:50 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH RFC] md: lockless bitmap demo
Message-ID: <Zw89BmLBF4S_nX5V@infradead.org>
References: <20241015083557.4033741-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015083557.4033741-1-yukuai1@huaweicloud.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Oct 15, 2024 at 04:35:57PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Just implement very basic functions, there are lots of todos.
> 
> Very limited functional testing(mdadm tests and some manual tests), and
> following performance test for raid10:

Can you explain what it does?

