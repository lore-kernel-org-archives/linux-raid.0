From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 1/3] ioat3: fix p-disabled q-continuation
Date: Mon, 28 Dec 2009 16:08:47 +0000
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB3710B9@irsmsx504.ger.corp.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
 <20091223002555.32335.85860.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751884AbZL1QIy@vger.kernel.org>
In-Reply-To: <20091223002555.32335.85860.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "stable@kernel.org" <stable@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> When continuing a pq calculation the driver needs 3 extra sources.  The
> driver can perform a 3 source calculation with a single descriptor, but
> needs an extended descriptor to process up to 8 sources in one
> operation.  However, in the p-disabled case only one extra source is
> needed.  When continuing a p-disabled operation there are occasions
> (i.e. 0 < src_cnt % 8 < 3) where the tail operation does not need an
> extended descriptor.  Properly account for this fact otherwise invalid
> 'dmacount' values will be written to hardware usually causing the
> channel to halt with 'invalid descriptor' errors.
> 
> Cc: <stable@kernel.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
