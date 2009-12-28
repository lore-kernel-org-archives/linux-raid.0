From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 3/3] ioat2,3: put channel hardware in known state at init
Date: Mon, 28 Dec 2009 16:09:44 +0000
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB3710BC@irsmsx504.ger.corp.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
 <20091223002606.32335.87363.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752184AbZL1QKX@vger.kernel.org>
In-Reply-To: <20091223002606.32335.87363.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "stable@kernel.org" <stable@kernel.org>, Simon Horman <horms@verge.net.au>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> Put the ioat2 and ioat3 state machines in the halted state with all
> errors cleared.
> 
> The ioat1 init path is not disturbed for stability, there are no
> reported ioat1 initiaization issues.
> 
> Cc: <stable@kernel.org>
> Reported-by: Roland Dreier <rdreier@cisco.com>
> Tested-by: Roland Dreier <rdreier@cisco.com>
> Acked-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
