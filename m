From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 001 of 7] md: Support 'external' metadata for md arrays.
Date: Tue, 25 Dec 2007 14:03:42 -0800
Message-ID: <20071225140342.9d0ff789.akpm@linux-foundation.org>
References: <20071214171950.1308.patches@notabene>
	<1071214062608.1815@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751844AbXLYWEi@vger.kernel.org>
In-Reply-To: <1071214062608.1815@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 14 Dec 2007 17:26:08 +1100 NeilBrown <neilb@suse.de> wrote:

> +	if (strncmp(buf, "external:", 9) == 0) {
> +		int namelen = len-9;
> +		if (namelen >= sizeof(mddev->metadata_type))
> +			namelen = sizeof(mddev->metadata_type)-1;
> +		strncpy(mddev->metadata_type, buf+9, namelen);
> +		mddev->metadata_type[namelen] = 0;
> +		if (namelen && mddev->metadata_type[namelen-1] == '\n')
> +			mddev->metadata_type[--namelen] = 0;
> +		mddev->persistent = 0;
> +		mddev->external = 1;

size_t would be a more appropriate type for `namelen'.
