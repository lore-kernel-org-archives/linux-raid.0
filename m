From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] fix: Monitor doesn't return after starting daemon
Date: Wed, 15 Dec 2010 08:58:14 +1100
Message-ID: <20101215085814.6a04b9af@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FAF@irsmsx504.ger.corp.intel.com>
	<20101117212242.5ad7b210@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BE8FD35@irsmsx504.ger.corp.intel.com>
	<20101122131644.6ba971f2@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010BF03A1F@irsmsx504.ger.corp.intel.com>
	<20101123123417.09397400@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D174BA9762@irsmsx503.ger.corp.intel.com>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010E24D4A4@irsmsx504.ger.corp.intel.com>
	<20101213112102.4a39c1b3@notabene.brown>
	<A9DE54D0CD747C4CB06DCE5B6FA2246F010E44C3EC@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E44C3EC@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

On Tue, 14 Dec 2010 14:47:27 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From 8b2465b0d314cc93bba5797dbad9fd2813f0a79e Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Tue, 14 Dec 2010 12:26:33 +0100
> Subject: [PATCH] fix: Monitor doesn't return after starting daemon
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> Because both parent and child process continue after make_daemon succeeds.

Applied, thanks.

NeilBrown


> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> ---
>  Monitor.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index e7f6d03..4ae1d2b 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -152,9 +152,11 @@ int Monitor(struct mddev_dev *devlist,
>  	info.mailfrom = mailfrom;
>  	info.dosyslog = dosyslog;
>  
> -	if (daemonise)
> -		if (make_daemon(pidfile))
> -			return 1;
> +	if (daemonise) {
> +		int rv = make_daemon(pidfile);
> +		if (rv >= 0)
> +			return rv;
> +	}
>  
>  	if (share) 
>  		if (check_one_sharer(scan))
> @@ -272,7 +274,7 @@ static int make_daemon(char *pidfile)
>  	dup2(0,1);
>  	dup2(0,2);
>  	setsid();
> -	return 0;
> +	return -1;
>  }
>  
>  static int check_one_sharer(int scan)

