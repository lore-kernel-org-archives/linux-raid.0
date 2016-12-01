From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2 7/9] imsm: provide list of bad blocks for an array
Date: Thu, 01 Dec 2016 17:34:25 -0500
Message-ID: <wrfjoa0vz3bi.fsf@redhat.com>
References: <1480424555-31509-1-git-send-email-tomasz.majchrzak@intel.com>
        <1480424555-31509-8-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1480424555-31509-8-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Tue, 29 Nov 2016 14:02:33 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> Provide list of bad blocks using memory allocated in advance so it's
> safe to call it from monitor.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  super-intel.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
>
> diff --git a/super-intel.c b/super-intel.c
> index 731878c..fd2145c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -393,6 +393,7 @@ struct intel_super {
>  	struct intel_hba *hba; /* device path of the raid controller for this metadata */
>  	const struct imsm_orom *orom; /* platform firmware support */
>  	struct intel_super *next; /* (temp) list for disambiguating family_num */
> +	struct md_bb bb;	/* memory for get_bad_blocks call */
>  };
>  
>  struct intel_disk {
> @@ -4298,6 +4299,7 @@ static void __free_imsm(struct intel_super *super, int free_disks)
>  static void free_imsm(struct intel_super *super)
>  {
>  	__free_imsm(super, 1);
> +	free(super->bb.entries);
>  	free(super);
>  }
>  
> @@ -4318,6 +4320,14 @@ static struct intel_super *alloc_super(void)
>  
>  	super->current_vol = -1;
>  	super->create_offset = ~((unsigned long long) 0);
> +
> +	super->bb.entries = malloc(BBM_LOG_MAX_ENTRIES *
> +				   sizeof(struct md_bb_entry));

Hi Tomek,

Another nit - you are using plain malloc() here, while every other part
of super-intel.c uses xmalloc().

Cheers,
Jes
