From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 26/33] added --path <path_id> to give the information on
 the 'path-id' of removed device
Date: Tue, 6 Jul 2010 17:15:02 +1000
Message-ID: <20100706171502.0737635a@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C4F@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C4F@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, 5 Jul 2010 10:40:13 +0100
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> From: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com>
> 
> 
> 
> <path-id> allows to identify the port to which given device is plugged in. In case of hot-removal, udev can pass this information for future use (eg. write this name as 'cookie' allowing to detect the fact of reinserting device to the same port).
> 
> --path <path-id> parameter has been added to device removal handle (and char *path has been added to IncrementalRemove() to pass this value) in order to pass path-id to this handler.
> 
> 
> 
> Signed-off-by: Przemyslaw Czarnowski <przemyslaw.hawrylewicz.czarnowski@intel.com<mailto:przemyslaw.hawrylewicz.czarnowski@intel.com>>
> 
> ---
> 
>  Incremental.c |    8 +++++++-
> 
>  ReadMe.c      |    2 ++
> 
>  mdadm.c       |   15 ++++++++++++---
> 
>  mdadm.h       |    6 +++++-
> 
>  4 files changed, 26 insertions(+), 5 deletions(-)
> 
> 
> 
> diff --git a/Incremental.c b/Incremental.c index 4f52e3b..20e3445 100644
> 
> --- a/Incremental.c
> 
> +++ b/Incremental.c
> 
> @@ -941,13 +941,19 @@ int Incremental_container(struct supertype *st, char *devname, int verbose,
> 
>   * Note: the device name must be a kernel name like "sda", so
> 
>   * that we can find it in /proc/mdstat
> 
>   */
> 
> -int IncrementalRemove(char *devname, int verbose)
> 
> +int IncrementalRemove(char *devname, char *path, int verbose)
> 
>  {
> 
>       int mdfd;
> 
>       int rv;
> 
>       struct mdstat_ent *ent;
> 
>       struct mddev_dev_s devlist;
> 
> 
> 
> +     if (!path) {
> 
> +           fprintf(stderr, Name ": incremental removal without --path <path_id> lacks "
> 
> +                 "the possibility to re-add new device in this port\n");
> 
> +           return 1;
> 
> +     }
> 
> +


It may be appropriate to give a warning here (though I doubt it).  It is
certainly no appropriate to fail IncrementalRemove just because no path was
specified.


> +++ b/mdadm.h
> 
> @@ -275,6 +275,9 @@ enum special_options {
> 
>       AutoDetect,
> 
>       Waitclean,
> 
>       DetailPlatform,
> 
> +     HotPlug,
> 
> +     HotUnplug,
> 
> +     IncrementalPath
> 
>  };

Please only add options here as you actually use them.
Hotplug and HotUnplug are not used, so should not be here.

NeilBrown

