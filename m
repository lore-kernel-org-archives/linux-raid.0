From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 01/18] dmaengine: add fence support
Date: Tue, 15 Sep 2009 17:04:59 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548783@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064440.7141.72561.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755004AbZIOQGy@vger.kernel.org>
In-Reply-To: <20090904064440.7141.72561.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> Some engines optimize operation by reading ahead in the descriptor chain
> such that descriptor2 may start execution before descriptor1 completes.
> If descriptor2 depends on the result from descriptor1 then a fence is
> required (on descriptor2) to disable this optimization.  The async_tx
> api could implicitly identify dependencies via the 'depend_tx'
> parameter, but that would constrain cases where the dependency chain
> only specifies a completion order rather than a data dependency.  So,
> provide an ASYNC_TX_FENCE to explicitly identify data dependencies.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>