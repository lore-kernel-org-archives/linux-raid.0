From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: introduce polling on bio level
Date: Sat, 1 Feb 2020 00:20:34 -0800
Message-ID: <20200201082034.GA8423@infradead.org>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
 <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
 <20200131063407.GB6267@infradead.org>
 <081badca-ab0f-f666-1e5e-71992f93a157@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <081badca-ab0f-f666-1e5e-71992f93a157@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On Fri, Jan 31, 2020 at 11:51:43AM -0700, Andrzej Jakowski wrote:
> On 1/30/20 11:34 PM, Christoph Hellwig wrote:
> > Can you explain this check?  This looks weird to me  I think we need
> > a generalized check if a make_request based driver supports REQ_NOWAIT
> > instead (and as a separate patch / patchset).
> 
> Original check used to reject polled IO for stackable block devices as "not
> supported". To solve that situation I introduced additional check to reject
> all non REQ_HIPRI requests. That check is not intended to generalize, like
> you indicated, but to conservatively select which requests to accept.
> Perhaps there is better way to do that. Any suggestions?

REQ_NOWAIT and REQ_HIPRI are completley unrelated concepts and they need
to be dealt with entirely separately.
