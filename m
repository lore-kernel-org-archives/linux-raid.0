Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198B01EA73;
	Fri, 20 Sep 2024 14:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726841460; cv=none; b=WZMC7SWBqswtD5rzXRMBa3THjm8gevGMuuE77zXLz6wkY1C/iuLKZpsxs5deJ3fqja6PmmgdRXeuCSr5YePjreB8RD56ZAXWSFX+LorjyzzEqKVdaT9lyL/8wptp82ryEolgGnitt0YH+xkSUTnyl+7zCrrCMMloL0YGMMKyY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726841460; c=relaxed/simple;
	bh=z80713+np/vIk5gjx1x7fmlKp0VYFjBVgy3A1eKqwI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5NqXMtsClRaNQF9NqDaQLSWlzYAHhzO0zBNhNyDVW8WKmSZySEdXYC7ES/u1Pd1BLB3pw8lTs2mQefIHDFE2Igp9BiZlSgjirBXZl7AlxQGEZhcTN0JLxzt+VG8EE0QBW0Xfw5ImCbaqxArgj7Bxg/0MwmO2sbuPw13o1bXv0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0AB7C227AA8; Fri, 20 Sep 2024 16:10:56 +0200 (CEST)
Date: Fri, 20 Sep 2024 16:10:55 +0200
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	martin.petersen@oracle.com
Subject: Re: [PATCH RFC 4/6] md/raid0: Handle bio_split() errors
Message-ID: <20240920141055.GC2517@lst.de>
References: <20240919092302.3094725-1-john.g.garry@oracle.com> <20240919092302.3094725-5-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240919092302.3094725-5-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 19, 2024 at 09:23:00AM +0000, John Garry wrote:
> Add proper bio_split() error handling. For any error, set bi_status, end
> the bio, and return.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/md/raid0.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 32d587524778..d8ad69620c9d 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -466,6 +466,11 @@ static void raid0_handle_discard(struct mddev *mddev, struct bio *bio)
>  		struct bio *split = bio_split(bio,
>  			zone->zone_end - bio->bi_iter.bi_sector, GFP_NOIO,
>  			&mddev->bio_set);
> +		if (IS_ERR(split)) {

Empty line after the variable declarations.  Also jumping out of the
loop to an error handling label might be beneficial here, but that's
probably up to the maintainers.

Same for the other hunk (and probably the other raid personalities).
