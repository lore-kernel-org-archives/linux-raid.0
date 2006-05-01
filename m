From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 004 of 11] md: Increase the delay before marking
 metadata clean, and make it configurable.
Date: Sun, 30 Apr 2006 22:44:04 -0700
Message-ID: <20060430224404.1060d29a.akpm@osdl.org>
References: <20060501152229.18367.patches@notabene>
	<1060501053019.22949@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060501053019.22949@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> wrote:
>
> 
> When a md array has been idle (no writes) for 20msecs it is marked as
> 'clean'.  This delay turns out to be too short for some real
> workloads.  So increase it to 200msec (the time to update the metadata
> should be a tiny fraction of that) and make it sysfs-configurable.
> 
> 
> ...
> 
> +   safe_mode_delay
> +     When an md array has seen no write requests for a certain period
> +     of time, it will be marked as 'clean'.  When another write
> +     request arrive, the array is marked as 'dirty' before the write
> +     commenses.  This is known as 'safe_mode'.
> +     The 'certain period' is controlled by this file which stores the
> +     period as a number of seconds.  The default is 200msec (0.200).
> +     Writing a value of 0 disables safemode.
> +

Why not make the units milliseconds?  Rename this to safe_mode_delay_msecs
to remove any doubt.

> +static ssize_t
> +safe_delay_store(mddev_t *mddev, const char *cbuf, size_t len)
> +{
> +	int scale=1;
> +	int dot=0;
> +	int i;
> +	unsigned long msec;
> +	char buf[30];
> +	char *e;
> +	/* remove a period, and count digits after it */
> +	if (len >= sizeof(buf))
> +		return -EINVAL;
> +	strlcpy(buf, cbuf, len);
> +	buf[len] = 0;
> +	for (i=0; i<len; i++) {
> +		if (dot) {
> +			if (isdigit(buf[i])) {
> +				buf[i-1] = buf[i];
> +				scale *= 10;
> +			}
> +			buf[i] = 0;
> +		} else if (buf[i] == '.') {
> +			dot=1;
> +			buf[i] = 0;
> +		}
> +	}
> +	msec = simple_strtoul(buf, &e, 10);
> +	if (e == buf || (*e && *e != '\n'))
> +		return -EINVAL;
> +	msec = (msec * 1000) / scale;
> +	if (msec == 0)
> +		mddev->safemode_delay = 0;
> +	else {
> +		mddev->safemode_delay = (msec*HZ)/1000;
> +		if (mddev->safemode_delay == 0)
> +			mddev->safemode_delay = 1;
> +	}
> +	return len;

And most of that goes away.


