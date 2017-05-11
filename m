From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 16/16] fs: switch ->s_uuid to uuid_t
Date: Thu, 11 May 2017 09:58:25 +0200
Message-ID: <20170511075825.GB19837@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-17-hch@lst.de>
 <CAOQ4uxga2U6OS8N5MnBoytyWP8Fbf8qQCS1cnsPqjoby=Mxc1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxga2U6OS8N5MnBoytyWP8Fbf8qQCS1cnsPqjoby=Mxc1w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-raid.ids

On Wed, May 10, 2017 at 10:08:25PM +0300, Amir Goldstein wrote:
> On Wed, May 10, 2017 at 9:02 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> > For some file systems we still memcpy into it, but in various places this
> > already allows us to use the proper uuid helpers.  More to come..
> > Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> > ---
> 
> Series looks good!
> 
> My main concern is that filesystems with char uuid[16] are here to stay,
> or maybe, will be converted slowly.

I'll take a stab to convert them ASAP, and add s_uuid support for you
to more file systems once this initial series is done.

> 
> Considering this, perhaps we should have a helper/macro to copy from
> char[16] to *uuid_t and maybe  BUILD_BUG_ON the size comparison?
> #define bytes_to_uuid(dst, src) ...

If the mix of proper types and u8 arrays was to stay that'd be the way
to go, but I'd rather fix things up in a merge window or two instead
of leaving us in a transitionary state forever.
