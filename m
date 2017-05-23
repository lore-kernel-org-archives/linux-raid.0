From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 13/23] md: namespace private helper names
Date: Tue, 23 May 2017 10:41:18 +0200
Message-ID: <20170523084118.GA20121@lst.de>
References: <20170518062705.25902-1-hch@lst.de> <20170518062705.25902-14-hch@lst.de> <1495479147.6967.70.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1495479147.6967.70.camel@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, Dan Williams <dan.j.williams@intel.com>, David Howells <dhowells@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 22, 2017 at 09:52:27PM +0300, Andy Shevchenko wrote:
> On Thu, 2017-05-18 at 08:26 +0200, Christoph Hellwig wrote:
> > From: Amir Goldstein <amir73il@gmail.com>
> > 
> > The md private helper uuid_equal() collides with a generic helper
> > of the same name.
> > 
> > Rename the md private helper to md_uuid_equal() and do the same for
> > md_sb_equal().
> > 
> 
> While patch is good, shouldn't it go before we introduce those helpers?

Yes, I'll move it to the beginning of the series.
