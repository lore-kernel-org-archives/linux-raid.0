From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [PATCH 09/17] Monitor: avoid skipping checks on external arays
Date: Fri, 5 Nov 2010 14:56:11 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BC6D48D@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010BAF0FC9@irsmsx504.ger.corp.intel.com>
 <4CD39A5F.2050703@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CD39A5F.2050703@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

Metadata_version is needed for: 
	Deciding if metadata type is container-based - more than just the utime check depends on it
	Getting parent container number from subarrays - for linking subarrays with containers
	Obtaining superswitch - to avoid calling guess_super when we already know the kind of metadata

Introducing utime_valid flag would just duplicate part of information included in metadata_version.
Regards
Anna

-----Original Message-----
From: Williams, Dan J 
Sent: Friday, November 05, 2010 6:47 AM
To: Czarnowska, Anna
Cc: Neil Brown; linux-raid@vger.kernel.org; Neubauer, Wojciech; Ciechanowski, Ed; Labun, Marcin; Hawrylewicz Czarnowski, Przemyslaw
Subject: Re: [PATCH 09/17] Monitor: avoid skipping checks on external arays

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
---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

