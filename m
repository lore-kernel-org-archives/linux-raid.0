From: Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH v2 2/2] md: enable io polling
Date: Thu, 13 Feb 2020 06:42:07 +0900
Message-ID: <20200212214207.GA6409@redsun51.ssa.fujisawa.hgst.com>
References: <20200211191729.4745-1-andrzej.jakowski@linux.intel.com>
 <20200211191729.4745-3-andrzej.jakowski@linux.intel.com>
 <20200211211334.GB3837@redsun51.ssa.fujisawa.hgst.com>
 <e9941d4d-c403-4177-526d-b3086207f31a@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9941d4d-c403-4177-526d-b3086207f31a@linux.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On Wed, Feb 12, 2020 at 02:00:10PM -0700, Andrzej Jakowski wrote:
> On 2/11/20 2:13 PM, Keith Busch wrote:
> > I must be missing something: md's make_request_fn always returns
> > BLK_QC_T_NONE for the cookie, and that couldn't get past blk_poll's
> > blk_qc_t_valid(cookie) check. How does the initial blk_poll() caller get
> > a valid cookie for an md backing device's request_queue? And how is the
> > same cookie valid for more than one request_queue?
> 
> That's true md_make_request() always returns BLK_QC_T_NONE. md_make_request()
> recursively calls generic_make_request() for the underlying device (e.g. nvme).
> That block io request directed to member disk is added into bio_list and is 
> processed later by top level generic_make_request(). generic_make_request() 
> returns cookie that is returned by blk_mq_make_request().
> That cookie is later used to poll for completion. 

Okay, that's a nice subtlety. But it means the original caller gets the
cookie from the last submission in the chain. If md recieves a single
request that has to be split among more than one member disk, the cookie
you're using to control the polling is valid only for one of the
request_queue's and may break others.
