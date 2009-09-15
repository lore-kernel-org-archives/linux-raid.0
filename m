From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: RE: [PATCH 10/18] ioat3: xor support
Date: Tue, 15 Sep 2009 17:08:48 +0100
Message-ID: <129600E5E5FB004392DDC3FB599660D7B5548796@irsmsx504.ger.corp.intel.com>
References: <20090904064308.7141.30576.stgit@dwillia2-linux.ch.intel.com>
 <20090904064525.7141.34029.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755215AbZIOQJe@vger.kernel.org>
In-Reply-To: <20090904064525.7141.34029.stgit@dwillia2-linux.ch.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Williams, Dan J wrote:
> ioat3.2 adds xor offload support for up to 8 sources.  It can also
> perform an xor-zero-sum operation to validate whether all given sources
> sum to zero, without writing to a destination.  Xor descriptors differ
> from memcpy in that one operation may require multiple descriptors
> depending on the number of sources.  When the number of sources exceeds
> 5 an extended descriptor is needed.  These descriptors need to be
> accounted for when updating the DMA_COUNT register.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

Signed-off-by: Maciej Sosnowski <maciej.sosnowski@intel.com>