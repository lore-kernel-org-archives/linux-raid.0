From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 05/18] ioat2+: add fence support
Date: Tue, 15 Sep 2009 17:06:52 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554878E@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064500.7141.60154.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755030AbZIOQHH@vger.kernel.org>
In-Reply-To: <20090904064500.7141.60154.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> In preparation for adding more operation types to the ioat3 path the
> driver needs to honor the DMA_PREP_FENCE flag.  For example the async_tx api
> will hand xor->memcpy->xor chains to the driver with the 'fence' flag set on
> the first xor and the memcpy operation.  This flag in turn sets the 'fence'
> flag in the descriptor control field telling the hardware that future
> descriptors in the chain depend on the result of the current descriptor, so
> wait for all writes to complete before starting the next operation.
> 
> Note that ioat1 does not prefetch the descriptor chain, so does not
> require/support fenced operations.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>