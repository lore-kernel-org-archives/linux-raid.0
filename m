From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 23/23] uuid: remove uuid_be
Date: Thu, 18 May 2017 10:57:24 +0300
Message-ID: <CAOQ4uxj+TH5vS5HoEFPJXUpneBqr+YwbVES0bsHzw9qmS8HzKg@mail.gmail.com>
References: <20170518062705.25902-1-hch@lst.de>
 <20170518062705.25902-24-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170518062705.25902-24-hch-jcswGhMUV9g@public.gmane.org>
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
Cc: linux-xfs <linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Thu, May 18, 2017 at 9:27 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> Everything uses uuid_t now.
>
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---

Excellent!
I reviewed the entire series. You may add
Reviewed-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

to any of the patches as you see fit.

Now let's talk about how this is going to be merged.
Do you intend to send Linus a pull request?
Get those patches merged via someone else's tree?
Is this branch listed for linux-next build?

The reason I am asking is because this last removal patch should probably
be applied near the end of the merge window (?).
Because maintainers cannot apply patches with code that uses the new
uuid_t to linux-next branches and we don't want linux-next build to fail
with new code that uses uuid_be...

More to the point, I would like to re-post the patch
("tmpfs: generate random sb->s_uuid") using uuid_gen()
instead of generate_random_uuid() as you proposed.
Hugh has already acked the intent "once fs is agreed on the way to go"
When and how would I have this patch applied?
Obvious solution.. can you apply this patch to your branch?
Do you need me to re-post it?

Thanks for working on this!
Amir.
