From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
Date: Wed, 10 May 2017 22:15:51 +0300
Message-ID: <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170510180214.16852-4-hch-jcswGhMUV9g@public.gmane.org>
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
> Our "little endian" UUID really is a Wintel GUID, so rename it and its
> helpers such (guid_t).  The big endian UUID is the only true one, so
> give it the name uuid_t.  The uuid_le and uuid_be names are retained for,
> but will hopefully go away soon.
>
> Also remove the existing typedef in XFS that's now been superceeded by
> the generic type name.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> [andy: also updated the UUID_LE/UUID_BE macros including fallout]
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
[...]

>
> -static inline int uuid_le_cmp(const uuid_le u1, const uuid_le u2)
> +static inline int guid_cmp(const guid_t u1, const guid_t u2)
>  {
> -       return memcmp(&u1, &u2, sizeof(uuid_le));
> +       return memcmp(&u1, &u2, sizeof(guid_t));
>  }
>
> -static inline int uuid_be_cmp(const uuid_be u1, const uuid_be u2)
> +static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
>  {
> -       return memcmp(&u1, &u2, sizeof(uuid_be));
> +       return memcmp(&u1, &u2, sizeof(uuid_t));
>  }
>


I think we should use this opportunity to change these to (uuid_t *, uuid_t *)
which is more in line with the rest of the helpers including the new helpers
hoisted from xfs.

[...]

> +/* backwards compatibility, don't use in new code */
> +#define uuid_le_cmp(u1, u2)    guid_cmp(u1, u2)
> +#define uuid_be_cmp(u1, u2)    uuid_cmp(u1, u2)

Therefore:
#define uuid_le_cmp(u1, u2)    guid_cmp(&(u1), &(u2))
#define uuid_be_cmp(u1, u2)    uuid_cmp(&(u1), &(u2))
