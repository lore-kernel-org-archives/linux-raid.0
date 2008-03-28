From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: Subject: introduce get_priority_stripe() to
     improve raid456 write performance
Date: Sat, 29 Mar 2008 08:10:37 +1100 (EST)
Message-ID: <39784.192.168.1.70.1206738637.squirrel@neil.brown.name>
References: <20080328164351.30557.patches@notabene>
    <1080328054528.30605@suse.de>
    <20080327232252.20764ac4.akpm@linux-foundation.org>
    <1206732819.29383.11.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1206732819.29383.11.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sat, March 29, 2008 6:33 am, Dan Williams wrote:
>  raid5_store_preread_threshold(mddev_t *mddev, const char *page, size_t
> len)
>  {
>  	raid5_conf_t *conf = mddev_to_conf(mddev);
> -	char *end;
> -	int new;
> +	unsigned long new;
>  	if (len >= PAGE_SIZE)
>  		return -EINVAL;
>  	if (!conf)
>  		return -ENODEV;
>
> -	new = simple_strtoul(page, &end, 10);
> -	if (!*page || (*end && *end != '\n'))
> +	if (strict_strtoul(page, 10, &new))
>  		return -EINVAL;
> -	if (new > conf->max_nr_stripes || new < 0)
> +	if (new > conf->max_nr_stripes || (int) new < 0)

I had suggested that "new < 0" test when I saw that 'new' was an 'int'.
A better suggestion would have been to make 'new' 'unsigned'.
Now that you have done that, the "< 0" it pointless and
should go.
Otherwise
  Acked-By: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown

