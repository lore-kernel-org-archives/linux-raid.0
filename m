From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] modified message on failure to read metadata in
 Manage
Date: Mon, 21 Feb 2011 16:46:27 +1100
Message-ID: <20110221164627.10780b90@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F01118FAADB@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246F01118FAADB@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

On Thu, 17 Feb 2011 22:43:19 +0000 "Czarnowska, Anna"
<anna.czarnowska@intel.com> wrote:

> >From 347ed6b46a18374cc6743f2fdfccd136ea502331 Mon Sep 17 00:00:00 2001
> From: Anna Czarnowska <anna.czarnowska@intel.com>
> Date: Wed, 16 Feb 2011 13:10:29 +0100
> Subject: [PATCH 1/2] modified message on failure to read metadata in Manage
> Cc: linux-raid@vger.kernel.org, Williams, Dan J <dan.j.williams@intel.com>, Ciechanowski, Ed <ed.ciechanowski@intel.com>
> 
> Loading container may fail if e.g. one of the disks in container
> has been detached but udev has not realized the change.
> Addition to such array will fail because reading superblock
> from one of disks in array fails.
> Current message is a bit confusing.
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> ---
>  Manage.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Manage.c b/Manage.c
> index 481c165..ea5d70f 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -637,7 +637,7 @@ int Manage_subdevs(char *devname, int fd,
>  				/* FIXME this is a bad test to be using */
>  				if (!tst->sb) {
>  					close(tfd);
> -					fprintf(stderr, Name ": cannot find valid superblock in this array - HELP\n");
> +					fprintf(stderr, Name ": cannot load array metadata from %s\n", devname);
>  					return 1;
>  				}
>  


This and the next one both applied - thanks.

NeilBrown

