From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/6] proc: commit to genradix
Date: Wed, 23 May 2018 18:18:45 -0400
Message-ID: <20180523221845.GB23040@kmo-pixel>
References: <20180523011821.12165-1-kent.overstreet@gmail.com>
	<20180523011821.12165-2-kent.overstreet@gmail.com>
	<20180523112823.GA19987@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180523112823.GA19987-PfSpb0PWhxZc2C7mugBRk2EX/6BAtgUQ@public.gmane.org>
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-raid.ids

On Wed, May 23, 2018 at 04:28:23AM -0700, Matthew Wilcox wrote:
> On Tue, May 22, 2018 at 09:18:17PM -0400, Kent Overstreet wrote:
> > @@ -2140,11 +2140,12 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
> >  	struct task_struct *task;
> >  	struct mm_struct *mm;
> >  	unsigned long nr_files, pos, i;
> > -	struct flex_array *fa = NULL;
> > -	struct map_files_info info;
> > +	GENRADIX(struct map_files_info) fa;
> >  	struct map_files_info *p;
> >  	int ret;
> >  
> > +	genradix_init(&fa);
> 
> Could we have a DEFINE_GENRADIX(type, name) which initialises the tree?

Already exists. I kind of prefer not to use it when I don't need to though, and
stick to things that look more like normal declarations instead.
