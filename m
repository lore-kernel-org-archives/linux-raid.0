From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 15/18] ioat3: ioat3.2 pci ids for Jasper Forest
Date: Tue, 15 Sep 2009 17:10:32 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554879C@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064551.7141.2216.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755401AbZIOQLg@vger.kernel.org>
In-Reply-To: <20090904064551.7141.2216.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Picard, Tom S" <tom.s.picard@intel.com>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> From: Tom Picard <tom.s.picard@intel.com>
> 
> Jasper Forest introduces raid offload support via ioat3.2 support.  When
> raid offload is enabled two (out of 8 channels) will report raid5/raid6
> offload capabilities.  The remaining channels will only report ioat3.0
> capabilities (memcpy).
> 
> Signed-off-by: Tom Picard <tom.s.picard@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>