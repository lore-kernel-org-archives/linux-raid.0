From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH 1/8] imsm: parse bad block log in metadata on startup
Date: Wed, 16 Nov 2016 09:43:18 -0500
Message-ID: <wrfjh977mqnt.fsf@redhat.com>
References: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477925454-16809-1-git-send-email-tomasz.majchrzak@intel.com>
        (Tomasz Majchrzak's message of "Mon, 31 Oct 2016 15:50:47 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Majchrzak <tomasz.majchrzak@intel.com> writes:
> Always allocate memory for all log entries to avoid a need for memory
> allocation when monitor requests to record a bad block.
>
> Also some extra checks added to make static code analyzer happy.
>
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> ---
>  super-intel.c | 158 +++++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 112 insertions(+), 46 deletions(-)

Tomasz,

A couple of comments on this one:

First of all: *Always* provide a cover letter when submitting
multi-patch sets.

> diff --git a/super-intel.c b/super-intel.c
> index c146bbd..5d6d534 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -217,22 +217,24 @@ struct imsm_super {
>  } __attribute__ ((packed));
>  
>  #define BBM_LOG_MAX_ENTRIES 254
> +#define BBM_LOG_MAX_LBA_ENTRY_VAL 256		/* Represents 256 LBAs */
> +#define BBM_LOG_SIGNATURE 0xABADB10C

I know the old code is messy with regard to this, but lets get it right
from now on. Numbers are lower-case and #define NAMES are upper case.

> @@ -785,6 +787,92 @@ static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 index)
>  	return NULL;
>  }
>  
> +#if BYTE_ORDER == LITTLE_ENDIAN
> +static inline unsigned long long __le48_to_cpu(const struct bbm_log_block_addr
> +					       *addr)
> +{
> +	return ((((__u64)addr->dw1) << 16) | addr->w1);
> +}
> +
> +static inline struct bbm_log_block_addr __cpu_to_le48(unsigned long long sec)
> +{
> +	struct bbm_log_block_addr addr;
> +
> +	addr.w1 =  (__u16)(sec & 0xFFFF);
> +	addr.dw1 = (__u32)((sec >> 16) & 0xFFFFFFFF);
> +	return addr;
> +}

Again, 0xffff/0xffffffff

> +#elif BYTE_ORDER == BIG_ENDIAN
> +static inline unsigned long long __le48_to_cpu(const struct bbm_log_block_addr
> +					       *addr)
> +{
> +	return ((((__u64)__le32_to_cpu(addr->dw1)) << 16) |
> +		__le16_to_cpu(addr->w1));
> +}
> +
> +static inline struct bbm_log_block_addr __cpu_to_le48(unsigned long long sec)
> +{
> +	struct bbm_log_block_addr addr;
> +
> +	addr.w1 =  __cpu_to_le16((__u16)(sec & 0xFFFF));
> +	addr.dw1 = __cpu_to_le32((__u32)(sec >> 16) & 0xFFFFFFFF);
> +	return addr;
> +}

Given that __cpu_to_le*()/__le*_to_cpu*() are no-ops on little-endian,
you don't really need two versions of these. The big-endian version
should suffice for both, which makes it far less cluttered. Unless I got
something wrong here of course.

> +#else
> +#  error "unknown endianness."
> +#endif
> +
> +#ifndef MDASSEMBLE
> +/* get size of the bbm log */
> +static __u32 get_imsm_bbm_log_size(struct bbm_log *log)
> +{
> +	if (!log || log->entry_count == 0)
> +		return 0;
> +
> +	return sizeof(log->signature) +
> +		sizeof(log->entry_count) +
> +		log->entry_count * sizeof(struct bbm_log_entry);
> +}
> +#endif /* MDASSEMBLE */
> +
> +/* allocate and load BBM log from metadata */
> +static int load_bbm_log(struct intel_super *super)
> +{
> +	struct imsm_super *mpb = super->anchor;
> +	__u32 bbm_log_size =  __le32_to_cpu(mpb->bbm_log_size);
> +
> +	super->bbm_log = malloc(sizeof(struct bbm_log));
> +	if (!super->bbm_log)
> +		return 1;
> +
> +	if (bbm_log_size) {
> +		struct bbm_log *log = (void *)mpb +
> +			__le32_to_cpu(mpb->mpb_size) - bbm_log_size;
> +		__u32 entry_count;

Put the assignment on a separate line please when it's this long.

> +
> +		if (bbm_log_size < sizeof(log->signature) +
> +		    sizeof(log->entry_count))
> +			return 2;
> +
> +		entry_count = __le32_to_cpu(log->entry_count);
> +		if ((__le32_to_cpu(log->signature) != BBM_LOG_SIGNATURE) ||
> +		    (entry_count > BBM_LOG_MAX_ENTRIES))
> +			return 3;
> +
> +		if (bbm_log_size !=
> +		    sizeof(log->signature) + sizeof(log->entry_count) +
> +		    entry_count * sizeof(struct bbm_log_entry))
> +			return 4;
> +
> +		memcpy(super->bbm_log, log, bbm_log_size);
> +	} else {
> +		super->bbm_log->signature = __cpu_to_le32(BBM_LOG_SIGNATURE);
> +		super->bbm_log->entry_count = 0;
> +	}

This part looks problematic - you don't clear super->bbm_log and if
bbm_log_size == 0 you end up leaving it with random data. Wouldn't it be
better to just use calloc()?

Jes
