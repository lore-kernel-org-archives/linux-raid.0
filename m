From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/6] proc: commit to genradix
Date: Wed, 23 May 2018 04:28:23 -0700
Message-ID: <20180523112823.GA19987@bombadil.infradead.org>
References: <20180523011821.12165-1-kent.overstreet@gmail.com>
 <20180523011821.12165-2-kent.overstreet@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180523011821.12165-2-kent.overstreet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, gregkh@linuxfoundation.org, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, dev@openvswitch.org, shli@kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, May 22, 2018 at 09:18:17PM -0400, Kent Overstreet wrote:
> @@ -2140,11 +2140,12 @@ proc_map_files_readdir(struct file *file, struct dir_context *ctx)
>  	struct task_struct *task;
>  	struct mm_struct *mm;
>  	unsigned long nr_files, pos, i;
> -	struct flex_array *fa = NULL;
> -	struct map_files_info info;
> +	GENRADIX(struct map_files_info) fa;
>  	struct map_files_info *p;
>  	int ret;
>  
> +	genradix_init(&fa);

Could we have a DEFINE_GENRADIX(type, name) which initialises the tree?
