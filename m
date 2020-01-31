From: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Subject: Re: [PATCH 1/2] block: introduce polling on bio level
Date: Fri, 31 Jan 2020 11:51:43 -0700
Message-ID: <081badca-ab0f-f666-1e5e-71992f93a157@linux.intel.com>
References: <20200126044138.5066-1-andrzej.jakowski@linux.intel.com>
 <20200126044138.5066-2-andrzej.jakowski@linux.intel.com>
 <20200131063407.GB6267@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200131063407.GB6267@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On 1/30/20 11:34 PM, Christoph Hellwig wrote:
> Can you explain this check?  This looks weird to me  I think we need
> a generalized check if a make_request based driver supports REQ_NOWAIT
> instead (and as a separate patch / patchset).

Original check used to reject polled IO for stackable block devices as 
"not supported". To solve that situation I introduced additional check 
to reject all non REQ_HIPRI requests. That check is not intended to 
generalize, like you indicated, but to conservatively select which 
requests to accept.
Perhaps there is better way to do that. Any suggestions?
