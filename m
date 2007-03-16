From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] [PPC32] ADMA support for PPC 440SPe processors.
Date: Fri, 16 Mar 2007 09:57:57 -0700
Message-ID: <e9c3a7c20703160957o7f1ecf41gb47d47227575629c@mail.gmail.com>
References: <20070315232956.37DAB353A6C@atlas.denx.de>
	 <1174033758.6861.41.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1174033758.6861.41.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Wolfgang Denk <wd@denx.de>, linuxppc-dev@ozlabs.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/16/07, Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > +     PRINTK("\tfree slot %x: %d stride: %d\n", desc->phys, desc->idx, desc->stride);
>
> Why don't you use the kernel existing debugging facilitie, like
> pr_debug, or dev_dbg if you have a proper struct device (which you
> should have with an arch/powerpc port hopefully using
> of_platform_device).
>
This came from the the iop-adma driver.  I blindly copied it from
drivers/md/raid5.c, but yes it should change to dev_dbg.

> > +     spin_lock_bh(&spe_chan->lock);
> > +     /* Allocate descriptor slots */
> > +     i = spe_chan->slots_allocated;
> > +     if (spe_chan->device->id != PPC440SPE_XOR_ID)
> > +             db_sz = sizeof (dma_cdb_t);
> > +     else
> > +             db_sz = sizeof (xor_cb_t);
> > +
> > +     for (; i < (plat_data->pool_size/db_sz); i++) {
> > +             slot = kzalloc(sizeof(struct spe_adma_desc_slot), GFP_KERNEL);
>
> GFP_KERNEL within spin_lock_bh is no good...
>
This is an iop-adma wart... will fix.

> > diff --git a/include/asm-ppc/adma.h b/include/asm-ppc/adma.h
> > new file mode 100644
> > index 0000000..0be88f1
> > --- /dev/null
> > +++ b/include/asm-ppc/adma.h
>
> There's way too many code in this .h file, too big inline functions. It
> should mostly be moved to a .c file
>
The iop-adma driver uses separate .h files because the driver is
shared between iop3xx and iop13xx implementations and I did not want
the overhead of another indirect-branch layer.  In this case the
hardware specific routines can be written inline since the driver is
only supporting one architecture... other suggestions?

> Cheers,
> Ben.
>

Regards,
Dan
