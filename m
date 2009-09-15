From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 08/18] ioat: add 'ioat' sysfs attributes
Date: Tue, 15 Sep 2009 17:08:08 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548794@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064515.7141.3535.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090904064515.7141.3535.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> Export driver attributes for diagnostic purposes:
> 'ring_size': total number of descriptors available to the engine
> 'ring_active': number of descriptors in-flight
> 'capabilities': supported operation types for this channel
> 'version': Intel(R) QuickData specfication revision
> 
> This also allows some chattiness to be removed from the driver startup
> as this information is now available via sysfs.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>