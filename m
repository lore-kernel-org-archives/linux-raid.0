From: Geliang Tang <geliangtang@gmail.com>
Subject: Re: [PATCH] md/bitmap: use i_blocksize()
Date: Sun, 22 Jan 2017 09:50:30 +0800
Message-ID: <20170122015030.d6sccz76asvvnvzz@OptiPlex>
References: <0a58b38c7ddfbbc8f56cb8d815114bd4357a6016.1484895399.git.geliangtang@gmail.com>
 <2e7ac27f6ca34bfa01f3b6906fdf409c348e9187.1484895660.git.geliangtang@gmail.com>
 <20170121181307.mbvoe45ca3d7sufv@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170121181307.mbvoe45ca3d7sufv@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Coly Li <colyli@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 21, 2017 at 10:13:07AM -0800, Shaohua Li wrote:
> On Fri, Jan 20, 2017 at 10:29:52PM +0800, Geliang Tang wrote:
> > Since i_blocksize() helper has been defined in fs.h, use it instead
> > of open-coding.
> 
> which tree is this patch applied to? I can't find it in Linus's tree
> 

This patch is against the last linux-next tree, next-20170120. It
depends on the patch '2651ed7 fs: add i_blocksize()' which isn't merged
into Linus's tree yet.

-Geliang
