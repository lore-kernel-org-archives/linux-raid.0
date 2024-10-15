Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453CF1E7666
	for <linux-raid@vger.kernel.org>; Tue, 15 Oct 2024 10:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728989973; cv=none; b=jo3Tonih2345oZkXVH6wJTOq167sBc3urJNjgmw0yCun7Qw7HxUzluIgzqPWP/Zh97g9khIaxnrpwbDNhrDoxETg2aZ76isxagOrULojdAWoij7DGye0srdA2HHwFLdC52XFJ6hpi1QCUzqcRVTMUv6N2TZFT3erlSNji6TmHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728989973; c=relaxed/simple;
	bh=ly/NC2kwZ3cRKwWiABDoQjTvFKH0kh1X0ePiMlqGNMA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rzvr6RUmzqvKNn8kpfwS810KYSSM/J1b6xQxa1VDLdf2VZRSBE4NW9k2VYUzlHMZU91tw8otf9Lf0snnv+O95ICjXM6ywjL58uNj/ku8Cu1uNoJVoENp2bqBiwyF0l+IyDOv6OhL67hrJlmSYjHgXs/n2xAHmZx8M5qXpCCVnKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=B1W2hg8G; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="B1W2hg8G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728989970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ybTiS+fP0SSadAHt+F77jSZOWRj/uDfaIQfdA4Tihlk=;
	b=B1W2hg8GQXBpxxFN50+looD+bZNhFnUJE7Y5imo7m/nHhUQYkRz6AF0iqpRFNF6ZLfnheH
	FDG7y13tvlToaRg0GYovs3eVauy9ng6PxZwmFatKLP4HuGBnD5SJT2SjdVAlJxv8hKoCkG
	RGgHRDA6yQNsE3DUpVCTmLg6xFjCQyU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-614-MzYKfzDZNr6jLeY-LjMoDg-1; Tue,
 15 Oct 2024 06:59:27 -0400
X-MC-Unique: MzYKfzDZNr6jLeY-LjMoDg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3150A1955D59;
	Tue, 15 Oct 2024 10:59:23 +0000 (UTC)
Received: from [10.45.226.64] (unknown [10.45.226.64])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79B2330001A3;
	Tue, 15 Oct 2024 10:59:16 +0000 (UTC)
Date: Tue, 15 Oct 2024 12:59:13 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Md Sadre Alam <quic_mdalam@quicinc.com>
cc: axboe@kernel.dk, song@kernel.org, yukuai3@huawei.com, agk@redhat.com, 
    snitzer@kernel.org, adrian.hunter@intel.com, quic_asutoshd@quicinc.com, 
    ritesh.list@gmail.com, ulf.hansson@linaro.org, andersson@kernel.org, 
    konradybcio@kernel.org, kees@kernel.org, gustavoars@kernel.org, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
    linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
    linux-hardening@vger.kernel.org, quic_srichara@quicinc.com, 
    quic_varada@quicinc.com
Subject: Re: [PATCH v2 1/3] dm-inlinecrypt: Add inline encryption support
In-Reply-To: <20240916085741.1636554-2-quic_mdalam@quicinc.com>
Message-ID: <3161a67d-66f6-775e-c67e-3b5ca1aa2e1b@redhat.com>
References: <20240916085741.1636554-1-quic_mdalam@quicinc.com> <20240916085741.1636554-2-quic_mdalam@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi

The patch seems OK. Should it go in via the device mapper tree or the 
block layer tree?


On Mon, 16 Sep 2024, Md Sadre Alam wrote:

> +#define DM_CRYPT_DEFAULT_MAX_READ_SIZE		131072
> +#define DM_CRYPT_DEFAULT_MAX_WRITE_SIZE		131072
> +
> +static unsigned int get_max_request_size(struct inlinecrypt_config *cc, bool wrt)
> +{
> +	unsigned int val, sector_align;
> +
> +	val = !wrt ? DM_CRYPT_DEFAULT_MAX_READ_SIZE : DM_CRYPT_DEFAULT_MAX_WRITE_SIZE;
> +	if (wrt) {
> +		if (unlikely(val > BIO_MAX_VECS << PAGE_SHIFT))
> +			val = BIO_MAX_VECS << PAGE_SHIFT;
> +	}
> +	sector_align = max(bdev_logical_block_size(cc->dev->bdev), (unsigned int)cc->sector_size);
> +	val = round_down(val, sector_align);
> +	if (unlikely(!val))
> +		val = sector_align;
> +	return val >> SECTOR_SHIFT;
> +}

This piece of code was copied from the dm-crypt target. For dm-crypt, I 
was actually benchmarking the performance for various 
DM_CRYPT_DEFAULT_MAX_READ_SIZE and DM_CRYPT_DEFAULT_MAX_WRITE_SIZE values 
and I selected the values that resulted in the best performance.

You should benchmark it too to find the optimal I/O size. Perhaps you find 
out that there is no need to split big requests and this piece of code can 
be dropped.

> +               /* Omit the key for now. */
> +               DMEMIT("%s - %llu %s %llu", ctx->cipher_string, ctx->iv_offset,
> +                      ctx->dev->name, (unsigned long long)ctx->start);

What if someone reloads the table? I think you should display the key. 
dmsetup does not display the key if the "--showkeys" parameter is not 
specified.

Mikulas

