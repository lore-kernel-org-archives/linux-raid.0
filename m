From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 20/33] Added disk util functions
Date: Tue, 6 Jul 2010 16:55:10 +1000
Message-ID: <20100706165510.34483a05@notabene.brown>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C3E@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A9DE54D0CD747C4CB06DCE5B6FA2246FDA893C3E@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-raid.ids

On Mon, 5 Jul 2010 10:34:29 +0100
"Czarnowska, Anna" <anna.czarnowska@intel.com> wrote:

> Needed for checking suitability of a disk to use for rebuild.
> 
> 
> 
> Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com<mailto:anna.czarnowska@intel.com>>
> 
> ---
> 
>  mdadm.h       |   11 +++++++++++
> 
>  super-ddf.c   |   36 ++++++++++++++++++++++++++++++++++++
> 
>  super-intel.c |   31 +++++++++++++++++++++++++++++++
> 
>  util.c        |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
>  4 files changed, 133 insertions(+), 0 deletions(-)
> 
> 
> 
> diff --git a/mdadm.h b/mdadm.h
> 
> index b6d7933..86f5370 100644
> 
> --- a/mdadm.h
> 
> +++ b/mdadm.h
> 
> @@ -277,6 +277,12 @@ enum special_options {
> 
>       DetailPlatform,
> 
>  };
> 
> 
> 
> +enum disk_status {
> 
> +     unknown,
> 
> +     spare_disk,
> 
> +     failed_disk,
> 
> +};
> 
> +
> 
>  enum domain_actions {
> 
>       ignore,
> 
>       incremental,
> 
> @@ -656,6 +662,8 @@ extern struct superswitch {
> 
>       int (*load_super)(struct supertype *st, int fd, char *devname);
> 
>       struct supertype * (*match_metadata_desc)(char *arg);
> 
>       __u64 (*avail_size)(struct supertype *st, __u64 size);
> 
> +
> 
> +     enum disk_status (*get_disk_status)(struct supertype *st, int major,
> 
> +int minor);


I don't like the idea of identifying a device by major/minor in this context.

This disk_status information should all be loaded by 'load_super'.

i.e. we call 'load_super' giving an 'fd' for the container, and it loads all
the relevant details.  Then Monitor just looks through the mdinfo that was
loaded to find out the status of each device.
If the required status isn't currently available in mdinfo, we should change
load_super to put it there.

Thanks,
NeilBrown

