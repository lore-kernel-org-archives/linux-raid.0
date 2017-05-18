From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 16/23] ima/policy: switch to use uuid_t
Date: Thu, 18 May 2017 19:16:14 -0400
Message-ID: <1495149374.3404.3.camel@linux.vnet.ibm.com>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-17-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170518062705.25902-17-hch-jcswGhMUV9g@public.gmane.org>
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
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Thanks!
Acked-by: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

> ---
>  security/integrity/ima/ima_policy.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index 49fbc3e8f012..da3e7d50e0d7 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -61,7 +61,7 @@ struct ima_rule_entry {
>  	enum ima_hooks func;
>  	int mask;
>  	unsigned long fsmagic;
> -	u8 fsuuid[16];
> +	uuid_t fsuuid;
>  	kuid_t uid;
>  	kuid_t fowner;
>  	bool (*uid_op)(kuid_t, kuid_t);    /* Handlers for operators       */
> @@ -244,7 +244,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
>  	    && rule->fsmagic != inode->i_sb->s_magic)
>  		return false;
>  	if ((rule->flags & IMA_FSUUID) &&
> -	    memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
> +	    memcmp(&rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
>  		return false;
>  	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
>  		return false;
> @@ -711,13 +711,12 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
>  		case Opt_fsuuid:
>  			ima_log_string(ab, "fsuuid", args[0].from);
> 
> -			if (memchr_inv(entry->fsuuid, 0x00,
> -				       sizeof(entry->fsuuid))) {
> +			if (uuid_is_null(&entry->fsuuid)) {
>  				result = -EINVAL;
>  				break;
>  			}
> 
> -			result = uuid_to_bin(args[0].from, (uuid_t *)&entry->fsuuid);
> +			result = uuid_to_bin(args[0].from, &entry->fsuuid);
>  			if (!result)
>  				entry->flags |= IMA_FSUUID;
>  			break;
> @@ -1086,7 +1085,7 @@ int ima_policy_show(struct seq_file *m, void *v)
>  	}
> 
>  	if (entry->flags & IMA_FSUUID) {
> -		seq_printf(m, "fsuuid=%pU", entry->fsuuid);
> +		seq_printf(m, "fsuuid=%pU", &entry->fsuuid);
>  		seq_puts(m, " ");
>  	}
> 
