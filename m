From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH v2] Fix bus error when accessing MBR partition records
Date: Wed, 19 Oct 2016 12:33:24 -0400
Message-ID: <wrfjtwc8uwmj.fsf@redhat.com>
References: <wrfjshs8dwd7.fsf@redhat.com>
        <20161017201601.93258-1-jrtc27@jrtc27.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161017201601.93258-1-jrtc27@jrtc27.com> (James Clarke's
        message of "Mon, 17 Oct 2016 21:16:01 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: James Clarke <jrtc27@jrtc27.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

James Clarke <jrtc27@jrtc27.com> writes:
> Since the MBR layout only has partition records as 2-byte aligned, the 32-bit
> fields in them are not aligned. Thus, they cannot be accessed on some
> architectures (such as SPARC) by using a "struct MBR_part_record *" pointer,
> as the compiler can assume that the pointer is properly aligned. Instead, the
> records must be accessed by going through the MBR struct itself every time.
>
> Signed-off-by: James Clarke <jrtc27@jrtc27.com>
> ---
> Changes from v1:
>
>  * Added packed attribute to MBR_part_record
>
>  * Reformatted changes to fit the 80-character line limit (assuming a tab stop
>    of 4; if it's 8 I can try and cut the line lengths down, though with the
>    extra verbosity that's going to be more awkward...)

I am going to clean this up - a tab is always 8 characters just like
with the kernel.

Jes

>
>  part.h      |  2 +-
>  super-mbr.c |  6 ++++++
>  util.c      | 15 ++++++++-------
>  3 files changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/part.h b/part.h
> index 862a14c..e697fb4 100644
> --- a/part.h
> +++ b/part.h
> @@ -40,7 +40,7 @@ struct MBR_part_record {
>    __u8 last_cyl;
>    __u32 first_sect_lba;
>    __u32 blocks_num;
> -};
> +} __attribute__((packed));
>  
>  struct MBR {
>  	__u8 pad[446];
> diff --git a/super-mbr.c b/super-mbr.c
> index 62b3f03..303dde4 100644
> --- a/super-mbr.c
> +++ b/super-mbr.c
> @@ -57,6 +57,9 @@ static void examine_mbr(struct supertype *st, char *homehost)
>  
>  	printf("   MBR Magic : %04x\n", sb->magic);
>  	for (i = 0; i < MBR_PARTITIONS; i++)
> +		/* Have to make every access through sb rather than using a pointer to
> +		 * the partition table (or an entry), since the entries are not
> +		 * properly aligned. */
>  		if (sb->parts[i].blocks_num)
>  			printf("Partition[%d] : %12lu sectors at %12lu (type %02x)\n",
>  			       i,
> @@ -151,6 +154,9 @@ static void getinfo_mbr(struct supertype *st, struct mdinfo *info, char *map)
>  	info->component_size = 0;
>  
>  	for (i = 0; i < MBR_PARTITIONS ; i++)
> +		/* Have to make every access through sb rather than using a pointer to
> +		 * the partition table (or an entry), since the entries are not
> +		 * properly aligned. */
>  		if (sb->parts[i].blocks_num) {
>  			unsigned long last =
>  				(unsigned long)__le32_to_cpu(sb->parts[i].blocks_num)
> diff --git a/util.c b/util.c
> index a238a21..4a8767b 100644
> --- a/util.c
> +++ b/util.c
> @@ -1412,7 +1412,6 @@ static int get_gpt_last_partition_end(int fd, unsigned long long *endofpart)
>  static int get_last_partition_end(int fd, unsigned long long *endofpart)
>  {
>  	struct MBR boot_sect;
> -	struct MBR_part_record *part;
>  	unsigned long long curr_part_end;
>  	unsigned part_nr;
>  	int retval = 0;
> @@ -1429,21 +1428,23 @@ static int get_last_partition_end(int fd, unsigned long long *endofpart)
>  	if (boot_sect.magic == MBR_SIGNATURE_MAGIC) {
>  		retval = 1;
>  		/* found the correct signature */
> -		part = boot_sect.parts;
>  
>  		for (part_nr = 0; part_nr < MBR_PARTITIONS; part_nr++) {
> +			/* Have to make every access through boot_sect rather than using a
> +			 * pointer to the partition table (or an entry), since the entries
> +			 * are not properly aligned. */
> +
>  			/* check for GPT type */
> -			if (part->part_type == MBR_GPT_PARTITION_TYPE) {
> +			if (boot_sect.parts[part_nr].part_type == MBR_GPT_PARTITION_TYPE) {
>  				retval = get_gpt_last_partition_end(fd, endofpart);
>  				break;
>  			}
>  			/* check the last used lba for the current partition  */
> -			curr_part_end = __le32_to_cpu(part->first_sect_lba) +
> -				__le32_to_cpu(part->blocks_num);
> +			curr_part_end =
> +				__le32_to_cpu(boot_sect.parts[part_nr].first_sect_lba) +
> +				__le32_to_cpu(boot_sect.parts[part_nr].blocks_num);
>  			if (curr_part_end > *endofpart)
>  				*endofpart = curr_part_end;
> -
> -			part++;
>  		}
>  	} else {
>  		/* Unknown partition table */
