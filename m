From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 004 of 5] Allow a manual resync with md
Date: Tue, 11 Oct 2005 16:56:07 -0700
Message-ID: <20051011165607.43fc05bf.akpm@osdl.org>
References: <20051004151922.28715.patches@notabene>
	<1051004052347.28827@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1051004052347.28827@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> static ssize_t
> +md_show_scan(mddev_t *mddev, char *page)
> +{
> +	char *type = "none";
> +	if (mddev->recovery &
> +	    ((1<<MD_RECOVERY_RUNNING) || (1<<MD_RECOVERY_NEEDED))) {

Shouldn't this be a bitwise OR?

> +		if (mddev->recovery & (1<<MD_RECOVERY_SYNC)) {
> +			if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> +				type = "resync";
> +			else if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
> +				type = "check";
> +			else
> +				type = "repair";
> +		} else
> +			type = "recover";
> +	}
> +	return sprintf(page, "%s\n", type);
> +}
> +
> +static ssize_t
> +md_store_scan(mddev_t *mddev, const char *page, size_t len)
> +{
> +	int canscan=0;
> +	if (mddev->recovery &
> +	    ((1<<MD_RECOVERY_RUNNING) || (1<<MD_RECOVERY_NEEDED)))

And this?

> +		return -EBUSY;
