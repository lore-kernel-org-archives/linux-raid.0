From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH v5 3/7] raid5-ppl: Partial Parity Log write logging implementation
Date: Sun, 16 Apr 2017 15:58:28 -0700
Message-ID: <xr93wpak0xkb.fsf@gthelen.mtv.corp.google.com>
References: <20170309090003.13298-4-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20170309090003.13298-4-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 09 2017, Artur Paszkiewicz wrote:

> Implement the calculation of partial parity for a stripe and PPL write
> logging functionality. The description of PPL is added to the
> documentation. More details can be found in the comments in raid5-ppl.c.
> 
> Attach a page for holding the partial parity data to stripe_head.
> Allocate it only if mddev has the MD_HAS_PPL flag set.
> 
> Partial parity is the xor of not modified data chunks of a stripe and is
> calculated as follows:
> 
> - reconstruct-write case:
>   xor data from all not updated disks in a stripe
> 
> - read-modify-write case:
>   xor old data and parity from all updated disks in a stripe
> 
> Implement it using the async_tx API and integrate into raid_run_ops().
> It must be called when we still have access to old data, so do it when
> STRIPE_OP_BIODRAIN is set, but before ops_run_prexor5(). The result is
> stored into sh->ppl_page.
> 
> Partial parity is not meaningful for full stripe write and is not stored
> in the log or used for recovery, so don't attempt to calculate it when
> stripe has STRIPE_FULL_WRITE.
> 
> Put the PPL metadata structures to md_p.h because userspace tools
> (mdadm) will also need to read/write PPL.

...

> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
> index fe2112810c43..d9a1ead867b9 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -398,4 +398,31 @@ struct r5l_meta_block {
>  
>  #define R5LOG_VERSION 0x1
>  #define R5LOG_MAGIC 0x6433c509
> +
> +struct ppl_header_entry {
> +	__le64 data_sector;	/* raid sector of the new data */
> +	__le32 pp_size;		/* length of partial parity */
> +	__le32 data_size;	/* length of data */
> +	__le32 parity_disk;	/* member disk containing parity */
> +	__le32 checksum;	/* checksum of partial parity data for this
> +				 * entry (~crc32c) */
> +} __attribute__ ((__packed__));
> +
> +#define PPL_HEADER_SIZE 4096
> +#define PPL_HDR_RESERVED 512
> +#define PPL_HDR_ENTRY_SPACE \
> +	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))

PPL_HDR_ENTRY_SPACE is ostensibly a function of the ppl_header structure fields.
Can we use its field types: e.g. __le32 rather than u32.

This fixes klibc build error:
  In file included from /klibc/usr/klibc/../include/sys/md.h:30:0,
                   from /klibc/usr/kinit/do_mounts_md.c:19:
  /linux-next/usr/include/linux/raid/md_p.h:414:51: error: 'u32' undeclared here (not in a function)
    (PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))

 #define PPL_HDR_ENTRY_SPACE \
-	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(u32) - sizeof(u64))
+	(PPL_HEADER_SIZE - PPL_HDR_RESERVED - 4 * sizeof(__le32) - sizeof(__le64))

> +#define PPL_HDR_MAX_ENTRIES \
> +	(PPL_HDR_ENTRY_SPACE / sizeof(struct ppl_header_entry))
> +
> +struct ppl_header {
> +	__u8 reserved[PPL_HDR_RESERVED];/* reserved space, fill with 0xff */
> +	__le32 signature;		/* signature (family number of volume) */
> +	__le32 padding;			/* zero pad */
> +	__le64 generation;		/* generation number of the header */
> +	__le32 entries_count;		/* number of entries in entry array */
> +	__le32 checksum;		/* checksum of the header (~crc32c) */
> +	struct ppl_header_entry entries[PPL_HDR_MAX_ENTRIES];
> +} __attribute__ ((__packed__));
> +
>  #endif

