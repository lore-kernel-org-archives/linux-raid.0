From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 03/16] uuid: rename uuid types
Date: Thu, 11 May 2017 09:59:26 +0200
Message-ID: <20170511075926.GC19837@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
 <20170510180214.16852-4-hch@lst.de>
 <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjSpCgM=RK5jXkuY5HmseQT2EKh_huntvK2ADKBuNqi4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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

On Wed, May 10, 2017 at 10:15:51PM +0300, Amir Goldstein wrote:
> > +static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
> >  {
> > -       return memcmp(&u1, &u2, sizeof(uuid_be));
> > +       return memcmp(&u1, &u2, sizeof(uuid_t));
> >  }
> >
> 
> 
> I think we should use this opportunity to change these to (uuid_t *, uuid_t *)
> which is more in line with the rest of the helpers including the new helpers
> hoisted from xfs.

Or just kill them off - uuid/guid_equals is the better interface for all
existing users as far as I can tell.  My updated series already kills
off the be/uuid one, the le/guid one will need a bit more work, though.
