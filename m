From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 17/19] iop3xx: define IOP3XX_REG_ADDR[32|16|8] and clean
 up DMA/AAU defs
Date: Mon, 11 Sep 2006 19:55:06 -0400
Message-ID: <4505F75A.80703@garzik.org>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com> <20060911231905.4737.15667.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060911231905.4737.15667.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

Dan Williams wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> 
> Also brings the iop3xx registers in line with the format of the iop13xx
> register definitions.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> 
>  include/asm-arm/arch-iop32x/entry-macro.S |    2 
>  include/asm-arm/arch-iop32x/iop32x.h      |   14 +
>  include/asm-arm/arch-iop33x/entry-macro.S |    2 
>  include/asm-arm/arch-iop33x/iop33x.h      |   38 ++-
>  include/asm-arm/hardware/iop3xx.h         |  347 +++++++++++++----------------
>  5 files changed, 188 insertions(+), 215 deletions(-)

Another Linux mantra:  "volatile" == hiding a bug.  Avoid, please.

	Jeff



