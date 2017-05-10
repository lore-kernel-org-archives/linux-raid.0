From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 16/16] fs: switch ->s_uuid to uuid_t
Date: Wed, 10 May 2017 22:08:25 +0300
Message-ID: <CAOQ4uxga2U6OS8N5MnBoytyWP8Fbf8qQCS1cnsPqjoby=Mxc1w@mail.gmail.com>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-17-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170510180214.16852-17-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Wed, May 10, 2017 at 9:02 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> For some file systems we still memcpy into it, but in various places this
> already allows us to use the proper uuid helpers.  More to come..
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---

Series looks good!

My main concern is that filesystems with char uuid[16] are here to stay,
or maybe, will be converted slowly.

Considering this, perhaps we should have a helper/macro to copy from
char[16] to *uuid_t and maybe  BUILD_BUG_ON the size comparison?
#define bytes_to_uuid(dst, src) ...


> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 682b336a7a6a..93a420160964 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -75,7 +75,7 @@ xfs_uuid_mount(
>
>         /* Publish UUID in struct super_block */
>         BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));

This BUILD_BUG is no longer needed.

> -       memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
> +       uuid_copy(&mp->m_super->s_uuid, uuid);
>
>         if (mp->m_flags & XFS_MOUNT_NOUUID)
>                 return 0;
[...]

> diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
> index d7f282d75cc1..1d32cd20009a 100644
> --- a/security/integrity/evm/evm_crypto.c
> +++ b/security/integrity/evm/evm_crypto.c
> @@ -164,7 +164,7 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
>         hmac_misc.mode = inode->i_mode;
>         crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof(hmac_misc));
>         if (evm_hmac_attrs & EVM_ATTR_FSUUID)
> -               crypto_shash_update(desc, inode->i_sb->s_uuid,
> +               crypto_shash_update(desc, &inode->i_sb->s_uuid.b[0],

I wonder if 'inode->i_sb->s_uuid.b' would have been better here

Cheers,
Amir.
