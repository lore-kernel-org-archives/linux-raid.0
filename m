From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 003 of 5] Add kobject/sysfs support to raid5
Date: Tue, 11 Oct 2005 16:54:37 -0700
Message-ID: <20051011165437.7d09468c.akpm@osdl.org>
References: <20051004151922.28715.patches@notabene>
	<1051004052339.28815@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051004052339.28815@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> +static ssize_t
> +raid5_store_stripe_cache_size(raid5_conf_t *conf, const char *page, ssize_t len)
> +{
> +	char *end;
> +	int new;
> +	if (len >= PAGE_SIZE)
> +		return -EINVAL;

Can `len' be negative?
