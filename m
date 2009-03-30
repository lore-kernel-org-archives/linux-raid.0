From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 09/13] iop-adma: P+Q self test
Date: Mon, 30 Mar 2009 15:30:47 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D790F8BF26@irsmsx504.ger.corp.intel.com>
References: <20090318191248.20375.40560.stgit@dwillia2-linux.ch.intel.com>
 <20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755416AbZC3OcQ@vger.kernel.org>
In-Reply-To: <20090318192102.20375.36540.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "neilb@suse.de" <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> +	cookie = iop_adma_tx_submit(tx);
> +	iop_adma_issue_pending(dma_chan);
> +	msleep(8);

Why sleeping exactly 8 ms?
Has this value been somehow experiomentally obtained?
How about introducing wait_for_completion, just like it is in ioatdma now?

General remark:
Both iop_adma_pq_zero_sum_self_test() and iop_adma_xor_zero_sum_self_test()
are quite long and they consist of series of subsequent similar tests.
I guess the code would be easier to read if every test was a separate function
called from iop_adma_XX_zero_sum_self_test().

Regards,
Maciej
