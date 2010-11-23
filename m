From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 02/13] block monitor: freeze spare assignment for
 external arrays
Date: Tue, 23 Nov 2010 15:03:35 +1100
Message-ID: <20101123150335.1d0e15a1@notabene.brown>
References: <20101118080359.29508.50648.stgit@gklab-170-111.igk.intel.com>
	<20101118092137.29508.66427.stgit@gklab-170-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118092137.29508.66427.stgit@gklab-170-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids


I've applied 1/13 to devel-3.2
and if have applied this (2/13) with a few changes:

> +		version = ping_monitor_version(container);
> +		ver = version ? mdadm_version(version) : -1;
> +		free(version);
> +		if (ver < 3001003) {

I changed this to 3002000 and changed ReadMe.c so the version is 3.2-devel.

>  
> +int mdadm_version(char *version)
> +{
> +	int a, b, c;
> +	char *cp;
> +
> +	if (!version)
> +		version = Version;
> +
> +	cp = strchr(version, '-');
> +	if (!cp || *(cp+1) != ' ' || *(cp+2) != 'v')
> +		return -1;
> +	cp += 3;
> +	a = strtoul(cp, &cp, 10);
> +	if (*cp != '.')
> +		return -1;
> +	b = strtoul(cp+1, &cp, 10);
> +	if (*cp != '.')
> +		return -1;
> +	c = strtoul(cp+1, &cp, 10);
> +	if (*cp != ' ')
> +		return -1;
> +	return (a*1000000)+(b*1000)+c;
> +}
> +

I have fixed this so that it access 2 number versions, and ignores a trailing
  "-tag", so 3.2-devel is parsed OK.

NeilBrown

