From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/17] fs: switch ->s_uuid to uuid_t
Date: Tue, 16 May 2017 17:53:07 +0200
Message-ID: <20170516155307.GA2086@lst.de>
References: <20170515154308.26739-1-hch@lst.de> <20170515154308.26739-18-hch@lst.de> <CAOQ4uxgyetFTbtuE3H2Msv9Zg1LEdoxr0YqZJ6yv0cFgiTAmAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgyetFTbtuE3H2Msv9Zg1LEdoxr0YqZJ6yv0cFgiTAmAw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 15, 2017 at 10:38:18PM +0300, Amir Goldstein wrote:
> On Mon, May 15, 2017 at 6:43 PM, Christoph Hellwig <hch@lst.de> wrote:
> > For some file systems we still memcpy into it, but in various places this
> > already allows us to use the proper uuid helpers.  More to come..
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> 
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -75,7 +75,7 @@ xfs_uuid_mount(
> >
> >         /* Publish UUID in struct super_block */
> >         BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));
> 
> BUILD_BUG_ON not needed anymore now that s_uuid is uuid_t

Yeah, you mentioned that last time and I forgot about it.  Fixed up
in the git tree and for the next repost.
