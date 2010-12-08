From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] fix: mdstat_read() incorrectly translates value of
 mdstat_ent->reshape for recovering
Date: Thu, 9 Dec 2010 08:43:20 +1100
Message-ID: <20101209084320.0ef8f506@notabene.brown>
References: <66C59AD0932712458090B447266D638C010C05314A@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638C010C05314A@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Czarnowska, Anna" <anna.czarnowska@intel.com>
List-Id: linux-raid.ids

On Wed, 8 Dec 2010 11:30:28 +0000 "Hawrylewicz Czarnowski, Przemyslaw"
<przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:

> it results in wrong output of mdadm --detail (shows reshaping instead
> of recovering)
> 
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> ---
>  mdstat.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mdstat.c b/mdstat.c
> index fdce516..c5a07b5 100644
> --- a/mdstat.c
> +++ b/mdstat.c
> @@ -253,7 +253,7 @@ struct mdstat_ent *mdstat_read(int hold, int start)
>  				if (strncmp(w, "reshape", 7)==0)
>  					ent->resync = 2;
>  				if (strncmp(w, "recovery", 8)==0)
> -					ent->resync = 2;
> +					ent->resync = 0;
>  				if (strncmp(w, "check", 5)==0)
>  					ent->resync = 3;
>  


Thanks.
Applied.

NeilBrown
