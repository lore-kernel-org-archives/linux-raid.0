From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 09/17] Monitor: avoid skipping checks on external arays
Date: Thu, 04 Nov 2010 22:47:11 -0700
Message-ID: <4CD39A5F.2050703@intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FC9@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FC9@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On 10/29/2010 7:23 AM, Czarnowska, Anna wrote:
>  From bb9ca6dbe0a92e00b21cd8985533b561b40ed6b9 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska<anna.czarnowska@intel.com>
> Date: Mon, 25 Oct 2010 11:30:43 +0200
> Subject: [PATCH 09/17] Monitor: avoid skipping checks on external arays
>
> utime is not correct for external metadata so we can only
> skip further checks for native metadata
>
> Signed-off-by: Anna Czarnowska<anna.czarnowska@intel.com>
> ---
>   Monitor.c |   33 ++++++++++++++++++++++++++-------
>   1 files changed, 26 insertions(+), 7 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index a4bfedd..d915d7d 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -50,6 +50,7 @@ struct state {
>   	int devstate[MaxDisks];
>   	unsigned devid[MaxDisks];
>   	int percent;
> +	char *metadata_version;

Another small nit... this is really just a "int utime_valid" flag, 
calling it "char *metadata_version" is a slightly confusing shortcut.
