From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 2/3] async_tx: expand async raid6 test to cover ioatdma
 corner	case
Date: Mon, 28 Dec 2009 16:09:11 +0000
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB3710BB@irsmsx504.ger.corp.intel.com>
References: <20091223002518.32335.27768.stgit@dwillia2-linux.ch.intel.com>
 <20091223002600.32335.55048.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751991AbZL1QJS@vger.kernel.org>
In-Reply-To: <20091223002600.32335.55048.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> Add explicit 11 and 12 disks cases to exercise the 0 < src_cnt % 8 < 3
> corner case in the ioatdma driver.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
