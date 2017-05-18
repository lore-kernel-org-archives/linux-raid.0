From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 03/23] uuid: remove uuid_be defintions from the uapi header
Date: Thu, 18 May 2017 00:12:45 -0700
Message-ID: <1495091565.31562.28.camel@perches.com>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-4-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170518062705.25902-4-hch-jcswGhMUV9g@public.gmane.org>
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
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> We don't use uuid_be and the UUID_BE constants in any uapi headers, so make
> them private to the kernel.

On the assumption that no user program uses them?
Is that a safe assumption?

> diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
> index 3738e5fb6a4d..0099756c4bac 100644
> --- a/include/uapi/linux/uuid.h
> +++ b/include/uapi/linux/uuid.h
> @@ -24,10 +24,6 @@ typedef struct {
>  	__u8 b[16];
>  } uuid_le;
>  
> -typedef struct {
> -	__u8 b[16];
> -} uuid_be;
> -
>  #define UUID_LE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
>  ((uuid_le)								\
>  {{ (a) & 0xff, ((a) >> 8) & 0xff, ((a) >> 16) & 0xff, ((a) >> 24) & 0xff, \
> @@ -35,20 +31,8 @@ typedef struct {
>     (c) & 0xff, ((c) >> 8) & 0xff,					\
>     (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
>  
> -#define UUID_BE(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)		\
> -((uuid_be)								\
> -{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
> -   ((b) >> 8) & 0xff, (b) & 0xff,					\
> -   ((c) >> 8) & 0xff, (c) & 0xff,					\
> -   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
> -
>  #define NULL_UUID_LE							\
>  	UUID_LE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
>  		0x00, 0x00, 0x00, 0x00)
>  
> -#define NULL_UUID_BE							\
> -	UUID_BE(0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00,	\
> -		0x00, 0x00, 0x00, 0x00)
> -
> -
>  #endif /* _UAPI_LINUX_UUID_H_ */
