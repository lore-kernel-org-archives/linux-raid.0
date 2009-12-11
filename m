From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2 v4] powerpc/44x: Extend Katmai dts for ADMA and
	RAID56 support
Date: Fri, 11 Dec 2009 10:51:04 -0500
Message-ID: <20091211155104.GB8458@zod.rchland.ibm.com>
References: <1260538793-6655-1-git-send-email-agust@denx.de> <1260538793-6655-2-git-send-email-agust@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1260538793-6655-2-git-send-email-agust@denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, wd@denx.de, dzu@denx.de, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Fri, Dec 11, 2009 at 02:39:53PM +0100, Anatolij Gustschin wrote:
>Add nodes for PPC440SPe DMA, I2O, XOR engines and Memory
>Queue module which are used in the updated PPC440SPe ADMA
>driver. Also extend plb ranges property to specify address
>ranges for DMA0/1 and I2O engines.
>
>Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>Signed-off-by: Anatolij Gustschin <agust@denx.de>

I've queued this up in my next branch.  I'll probably send this to Ben in the
next few days as the DTS changes are pretty independent of the actual driver.

josh
