From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 15/23] block: remove blk_part_pack_uuid
Date: Thu, 18 May 2017 19:15:15 -0400
Message-ID: <1495149315.3404.2.camel@linux.vnet.ibm.com>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-16-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170518062705.25902-16-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> This helper was only used by IMA of all things, which would get spurious
> errors if CONFIG_BLOCK is disabled.  Just opencode the call there.
> 
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Acked-by: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

> ---
>  include/linux/genhd.h               | 11 -----------
>  security/integrity/ima/ima_policy.c |  3 +--
>  2 files changed, 1 insertion(+), 13 deletions(-)
> 
> diff --git a/include/linux/genhd.h b/include/linux/genhd.h
> index acff9437e5c3..e619fae2f037 100644
> --- a/include/linux/genhd.h
> +++ b/include/linux/genhd.h
> @@ -219,12 +219,6 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
>  	return NULL;
>  }
> 
> -static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
> -{
> -	uuid_be_to_bin(uuid_str, (uuid_be *)to);
> -	return 0;
> -}
> -
>  static inline int disk_max_parts(struct gendisk *disk)
>  {
>  	if (disk->flags & GENHD_FL_EXT_DEVT)
> @@ -736,11 +730,6 @@ static inline dev_t blk_lookup_devt(const char *name, int partno)
>  	dev_t devt = MKDEV(0, 0);
>  	return devt;
>  }
> -
> -static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
> -{
> -	return -EINVAL;
> -}
>  #endif /* CONFIG_BLOCK */
> 
>  #endif /* _LINUX_GENHD_H */
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 3ab1067db624..49fbc3e8f012 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -717,8 +717,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  				break;
>  			}
> 
> -			result = blk_part_pack_uuid(args[0].from,
> -						    entry->fsuuid);
> +			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
>  			if (!result)
>  				entry->flags |= IMA_FSUUID;
>  			break;
