Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DFEBC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 07:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5041B6134F
	for <linux-raid@archiver.kernel.org>; Tue, 19 Oct 2021 07:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbhJSH15 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Oct 2021 03:27:57 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17272 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234412AbhJSH15 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Oct 2021 03:27:57 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1634628339; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=hpc/T2vJJVaEMRejrKPjDyVZ1B7Vm44g7/8aNDKX1nqsQoaCgcgA/d/sN3jVn53rYXuAN/S8XHvQbscOkqbOTzUoQgvVPRTTLjLaN4LKupWBh7qyWRJjKjeCz8uyR07pwsJs0LkLN7n0+I2eOuZw1KCO4XdsU1AddB5pLc9o/Zs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1634628339; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=izKnbDffIDCEycQ9JfkPaMu4HRBdI+vz89x28qBGP4U=; 
        b=L2muto/U5ZCfrpXV+NwDCs1dXp2CSytW6HCQ1S5dQ3cEpzZVjx2tmDwBRjs/jYE4ce4qPbjXSjMLRlh55vVhCYJxxYrPhn4yfJGIpo+vcwoQZJbPEpMVGOEQdTLU3UKRB80jTeQ1d0NdKJl57gREJrZeBLBRBZt3jcRXPqGa5Aw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.109.156.142] (163.114.130.5 [163.114.130.5]) by mx.zoho.eu
        with SMTPS id 1634628337287719.4498529326971; Tue, 19 Oct 2021 09:25:37 +0200 (CEST)
Subject: Re: [PATCH] imsm: introduce helpers to manage file descriptors
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20211018151217.31583-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <d1cbeb1e-13f7-481b-81a6-9720b56d6a77@trained-monkey.org>
Date:   Tue, 19 Oct 2021 03:25:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211018151217.31583-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/18/21 11:12 AM, Mariusz Tkaczyk wrote:
> To avoid direct comparisions define dedicated inlines.
> This patch propagates them in super-intel.c. They are declared globally
> for future usage outside IMSM.
> 
> Additionally, it adds fd check in save_backup_imsm() to remove
> code vulnerability and simplifies targets array implementation.
> 
> It also propagates prr_vrb() macro instead if (verbose) condidtion.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
> Hi Jes,
> For now scope is limited to IMSM. If you ok the idea please apply it.
> I would like to use it in other places, but first I need to have it
> applied.

Hi Mariusz,

I am not a huge fan of hiding things in wrappers, however we've seen a
number of cases in the code with inconsistent checks for > 0 and >= 0,
so I guess it makes sense.

However I think you introduce a bug or at least a behavioral change in
the code, please see below.

> @@ -7643,26 +7635,27 @@ static int validate_geometry_imsm(struct supertype *st, int level, int layout,
>  
>  	/* This device needs to be a device in an 'imsm' container */
>  	fd = open(dev, O_RDONLY|O_EXCL, 0);
> -	if (fd >= 0) {
> -		if (verbose)
> -			pr_err("Cannot create this array on device %s\n",
> -			       dev);
> +
> +	if (is_fd_valid(fd)) {
> +		pr_vrb("Cannot create this array on device %s\n", dev);
>  		close(fd);
>  		return 0;
>  	}
> -	if (errno != EBUSY || (fd = open(dev, O_RDONLY, 0)) < 0) {
> -		if (verbose)
> -			pr_err("Cannot open %s: %s\n",
> -				dev, strerror(errno));
> -		return 0;
> +	if (errno != EBUSY) {
> +		fd = open(dev, O_RDONLY, 0);
> +
> +		if (!is_fd_valid(fd)) {
> +			pr_vrb("Cannot open %s: %s\n", dev, strerror(errno));
> +			return 0;
> +		}
>  	}

The old code would only call open(dev, O_RDONLY, 0) if errno == EBUSY,
and it enters the if() block unconditionally, unless errno == EBUSY and
we fail to open O_RDONLY.

With your change you try to reopen the device for all error cases,
except for EBUSY.

I assume this is a mistake? If you do want to change the logic, it would
be preferred to do it in a separate patch.

Cheers,
Jes
