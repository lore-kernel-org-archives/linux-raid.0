From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 16/18] ioat3: segregate raid engines
Date: Tue, 15 Sep 2009 17:10:46 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B554879D@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064556.7141.76580.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090904064556.7141.76580.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> The cleanup routine for the raid cases imposes extra checks for handling
> raid descriptors and extended descriptors.  If the channel does not
> support raid it can avoid this extra overhead by using the ioat2 cleanup
> path.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>