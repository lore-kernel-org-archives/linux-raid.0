From: Andrzej Jakowski <andrzej.jakowski@linux.intel.com>
Subject: Re: [PATCH v2 2/2] md: enable io polling
Date: Wed, 12 Feb 2020 14:00:10 -0700
Message-ID: <e9941d4d-c403-4177-526d-b3086207f31a@linux.intel.com>
References: <20200211191729.4745-1-andrzej.jakowski@linux.intel.com>
 <20200211191729.4745-3-andrzej.jakowski@linux.intel.com>
 <20200211211334.GB3837@redsun51.ssa.fujisawa.hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200211211334.GB3837@redsun51.ssa.fujisawa.hgst.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <kbusch@kernel.org>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

On 2/11/20 2:13 PM, Keith Busch wrote:
> I must be missing something: md's make_request_fn always returns
> BLK_QC_T_NONE for the cookie, and that couldn't get past blk_poll's
> blk_qc_t_valid(cookie) check. How does the initial blk_poll() caller get
> a valid cookie for an md backing device's request_queue? And how is the
> same cookie valid for more than one request_queue?

That's true md_make_request() always returns BLK_QC_T_NONE. md_make_request()
recursively calls generic_make_request() for the underlying device (e.g. nvme).
That block io request directed to member disk is added into bio_list and is 
processed later by top level generic_make_request(). generic_make_request() 
returns cookie that is returned by blk_mq_make_request().
That cookie is later used to poll for completion. 
