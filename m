From: Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 16/19] dmaengine: Driver for the Intel IOP 32x, 33x, and
 13xx RAID engines
Date: Fri, 15 Sep 2006 09:57:50 -0500
Message-ID: <20060915095750.4b5733fe@localhost.localdomain>
References: <1158015632.4241.31.camel@dwillia2-linux.ch.intel.com>
	<20060911231859.4737.46229.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060911231859.4737.46229.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, christopher.leech@intel.com
List-Id: linux-raid.ids

Hi,

On Mon, 11 Sep 2006 16:19:00 -0700 Dan Williams <dan.j.williams@intel.com> wrote:

> From: Dan Williams <dan.j.williams@intel.com>
> 
> This is a driver for the iop DMA/AAU/ADMA units which are capable of pq_xor,
> pq_update, pq_zero_sum, xor, dual_xor, xor_zero_sum, fill, copy+crc, and copy
> operations.

You implement a bunch of different functions here. I agree with Jeff's
feedback related to the lack of scalability the way the API is going
right now.

Another example of this is that the driver is doing it's own self-test
of the functions. This means that every backend driver will need to
duplicate this code. Wouldn't it be easier for everyone if the common
infrastructure did a test call at the time of registration of a
function instead, and return failure if it doesn't pass?

>  drivers/dma/Kconfig                 |   27 +
>  drivers/dma/Makefile                |    1 
>  drivers/dma/iop-adma.c              | 1501 +++++++++++++++++++++++++++++++++++
>  include/asm-arm/hardware/iop_adma.h |   98 ++

ioatdma.h is currently under drivers/dma/. If the contents is strictly
device-related please add them under drivers/dma.


-Olof
